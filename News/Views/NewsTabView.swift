//
//  NewsTabView.swift
//  News
//
//  Created by joooli on 4/1/22.
//

import SwiftUI

struct NewsTabView: View {
    // MARK: - Property
    // Updated View : reference to this viewModel and not created every time
    @StateObject var articleNewsVM = ArticleNewsViewModel()
    // Updated View : every time will be re-initialize not reference to it
    // @ObservedObject
    // MARK: - Body
    var body: some View {
        NavigationView {
            ArticleListView(articles: articleNewsVM.articles,isFetchingNextPage: articleNewsVM.isFetchingNextPage, nextPageHandler: {await articleNewsVM.loadNextPage() })
                .overlay(overlayView)
                .refreshable  {
                    refreshTask()
                }
                .task(id: articleNewsVM.fetchTaskToken, {
                    await loadTask()
                })
                .toolbar {
                    ToolbarItem(placement:  .navigationBarTrailing) {
                        menu
                    }
                }
                .navigationTitle(articleNewsVM.fetchTaskToken.category.text)
        } //:NavigationView
    }
    
    
    // implement all phases of article
    @ViewBuilder
    private var overlayView: some View {
        switch articleNewsVM.phase {
            case .empty:
                 ProgressView()
            case .success(let articles) where articles.isEmpty:
                EmptyPlaceholderView(text: "No Article", image: nil)
            case .failure(let error):
            RetryView(text: error.localizedDescription,retryAction: refreshTask)
            default:
                 EmptyView()
        }
    }
    
    // check the phase of article
    private var articles: [Article] {
        if case let .success(articles) = articleNewsVM.phase {
            return articles
        } else {
            return []
        }
    }
    
    private var menu: some View {
        Menu {
            Picker("Category",selection: $articleNewsVM.fetchTaskToken.category) {
                ForEach(Category.allCases) { category in
                    Text(category.text).tag(category )
                }
            }
        } label: {
            Image(systemName: "fiberchannel")
                .imageScale(.large)
        }
    }
 
    @Sendable
    private func loadTask() async {
        await articleNewsVM.loadFirstPage()
    }
    
    @Sendable
    private func refreshTask() {
        articleNewsVM.fetchTaskToken = FetchTaskToken(category: articleNewsVM.fetchTaskToken.category, token: Date())
    }
}




// MARK: - Preview
struct NewsTabView_Previews: PreviewProvider {
    static var previews: some View {
        NewsTabView(articleNewsVM: ArticleNewsViewModel(articles: Article.previewData, selectedCategory: Category.general))
    }
}
