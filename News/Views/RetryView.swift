//
//  RetryView.swift
//  News
//
//  Created by joooli on 4/1/22.
//

import SwiftUI

struct RetryView: View {
    let text:String
    let retryAction: () -> ()
    var body: some View {
        VStack(spacing:8) {
            Text("\(text)")
                .font(.callout)
                .multilineTextAlignment(.center)
            
            Button(action: retryAction) {
                Text("try Again")
            }
        }
    }
}

struct RetryView_Previews: PreviewProvider {
    static var previews: some View {
        RetryView(text: "An ERROR Occurred") {
            
        }
    }
}
