//
//  ContentView.swift
//  News
//
//  Created by joooli on 3/31/22.
//

import SwiftUI

struct ContentView: View {
    // MARK: - Property
    // MARK: - Body
    var body: some View {
        TabView {
            NewsTabView()
                .tabItem {
                    Label("News",systemImage: "newspaper")
                }
            SearchTabView()
                .tabItem {
                    Label("Search",systemImage: "magnifyingglass")
                }
            BookmarkTabView()
                .tabItem {
                    Label("Bookmark",systemImage: "bookmark")
                }
        }
    }
}


// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
