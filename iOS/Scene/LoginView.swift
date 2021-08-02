//
//  LoginView.swift
//  Versatile (iOS)
//
//  Created by 417.72KI on 2021/07/31.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject var viewModel: LoginViewModel

    var body: some View {
        VStack {
            Text("Welcome to Versatile!")
                .font(.title)
            HStack {
                Text("Login name")
                TextField("Login name", text: $viewModel.name)
            }
            .font(.headline)
            HStack(alignment: .top) {
                Text("Description")
                TextEditor(text: $viewModel.description)
            }
            .font(.headline)
            Button("Login") {
                viewModel.login {
                    appState.userId = $0
                }
            }
        }
        .padding(8)
        .frame(width: 360, height: 160)
        .alert(isPresented: viewModel.isAlertDisplaying) {
            Alert(error: viewModel.error!)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView(viewModel: LoginViewModel(client: APIClientMock()))
                .previewDevice("iPhone 12")
        }
    }
}
