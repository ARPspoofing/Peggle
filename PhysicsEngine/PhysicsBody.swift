//
//  PhysicsBody.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 6/2/24.
//

class PhysicsBody: PhysicsElasticCollision, PhysicsRigidBody {
    private(set) var object: GameObject
    private(set) var position: Vector
    private(set) var mass = 8.0

    var velocity = Vector(horizontal: 0.0, vertical: 0.0)

    init(object: GameObject, position: Vector) {
        self.object = object
        self.position = position
    }

    init(object: GameObject, position: Point) {
        self.object = object
        self.position = position.convertToVector()
    }

    init(object: GameObject, position: Vector, mass: Double) {
        self.object = object
        self.position = position
        self.mass = mass
    }

    init(object: GameObject, position: Point, mass: Double) {
        self.object = object
        self.position = position.convertToVector()
        self.mass = mass
    }

    private func getOverlapStatus() -> Bool {
        object.isHandleOverlap
    }

    private func getUnitNormVector(from: Vector, to: Vector) -> Vector? {
        let normalVector: Vector = to.subtract(vector: from)
        return normalVector.calcUnitVector()
    }

    private func getTangentVector(from: Vector) -> Vector {
        Vector(horizontal: -from.vertical, vertical: from.horizontal)
    }

    private func getProjection(vector: Vector, velocity: Vector) -> Double {
        vector.dotProduct(with: velocity)
    }

    internal func resultantNormVec(normVec: Vector, src: PhysicsBody, dst: PhysicsBody) -> Vector {
        let srcVelProj = getProjection(vector: normVec, velocity: src.velocity)
        let dstVelProj = getProjection(vector: normVec, velocity: dst.velocity)

        let kineticConservation = srcVelProj * (src.mass - dst.mass) + 2.0 * dst.mass * dstVelProj
        let momentumConservation = src.mass + dst.mass
        return normVec.scale(kineticConservation / momentumConservation)
    }

    internal func resultantTanVector(tanVec: Vector, src: PhysicsBody) -> Vector {
        let srcVelProj = getProjection(vector: tanVec, velocity: src.velocity)
        return tanVec.scale(srcVelProj)
    }

    internal func assignResultantVel(normVel: Vector, tanVel: Vector,
                                     collider: inout PhysicsBody, collidee: inout PhysicsBody) {
        let resultantNormVel = resultantNormVec(normVec: normVel, src: collider, dst: collidee)
        let resultantTanVel = resultantTanVector(tanVec: tanVel, src: collider)
        collider.velocity = resultantNormVel.add(vector: resultantTanVel)
    }

    func doElasticCollision(collider: inout PhysicsBody, collidee: inout PhysicsBody) {
        guard !collider.mass.isZero && !collidee.mass.isZero else {
            return
        }
        guard let unitNormVec = getUnitNormVector(from: collider.position, to: collidee.position) else {
            return
        }
        let unitTanVec = getTangentVector(from: unitNormVec)
        assignResultantVel(normVel: unitNormVec, tanVel: unitTanVec, collider: &collider, collidee: &collidee)
    }
}
