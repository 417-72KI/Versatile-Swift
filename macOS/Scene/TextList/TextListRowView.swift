//
//  TextListRowView.swift
//  Versatile
//
//  Created by 417.72KI on 2021/08/01.
//

import SwiftUI

struct TextListRowView: View {
    var model: TextModel


    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(model.text)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .font(.headline)
            HStack {
                Spacer()
                if let name = model.user?.name {
                    Text("@\(name)")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                } else {
                    Text("@Anonymous")
                        .font(.subheadline)
                }
            }
            HStack {
                Spacer()
                Text(dateFormatter.string(from: model.createdAt))
                    .font(.footnote)
            }
            Divider()
        }.padding(8)
    }
}

private extension TextListRowView {
    var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .long
        df.timeStyle = .long
        df.locale = .current
        return df
    }
}

struct TextListRowView_Previews: PreviewProvider {
    static var previews: some View {
        TextListRowView(
            model: .init(
                id: "id",
                text: "長い文章テスト",
                user: .init(name: "foo", description: "bar"),
                createdAt: Date(),
                updatedAt: Date(),
                inReplyToUserId: nil,
                inReplyToTextId: nil
            )
        ).frame(width: 320, height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}
