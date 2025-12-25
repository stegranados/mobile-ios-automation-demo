//
//  UIIdentifiers.swift
//  ItemApp
//
//  Created by Karin Prater on 24/05/2025.
//

import Foundation

enum UIIdentifiers {
    
    enum AddNewItemScreen {
        static let addButton = "AddNewItemScreen.button.add"
        static let itemNameTextField = "AddNewItemScreen.textfield.newItem"
        static let sheet = "AddNewItemScreen.sheet.shown"
    }
    
    enum ItemListScreen {
        static let itemList = "ItemListScreen.itemList"
        static let addButton = "ItemListScreen.button.add"
        static let deleteButton = "ItemListScreen.button.delete"
        
        static func item(_ id: UUID?) -> String {
            "ItemListScreen.item.\(id?.uuidString ?? "")"
        }
    }

}
