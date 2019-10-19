//
//  ApolloManager.swift
//  iosconfsg2019
//
//  Created by Vina Rianti on 10/10/19.
//  Copyright © 2019 Vina Melody. All rights reserved.
//

import Foundation
import Apollo

class NetworkManager {
    static let shared = NetworkManager()
    let httpsEndpoint = "https://iosconfsg.herokuapp.com/v1/graphql"
    let wsEndpoint = "wss://iosconfsg.herokuapp.com/v1/graphql"
    var apolloClient: ApolloClient?

    private init() {
        setApolloClient()
    }

    func setApolloClient() {
        self.apolloClient = {
            let map: GraphQLMap = [:]
            guard let wsEndpointUrl = URL(string: wsEndpoint) else { return nil }

            let configuration = URLSessionConfiguration.default
            guard let httpsEndpointUrl = URL(string: httpsEndpoint) else { return nil}

            var request = URLRequest(url: wsEndpointUrl)
            let websocket = WebSocketTransport(request: request, sendOperationIdentifiers: false, reconnectionInterval: 30000, connectingPayload: map)
            let httpNetworkTransport: HTTPNetworkTransport = HTTPNetworkTransport(url: httpsEndpointUrl, session: URLSession(configuration: configuration))
            let splitNetworkTransport = SplitNetworkTransport(httpNetworkTransport: httpNetworkTransport, webSocketNetworkTransport: websocket)
            return ApolloClient(networkTransport: splitNetworkTransport)
        }()
    }
}
