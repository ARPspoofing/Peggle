//
//  PeggleTests.swift
//  PeggleTests
//
//  Created by Muhammad Reyaaz on 22/1/24.
//

import XCTest
@testable import Peggle
import SwiftUI

final class PeggleTests: XCTestCase {

    // MARK: Point
    func test_addVectorToPoint_equalNewPoint() {
        let startPoint = Point(xCoord: 1.0, yCoord: 1.0)
        let shiftVector = Vector(horizontal: 1.0, vertical: 1.0)

        let expectedEndPoint = Point(xCoord: 2.0, yCoord: 2.0)

        let actualEndPoint: Point = startPoint.add(vector: shiftVector)

        XCTAssertEqual(actualEndPoint, expectedEndPoint)
    }

    func test_subtractVectorFromPoint_equalNewPoint() {
        let startPoint = Point(xCoord: 2.0, yCoord: 2.0)
        let shiftVector = Vector(horizontal: 1.0, vertical: 1.0)

        let expectedEndPoint = Point(xCoord: 1.0, yCoord: 1.0)

        let actualEndPoint: Point = startPoint.subtract(vector: shiftVector)

        XCTAssertEqual(actualEndPoint, expectedEndPoint)
    }

    func test_squareDistance_equalDistance() {
        let startPoint = Point(xCoord: 2.0, yCoord: 2.0)
        let endPoint = Point(xCoord: 4.0, yCoord: 4.0)

        let actualSquaredDistance: Double = startPoint.squareDistance(to: endPoint)

        let expectedSquaredDistance = 8.0

        XCTAssertEqual(actualSquaredDistance, expectedSquaredDistance)
    }

    // MARK: Vector
    func test_squareVectorLength_equalDistance() {
        let vector = Vector(horizontal: 2.0, vertical: 2.0)
        let actualSquaredLength: Double = vector.squareLength()

        let expectedSquaredLength = 8.0

        XCTAssertEqual(actualSquaredLength, expectedSquaredLength)
    }

    func test_addVectors_equalVector() {
        let vectorA = Vector(horizontal: 4.0, vertical: 4.0)
        let vectorB = Vector(horizontal: 2.0, vertical: 2.0)

        let actualVector: Vector = vectorA.add(vector: vectorB)

        let expectedVector = Vector(horizontal: 6.0, vertical: 6.0)

        XCTAssertEqual(actualVector, expectedVector)
    }

    func test_subtractVectors_equalVector() {
        let vectorA = Vector(horizontal: 4.0, vertical: 4.0)
        let vectorB = Vector(horizontal: 2.0, vertical: 2.0)

        let actualVector: Vector = vectorA.subtract(vector: vectorB)

        let expectedVector = Vector(horizontal: 2.0, vertical: 2.0)

        XCTAssertEqual(actualVector, expectedVector)
    }

    func test_scaleVectors_equalVector() {
        let vectorA = Vector(horizontal: 4.0, vertical: 4.0)
        let magnitude = 2.0

        let actualVector: Vector = vectorA.scale(magnitude)

        let expectedVector = Vector(horizontal: 8.0, vertical: 8.0)

        XCTAssertEqual(actualVector, expectedVector)
    }

    func test_dotProductVectors_equalProduct() {
        let vectorA = Vector(horizontal: 4.0, vertical: 4.0)
        let vectorB = Vector(horizontal: 2.0, vertical: 2.0)

        let actualDotProduct: Double = vectorA.dotProduct(with: vectorB)

        let expectedDotProduct = 16.0

        XCTAssertEqual(actualDotProduct, expectedDotProduct)
    }

    func test_crossProduct_equalProduct() {
        let vectorA = Vector(horizontal: 4.0, vertical: 2.0)
        let vectorB = Vector(horizontal: 2.0, vertical: 4.0)

        let actualCrossProduct: Double = vectorA.crossProduct(with: vectorB)

        let expectedCrossProduct = 12.0

        XCTAssertEqual(actualCrossProduct, expectedCrossProduct)
    }

    func test_rayTracingProduct_equalProduct() {
        let vectorA = Vector(horizontal: 4.0, vertical: 2.0)
        let vectorB = Vector(horizontal: 2.0, vertical: 4.0)

        let actualRayTracingProduct: Double = vectorA.rayTracingProduct(with: vectorB)

        let expectedRayTracingProduct = 20.0

        XCTAssertEqual(actualRayTracingProduct, expectedRayTracingProduct)
    }

    // MARK: GameObject
    func test_getDefaultXCoord_isEqual() {
        let gameObject = GameObject(name: "testObject")
        let actualXCoord: Double = gameObject.retrieveXCoord()

        let expectedXCoord = 0.0

        XCTAssertEqual(actualXCoord, expectedXCoord)
    }

    func test_getDefaultYCoord_isEqual() {
        let gameObject = GameObject(name: "testObject")
        let actualYCoord: Double = gameObject.retrieveYCoord()

        let expectedYCoord = 0.0

        XCTAssertEqual(actualYCoord, expectedYCoord)
    }

    func test_retrieveXCoord_isEqual() {
        let center = Point(xCoord: 2.0, yCoord: 3.0)
        let gameObject = GameObject(center: center, name: "testObject")
        let actualXCoord: Double = gameObject.retrieveXCoord()

        let expectedXCoord = 2.0

        XCTAssertEqual(actualXCoord, expectedXCoord)
    }

    func test_retrieveYCoord_isEqual() {
        let center = Point(xCoord: 2.0, yCoord: 3.0)
        let gameObject = GameObject(center: center, name: "testObject")
        let actualYCoord: Double = gameObject.retrieveYCoord()

        let expectedYCoord = 3.0

        XCTAssertEqual(actualYCoord, expectedYCoord)
    }

    func test_getDeepCopyGameObject_isNotEqual() {
        let center = Point(xCoord: 2.0, yCoord: 2.0)
        let gameObject = GameObject(center: center, name: "testObject")

        let deepCopyGameObject = gameObject.makeDeepCopy()

        XCTAssertEqual(gameObject.retrieveXCoord(), deepCopyGameObject.retrieveXCoord())
        XCTAssertEqual(gameObject.retrieveYCoord(), deepCopyGameObject.retrieveYCoord())

        XCTAssertNotEqual(gameObject, deepCopyGameObject)
    }

    func test_changeCenter_isEqual() {
        let gameObject = GameObject(name: "testObject")
        gameObject.changeCenter(newCenter: Point(xCoord: 10.0, yCoord: 10.0))
        let actualXCoord: Double = gameObject.retrieveXCoord()
        let actualYCoord: Double = gameObject.retrieveYCoord()

        let expectedXCoord = 10.0
        let expectedYCoord = 10.0

        XCTAssertEqual(actualXCoord, expectedXCoord)
        XCTAssertEqual(actualYCoord, expectedYCoord)
    }

    // MARK: Peg
    func test_EncodingAndDecoding() {
        let center = Point(xCoord: 0, yCoord: 0)
        let originalPeg = Peg(center: center, name: "TestPeg", radius: 10.0)

        do {
            let encodedData = try JSONEncoder().encode(originalPeg)
            let decodedPeg = try JSONDecoder().decode(Peg.self, from: encodedData)
            XCTAssertEqual(originalPeg, decodedPeg, "Encoded and decoded Pegs should be equal")
        } catch {
            XCTFail("Failed to encode or decode Peg: \(error)")
        }
    }

    func test_getDeepCopyPeg_isNotEqual() {

        let center = Point(xCoord: 2.0, yCoord: 2.0)
        let name = "testPeg"
        let radius = 10.0

        let peg = Peg(center: center, name: name, radius: radius)

        let deepCopyPeg = peg.makeDeepCopy()

        XCTAssertEqual(peg.center, deepCopyPeg.center)
        XCTAssertEqual(peg.radius, deepCopyPeg.radius)
        XCTAssertEqual(peg.name, deepCopyPeg.name)

        XCTAssertNotEqual(peg, deepCopyPeg)
    }

    func test_exceedRightBorder_isFalse() {

        let center = Point(xCoord: Constants.screenWidth, yCoord: 2.0)
        let name = "testPeg"
        let radius = 10.0

        let peg = Peg(center: center, name: name, radius: radius)

        XCTAssertFalse(peg.checkRightBorder())
    }

    func test_touchingRightBorderEdge_isFalse() {

        let center = Point(xCoord: Constants.screenWidth - 10.0, yCoord: 2.0)
        let name = "testPeg"
        let radius = 10.0

        let peg = Peg(center: center, name: name, radius: radius)

        XCTAssertFalse(peg.checkRightBorder())
    }

    func test_notExceedRightBorderEdge_isTrue() {

        let center = Point(xCoord: Constants.screenWidth - 11.0, yCoord: 2.0)
        let name = "testPeg"
        let radius = 10.0

        let peg = Peg(center: center, name: name, radius: radius)

        XCTAssertTrue(peg.checkRightBorder())
    }

    func test_exceedLeftBorder_isFalse() {

        let center = Point(xCoord: 0, yCoord: 2.0)
        let name = "testPeg"
        let radius = 10.0

        let peg = Peg(center: center, name: name, radius: radius)

        XCTAssertFalse(peg.checkLeftBorder())
    }

    func test_touchingLeftBorderEdge_isFalse() {

        let center = Point(xCoord: 10.0, yCoord: 2.0)
        let name = "testPeg"
        let radius = 10.0

        let peg = Peg(center: center, name: name, radius: radius)

        XCTAssertFalse(peg.checkLeftBorder())
    }

    func test_notExceedLeftBorderEdge_isTrue() {

        let center = Point(xCoord: 11.0, yCoord: 2.0)
        let name = "testPeg"
        let radius = 10.0

        let peg = Peg(center: center, name: name, radius: radius)

        XCTAssertTrue(peg.checkRightBorder())
    }

    func test_exceedTopBorder_isFalse() {

        let center = Point(xCoord: Constants.screenWidth / 2, yCoord: 0)
        let name = "testPeg"
        let radius = 10.0

        let peg = Peg(center: center, name: name, radius: radius)

        XCTAssertFalse(peg.checkTopBorder())
    }

    func test_touchingTopBorderEdge_isFalse() {

        let center = Point(xCoord: Constants.screenWidth / 2, yCoord: 0 + 10.0)
        let name = "testPeg"
        let radius = 10.0

        let peg = Peg(center: center, name: name, radius: radius)

        XCTAssertFalse(peg.checkTopBorder())
    }

    func test_notExceedTopBorderEdge_isTrue() {

        let center = Point(xCoord: Constants.screenWidth / 2, yCoord: 0 + 11.0)
        let name = "testPeg"
        let radius = 10.0

        let peg = Peg(center: center, name: name, radius: radius)

        XCTAssertTrue(peg.checkTopBorder())
    }

    func test_exceedBottomBorder_isFalse() {

        let center = Point(xCoord: Constants.screenWidth / 2, yCoord: Constants.screenHeight)
        let name = "testPeg"
        let radius = 10.0

        let peg = Peg(center: center, name: name, radius: radius)

        XCTAssertFalse(peg.checkBottomBorder())
    }

    func test_touchingBottomBorderEdge_isFalse() {

        let center = Point(xCoord: Constants.screenWidth / 2, yCoord: Constants.screenHeight - 10.0)
        let name = "testPeg"
        let radius = 10.0

        let peg = Peg(center: center, name: name, radius: radius)

        XCTAssertFalse(peg.checkBottomBorder())
    }

    func test_notExceedBottomBorderEdge_isTrue() {

        let center = Point(xCoord: Constants.screenWidth / 2, yCoord: Constants.screenHeight - 11.0)
        let name = "testPeg"
        let radius = 10.0

        let peg = Peg(center: center, name: name, radius: radius)

        XCTAssertTrue(peg.checkBottomBorder())
    }
}
