//
//  BookmarkTabView.swift
//  News
//
//  Created by joooli on 4/1/22.
//

import SwiftUI

struct BookmarkTabView: View {
    // MARK: - Property
    @EnvironmentObject var articleBookmarkVM: ArticleBookmarkViewModel
    @State var searchText: String = ""
    // MARK: - Body
    var body: some View {
        let articles = self.articles
        NavigationView {
            ArticleListView(articles: articles)
                .overlay(overlayView(isEmpty: articles.isEmpty))
                .navigationTitle("Save Article")
        }
        .searchable(text: $searchText)
    }
    
    @ViewBuilder
    func overlayView(isEmpty: Bool) ->   some View {
        if isEmpty {
            EmptyPlaceholderView(text: "No Bookmark", image: Image(systemName: "bookmark"))
        }
    }
    
    private var articles: [Article] {
        if searchText.isEmpty {
            return articleBookmarkVM.bookmarks
        } else {
            return articleBookmarkVM.bookmarks.filter {
                $0.title.lowercased().contains(searchText.lowercased()) || $0.descriptionText.lowercased().contains(searchText.lowercased())
            }
        }
    }
}


// MARK: - Preview
struct BookmarkTabView_Previews: PreviewProvider {
    @StateObject static var articleBookmarkVM = ArticleBookmarkViewModel.shared
    static var previews: some View {
        BookmarkTabView()
            .environmentObject(articleBookmarkVM)
    }
}
