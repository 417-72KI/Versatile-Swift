//
//  VersatileAPI+Login.swift
//  Versatile
//
//  Created by 417.72KI on 2021/07/31.
//

import Foundation

extension VersatileAPI {
    struct Login: APIRequest {
        typealias ResponseType = LoginResponseEntity

        var name: String
        var description: String

        var path: String { "/user/create_user" }
        var method: HTTPMethod { .post }
        var body: RequestBody? {
            JSONRequestBody(object: [
                "name": name,
                "description": description
            ])
        }
    }
}
