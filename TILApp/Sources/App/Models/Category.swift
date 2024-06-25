//
//  Category.swift
//
//
//  Created by Михаил Егоров on 19.06.2024.
//
// Tag model

import Fluent
import Vapor

final class Category: Model, @unchecked Sendable {
    static let schema = "categories"
    
    @ID
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Siblings(
      through: AcronymCategoryPivot.self,
      from: \.$category,
      to: \.$acronym)
    public var acronyms: [Acronym]
    
    init() {}
    
    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
    
    func toDTO() -> CategoryDTO {
        .init(
            id: self.id,
            name: self.name
        )
    }
}
