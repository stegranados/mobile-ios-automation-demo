//
//  RemoveItemsTest.swift
//  ItemAppTests
//
//  Created by Karin Prater on 12/05/2025.
//

import Testing
@testable import ItemApp

struct RemoveItemsTest {

    @Test("Remove Button lowers item count")
    func items_when_remove_button_then_items_count_lowered() async throws {
        // --- GIVEN ---
        let vm = ItemViewModel()
        let itemCount = vm.items.count
        let expectedItemCount = itemCount - 1
        #expect(vm.items.count > 0)
        
        // --- WHEN ---
        vm.deleteLastItem()
        
        // --- THEN ---
        #expect(vm.items.count == expectedItemCount,
                "Expected that the array has \(expectedItemCount) items")
    }
    
    @Test func no_items_remove_disabled() {
        // --- GIVEN ---
        let vm = ItemViewModel()
        #expect(vm.deleteDisabled == false)
        
        // --- WHEN ---
        for _ in vm.items {
            vm.deleteLastItem()
        }
        
        // --- THEN ---
        #expect(vm.deleteDisabled == true, "Delete should not be allowed when we have no items")
    }
    
    @Test func no_items_when_remove_button_then_nothing_happens() async throws {
        // --- GIVEN ---
        let vm = ItemViewModel()
        vm.items = []
        
        // --- WHEN ---
        vm.deleteLastItem()
        
        // --- THEN ---
        #expect(vm.items.isEmpty)
    }
    
    @Test func add_new_item() async throws {
        // --- GIVEN ---
        let vm = ItemViewModel()
        let expectedItemCount = vm.items.count + 1
        let newItemName = "new"
        
        // --- WHEN ---
        vm.addItem(name: newItemName)
        
        // --- THEN ---
        #expect(vm.items.count == expectedItemCount)
        #expect(vm.items.last?.name == newItemName)
    }
}
