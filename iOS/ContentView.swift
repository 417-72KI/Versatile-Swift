//
//  ContentView.swift
//  Shared
//
//  Created by 417.72KI on 2021/07/31.
//

import SwiftUI

struct ContentView: View {
    let apiClient: APIClient

    var body: some View {
        NavigationView {
            LoginView(viewModel: .init(client: apiClient))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(apiClient: APIClientMock())
    }
}
