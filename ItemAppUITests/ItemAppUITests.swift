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
        if let run = testRun, !run.hasSucceeded {
            allureCaptureFailureArtifacts(app: app)
        }
        app = nil
    }

    @MainActor
    func test_items_shown() throws {
        AllureXCTestSupport.setDisplayName("Item list displays existing items")
        AllureXCTestSupport.addLabel("testlioManualTestID",
                                     value: "5a01a6e7-856a-4193-bd02-10fe47fbf644")
        AllureXCTestSupport.addDescription("Smoke check that seeded items are visible to the user.")
        
        let collection = AllureXCTestSupport.step("(1) Locate item list container") {
            let view = app.descendants(matching: .any)[itemListScreen.itemList]
            XCTAssertTrue(view.exists, "Should see the container e.g. Scrollview with the items")
            return view
        }
        
        AllureXCTestSupport.step("(2) Assert list has at least one item") {
            let itemRowID = itemListScreen.item(nil)
            let predicate = NSPredicate(format: "identifier CONTAINS '\(itemRowID)'")
            let items = collection.descendants(matching: .any).matching(predicate)
            
            XCTAssertTrue(items.count > 0, "Expecting at least one item shown")
            allureAttachAppScreenshot(app: app, name: "Item list visible")
        }
    }
    
    
    @MainActor
    func test_add_new_item() throws {
        AllureXCTestSupport.setDisplayName("User can add a new item")
        AllureXCTestSupport.addLabel("testlioManualTestID",
                                     value: "d8c9b3c1-7c03-4c4e-8a4c-8972f8a7be21")
        AllureXCTestSupport.addDescription("Happy path add-item flow via add sheet.")
        
        let (collection, predicate, initialCount) = AllureXCTestSupport.step("(1) Capture initial list state") {
            let itemRowID = itemListScreen.item(nil)
            let predicate = NSPredicate(format: "identifier CONTAINS '\(itemRowID)'")
            let collection = app.descendants(matching: .any)[itemListScreen.itemList]
            let initialCount = collection.descendants(matching: .any).matching(predicate).count
            return (collection, predicate, initialCount)
        }

        let sheetView = AllureXCTestSupport.step("(2) Open add item sheet") {
            app.buttons[itemListScreen.addButton].tap()
            let view = app.descendants(matching: .any)[newItemScreen.sheet]
            XCTAssert(view.waitForExistence(timeout: 1),
                     "Expected to show new item sheet")
            return view
        }
        
        AllureXCTestSupport.step("(3) Input new item name") {
            let textfield = app.textFields[newItemScreen.itemNameTextField]
            XCTAssert(textfield.waitForExistence(timeout: 1))
                      
            textfield.tap()
            textfield.typeText("Test")
        }

        AllureXCTestSupport.step("(4) Submit new item") {
            app.buttons[newItemScreen.addButton].tap()
        }
    
        AllureXCTestSupport.step("(5) Verify sheet closes and list increments") {
            XCTAssert(sheetView.waitForNonExistence(timeout: 1),
                      "Expected that add button closes sheet")
            
            let finalItemCount = collection.descendants(matching: .any).matching(predicate).count
            
            XCTAssertEqual(initialCount + 1, finalItemCount,
                           "Expected to have one more item in the list")
            allureAttachAppScreenshot(app: app, name: "Item list after adding")
        }
    }
}
