//
//  ItemViewModel.swift
//  ItemApp
//
//  Created by Karin Prater on 12/05/2025.
//

import Foundation

final class ItemViewModel: ObservableObject {
    
    @Published var items: [Item] = Item.examples
    @Published var deleteDisabled = false
    
    func deleteLastItem() {
        guard items.isEmpty == false else { return }
        items.removeLast()
        deleteDisabled = items.isEmpty
    }
    
    func addItem(name: String) {
        items.append(Item(name: name))
        deleteDisabled = items.isEmpty
    }
}
