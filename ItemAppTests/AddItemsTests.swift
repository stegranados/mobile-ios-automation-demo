//
//  AddItemsTests.swift
//  ItemAppTests
//
//  Created by Karin Prater on 19/05/2025.
//

import XCTest
@testable import ItemApp

final class AddItemsTests: XCTestCase {

    func test_add_new_item() {
        // --- GIVEN ---
        let vm = ItemViewModel()
        let initialCount = vm.items.count
        let expectedName = "Test Item"

        // --- WHEN ---
        vm.addItem(name: expectedName)

        // --- THEN ---
        XCTAssertEqual(vm.items.count, initialCount + 1,
                       "Item count should be increased by one")
        XCTAssertEqual(vm.items.last?.name, expectedName,
                       "Expected that the last items title is the new items title")
    }
    
    func test_add_empty_name_item_is_allowed() {
        // --- GIVEN ---
        let vm = ItemViewModel()

        // --- WHEN ---
        vm.addItem(name: "")

        // --- THEN ---
        XCTAssertEqual(vm.items.last?.name, "",
                       "Should be allowed to add an item with empty name field")
    }
}
