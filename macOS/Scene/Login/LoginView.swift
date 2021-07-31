//
//  LoginView.swift
//  Versatile (macOS)
//
//  Created by 417.72KI on 2021/07/31.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject var viewModel: LoginViewModel

    var body: some View {
        VStack {
            Text("Login to Versatile")
                .font(.title)
            HStack {
                Text("Login name")
                TextField("Login name", text: $viewModel.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            HStack {
                Text("Description")
                TextEditor(text: $viewModel.description)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            Button("Login") {
                viewModel.login {
                    appState.userId = $0
                }
            }
        }.padding(8)
        .frame(minWidth: 360, minHeight: 180)
        .alert(isPresented: viewModel.isAlertDisplaying) {
            Alert(error: viewModel.error!)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView(viewModel: LoginViewModel(client: APIClientMock()))
                .previewDevice("Mac")
        }
    }
}
