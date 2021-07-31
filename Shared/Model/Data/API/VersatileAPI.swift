//
//  VersatileAPI.swift
//  Versatile
//
//  Created by 417.72KI on 2021/07/31.
//

import Foundation

enum VersatileAPI {
    static let scheme = "https"
    static let host = "versatileapi.herokuapp.com"
    static let apiRootPath = "/api"
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

// MARK: -
protocol APIRequest {
    associatedtype ResponseType: Entity

    var path: String { get }
    var method: HTTPMethod { get }
    var header: [String: String] { get }
    var query: [String: Any?]? { get }
    var body: RequestBody? { get }

    func asURLRequest() throws -> URLRequest
}

extension APIRequest {
    var header: [String: String] { [:] }
    var query: [String: Any?]? { nil }
    var body: RequestBody? { nil }
}

extension APIRequest {
    func asURLRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = VersatileAPI.scheme
        components.host = VersatileAPI.host
        components.path = VersatileAPI.apiRootPath + path
        components.percentEncodedQueryItems = query?.compactMap { key, value in
            guard let value = value else { return nil }
            return URLQueryItem(name: key, value: String(describing: value).addingPercentEncoding(withAllowedCharacters: .alphanumerics))
        }
        guard let url = components.url else {
            fatalError("Invalid components: \(components)")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        header.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        request.httpBody = body?.data
        return request
    }
}

// MARK: -
extension VersatileAPI {
    enum Error: LocalizedError {
        case unimplemented
    }
}

extension VersatileAPI.Error {
    var errorDescription: String? {
        switch self {
        case .unimplemented:
            return "Unimplemented"
        }
    }

    var failureReason: String? {
        switch self {
        case .unimplemented:
            return "This function is unimplemented"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .unimplemented:
            return nil
        }
    }
}
