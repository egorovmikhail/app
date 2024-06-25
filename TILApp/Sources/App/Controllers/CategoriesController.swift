//
//  CategoriesController.swift
//
//
//  Created by Михаил Егоров on 19.06.2024.
//

import Vapor

struct CategoriesController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let categoriesRoute = routes.grouped("api", "categories")
        categoriesRoute.post(use: createHandler)
        categoriesRoute.get(use: getAllHandler)
        categoriesRoute.get(":categoryID", use: getHandler)
        categoriesRoute.get(":categoryID", "acronyms", use: getAcronymsHandler)
    }
    
    @Sendable
    func createHandler(_ req: Request) async
    throws -> CategoryDTO {
        guard let category = try?  req.content.decode(CategoryDTO.self).toModel() else {
            throw Abort(.conflict)
        }
        try await category.save(on: req.db)
        return category.toDTO()
    }
    
    @Sendable
    func getAllHandler(_ req: Request) async throws -> [CategoryDTO] {
        try await Category.query(on: req.db).all().map{$0.toDTO()}
    }
    
    @Sendable
    func getHandler(_ req: Request) async throws -> CategoryDTO {
        
        guard let category = try await Category.find(req.parameters.get("categoryID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return category.toDTO()
    }
    
//    MARK: - Querying the relationship
//            Category’s acronyms
    @Sendable
    func getAcronymsHandler(req: Request) async throws -> [AcronymDTO] {
        guard let category = try await Category.find(req.parameters.get("categoryID"), on: req.db) else {
            throw Abort(.notFound)
        }
        let acronyms: [AcronymDTO] = try await category.$acronyms.get(on: req.db).map{$0.toDTO()}
        return acronyms
    }
}
