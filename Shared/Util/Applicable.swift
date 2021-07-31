//
//  Applicable.swift
//  Versatile
//
//  Created by 417.72KI on 2021/07/31.
//

import Foundation

protocol Applicable {
}

extension Applicable where Self: AnyObject {
    @discardableResult
    func apply(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}

extension NSObject: Applicable {}
extension JSONDecoder: Applicable {}
extension JSONEncoder: Applicable {}
