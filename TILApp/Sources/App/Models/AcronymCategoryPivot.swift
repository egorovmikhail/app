//
//  AcronymCategoryPivot.swift
//
//
//  Created by Михаил Егоров on 19.06.2024.
//

import Foundation
import Fluent

final class AcronymCategoryPivot: Model, @unchecked Sendable {
    static let schema = "acronym-category-pivot"
    
    @ID
    var id: UUID?
    
    @Parent(key: "acronymID")
    var acronym: Acronym
    
    @Parent(key: "categoryID")
    var category: Category 
    
    init() { }
    
    internal init(id: UUID? = nil,
                  acronym: Acronym,
                  category: Category
    ) throws {
        self.id = id
        self.$acronym.id = try acronym.requireID()
        self.$category.id = try category.requireID()
    }
}
