//
//  String.swift
//  Versatile
//
//  Created by 417.72KI on 2021/08/01.
//

import Foundation

extension String {
    var camelized: String {
        guard !isEmpty else { return self }

        let words = lowercased().split(separator: "_")
            .map(String.init)
        let firstWord = words.first ?? ""

        return words.dropFirst().reduce(into: firstWord, { camel, word in
            camel.append(String(word.prefix(1).capitalized) + String(word.suffix(from: index(after: startIndex))))
        })
    }
}
