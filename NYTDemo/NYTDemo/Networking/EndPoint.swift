//
//  EndPoint.swift
//  NYTDemo
//
//  Created by Anuj Rai on 17/09/19.
//  Copyright © 2019 Anuj Rai. All rights reserved.
//

import Foundation

protocol Endpoint {
    
    var base: String { get }
    var path: String { get }
}

extension Endpoint {
    
    var apiKey: String {
        return "8O3iaLobQ3Tzs5fpqhtBIZAY9UCWVpgW"
    }
    
    var urlComponents: URLComponents {
        guard var components = URLComponents(string: self.base) else {
            fatalError("Unable to make url")
        }
        components.path = self.path
        components.queryItems = [URLQueryItem(name: "api-key", value: self.apiKey)]
        return components
    }
    
    var request: URLRequest {
        guard let url = self.urlComponents.url else {
            fatalError("Unable to make request")
        }
        return URLRequest(url: url)
    }
}

extension URLComponents {
    
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}

enum ArticlesEndPoint {
    case emailed(inDays: Int)
    case shared(inDays: Int)
    case viewed(inDays: Int)
    case search(string: String)
}

extension ArticlesEndPoint: Endpoint {
    
    var base: String {
        return "https://api.nytimes.com"
    }
    
    var path: String {
        switch self {
        case .emailed(inDays: let days):
            return "/svc/mostpopular/v2/emailed/\(days).json"
        case .shared(inDays: let days):
            return "/svc/mostpopular/v2/shared/\(days).json"
        case .viewed(inDays: let days):
            return "/svc/mostpopular/v2/viewed/\(days).json"
        case .search(string: let searchString):
            return "/svc/search/v2/articlesearch.json?q=\(searchString)"
        }
    }
}
