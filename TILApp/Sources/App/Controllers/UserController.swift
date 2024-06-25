//
//  UserController.swift
//
//
//  Created by Михаил Егоров on 18.06.2024.
//

import Vapor
import Fluent

struct UserController: RouteCollection{
    func boot(routes: any Vapor.RoutesBuilder) throws {
        let userRoute = routes.grouped("api", "users")
        userRoute.post(use: createHandler)
        userRoute.get(use: getAllHandler)
        userRoute.get(":userID", use: getHandler)
        userRoute.get(":userID", "acronyms", use: getAcronymsHandler)
    }
    
    @Sendable
    func createHandler(req: Request) async throws -> UserDTO{
        let user = try req.content.decode(UserDTO.self).toModel()
        try await user.save(on: req.db)
        return user.toDTO()
    }
    
    @Sendable
    func getAllHandler(req: Request) async throws -> [UserDTO] {
        try await User.query(on: req.db).all().map{$0.toDTO()}
    }
    
    @Sendable
    func getHandler(req: Request) async throws -> UserDTO {
        guard let user = try await User.find(req.parameters.get("userID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return user.toDTO()
    }
    
//    MARK: - Getting the children
//    Acronyms user
    @Sendable
    func getAcronymsHandler(req: Request) async throws -> [AcronymDTO] {
        guard let user = try await User.find(req.parameters.get("userID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return try await user.$acronyms.get(on: req.db).map{$0.toDTO()}
    }
}
