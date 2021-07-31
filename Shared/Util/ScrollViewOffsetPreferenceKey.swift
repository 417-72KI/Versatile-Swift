//
//  ScrollViewOffsetPreferenceKey.swift
//  Versatile
//
//  Created by 417.72KI on 2021/08/01.
//

import SwiftUI

struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    typealias Value = CGFloat

    static var defaultValue: Value = 0

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}
