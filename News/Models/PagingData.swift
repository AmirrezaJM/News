//
//  PagingData.swift
//  News
//
//  Created by joooli on 4/8/22.
//

import Foundation

actor PagingData {
    private(set) var currentPage = 0
    private(set) var hasReachEnd = false
    
    let itemsPerPage: Int
    let maxPageLimit: Int
    
    init(itemsPerPage: Int,maxPageLimit: Int) {
        // make condition in init and make sure the internal implementation will not break
        assert(itemsPerPage > 0 && maxPageLimit > 0, "Items per page and max page Limit must be greater than 0")
        
        self.itemsPerPage = itemsPerPage
        self.maxPageLimit = maxPageLimit
        
    }
    
    var nextPage: Int { currentPage + 1 }
    var shouldLoadNextPage: Bool {
        !hasReachEnd && nextPage <= maxPageLimit
    }
    
    func reset() {
        print("Paging Reset")
        currentPage = 0
        hasReachEnd = false
    }
    
    func loadNextPage<T>(dataFetchProvider: @escaping(Int) async throws -> [T]) async throws -> [T] {
        if Task.isCancelled { return [] }
        print("PAGING: Current Page \(currentPage), next Page: \(nextPage)")
        currentPage += 1
        
        guard shouldLoadNextPage else { return [] }
        
        let nextPage = self.nextPage
        let items = try await dataFetchProvider(nextPage)
        if Task.isCancelled || nextPage != self.nextPage { return [] }
        
        currentPage = nextPage
        hasReachEnd = items.count < itemsPerPage
        
        print("PAGING: fetch \(items.count) items successfully current page: \(currentPage)")
        
        return items
        
        
    }
    
}
