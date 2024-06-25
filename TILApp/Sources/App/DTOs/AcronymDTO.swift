//
//  AcronymDTO.swift
//
//
//  Created by Михаил Егоров on 17.06.2024.
//

import Fluent
import Vapor

struct AcronymDTO: Content {
    var id: UUID?
    var short: String
    var long: String
    let userID: UUID

    func toModel() -> Acronym {
        let model = Acronym()

        model.id = self.id
        model.short = self.short
        model.long = self.long
        model.$user.id = self.userID

        return model
    }
}
