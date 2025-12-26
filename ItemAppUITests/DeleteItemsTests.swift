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
        if let run = testRun, !run.hasSucceeded {
            allureCaptureFailureArtifacts(app: app)
        }
        app = nil
    }

    @MainActor
    func test_when_press_remove_last_button_then_updates_item_list() throws {
        AllureXCTestSupport.setDisplayName("User can remove the last item")
        AllureXCTestSupport.addLabel("testlioManualTestID",
                                     value: "1f7d7d7c-7ba9-4bbf-9c9a-8f4f5d45c111")
        AllureXCTestSupport.addDescription("Happy path removal flow via delete button.")
        
        let (collection, predicate, initialCount) = AllureXCTestSupport.step("(1) Ensure list has items") {
            let itemRowID = itemListScreen.item(nil)
            let predicate = NSPredicate(format: "identifier CONTAINS '\(itemRowID)'")
            let collection = app.descendants(matching: .any)[itemListScreen.itemList]
            let initialCount = collection.descendants(matching: .any).matching(predicate).count
            XCTAssertTrue(initialCount > 0, "Expecting at least one item shown")
            return (collection, predicate, initialCount)
        }
                
        AllureXCTestSupport.step("(2) Tap remove last button") {
            app.buttons[itemListScreen.deleteButton].tap()
        }

        AllureXCTestSupport.step("(3) Validate item count decreased") {
            let finalItemCount = collection.descendants(matching: .any).matching(predicate).count
            
            XCTAssertEqual(initialCount - 1, finalItemCount,
                           "Expecting that item count decreases by one")
            allureAttachAppScreenshot(app: app, name: "List after deletion")
        }
    }
    
    @MainActor
    func test_when_all_items_removed_then_remove_disabled() throws {
        AllureXCTestSupport.setDisplayName("Remove all items disables delete")
        AllureXCTestSupport.addLabel("testlioManualTestID",
                                     value: "c1a2c1d8-7368-4d6e-9f35-5f7d0bb0b222")
        AllureXCTestSupport.addDescription("Ensure delete button disables once list is empty.")
        
        let (collection, predicate, initialCount, removeLastButton) = AllureXCTestSupport.step("(1) Prepare list and button") {
            let itemRowID = itemListScreen.item(nil)
            let predicate = NSPredicate(format: "identifier CONTAINS '\(itemRowID)'")
            let collection = app.descendants(matching: .any)[itemListScreen.itemList]
            let initialCount = collection.descendants(matching: .any).matching(predicate).count
            XCTAssertTrue(initialCount > 0, "Expecting at least one item shown")
            let removeLastButton = app.buttons[itemListScreen.deleteButton]
            XCTAssertTrue(removeLastButton.isEnabled, "Delete buttons should be enabled initially")
            return (collection, predicate, initialCount, removeLastButton)
        }
        
        AllureXCTestSupport.step("(2) Remove items until empty") {
            for _ in 0..<initialCount {
                removeLastButton.tap()
            }
        }
        
        AllureXCTestSupport.step("(3) Verify list empty and button disabled") {
            let finalItemCount = collection.descendants(matching: .any).matching(predicate).count
            
            XCTAssertEqual(0, finalItemCount,
                           "Expecting that no more items")
            
            XCTAssertFalse(removeLastButton.isEnabled,
                            "Delete button should be disabled")
            allureAttachAppScreenshot(app: app, name: "Delete disabled after empty list")
        }
    }
}
