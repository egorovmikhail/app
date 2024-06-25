//
//  CreateAcronym.swift
//
//
//  Created by Михаил Егоров on 16.06.2024.
//

import Fluent

struct CreateAcronym: AsyncMigration {
    
    func prepare(on database: any FluentKit.Database) async throws {
        try await database.schema("acronyms")
            .id()
            .field("short", .string, .required)
            .field("long", .string, .required)
            .field("userID", .uuid, .required, .references("users", "id"))
            .create()
    }
    
    func revert(on database: any FluentKit.Database) async throws {
        try await database.schema("acronyms").delete()
    }
    
}
