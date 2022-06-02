//
//  EmptyPlaceholderView.swift
//  News
//
//  Created by joooli on 4/1/22.
//

import SwiftUI

struct EmptyPlaceholderView: View {
    let text: String
    let image: Image?
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            if let image = self.image {
                image
                    .imageScale(.large)
                    .font(.title)
            }
            Text(text)
            Spacer()
        }
    }
}
struct EmptyPlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyPlaceholderView(text: "No Bookmark",image: Image(systemName: "bookmark"))
    }
}
