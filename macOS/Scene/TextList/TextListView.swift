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

    var body: some View {
        VStack {
            Text("Home")
            ScrollView {
                ForEach(viewModel.texts, id: \.id) {
                    TextListRowView(model: $0)
                }
            }
        }
        .frame(minWidth: 320, minHeight: 160)
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
