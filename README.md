# CI setup: XCTest UI tests with Allure (classic)

This project is wired so macOS runners can execute XCTest UI tests and emit an Allure classic report directly from the `.xcresult` bundle.

## Prerequisites on the macOS runner
- Xcode 26.2 selected (`sudo xcode-select -s /Applications/Xcode_26.2.app/Contents/Developer`).
- iOS 17 simulator available (workflow uses `iPhone 17` on `OS=26.1`).
- Node.js/npm available to install the Allure CLI (Allure 3): `npm install -g allure`.
- In the ItemApp test plan/scheme, enable `Record Screen` and `Capture Screenshots` so videos/images are stored in `TestResults.xcresult` for Allure to render.

## Run the UI tests (same as CI)
```bash
set -o pipefail
xcodebuild test \
  -project ItemApp.xcodeproj \
  -scheme ItemApp \
  -testPlan ItemApp \
  -destination 'platform=iOS Simulator,name=iPhone 17,OS=26.1' \
  -only-testing:ItemAppUITests \
  -parallel-testing-enabled NO \
  -maximum-parallel-testing-workers 1 \
  -enableCodeCoverage YES \
  -resultBundlePath TestResults.xcresult
```

## Generate Allure classic report
From the same workspace:
```bash
allure --version          # sanity check
allure allure2 --report-name allure-report TestResults.xcresult
tar -czf allure-report.tar.gz allure-report  # optional: artifact for CI
```

## How Allure picks up test metadata
- Tests use `AllureXCTestSupport` to emit Allure-compatible activities (e.g., `allure.label.*`, `allure.name`, `allure.link`) that the Allure classic parser reads from `TestResults.xcresult`.
- Keep Allure metadata activities flat/empty so the parser treats them as labels/links instead of steps.
- Steps are wrapped with `AllureXCTestSupport.step(...)` so they appear as steps in the report.
- Screenshots and failure captures call `allureAttachScreenshot` / `allureAttachAppScreenshot` / `allureCaptureFailureArtifacts`; attachments use `.keepAlways` so they survive into the result bundle.
- With screen recording/screenshot capture enabled, Allure renders those artifacts without extra post-processing.

### Swift usage example
```swift
@MainActor
func test_items_shown() throws {
    // Sets the display name shown in Allure
    AllureXCTestSupport.setDisplayName("Item list displays existing items")

    // Adds a custom label (e.g., Testlio test ID) and a description
    AllureXCTestSupport.addLabel("testlioManualTestID",
                                 value: "5a01a6e7-856a-4193-bd02-10fe47fbf644")
    AllureXCTestSupport.addDescription("Smoke check that seeded items are visible.")

    // Steps appear in Allure as ordered steps
    let collection = AllureXCTestSupport.step("(1) Locate item list") {
        let view = app.descendants(matching: .any)[UIIdentifiers.ItemListScreen.itemList]
        XCTAssertTrue(view.exists)
        return view
    }

    AllureXCTestSupport.step("(2) Assert list has items") {
        let predicate = NSPredicate(format: "identifier CONTAINS %@", UIIdentifiers.ItemListScreen.item(nil))
        let items = collection.descendants(matching: .any).matching(predicate)
        XCTAssertTrue(items.count > 0)
        allureAttachAppScreenshot(app: app, name: "Item list visible")
    }
}
```

### Local workflow (alternative to CI)
```bash
# Run UI tests and produce xcresult
xcodebuild test \
  -project ItemApp.xcodeproj \
  -scheme ItemApp \
  -testPlan ItemApp \
  -destination 'platform=iOS Simulator,name=iPhone 17,OS=26.1' \
  -only-testing:ItemAppUITests \
  -parallel-testing-enabled NO \
  -maximum-parallel-testing-workers 1 \
  -enableCodeCoverage YES \
  -resultBundlePath TestResults

# Generate and open Allure report (classic)
npx allure generate TestResults.xcresult -o allure-report --clean
npx allure open allure-report
```

## CI/CD notes
- The GitHub Actions workflow (`.github/workflows/ios-ci.yml`) already runs the command above, installs the Allure CLI, generates `allure-report` via `allure allure2`, and uploads both `TestResults.xcresult` and `allure-report.tar.gz`.
- Keep `-parallel-testing-enabled NO` to avoid multi-simulator runs that can interfere with video/screenshot capture in the report.

