//
//  Publisher+Array.swift
//  Versatile
//
//  Created by 417.72KI on 2021/08/01.
//

import Combine

extension Array where Element: Publisher {
    func zip() -> AnyPublisher<[Element.Output], Element.Failure> {
        dropFirst().reduce(into: AnyPublisher(self[0].map { [$0] })) {
            $0 = $0.zip($1) { $0 + [$1] }.eraseToAnyPublisher()
        }
    }
}
