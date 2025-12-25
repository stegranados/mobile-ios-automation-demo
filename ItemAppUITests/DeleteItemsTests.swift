//
//  DeleteItemsTests.swift
//  ItemAppUITests
//
//  Created by Karin Prater on 24/05/2025.
//

import XCTest

final class DeleteItemsTests: XCTestCase {
    
    let itemListScreen = UIIdentifiers.ItemListScreen.self
    let newItemScreen = UIIdentifiers.AddNewItemScreen.self
    
    var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false
        
        app = XCUIApplication()
        
        app.launchArguments = ["-UITest", "no-animations"]
        app.launchEnvironment["-base-url"] = "www.myapp.v2.com"
        
        app.launch()
    }
    
    override func tearDown() async throws {
        app = nil
    }

    @MainActor
    func test_when_press_remove_last_button_then_updates_item_list() throws {
        // --- GIVEN ---
        let itemRowID = itemListScreen.item(nil)
        let predicate = NSPredicate(format: "identifier CONTAINS '\(itemRowID)'")
        let collection = app.descendants(matching: .any)[itemListScreen.itemList]
        let initialCount = collection.descendants(matching: .any).matching(predicate).count
        XCTAssertTrue(initialCount > 0, "Expecting at least one item shown")
                
        // --- WHEN ---
        app.buttons[itemListScreen.deleteButton].tap()

        // --- THEN ---
        let finalItemCount = collection.descendants(matching: .any).matching(predicate).count
        
        XCTAssertEqual(initialCount - 1, finalItemCount,
                       "Expecting that item count decreases by one")
    }
    
    @MainActor
    func test_when_all_items_removed_then_remove_disabled() throws {
        // --- GIVEN ---
        let itemRowID = itemListScreen.item(nil)
        let predicate = NSPredicate(format: "identifier CONTAINS '\(itemRowID)'")
        let collection = app.descendants(matching: .any)[itemListScreen.itemList]
        let initialCount = collection.descendants(matching: .any).matching(predicate).count
        XCTAssertTrue(initialCount > 0, "Expecting at least one item shown")
        let removeLastButton = app.buttons[itemListScreen.deleteButton]
        XCTAssertTrue(removeLastButton.isEnabled, "Delete buttons should be enabled initially")
        
        // --- WHEN ---
        for _ in 0..<initialCount {
            removeLastButton.tap()
        }
        
        // --- THEN ---
        let finalItemCount = collection.descendants(matching: .any).matching(predicate).count
        
        XCTAssertEqual(0, finalItemCount,
                       "Expecting that no more items")
        
        XCTAssertFalse(removeLastButton.isEnabled,
                        "Delete button should be disabled")
    }
}
