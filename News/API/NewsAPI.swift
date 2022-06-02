//
//  NewsAPI.swift
//  News
//
//  Created by joooli on 4/1/22.
//

import Foundation


struct NewsAPI {
    static let shared = NewsAPI()
    private init() {
        
    }
    
    private let apiKey = "728ec4915cd846c59efcc99042ca5c82"
    private let session = URLSession.shared
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    
    // fetch data in project
    func fetch(from category: Category,page: Int = 1, pageSize: Int = 20) async throws -> [Article] {
        try await fetchArticle(from: generateNewsURL(from: category,page: page,pageSize: pageSize))
    }
    
    func search(for query: String) async throws -> [Article] {
        try await fetchArticle(from: generateSearchURL(from: query))
    }
    
    
    func fetchArticle(from url:URL) async throws -> [Article] {
        let (data,response) = try await session.data(from: url)
        guard let response = response as? HTTPURLResponse else {
            throw generateErrorCode(description: "Bad Response")
        }
        
        switch response.statusCode {
            case (200...299), (400...499):
            let apiResponse = try jsonDecoder.decode(NewAPIResponse.self, from: data)
            if apiResponse.status == "ok" {
                return apiResponse.articles ?? []
            } else {
                throw generateErrorCode(description: apiResponse.message ?? "Error")
            }
        default:
            throw generateErrorCode(description: "A server error occured")
        }
    }
    
    private func generateErrorCode(code: Int = 1, description: String) -> Error {
        NSError(domain: "NewsAPI", code: code, userInfo: [NSLocalizedDescriptionKey: description])
    }
    
    
    private func generateSearchURL(from query: String) -> URL {
        let percentEncodedString = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        var url = "https://newsapi.org/v2/everything?"
        url += "apiKey=\(apiKey)"
        url += "&language=en"
        url += "&q=\(percentEncodedString)"
        return URL(string: url)!
    }
    
    // generate news url with apiKey and other property
    private func generateNewsURL(from category: Category,page: Int = 1, pageSize: Int = 20) -> URL {
        var url = "https://newsapi.org/v2/top-headlines?"
        url += "apiKey=\(apiKey)"
        url += "&language=en"
        url += "&category=\(category.rawValue)"
        url += "&page=\(page)"
        url += "&pageSize=\(pageSize)"
        return URL(string: url)!
    }
}
