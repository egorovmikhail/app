//
//  User.swift
//
//
//  Created by Михаил Егоров on 18.06.2024.
//

import Fluent
import Vapor
import struct Foundation.UUID

final class User: Model, @unchecked Sendable {
    
    static let schema = "users"
    
    @ID
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "username")
    var username: String
    
    @Children(for: \.$user)
    var acronyms: [Acronym]
    
    init() {}
    
    internal init(id: UUID? = nil, name: String, username: String) {
        self.id = id
        self.name = name
        self.username = username
        
    }
    
    func toDTO() -> UserDTO {
        .init(
            id: self.id,
            name: self.name,
            username: self.username
        )
    }
}
