//
//  Alert.swift
//  Versatile
//
//  Created by 417.72KI on 2021/07/31.
//

import SwiftUI

extension Alert {
    init(error: Error) {
        self = Alert(nsError: error as NSError)
    }

    init(localizedError: LocalizedError) {
        self = Alert(nsError: localizedError as NSError)
    }

    init(nsError: NSError) {
        let message: Text? = {
            let message = [
                nsError.localizedFailureReason,
                nsError.localizedRecoverySuggestion
            ]
            .compactMap { $0 }
            .joined(separator: "\n\n")
            return message.isEmpty ? nil : Text(message)
        }()

        self = Alert(title: Text(nsError.localizedDescription),
                     message: message,
                     dismissButton: .default(Text("OK")))
    }
}
