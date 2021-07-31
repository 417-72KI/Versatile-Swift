//
//  VersatileAPI+User.swift
//  Versatile
//
//  Created by 417.72KI on 2021/08/01.
//

import Foundation

extension VersatileAPI {
    enum User {
        struct Get: APIRequest {
            typealias ResponseType = UserEntity

            var userId: String

            var path: String { "/user/\(userId)" }
            var method: HTTPMethod { .get }
        }
    }
}
