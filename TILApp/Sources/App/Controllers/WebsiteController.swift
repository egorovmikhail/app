//
//  WebsiteController.swift
//
//
//  Created by Михаил Егоров on 23.06.2024.
//

import Vapor
import Leaf

struct IndexContext: Encodable {
    let title: String
    let acronyms: [Acronym]
}

struct AcronymContext: Encodable {
    let title: String
    let acronym: Acronym
    let user: User
}

struct UserContext: Encodable {
    let title: String
    let user: User
    let acronyms: [Acronym]
}

struct AllUsersContext: Encodable {
  let title: String
  let users: [User]
}

struct WebsiteController: RouteCollection {
    func boot(routes: any Vapor.RoutesBuilder) throws {
        routes.get(use: indexHandler)
        routes.get("acronyms", ":acronymID", use: acronymHandler)
        routes.get("users", ":userID", use: userHandler)
        routes.get("users", use: allUsersHandler)
    }
    
    @Sendable
    func indexHandler(req: Request) async throws -> View {
        guard let acronyms = try? await Acronym.query(on: req.db).all() else {
            throw Abort(.notFound)
        }
        let context = IndexContext(title: "Home page", acronyms: acronyms)
        return try await req.view.render("index", context)
    }
    
    @Sendable
    func acronymHandler(req: Request)
    async throws -> View {
        guard let acronym = try await Acronym.find(req.parameters.get("acronymID"), on: req.db) else {
            throw Abort(.notFound)
        }
        let user = try await acronym.$user.get(on: req.db)
        let context = AcronymContext(
            title: acronym.short,
            acronym: acronym,
            user: user)
        return try await req.view.render("acronym", context)
    }
    
    
    @Sendable
    func userHandler(_ req: Request) async throws-> View {
        guard let user = try await User.find(req.parameters.get("userID"), on: req.db) else {
            throw Abort(.notFound)
        }
        let acronyms = try await user.$acronyms.get(on: req.db)
        let context = UserContext(
            title: user.name,
            user: user,
            acronyms: acronyms)
        return try await req.view.render("user", context)
    }
    
    @Sendable
    func allUsersHandler(_ req: Request) async throws -> View {
    
        let users = try await User.query(on: req.db).all()
          
            let context = AllUsersContext(
              title: "All Users",
              users: users)
        return try await req.view.render("allUsers", context)      
    }
}



