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
            Constants.normalObject: createPegObject(center: center, type: type, radius: halfWidth, orientation: orientation),
            Constants.actionObject: createPegObject(center: center, type: type, radius: halfWidth, orientation: orientation)
        ]
        return entity[type] ?? createPegObject(center: center, type: type, radius: halfWidth, orientation: orientation)
    }

    func createPegObject(center: Point, type: String, radius: Double, orientation: Double) -> Peg {
        Peg(center: center, name: type, radius: radius, orientation: orientation)
    }

    func createSharpObject(center: Point, type: String, circumradius: Double, orientation: Double) -> Sharp {
        Sharp(center: center, name: type, circumradius: circumradius, orientation: orientation)
    }
}
