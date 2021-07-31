//
//  VersatileAPI+Text.swift
//  Versatile
//
//  Created by 417.72KI on 2021/08/01.
//

import Foundation

extension VersatileAPI {
    enum Text {
        struct GetAll: APIRequest {
            typealias ResponseType = [TextEntity]

            var orderBy: (OrderBy, desc: Bool)?
            var limit: Int?
            var skip: Int?

            var path: String { "/text/all" }
            var method: HTTPMethod { .get }

            var query: [String : Any?]? {
                [
                    "$orderby": orderBy.flatMap { "\($0.0.rawValue) \($0.desc ? "desc": "asc")" },
                    "$limit": limit,
                    "$skip": skip
                ]
            }
        }
    }
}

extension VersatileAPI.Text {
    enum OrderBy: String {
        case createdAt = "_created_at"
        case updatedAt = "_updated_at"
    }
}
