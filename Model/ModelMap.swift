//
//  ModelMap.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 23/2/24.
//

struct ModelMap {
    func getEntity(center: Point, type: String, halfWidth: Double, orientation: Double) -> GameObject {
        if type.contains(Constants.sharp) || type.contains(Constants.pointed) {
            return createSharpObject(center: center, type: type, circumradius: halfWidth, orientation: orientation)
        } else {
            let entity: [String: GameObject] = [
                Constants.normalObject: createNormalPeg(center: center, type: type,
                                                        radius: halfWidth, orientation: orientation),
                Constants.actionObject: createActionPeg(center: center, type: type,
                                                        radius: halfWidth, orientation: orientation),
                Constants.oscillateObject: createOscillate(center: center, type: type,
                                                           radius: halfWidth, orientation: orientation),
                Constants.reappearObject: createReappear(center: center, type: type,
                                                         radius: halfWidth, orientation: orientation),
                Constants.obstacleObject: createObstacleObject(center: center, type: type,
                                                               circumradius: halfWidth, orientation: orientation)
            ]
            return entity[type] ?? createNormalPeg(center: center,
                                                   type: type,
                                                   radius: halfWidth,
                                                   orientation: orientation)
        }
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
        OscillateObject(center: center, name: type, radius: radius, orientation: orientation)
    }

    func createReappear(center: Point, type: String, radius: Double, orientation: Double) -> ReappearObject {
        ReappearObject(center: center, name: type, radius: radius, orientation: orientation)
    }

    func createObstacleObject(center: Point, type: String,
                              circumradius: Double, orientation: Double) -> ObstacleObject {
        ObstacleObject(center: center, name: type, circumradius: circumradius, orientation: orientation)
    }

    func createAmmoObject(maxAmmo: Int) -> [MotionObject] {
        var ammo: [MotionObject] = []
        let ammoVel = 0.0
        let ammoX = 25.0
        for idx in 1...maxAmmo {
            let center = Point(xCoord: ammoX, yCoord: Constants.gameHeight - 250 - (Double(idx) * ammoX * 2))
            let velocity = Vector(horizontal: 0.0, vertical: ammoVel)
            let object = MotionObject(center: center, name: "ammo", velocity: velocity)
            ammo.append(object)
        }
        return ammo
    }

    func getEntityScore(for object: GameObject) -> Double {
        let entityScore: [String: Double] = [
            Constants.normalObject: 10.0,
            Constants.reappearObject: 10.0,
            Constants.actionObject: 100.0,
            Constants.oscillateObject: 500.0
        ]
        return entityScore[object.name] ?? 0.0
    }

    func getTotalScore(for gameObjects: [GameObject]) -> Double {
        var score = 0.0
        for object in gameObjects {
            guard object.isActive && object.health == 0 else {
                continue
            }
            score += getEntityScore(for: object)
        }
        return score
    }
}
