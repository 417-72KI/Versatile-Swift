//
//  AppState.swift
//  Versatile
//
//  Created by 417.72KI on 2021/07/31.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var userId: String?
}

extension AppState {
    var isLoggedIn: Bool { userId != nil }
}
