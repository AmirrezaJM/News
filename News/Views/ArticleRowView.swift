//
//  ArticleRowView.swift
//  News
//
//  Created by joooli on 3/31/22.
//

import SwiftUI

struct ArticleRowView: View {
    let article: Article
    @EnvironmentObject var articleBookmarkVM: ArticleBookmarkViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            AsyncImage(url: article.imageURL) {
                phase in
                switch phase {
                    case .empty:
                    HStack(alignment:.center) {
                            Spacer()
                            ProgressView()
                            Spacer()
                        } //:HSTACK
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    HStack {
                        Spacer()
                        Image(systemName: "photo")
                            .imageScale(.large)
                        Spacer()
                    } //:HSTACK
                @unknown default:
                    fatalError()
                }
            }  //:ASyncImage
            .frame(minHeight:200, maxHeight: 300)
            .background(Color.gray.opacity(0.3))
            VStack(alignment: .leading, spacing: 8, content: {
                Text(article.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .lineLimit(3)
                Text(article.descriptionText)
                    .font(.subheadline)
                    .lineLimit(2)
            }) //:VSTACK
            .padding(.horizontal)
            .padding(.bottom)
            
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(article.captionText)
                    .lineLimit(1)
                    .foregroundColor(.secondary)
                    .font(.caption)
                Spacer()
                Button {
                    toggleBookmark(for: article)
                } label: {
                    Image(systemName: articleBookmarkVM.isBookmarked(for: article) ? "bookmark.fill" : "bookmark")
                }
                .buttonStyle(.bordered)
                
                Button {
                    presentShareSheet(url: article.articleURL)
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
                .buttonStyle(.bordered)
            } //:HSTACK
            .padding(.horizontal)
            .padding(.bottom)
        } //:VSTACK
    }
    
    private func toggleBookmark(for article:Article) {
        if articleBookmarkVM.isBookmarked(for: article) {
            articleBookmarkVM.removeBookmark(for: article)
        } else {
            articleBookmarkVM.addBookmark(for: article)
        }
    }
}


extension View {
    // show a share sheet
    func presentShareSheet(url:URL) {
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
            .keyWindow?.rootViewController?.present(activityVC, animated: true)
    }
    
}

struct ArticleRowView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ArticleRowView(article: .previewData[0])
                .listRowInsets(.init(top:0, leading: 0,bottom: 0,trailing: 0))
        }
        .listStyle(.plain)
    } 
}
