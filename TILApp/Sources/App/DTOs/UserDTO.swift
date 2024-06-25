//
//  UserDTO.swift
//
//
//  Created by Михаил Егоров on 18.06.2024.
//

import Fluent
import Vapor

struct UserDTO: Content {
    
    var id: UUID?
    var name: String
    var username: String
    var acronums: [AcronymDTO]?
    
    
    func toModel() -> User {
        let model = User()
        
        model.id = self.id
        model.name = self.name
        model.username = self.username
        
        return model
    }
}
