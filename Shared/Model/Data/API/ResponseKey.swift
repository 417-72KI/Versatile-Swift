//
//  ResponseKey.swift
//  Versatile
//
//  Created by 417.72KI on 2021/08/01.
//

import Foundation

struct ResponseKey: CodingKey, ExpressibleByStringLiteral {
    typealias StringLiteralType = String

    var stringValue: String
    var intValue: Int?

    init(stringLiteral value: String) {
        self.stringValue = value
        self.intValue = nil
    }

    init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }

    init?(intValue: Int) {
        self.stringValue = String(intValue)
        self.intValue = intValue
    }
}
