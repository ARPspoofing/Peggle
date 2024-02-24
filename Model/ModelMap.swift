//
//  ModelMap.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 23/2/24.
//

struct ModelMap {
    func getEntity(center: Point, type: String, halfWidth: Double) -> GameObject {
        let entity: [String: GameObject] = [
            Constants.sharpObject: createSharpObject(center: center, type: type, circumradius: halfWidth),
            Constants.normalObject: createPegObject(center: center, type: type, radius: halfWidth),
            Constants.actionObject: createPegObject(center: center, type: type, radius: halfWidth)
        ]
        return entity[type] ?? createPegObject(center: center, type: type, radius: halfWidth)
    }

    func createPegObject(center: Point, type: String, radius: Double) -> Peg {
        Peg(center: center, name: type, radius: radius)
    }

    func createSharpObject(center: Point, type: String, circumradius: Double) -> Sharp {
        Sharp(center: center, name: type, circumradius: circumradius)
    }
}
