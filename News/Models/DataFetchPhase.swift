//
//  DataFetchPhase.swift
//  News
//
//  Created by joooli on 4/8/22.
//

import Foundation

enum DataFetchPhase<T> {
    case empty
    case success(T)
    case fetchNextPage(T)
    case failure(Error)
    
    var value: T? {
        if case .success(let value) = self {
            return value
        } else if case .fetchNextPage(let value) = self {
            return value
        }
        return nil
    }
}
