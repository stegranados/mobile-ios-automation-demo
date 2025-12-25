//
//  ItemAppUITests.swift
//  ItemAppUITests
//
//  Created by Karin Prater on 12/05/2025.
//

import XCTest

final class ItemAppUITests: XCTestCase {

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
    func test_items_shown() throws {
        // --- GIVEN ---
        
        // --- WHEN ---
        
        // --- THEN ---
       let collection = app.descendants(matching: .any)[itemListScreen.itemList]
        
        XCTAssertTrue(collection.exists, "Should see the container e.g. Scrollview with the items")
        
        let itemRowID = itemListScreen.item(nil)
        let predicate = NSPredicate(format: "identifier CONTAINS '\(itemRowID)'")
        let items = collection.descendants(matching: .any).matching(predicate)
         
         XCTAssertTrue(items.count > 0, "Expecting at least one item shown")
    }
    
    
    @MainActor
    func test_add_new_item() throws {
        // --- GIVEN ---
        let itemRowID = itemListScreen.item(nil)
        let predicate = NSPredicate(format: "identifier CONTAINS '\(itemRowID)'")
        let collection = app.descendants(matching: .any)[itemListScreen.itemList]
        let initialCount = collection.descendants(matching: .any).matching(predicate).count
        

        // --- WHEN ---
        app.buttons[itemListScreen.addButton].tap()
        let sheetView = app.descendants(matching: .any)[newItemScreen.sheet]
        XCTAssert(sheetView.waitForExistence(timeout: 1),
                 "Expected to show new item sheet")
        
        let textfield = app.textFields[newItemScreen.itemNameTextField]
        XCTAssert(textfield.waitForExistence(timeout: 1))
                  
        textfield.tap()
        textfield.typeText("Test")

        app.buttons[newItemScreen.addButton].tap()
    
        // --- THEN ---
        XCTAssert(sheetView.waitForNonExistence(timeout: 1),
                  "Expected that add button closes sheet")
        
        let finalItemCount = collection.descendants(matching: .any).matching(predicate).count
        
        XCTAssertEqual(initialCount + 1, finalItemCount,
                       "Expected to have one more item in the list")
    }
}
