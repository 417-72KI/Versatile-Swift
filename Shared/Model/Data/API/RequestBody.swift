//
//  RequestBody.swift
//  Versatile
//
//  Created by 417.72KI on 2021/07/31.
//

import Foundation

protocol RequestBody {
    var contentType: String { get }
    var data: Data? { get }
}

struct JSONRequestBody {
    var object: Any
}

extension JSONRequestBody: ExpressibleByDictionaryLiteral {
    public typealias Key = String
    public typealias Value = Any

    public init(dictionaryLiteral elements: (Key, Value)...) {
        self.init(object: Dictionary(uniqueKeysWithValues: elements))
    }
}

extension JSONRequestBody: RequestBody {
    var contentType: String { "application/json" }

    var data: Data? {
        try? JSONSerialization.data(withJSONObject: object, options: [])
    }
}
