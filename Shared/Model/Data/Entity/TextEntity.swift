//
//  TextEntity.swift
//  Versatile
//
//  Created by 417.72KI on 2021/08/01.
//

import Foundation

struct TextEntity: Entity {
    var id: String
    var text: String
    var userId: String?
    var createdAt: Date
    var updatedAt: Date
    var inReplyToUserId: String?
    var inReplyToTextId: String?

    enum CodingKeys: String, CodingKey {
        case id,
             text,
             userId = "_user_id",
             createdAt = "_created_at",
             updatedAt = "_updated_at",
             inReplyToUserId,
             inReplyToTextId
    }
}
