//
//  TextListView.swift
//  Versatile
//
//  Created by 417.72KI on 2021/07/31.
//

import SwiftUI

struct TextListView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject var viewModel: TextListViewModel
    @State private var offset: CGPoint = .zero {
        didSet {
            print(offset)
        }
    }

    var body: some View {
        HStack {
            VStack {
                Text("Home")
                    .padding(8)
                    .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Divider()
                ScrollView(.vertical) {
                    LazyVGrid(columns: [.init()]) {
                        VStack {
                            ForEach(viewModel.texts, id: \.id) {
                                TextListRowView(model: $0)
                            }
                            Spacer(minLength: 30)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    GeometryReader { g in
                        let offset = g.frame(in: .named("scroll")).minY
                        Color.clear.preference(key: ScrollViewOffsetPreferenceKey.self, value: offset)
                    }
                }
                .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) {
                    if $0 > -30 {
                        viewModel.fetchNext()
                    }
                }
                .frame(minWidth: 400, minHeight: 400)
                Divider()
                HStack {
                    Spacer()
                    Button(
                        action: { viewModel.fetchFirst() },
                        label: { Image(systemName: "arrow.clockwise") }
                    )
                    .frame(alignment: .trailing)
                    .keyboardShortcut(KeyEquivalent("r"), modifiers: /*@START_MENU_TOKEN@*/.command/*@END_MENU_TOKEN@*/)
                }
                .padding(8)
            }
            PostTextView {
                viewModel.post($0)
            }
            .frame(minWidth: 320)
        }
        .alert(isPresented: viewModel.isAlertDisplaying) {
            Alert(error: viewModel.error!)
        }
        .onAppear {
            viewModel.fetchNext()
        }
    }
}

struct TextListView_Previews: PreviewProvider {
    static var previews: some View {
        TextListView(viewModel: TextListViewModel(client: APIClientMock()))
            .previewDevice("Mac")
    }
}
