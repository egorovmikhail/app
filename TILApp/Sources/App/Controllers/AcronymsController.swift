//
//  AcronymsController.swift
//
//
//  Created by Михаил Егоров on 18.06.2024.
//

import Vapor
import Fluent

struct AcronymsController: RouteCollection {
    func boot(routes: any Vapor.RoutesBuilder) throws {
        let acronym = routes.grouped("api", "acronyms")
        acronym.post(use: createHandler)
        acronym.get(use: getAllHandler)
        acronym.get(":acronymID", use: getHandler)
        acronym.put(":acronymID", use: updateHandler)
        acronym.delete(":acronymID", use: deleteHandler)
        acronym.get("search", use: searchHandler)
        acronym.get("first", use: firstHandler)
        acronym.get("sorted", use: sortedHandler)
        acronym.get(":acronymID", "user", use: getUserHandler)
        acronym.post(":acronymID", "categories", ":categoryID", use: addCategoriesHandler)
        acronym.get(":acronymID", "categories", use: getCategoriesHandler)
        acronym.delete(":acronymID", "categories", ":categoryID", use: removeCategoriesHandler)
    }
    
    
    //MARK: Create Acronym
    @Sendable
    func createHandler(req: Request) async throws -> AcronymDTO {
        let acronym = try req.content.decode(AcronymDTO.self).toModel()
        try await acronym.save(on: req.db)
        return acronym.toDTO()
    }
    
    
    //    MARK: Retrieve Acronym
    @Sendable
    func getAllHandler(req: Request) async throws -> [AcronymDTO] {
        try await Acronym.query(on: req.db).all().map{$0.toDTO()}
    }
    
    
    //    MARK: Retrieve a single Acronym
    @Sendable
    func getHandler(req: Request) async throws -> AcronymDTO {
        guard let acronym = try await Acronym.find(req.parameters.get("acronymID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return acronym.toDTO()
    }
    
    
    //    MARK: Update
    @Sendable
    func updateHandler(req: Request) async throws -> AcronymDTO {
        guard let acronym = try await Acronym.find(req.parameters.get("acronymID"), on: req.db) else {
            throw Abort(.notFound)
        }
        let updateAcronym = try req.content.decode(AcronymDTO.self).toModel()
        acronym.short = updateAcronym.short
        acronym.long = updateAcronym.long
        try await acronym.save(on: req.db)
        return acronym.toDTO()
    }
    
    //    MARK: Delete
    @Sendable
    func deleteHandler(req: Request) async throws -> HTTPStatus {
        guard let acronym = try await Acronym.find(req.parameters.get("acronymID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await acronym.delete(on: req.db)
        return .notFound
    }
    
    //  MARK: Search
    @Sendable
    func searchHandler(req: Request) async throws -> [AcronymDTO] {
        guard let searchTerm = req.query[String.self, at: "term"] else {
            throw Abort(.badRequest)
        }
        
        let search = try await Acronym.query(on: req.db)
            .group(.or) {
                or in or.filter(\.$short == searchTerm)
                or.filter(\.$long == searchTerm)
            }.all()
        //            .filter(\.$short == searchTerm).all()
        return search.map{$0.toDTO()}
    }
    
    //    MARK: First result
    @Sendable
    func firstHandler(req: Request) async throws -> AcronymDTO {
        guard let first = try await Acronym.query(on: req.db).first() else {
            throw Abort(.notFound)
        }
        return first.toDTO()
    }
    
    //    MARK: - Sorting results
    @Sendable
    func sortedHandler(req: Request) async throws ->[AcronymDTO] {
        guard let sorted = try? await Acronym.query(on: req.db)
            .sort(\.$short, .ascending)
            .all() else {
            throw Abort(.notFound)
        }
        return sorted.map{$0.toDTO()}
    }
    
    //    MARK:  - Querying the relationship
    //             Getting the parent
    @Sendable
    func getUserHandler(req: Request) async throws -> UserDTO {
        guard let acronym = try await Acronym.find(req.parameters.get("acronymID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return try await acronym.$user.get(on: req.db).toDTO()
    }
    
//    MARK: - Create the relationship
    @Sendable
    func addCategoriesHandler(req: Request) async throws -> HTTPStatus {
        guard let acronymQuery = try await Acronym.find(req.parameters.get("acronymID"), on: req.db) else {
            throw Abort(.notFound)
        }
        guard let categoryQuery = try await Category.find(req.parameters.get("categoryID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await acronymQuery.$categories .attach(categoryQuery, on: req.db)
        return .created
    }
    
//    MARK: - Querying the relationship
//            Acronym’s categories
    @Sendable
    func getCategoriesHandler(req: Request)
    async throws -> [CategoryDTO] {
        
        guard let acronym =  try await Acronym.find(req.parameters.get("acronymID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let categories: [CategoryDTO] = try await acronym.$categories.query(on: req.db).all().map{$0.toDTO()}
        
        return  categories
    }
    
//    MARK: - Removing the relationship
    @Sendable
    func removeCategoriesHandler(req: Request) async throws -> HTTPStatus {
        guard let acronymQuery = try await Acronym.find(req.parameters.get("acronymID"), on: req.db) else {
            throw Abort(.notFound)
        }
        guard let categoryQuery = try await Category.find(req.parameters.get("categoryID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await acronymQuery.$categories.detach(categoryQuery, on: req.db)
        return .created
    }
}


