//
//  CategoryDTO.swift
//
//
//  Created by Михаил Егоров on 19.06.2024.
//

import Fluent
import Vapor
struct CategoryDTO: Content {
    var id: UUID?
    var name: String
    
    
    func toModel() -> Category {
        let model = Category()
        model.id = self.id
        model.name = self.name
        return model
    }
}

