//
//  TextListViewModel.swift
//  Versatile
//
//  Created by 417.72KI on 2021/08/01.
//

import SwiftUI
import Combine

final class TextListViewModel: ObservableObject {
    @Published var id: String?
    @Published var texts: [TextModel] = []
    @Published var error: Error?
    @Published var hasNext: Bool = true

    private let client: APIClient
    private var cancellables: Set<AnyCancellable> = []

    init(client: APIClient) {
        self.client = client
    }
}

extension TextListViewModel {
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

extension TextListViewModel {
    func fetchNext() {
        guard hasNext else { return }
        let skip = texts.count
        let limit = 20
        client.publish(request: VersatileAPI.Text.GetAll(orderBy: (.createdAt, desc: true), limit: limit, skip: skip))
            .flatMap { [self] in $0.map { fetchUser(of: $0) }.zip() }
            .map { $0.map(TextModel.init) }
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
                    self.texts += $0
                    self.hasNext = $0.count >= limit
                }
            ).store(in: &cancellables)
    }
}

private extension TextListViewModel {
    func fetchUser(of text: TextEntity) -> AnyPublisher<(TextEntity, UserEntity?), Error> {
        guard let userId = text.userId else {
            return Just((text, nil))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        return client.publish(request: VersatileAPI.User.Get(userId: userId))
            .map { (text, $0) }
            .eraseToAnyPublisher()
    }
}
