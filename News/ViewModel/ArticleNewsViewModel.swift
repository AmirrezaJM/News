//
//  ArticleNewsViewModel.swift
//  News
//
//  Created by joooli on 4/1/22.
//

import Foundation


struct FetchTaskToken: Equatable {
    var category: Category
    var token: Date
}


// new in swift 5.5 -> Dispatch.main.async 
@MainActor
class ArticleNewsViewModel: ObservableObject {
    
    @Published var phase = DataFetchPhase<[Article]>.empty
    @Published var fetchTaskToken: FetchTaskToken
    private let newsAPI = NewsAPI.shared
    private let pagingData = PagingData(itemsPerPage: 10, maxPageLimit: 8)
    

    var articles: [Article] {
        phase.value ?? []
    }
    
    
    init(articles: [Article]? = nil, selectedCategory: Category = .general) {
        if let articles = articles {
            self.phase = .success(articles)
        } else {
            self.phase = .empty
        }
        self.fetchTaskToken = FetchTaskToken(category: selectedCategory, token: Date())
    }
    
    
    
    
    // load article and we should in swift 5.5 write Task handling
    func loadFirstPage() async  {
        await pagingData.reset()
        if Task.isCancelled { return }
        phase = .empty
        do {
            let articles = try await pagingData.loadNextPage(dataFetchProvider: loadArticles(page:))
            if Task.isCancelled { return }
            phase = .success(articles)
        }
        catch {
            if Task.isCancelled { return }
            phase = .failure(error)
        }
    }
    
    var isFetchingNextPage: Bool {
        if case .fetchNextPage = phase {
            return true
        } else {
            return false
        }
    }
    
    func loadNextPage() async {
        if Task.isCancelled { return }
        
        let articles = self.phase.value ?? []
        phase = .fetchNextPage(articles)
        
        do {
            let nextArticle = try await pagingData.loadNextPage(dataFetchProvider: loadArticles(page:))
            if Task.isCancelled { return }
            phase = .success(articles + nextArticle)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func loadArticles(page: Int) async throws -> [Article] {
        let articles = try await newsAPI.fetch(from: fetchTaskToken.category, page: page, pageSize: pagingData.itemsPerPage)
        if Task.isCancelled { return [] }
        return articles
    }
}
