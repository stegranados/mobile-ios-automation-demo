//
//  Item.swift
//  ItemApp
//
//  Created by Karin Prater on 12/05/2025.
//


import Foundation

struct Item: Identifiable {
    var name: String
    let id: UUID
    init(name: String, id: UUID = UUID()) {
        self.name = name
        self.id = id
    }
    
    static var examples: [Item] {
        [Item(name: "first"), Item(name: "second"), Item(name: "third"), Item(name: "forth")]
    }
}
