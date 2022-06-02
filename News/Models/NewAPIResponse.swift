//
//  NewAPIResponse.swift
//  News
//
//  Created by joooli on 3/31/22.
//

import Foundation


struct NewAPIResponse: Decodable {
    let status: String
    let totalResult: Int?
    let articles: [Article]?
    
    let code: String?
    let message: String?
}
