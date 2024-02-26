//
//  ModelMap.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 23/2/24.
//

struct ModelMap {
    func getEntity(center: Point, type: String, halfWidth: Double, orientation: Double) -> GameObject {
        let entity: [String: GameObject] = [
            Constants.sharpObject: createSharpObject(center: center, type: type, circumradius: halfWidth, orientation: orientation),
            Constants.normalObject: createNormalPeg(center: center, type: type, radius: halfWidth, orientation: orientation),
            Constants.actionObject: createActionPeg(center: center, type: type, radius: halfWidth, orientation: orientation)
        ]
        return entity[type] ?? createNormalPeg(center: center, type: type, radius: halfWidth, orientation: orientation)
    }

    func createNormalPeg(center: Point, type: String, radius: Double, orientation: Double) -> Peg {
        Peg(center: center, name: type, radius: radius, orientation: orientation)
    }

    func createActionPeg(center: Point, type: String, radius: Double, orientation: Double) -> Peg {
        Peg(center: center, name: type, radius: radius, orientation: orientation, isBlast: true)
    }

    func createSharpObject(center: Point, type: String, circumradius: Double, orientation: Double) -> Sharp {
        Sharp(center: center, name: type, circumradius: circumradius, orientation: orientation)
    }
}
