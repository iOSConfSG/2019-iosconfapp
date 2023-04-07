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
    let httpsEndpoint = "https://api.iosconf.sg/v1/graphql"
    let wsEndpoint = "wss://api.iosconf.sg/v1/graphql"
    
    /// A web socket transport to use for subscriptions
    private lazy var webSocketTransport: WebSocketTransport = {
        let url = URL(string: wsEndpoint)!
        let webSocketClient = WebSocket(url: url, protocol: .graphql_transport_ws)
        return WebSocketTransport(websocket: webSocketClient)
    }()
    
    /// An HTTP transport to use for queries and mutations
    
    private lazy var normalTransport: RequestChainNetworkTransport = {
        let url = URL(string: httpsEndpoint)!
        return RequestChainNetworkTransport(interceptorProvider: DefaultInterceptorProvider(store: self.store), endpointURL: url)
    }()
    
    
    /// A split network transport to allow the use of both of the above
    /// transports through a single `NetworkTransport` instance.
    private lazy var splitNetworkTransport = SplitNetworkTransport(
        uploadingNetworkTransport: self.normalTransport,
        webSocketNetworkTransport: self.webSocketTransport
    )
    
    /// Create a client using the `SplitNetworkTransport`.
    private(set) lazy var client = ApolloClient(networkTransport: self.splitNetworkTransport, store: self.store)
    
    /// A common store to use for `normalTransport` and `client`.
    private lazy var store = ApolloStore()
    
}
