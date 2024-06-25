//
//  Acronym.swift
//
//
//  Created by Михаил Егоров on 16.06.2024.
//

import Vapor
import Fluent
import struct Foundation.UUID

final class Acronym: Model, @unchecked Sendable{
    static let schema = "acronyms"
    
    @ID
    var id: UUID?
    
    @Field(key: "short")
    var short: String
    
    @Field(key: "long")
    var long: String
    
    @Parent(key: "userID")
    var user: User
    
    @Siblings(
        through: AcronymCategoryPivot.self,
        from: \.$acronym,
        to: \.$category)
    public var categories: [Category]
    
    init() {}
    
    init(id: UUID? = nil,
         short: String,
         long: String,
         userID: User.IDValue
    ) {
        self.id = id
        self.short = short
        self.long = long
        self.$user.id = userID
    }
    
    func toDTO() -> AcronymDTO {
        .init(
            id: self.id,
            short: self.short,
            long: self.long, 
            userID: self.$user.id            
        )
    }
}
