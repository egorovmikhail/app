//
//  CreateCategory.swift
//
//
//  Created by Михаил Егоров on 19.06.2024.
//

import Fluent
struct CreateCategory: AsyncMigration {
    
    func prepare(on database: Database) async throws {
        try await database.schema("categories")
            .id()
            .field("name", .string, .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("categories").delete()
    }
}
