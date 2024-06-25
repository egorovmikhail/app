//
//  CreateAcronymCategoryPivot.swift
//
//
//  Created by Михаил Егоров on 19.06.2024.
//

import Fluent

struct CreateAcronymCategoryPivot: AsyncMigration {
    
    func prepare(on database: any FluentKit.Database) async throws {
        try await database.schema("acronym-category-pivot")
            .id()
            .field("acronymID", .uuid, .required,
                   .references("acronyms", "id", onDelete: .cascade))
            .field("categoryID", .uuid, .required,
                   .references("categories", "id", onDelete: .cascade))
            .create()
    }
    
    
    func revert(on database: any FluentKit.Database) async throws {
        try await database.schema("acronym-category-pivot").delete()
    }
    
}
