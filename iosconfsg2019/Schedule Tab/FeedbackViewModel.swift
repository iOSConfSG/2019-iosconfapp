//
//  FeedbackViewModel.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 22/12/18.
//  Copyright © 2018 Vina Melody. All rights reserved.
//

import Foundation
import Apollo
import ConfAPI

class FeedbackViewModel {

    enum FeedbackError: Error {
        case apolloError

        var message: String {
            return "Can't submit the feedback now, Apollo had an error"
        }
    }

    private var apollo: ApolloClient!
    private var feedbackClient: Cancellable?

    init() {
        self.apollo = NetworkManager.shared.client
    }

    func submitFeedback(for talk: Talk, feeling: Feedback.Feeling, comments: String, completionHandler: @escaping ((Result<Bool, FeedbackError>) -> Void)) {
        apollo.perform(mutation: CreateFeedbackMutation(talkId: talk.id, feeling: feeling.emoji, comment: comments)) { [weak self] (result) in
            switch result {
            case .success(let object):
                if let data = object.data {
                    #if DEBUG
                    print(data)
                    #endif
                    completionHandler(.success(true))
                }
                if let errors = object.errors {
                    self?.handleError(errors: errors)
                    completionHandler(.failure(FeedbackError.apolloError))
                }
            case .failure:
                completionHandler(.failure(FeedbackError.apolloError))
            }
        }
    }

    func handleError(errors: [GraphQLError]) {
        _ = errors.compactMap({ print($0.message ?? "unknown error") })
    }

}
