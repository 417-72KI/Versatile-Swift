//
//  LoginViewModel.swift
//  Versatile
//
//  Created by 417.72KI on 2021/07/31.
//

import SwiftUI
import Combine

final class LoginViewModel: ObservableObject {
    @Published var name: String
    @Published var description: String
    @Published var error: Error?

    private let client: APIClient
    private var cancellables: Set<AnyCancellable> = []

    init(
        name: String? = nil,
        description: String? = nil,
        client: APIClient
    ) {
        self.name = name ?? UserDefaults.standard.string(forKey: "name") ?? ""
        self.description = description ?? UserDefaults.standard.string(forKey: "description") ?? ""
        self.client = client
    }
}

extension LoginViewModel {
    var isAlertDisplaying: Binding<Bool> {
        .init(
            get: { self.error != nil },
            set: {
                guard !$0 else { return }
                self.error = nil
            }
        )
    }
}

extension LoginViewModel {
    func login(completion: @escaping (String) -> Void) {
        let name = name
        let description = description
        guard !name.isEmpty else { return }
        client.publish(request: VersatileAPI.Login(name: name, description: description))
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: {
                    switch $0 {
                    case let .failure(error):
                        self.error = error
                    case .finished:
                        self.error = nil
                    }
                },
                receiveValue: {
                    UserDefaults.standard.set(name, forKey: "name")
                    UserDefaults.standard.set(description, forKey: "description")
                    completion($0.id)
                }
            ).store(in: &cancellables)
    }
}
