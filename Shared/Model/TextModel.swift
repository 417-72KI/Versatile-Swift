//
//  TextModel.swift
//  Versatile
//
//  Created by 417.72KI on 2021/08/01.
//

import Foundation

struct TextModel {
    var id: String
    var text: String

    var user: UserEntity?

    var createdAt: Date
    var updatedAt: Date

    var inReplyToUserId: String?
    var inReplyToTextId: String?
}

extension TextModel {
    init(textEntity: TextEntity, userEntity: UserEntity?) {
        self.init(
            id: textEntity.id,
            text: textEntity.text,
            user: userEntity,
            createdAt: textEntity.createdAt,
            updatedAt: textEntity.updatedAt,
            inReplyToUserId: textEntity.inReplyToUserId,
            inReplyToTextId: textEntity.inReplyToTextId
        )
    }
}
