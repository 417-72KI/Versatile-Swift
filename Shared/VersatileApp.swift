//
//  VersatileApp.swift
//  Shared
//
//  Created by 417.72KI on 2021/07/31.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif
#if canImport(Cocoa)
import Cocoa
#endif

@main
struct VersatileApp: App {
    @StateObject var appState = AppState()
    private let apiClient: APIClient = APIClientImpl(session: .shared)

    #if canImport(UIKit)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif
    #if canImport(Cocoa)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif

    #if canImport(UIKit)
    var body: some Scene {
        WindowGroup {
            ContentView(apiClient: APIClientImpl(session: .shared))
        }
    }
    #endif
    #if canImport(Cocoa)
    var body: some Scene {
        WindowGroup {
            if appState.isLoggedIn {
                TextListView(viewModel: .init(client: apiClient))
                    .environmentObject(appState)
            } else {
                LoginView(viewModel: .init(client: apiClient))
                    .environmentObject(appState)
            }
        }
    }
    #endif
}
