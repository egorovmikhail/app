//
//  CreateUser.swift
//
//
//  Created by Михаил Егоров on 18.06.2024.
//

import Fluent

struct CreateUser: AsyncMigration {
    
    func prepare(on database: any FluentKit.Database) async throws {
        try await database.schema("users")
            .id()
            .field("name", .string, .required)
            .field("username", .string, .required)
            .create()
    }
    
    func revert(on database: any FluentKit.Database) async throws {
        try await database.schema("users").delete()
    }
      
}


