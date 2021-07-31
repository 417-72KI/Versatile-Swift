//
//  Entity.swift
//  Versatile
//
//  Created by 417.72KI on 2021/07/31.
//

import Foundation

protocol Entity: Decodable & Hashable {}

extension Array: Entity where Element: Entity {}
