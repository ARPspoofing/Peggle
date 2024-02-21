//
//  PeggleViewModelTests.swift
//  PeggleTests
//
//  Created by Muhammad Reyaaz on 29/1/24.
//

import XCTest
@testable import Peggle
import SwiftUI

final class PeggleLogicTests: XCTestCase {

    func test_touchingPegsNoIntersection_isFalse() {
        let centerA = Point(xCoord: 2.0, yCoord: 2.0)
        let centerB = Point(xCoord: 6.0, yCoord: 2.0)

        let radius = 2.0

        let pegA = Peg(center: centerA, name: "pegA", radius: radius)
        let pegB = Peg(center: centerB, name: "pegB", radius: radius)

        let isNotIntersecting = pegA.checkNoIntersection(with: pegB)

        XCTAssertFalse(isNotIntersecting)

    }

    func test_notTouchingPegsNoIntersection_isTrue() {
        let centerA = Point(xCoord: 2.0, yCoord: 2.0)
        let centerB = Point(xCoord: 7.0, yCoord: 2.0)

        let radius = 2.0

        let pegA = Peg(center: centerA, name: "pegA", radius: radius)
        let pegB = Peg(center: centerB, name: "pegB", radius: radius)

        let isNotIntersecting = pegA.checkNoIntersection(with: pegB)

        XCTAssertTrue(isNotIntersecting)

    }

    func test_overlappingPegsNoIntersection_isFalse() {
        let centerA = Point(xCoord: 2.0, yCoord: 2.0)
        let centerB = Point(xCoord: 3.0, yCoord: 2.0)

        let radius = 2.0

        let pegA = Peg(center: centerA, name: "pegA", radius: radius)
        let pegB = Peg(center: centerB, name: "pegB", radius: radius)

        let isNotIntersecting = pegA.checkNoIntersection(with: pegB)

        XCTAssertFalse(isNotIntersecting)

    }

    func test_checkSafeInsertOverlapping_isFalse() {
        let centerA = Point(xCoord: 2.0, yCoord: 2.0)
        let centerB = Point(xCoord: 3.0, yCoord: 2.0)

        let radius = 2.0

        let pegA = Peg(center: centerA, name: "pegA", radius: radius)
        let pegB = Peg(center: centerB, name: "pegB", radius: radius)

        let isSafeToInsert = pegA.checkSafeToInsert(with: pegB)

        XCTAssertFalse(isSafeToInsert)
    }

    // MARK: Level
    func test_levelEncodeDecode_isEqual() {
        let peg1 = Peg(center: Point(xCoord: 10, yCoord: 20), name: "Peg1", radius: 5.0)
        let peg2 = Peg(center: Point(xCoord: 30, yCoord: 40), name: "Peg2", radius: 8.0)
        let gameObjects: [GameObject] = [peg1, peg2]

        let level = Level(levelName: "TestLevel", isPreloadedLevel: true, gameObjects: gameObjects)

        do {
            let encodedData = try JSONEncoder().encode(level)

            let decodedLevel = try JSONDecoder().decode(Level.self, from: encodedData)

            XCTAssertEqual(decodedLevel.id, level.id)
            XCTAssertEqual(decodedLevel.isPreloadedLevel, level.isPreloadedLevel)
            XCTAssertEqual(decodedLevel.gameObjects.count, level.gameObjects.count)

        } catch {
            XCTFail("Failed to encode or decode Level: \(error)")
        }
    }

    func test_addGameObject_isSuccess() {
        let peg1 = Peg(center: Point(xCoord: 10, yCoord: 20), name: "Peg1", radius: 5.0)
        let peg2 = Peg(center: Point(xCoord: 30, yCoord: 40), name: "Peg2", radius: 8.0)
        let gameObjects: [GameObject] = [peg1, peg2]

        var level = Level(levelName: "TestLevel", isPreloadedLevel: true, gameObjects: gameObjects)

        level.addGameObject(peg2)

        let expectedGameObjects = [peg1, peg2]

        XCTAssertEqual(gameObjects[0].name, expectedGameObjects[0].name)
        XCTAssertEqual(gameObjects[0].center, expectedGameObjects[0].center)
        XCTAssertEqual(gameObjects[1].name, expectedGameObjects[1].name)
        XCTAssertEqual(gameObjects[1].center, expectedGameObjects[1].center)
    }

    func test_removeGameObject_isSuccess() {
        let peg1 = Peg(center: Point(xCoord: 10, yCoord: 20), name: "Peg1", radius: 5.0)
        let peg2 = Peg(center: Point(xCoord: 30, yCoord: 40), name: "Peg2", radius: 8.0)
        let gameObjects: [GameObject] = [peg1, peg2]

        var level = Level(levelName: "TestLevel", isPreloadedLevel: true, gameObjects: gameObjects)

        level.removeGameObject(peg2)

        let expectedGameObjects = [peg1]

        XCTAssertEqual(gameObjects[0].name, expectedGameObjects[0].name)
        XCTAssertEqual(gameObjects[0].center, expectedGameObjects[0].center)
    }

    func test_removeAllGameObject_isSuccess() {
        let peg1 = Peg(center: Point(xCoord: 10, yCoord: 20), name: "Peg1", radius: 5.0)
        let peg2 = Peg(center: Point(xCoord: 30, yCoord: 40), name: "Peg2", radius: 8.0)
        let gameObjects: [GameObject] = [peg1, peg2]

        var level = Level(levelName: "TestLevel", isPreloadedLevel: true, gameObjects: gameObjects)

        level.removeAll()

        let expectedGameObjects: [GameObject] = []

        XCTAssertEqual(level.gameObjects, expectedGameObjects)
    }

    func test_setName_isEqual() {
        let peg1 = Peg(center: Point(xCoord: 10, yCoord: 20), name: "Peg1", radius: 5.0)
        let peg2 = Peg(center: Point(xCoord: 30, yCoord: 40), name: "Peg2", radius: 8.0)
        let gameObjects: [GameObject] = [peg1, peg2]

        var level = Level(levelName: "TestLevel", isPreloadedLevel: true, gameObjects: gameObjects)

        level.setName(as: "newTestLevel")

        let expectedName = "newTestLevel"

        XCTAssertEqual(level.id, expectedName)
    }

    // MARK: PegViewModel
    func test_defaultRadius_isEqual() {
        let pegViewModel = PegViewModel(name: "viewModel")
        let expectedRadius: CGFloat = 25
        XCTAssertEqual(pegViewModel.getPegRadius(), expectedRadius)
    }

    func test_defaultWidth_isEqual() {
        let pegViewModel = PegViewModel(name: "viewModel")
        let expectedWidth: CGFloat = 50
        XCTAssertEqual(pegViewModel.calculateWidth(), expectedWidth)
    }

    func test_defaultHeight_isEqual() {
        let pegViewModel = PegViewModel(name: "viewModel")
        let expectedHeight: CGFloat = 50
        XCTAssertEqual(pegViewModel.calculateHeight(), expectedHeight)
    }

    // MARK: CanvasViewModel
    func test_canvasViewModelRender_isEqual() {
        let peg1 = Peg(center: Point(xCoord: 10, yCoord: 20), name: "Peg1", radius: 5.0)
        let peg2 = Peg(center: Point(xCoord: 30, yCoord: 40), name: "Peg2", radius: 8.0)
        let gameObjects: [GameObject] = [peg1, peg2]

        let selectedObject = Constants.normalObject

        let canvasViewModel = CanvasViewModel(gameObjects: gameObjects)
        canvasViewModel.addObject(Point(xCoord: 100, yCoord: 100), selectedObject)

        XCTAssertEqual(canvasViewModel.gameObjects.count, 3)
    }

    func test_canvasViewModelRemoveRender_isEqual() {
        let peg1 = Peg(center: Point(xCoord: 10, yCoord: 20), name: "Peg1", radius: 5.0)
        let peg2 = Peg(center: Point(xCoord: 30, yCoord: 40), name: "Peg2", radius: 8.0)
        let gameObjects: [GameObject] = [peg1, peg2]

        let canvasViewModel = CanvasViewModel(gameObjects: gameObjects)
        canvasViewModel.removeAndRender(removeObjectIndex: 1)

        XCTAssertEqual(canvasViewModel.gameObjects.count, 1)
    }

    func test_canvasViewModelAddOverlappingObject_isNotSuccess() {
        let peg1 = Peg(center: Point(xCoord: 10, yCoord: 20), name: "Peg1", radius: 5.0)
        let peg2 = Peg(center: Point(xCoord: 30, yCoord: 40), name: "Peg2", radius: 8.0)
        let gameObjects: [GameObject] = [peg1, peg2]

        let selectedObject = Constants.normalObject

        let canvasViewModel = CanvasViewModel(gameObjects: gameObjects)
        canvasViewModel.addObject(Point(xCoord: 10, yCoord: 20), selectedObject)

        XCTAssertEqual(canvasViewModel.gameObjects.count, 2)
    }

    func test_checkCanInsertUnsafeObject_isFalse() {
        let peg1 = Peg(center: Point(xCoord: 10, yCoord: 20), name: "Peg1", radius: 5.0)
        let peg2 = Peg(center: Point(xCoord: 10, yCoord: 20), name: "Peg2", radius: 5.0)
        let gameObjects: [GameObject] = [peg1]

        let canvasViewModel = CanvasViewModel(gameObjects: gameObjects)
        XCTAssertFalse(canvasViewModel.checkCanInsert(peg2))
    }

    func test_checkCanInsertSafeObject_isTrue() {
        let peg1 = Peg(center: Point(xCoord: 10, yCoord: 20), name: "Peg1", radius: 5.0)
        let peg2 = Peg(center: Point(xCoord: 50, yCoord: 50), name: "Peg2", radius: 5.0)
        let gameObjects: [GameObject] = [peg1]

        let canvasViewModel = CanvasViewModel(gameObjects: gameObjects)
        XCTAssertTrue(canvasViewModel.checkCanInsert(peg2))
    }

    func test_checkCanDragSafeObject_isTrue() {
        let peg1 = Peg(center: Point(xCoord: 10, yCoord: 20), name: "Peg1", radius: 5.0)
        let peg2 = Peg(center: Point(xCoord: 50, yCoord: 50), name: "Peg2", radius: 5.0)
        let gameObjects: [GameObject] = [peg1]

        let canvasViewModel = CanvasViewModel(gameObjects: gameObjects)
        XCTAssertTrue(canvasViewModel.checkCanDrag(peg2, 1))
    }

    func test_toggleDeleteState_isTrue() {
        let peg1 = Peg(center: Point(xCoord: 10, yCoord: 20), name: "Peg1", radius: 5.0)
        let gameObjects: [GameObject] = [peg1]

        let canvasViewModel = CanvasViewModel(gameObjects: gameObjects)
        canvasViewModel.toggleDeleteState()
        XCTAssertTrue(canvasViewModel.isDeleteState)
    }

    func test_toggleDeleteStateTwice_isFalse() {
        let peg1 = Peg(center: Point(xCoord: 10, yCoord: 20), name: "Peg1", radius: 5.0)
        let gameObjects: [GameObject] = [peg1]

        let canvasViewModel = CanvasViewModel(gameObjects: gameObjects)
        canvasViewModel.toggleDeleteState()
        canvasViewModel.toggleDeleteState()
        XCTAssertFalse(canvasViewModel.isDeleteState)
    }

    func test_tapObjectPegBlue_isEqual() {
        let peg1 = Peg(center: Point(xCoord: 10, yCoord: 20), name: "Peg1", radius: 5.0)
        let gameObjects: [GameObject] = [peg1]

        let canvasViewModel = CanvasViewModel(gameObjects: gameObjects)
        canvasViewModel.tapObject(Constants.normalObject)
        XCTAssertEqual(canvasViewModel.selectedObject, Constants.normalObject)
    }

    func test_tapObjectPegBlueTwice_isEqual() {
        let peg1 = Peg(center: Point(xCoord: 10, yCoord: 20), name: "Peg1", radius: 5.0)
        let gameObjects: [GameObject] = [peg1]

        let canvasViewModel = CanvasViewModel(gameObjects: gameObjects)
        canvasViewModel.tapObject(Constants.normalObject)
        canvasViewModel.tapObject(Constants.normalObject)
        XCTAssertNil(canvasViewModel.selectedObject)
    }

    // MARK: ActionButtonsViewModel
    func testSaveLevel_WithNoGameObjects_isNotSuccess() {
        let actionButtonsViewModel = ActionButtonsViewModel()
        let result = actionButtonsViewModel.saveLevel(levelName: "TestLevel", gameObjects: [])
        XCTAssertEqual(result, "There must be at least one peg on the game board")
    }

    func testSaveLevel_WithEmptyLevelName_isNotSuccess() {
        let peg1 = Peg(center: Point(xCoord: 10, yCoord: 20), name: "Peg1", radius: 5.0)
        let gameObjects: [GameObject] = [peg1]
        let actionButtonsViewModel = ActionButtonsViewModel()
        let result = actionButtonsViewModel.saveLevel(levelName: "", gameObjects: gameObjects)
        XCTAssertEqual(result, "Please enter a non empty alphanumeric level name")
    }

    func testSaveLevel_WithNonAlphaNumericLevelName_isNotSuccess() {
        let peg1 = Peg(center: Point(xCoord: 10, yCoord: 20), name: "Peg1", radius: 5.0)
        let gameObjects: [GameObject] = [peg1]
        let actionButtonsViewModel = ActionButtonsViewModel()
        let result = actionButtonsViewModel.saveLevel(levelName: "Test_Level_1", gameObjects: gameObjects)
        XCTAssertEqual(result, "Please enter an alphanumeric level name")
    }

    func testSaveLevel_WithValidInputCase_isSuccess() {
        let peg1 = Peg(center: Point(xCoord: 10, yCoord: 20), name: "Peg1", radius: 5.0)
        let gameObjects: [GameObject] = [peg1]
        let actionButtonsViewModel = ActionButtonsViewModel()
        _ = actionButtonsViewModel.saveLevel(levelName: "TestLevel1", gameObjects: gameObjects)
    }

    func testSaveLevel_WithValidInputNoCase_isSuccess() {
        let peg1 = Peg(center: Point(xCoord: 10, yCoord: 20), name: "Peg1", radius: 5.0)
        let gameObjects: [GameObject] = [peg1]
        let actionButtonsViewModel = ActionButtonsViewModel()
        _ = actionButtonsViewModel.saveLevel(levelName: "testlevel1", gameObjects: gameObjects)
    }

    func testDeleteLevel_isSuccess() {
        let actionButtonsViewModel = ActionButtonsViewModel()
        _ = actionButtonsViewModel.manager.deleteLevel(name: "testlevel1")
        _ = actionButtonsViewModel.manager.deleteLevel(name: "levelone")
    }
}
