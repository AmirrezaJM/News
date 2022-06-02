//
//  ArticleListView.swift
//  News
//
//  Created by joooli on 4/1/22.
//

import SwiftUI

struct ArticleListView: View {
    // MARK: - Property
    let articles: [Article]
    @State private var selectedArticle: Article?
    var isFetchingNextPage = false
    var nextPageHandler: (() async -> ())? = nil
    // MARK: - Body
    var body: some View {
        List {
            ForEach(articles) { item in
                if let nextPageHandler = nextPageHandler , item == articles.last {
                    ArticleRowView(article: item)
                        .onTapGesture {
                            selectedArticle = item
                        }
                        .task {
                            await nextPageHandler()
                        }
                    if isFetchingNextPage {
                         bottomProgressView
                    }
                    
                } else {
                    ArticleRowView(article: item)
                        .onTapGesture {
                            selectedArticle = item
                    }
                }
            } //:LOOP
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowSeparator(.hidden)
        } //:List
        .listStyle(.plain)
        .sheet(item: $selectedArticle) {
            SafariView(url: $0.articleURL)
                .edgesIgnoringSafeArea(.bottom)
        }
    } //:Body
    
    
    @ViewBuilder
    private var bottomProgressView: some View {
        Divider()
        HStack {
            Spacer()
            ProgressView()
            Spacer()
        }.padding()
    }
}


// MARK: - Preview
struct ArticleListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ArticleListView(articles: Article.previewData)
        }
    }
}
