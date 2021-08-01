//
//  APIClient.swift
//  Versatile
//
//  Created by 417.72KI on 2021/07/31.
//

import Foundation
import Combine

protocol APIClient: AnyObject {
    func publish<T: APIRequest, V>(request: T) -> AnyPublisher<V, Error> where V == T.ResponseType
}

final class APIClientImpl: APIClient {
    private let session: URLSession
    private let decoder = JSONDecoder().apply {
        $0.keyDecodingStrategy = .convertFromSnakeCase
        $0.keyDecodingStrategy = .custom { keys in
            let key = keys.last!
            if key.stringValue.hasPrefix("_") {
                return key
            }
            return ResponseKey(stringLiteral: key.stringValue.camelized)
        }
        //$0.dateDecodingStrategy = .iso8601
        $0.dateDecodingStrategy = .custom {
            let container = try $0.singleValueContainer()
            let str = try container.decode(String.self)
            let formatter = ISO8601DateFormatter().apply {
                $0.formatOptions.insert(.withFractionalSeconds)
            }
            guard let date = formatter.date(from: str) else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unexpected date format: \(str)")
            }
            return date
        }
    }

    init(session: URLSession) {
        self.session = session
    }

    func publish<T: APIRequest, V>(request: T) -> AnyPublisher<V, Error> where V == T.ResponseType {
        do {
            let urlRequest = try request.asURLRequest()
            print(urlRequest)
            return session.dataTaskPublisher(for: urlRequest)
                .retry(3)
                .map(\.data)
                .handleEvents(receiveOutput: { print(String(data: $0, encoding: .utf8) ?? "") })
                .decode(type: V.self, decoder: decoder)
                .handleEvents(
                    receiveOutput: { print($0) },
                    receiveCompletion: { print($0) }
                )
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
    }
}

#if DEBUG
final class APIClientMock: APIClient {
    func publish<T, V>(request: T) -> AnyPublisher<V, Error> where T : APIRequest, V == T.ResponseType {
        return Fail(error: VersatileAPI.Error.unimplemented)
            .eraseToAnyPublisher()
    }
}
#endif
