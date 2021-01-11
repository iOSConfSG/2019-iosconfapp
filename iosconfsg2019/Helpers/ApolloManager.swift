//
//  ApolloManager.swift
//  iosconfsg2019
//
//  Created by Vina Rianti on 10/10/19.
//  Copyright © 2019 Vina Melody. All rights reserved.
//

import Foundation
import Apollo
import ApolloWebSocket

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

//            let configuration = URLSessionConfiguration.default
            guard let httpsEndpointUrl = URL(string: httpsEndpoint) else { return nil}

            let request = URLRequest(url: wsEndpointUrl)
//            let websocket = WebSocketTransport(request: request, sendOperationIdentifiers: true, reconnectionInterval: 30000, connectingPayload: map)
            let websocket = WebSocketTransport(request: request)
            
            
            let store = ApolloStore(cache: InMemoryNormalizedCache())
//            let client = URLSessionClient()
            let provider = LegacyInterceptorProvider(store: store)
            let httpNetworkTransport = RequestChainNetworkTransport(interceptorProvider: provider, endpointURL: httpsEndpointUrl)
//            let httpNetworkTransport: HTTPNetworkTransport = HTTPNetworkTransport(url: httpsEndpointUrl, session: URLSession(configuration: configuration))
            let splitNetworkTransport = SplitNetworkTransport(uploadingNetworkTransport: httpNetworkTransport, webSocketNetworkTransport: websocket)
//            let splitNetworkTransport = SplitNetworkTransport(httpNetworkTransport: httpNetworkTransport, webSocketNetworkTransport: websocket)
            
            return ApolloClient(networkTransport: splitNetworkTransport, store: store)
        }()
    }
}
