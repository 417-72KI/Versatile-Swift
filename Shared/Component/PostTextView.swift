//
//  PostTextView.swift
//  Versatile
//
//  Created by 417.72KI on 2021/08/01.
//

import SwiftUI

struct PostTextView: View {
    @State private var text: String = ""
    var postAction: (String) -> Void

    var body: some View {
        VStack {
            TextEditor(text: $text)
                .frame(height: 160)
            Button("Post") { postAction(text) }
                .disabled(text.isEmpty)
        }
    }
}

extension PostTextView {
    func clear() {
        text = ""
    }
}

struct PostTextView_Previews: PreviewProvider {
    static var previews: some View {
        PostTextView { _ in }
    }
}
