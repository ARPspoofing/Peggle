//
//  PeggleUITests.swift
//  PeggleUITests
//
//  Created by Muhammad Reyaaz on 22/1/24.
//

import XCTest
import SwiftUI

final class PeggleUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func test_startButton_launchObject() {
        app.buttons["scroll"].tap()
        app.buttons["Done"].tap()
        app.images["normalObject"].tap()

        let backgroundImage = app.images["mainMap"]
        backgroundImage.tap()
        app.buttons["START"].tap()
        backgroundImage.tap()
    }

    func test_DeleteButton_normalObjectDeleted() {
        app.buttons["scroll"].tap()
        app.buttons["Done"].tap()
        app.images["normalObject"].tap()
        app.images["mainMap"].tap()
        app.images["delete"].tap()

    }

    func test_DeleteButton_actionObjectDeleted() {
        app.buttons["scroll"].tap()
        app.buttons["Done"].tap()
        app.images["actionObject"].tap()
        app.images["mainMap"].tap()
        app.images["delete"].tap()
    }

    func test_DeleteButton_untoggle() {
        app.buttons["scroll"].tap()
        app.buttons["Done"].tap()
        app.images["delete"].tap()
        app.images["delete"].tap()
    }

    func test_OrangePeg_untoggle() {
        app.buttons["scroll"].tap()
        app.buttons["Done"].tap()
        app.images["actionObject"].tap()
        app.images["actionObject"].tap()
    }

    func test_BluePeg_untoggle() {
        app.buttons["scroll"].tap()
        app.buttons["Done"].tap()
        app.images["normalObject"].tap()
        app.images["normalObject"].tap()
    }

    func test_OrangePegBlue_untoggle() {
        app.buttons["scroll"].tap()
        app.buttons["Done"].tap()
        app.images["actionObject"].tap()
        app.images["normalObject"].tap()
    }

    func test_BluePegOrange_untoggle() {
        app.buttons["scroll"].tap()
        app.buttons["Done"].tap()
        app.images["normalObject"].tap()
        app.images["actionObject"].tap()
    }

    func test_BluePegDelete_untoggle() {
        app.buttons["scroll"].tap()
        app.buttons["Done"].tap()
        app.images["normalObject"].tap()
        app.images["delete"].tap()
    }

    func test_OrangePegDelete_untoggle() {
        app.buttons["scroll"].tap()
        app.buttons["Done"].tap()
        app.images["actionObject"].tap()
        app.images["delete"].tap()
    }

    func test_ResetButtonCanvas_cancelBlueReset() {
        app.buttons["scroll"].tap()
        app.buttons["Done"].tap()
        app.images["normalObject"].tap()

        let backgroundImage = app.images["mainMap"]
        backgroundImage.tap()

        let resetButton = app.buttons["RESET"]
        XCTAssertTrue(resetButton.exists, "RESET button found")
        resetButton.tap()

        let alert = app.alerts.firstMatch
        let alertExists = alert.waitForExistence(timeout: 5)
        XCTAssertTrue(alertExists)

        let alertMessage = alert.staticTexts["Are you sure you want to reset?"].exists
        XCTAssertTrue(alertMessage)

        alert.buttons["Cancel"].tap()
    }

    func test_ResetButtonCanvas_cancelOrangeReset() {
        app.buttons["scroll"].tap()
        app.buttons["Done"].tap()
        app.images["actionObject"].tap()

        let backgroundImage = app.images["mainMap"]
        backgroundImage.tap()

        let resetButton = app.buttons["RESET"]
        XCTAssertTrue(resetButton.exists, "RESET button found")
        resetButton.tap()

        let alert = app.alerts.firstMatch
        let alertExists = alert.waitForExistence(timeout: 5)
        XCTAssertTrue(alertExists)

        let alertMessage = alert.staticTexts["Are you sure you want to reset?"].exists
        XCTAssertTrue(alertMessage)

        alert.buttons["Cancel"].tap()
    }

    func test_ResetButtonCanvas_confirmBlueReset() {
        app.buttons["scroll"].tap()
        app.buttons["Done"].tap()
        app.images["normalObject"].tap()

        let backgroundImage = app.images["mainMap"]
        backgroundImage.tap()

        let resetButton = app.buttons["RESET"]
        XCTAssertTrue(resetButton.exists, "RESET button found")
        resetButton.tap()

        let alert = app.alerts.firstMatch
        let alertExists = alert.waitForExistence(timeout: 5)
        XCTAssertTrue(alertExists)

        let alertMessage = alert.staticTexts["Are you sure you want to reset?"].exists
        XCTAssertTrue(alertMessage)

        alert.buttons["Reset"].tap()
    }

    func test_ResetButtonCanvas_confirmOrangeReset() {
        app.buttons["scroll"].tap()
        app.buttons["Done"].tap()
        app.images["actionObject"].tap()

        let backgroundImage = app.images["mainMap"]
        backgroundImage.tap()

        let resetButton = app.buttons["RESET"]
        XCTAssertTrue(resetButton.exists, "RESET button found")
        resetButton.tap()

        let alert = app.alerts.firstMatch
        let alertExists = alert.waitForExistence(timeout: 5)
        XCTAssertTrue(alertExists)

        let alertMessage = alert.staticTexts["Are you sure you want to reset?"].exists
        XCTAssertTrue(alertMessage)

        alert.buttons["Reset"].tap()
    }

    func test_LoadButtonCanvas_shouldShowSheet() {
        app.buttons["scroll"].tap()
        app.buttons["Done"].tap()
        app.buttons["LOAD"].tap()
        app.buttons["Cancel"].tap()

    }

    func test_SaveButtonEmptyCanvas_shouldNotSave() {
        app.buttons["scroll"].tap()
        app.buttons["Done"].tap()
        app.buttons["SAVE"].tap()

        let alert = app.alerts.firstMatch
        let alertExists = alert.waitForExistence(timeout: 5)
        XCTAssertTrue(alertExists)

        let alertMessage = alert.staticTexts["There must be at least one peg on the game board"].exists
        XCTAssertTrue(alertMessage)

        alert.scrollViews.otherElements.buttons["OK"].tap()
    }

    func emptyCanvasSave() {
        app.buttons["SAVE"].tap()

        let alert = app.alerts.firstMatch
        let alertExists = alert.waitForExistence(timeout: 5)
        XCTAssertTrue(alertExists)

        let alertMessage = alert.staticTexts["There must be at least one peg on the game board"].exists
        XCTAssertTrue(alertMessage)

        alert.scrollViews.otherElements.buttons["OK"].tap()
    }

    func successfulSave() {
        let saveButton = app.buttons["SAVE"]
        XCTAssertTrue(saveButton.exists, "SAVE button found")
        saveButton.tap()

        let alert = app.alerts.firstMatch
        let alertExists = alert.waitForExistence(timeout: 5)
        XCTAssertTrue(alertExists)

        let alertMessage = alert.staticTexts["Successfully saved level!"].exists
        XCTAssertTrue(alertMessage)

        alert.scrollViews.otherElements.buttons["OK"].tap()
    }
}
