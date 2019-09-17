//
//  Articles.swift
//  NYTDemo
//
//  Created by Anuj Rai on 17/09/19.
//  Copyright © 2019 Anuj Rai. All rights reserved.
//

import Foundation

protocol ModelData {
    var publishedDate: String? { get set }
    var title: String? { get set }
}

struct Article: Decodable, ModelData {
    var publishedDate: String?
    var title: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case publishedDate = "published_date"
    }
}

struct SearchedArticle: Decodable, ModelData {
    var publishedDate: String?
    var title: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "abstract"
        case publishedDate = "pub_date"
    }
}

struct SearchDocs: Decodable {
    let docs: [SearchedArticle]?
}

struct SearchResponse: Decodable {
    let response: SearchDocs?
}

struct ArticleResult: Decodable {
    let articles: [Article]?
    
    enum CodingKeys: String, CodingKey {
        case articles = "results"
    }
}

class ArticleClient<T>: APIClient where T: Decodable {
    
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    func getArticle(forEndpoint endPoint: Endpoint, completion: @escaping (Result<T?, APIError>) -> Void) {
        self.fetch(with: endPoint.request, decode: { json -> T? in
            guard let articles = json as? T else { return  nil }
            return articles
        }, completion: completion)
    }
}
