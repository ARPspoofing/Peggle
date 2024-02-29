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
            Constants.actionObject: createActionPeg(center: center, type: type, radius: halfWidth, orientation: orientation),
            Constants.oscillateObject: createOscillate(center: center, type: type, radius: halfWidth, orientation: orientation),
            Constants.reappearObject: createReappear(center: center, type: type, radius: halfWidth, orientation: orientation),
            Constants.obstacleObject: createObstacleObject(center: center, type: type, circumradius: halfWidth, orientation: orientation)
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

    func createOscillate(center: Point, type: String, radius: Double, orientation: Double) -> OscillateObject {
        OscillateObject(center: center, name: type, radius: radius,orientation: orientation)
    }

    func createReappear(center: Point, type: String, radius: Double, orientation: Double) -> ReappearObject {
        ReappearObject(center: center, name: type, radius: radius, orientation: orientation)
    }

    func createObstacleObject(center: Point, type: String, circumradius: Double, orientation: Double) -> ObstacleObject {
        ObstacleObject(center: center, name: type, circumradius: circumradius, orientation: orientation)
    }

    func createAmmoObject(maxAmmo: Int) -> [MotionObject] {
        var ammo: [MotionObject] = []
        var ammoVel = 8.0
        var ammoX = 50.0
        for idx in 1...maxAmmo {
            var object = MotionObject(center: Point(xCoord: ammoX, yCoord: Constants.screenHeight - (Double(idx) * ammoX)), name: "ammo", velocity: Vector(horizontal: 0.0, vertical: ammoVel))
            ammo.append(object)
        }
        return ammo
    }
}
