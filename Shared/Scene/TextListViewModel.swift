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
    @Published var isLoading: Bool = false
    @Published var isPosting: Bool = false

    private var userList: [String: UserEntity] = [:]

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
    func fetchFirst() {
        let limit = 20
        fetch(from: 0, limit: limit)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in
                    self?.texts = $0
                    self?.hasNext = $0.count >= limit
                }
            )
            .store(in: &cancellables)
    }

    func fetchNext() {
        guard hasNext else { return }
        let offset = texts.count
        let limit = 20
        fetch(from: offset, limit: limit)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in
                    self?.texts += $0
                    self?.hasNext = $0.count >= limit
                }
            )
            .store(in: &cancellables)
    }
}

private extension TextListViewModel {
    func fetch(from offset: Int, limit: Int) -> AnyPublisher<[TextModel], Error> {
        guard !isLoading else {
            return Just([])
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        isLoading = true
        return client.publish(request: VersatileAPI.Text.GetAll(orderBy: (.createdAt, desc: true), limit: limit, skip: offset))
            .flatMap { [weak self] in $0.compactMap { self?.fetchUser(of: $0) }.zip() }
            .map { $0.map(TextModel.init) }
            .receive(on: DispatchQueue.main)
            .handleEvents(
                receiveCompletion: { [weak self] in
                    self?.isLoading = false
                    switch $0 {
                    case let .failure(error):
                        self?.error = error
                    case .finished:
                        self?.error = nil
                    }
                }
            )
            .eraseToAnyPublisher()
    }
}

private extension TextListViewModel {
    func fetchUser(of text: TextEntity) -> AnyPublisher<(TextEntity, UserEntity?), Error> {
        guard let userId = text.userId else {
            return Just((text, nil))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        if let user = userList[userId] {
            return Just((text, user))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        return client.publish(request: VersatileAPI.User.Get(userId: userId))
            .handleEvents(receiveOutput: { [weak self] in self?.userList[userId] = $0 })
            .map { $0 as UserEntity? }
            .catch { _ in Just(nil).setFailureType(to: Error.self) }
            .map { (text, $0) }
            .eraseToAnyPublisher()
    }
}

extension TextListViewModel {
    func post(_ text: String) {
        guard !text.isEmpty, !isPosting else { return }

        isPosting = true
        client.publish(request: VersatileAPI.Text.Post(text: text))
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] in
                    self?.isPosting = false
                    switch $0 {
                    case let .failure(error):
                        self?.error = error
                    case .finished:
                        self?.error = nil
                    }
                },
                receiveValue: { [weak self] in
                    print($0)
                    self?.fetchFirst()
                }
            )
            .store(in: &cancellables)
    }
}
