//
//  PhysicsBody.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 6/2/24.
//

class PhysicsBody: PhysicsElasticCollision, PhysicsRigidBody {
    private(set) var position: Vector
    private(set) var mass = 8.0
    private(set) var isBlast = false

    var velocity = Vector(horizontal: 0.0, vertical: 0.0)

    init(position: Vector) {
        self.position = position
    }

    init(position: Point) {
        self.position = position.convertToVector()
    }

    init(position: Vector, mass: Double) {
        self.position = position
        self.mass = mass
    }

    init(position: Point, mass: Double) {
        self.position = position.convertToVector()
        self.mass = mass
    }

    init(position: Vector, mass: Double, isBlast: Bool) {
        self.position = position
        self.mass = mass
        self.isBlast = isBlast
    }

    init(position: Point, mass: Double, isBlast: Bool) {
        self.position = position.convertToVector()
        self.mass = mass
        self.isBlast = isBlast
    }

    init(position: Vector, mass: Double, isBlast: Bool, velocity: Vector) {
        self.position = position
        self.mass = mass
        self.isBlast = isBlast
        self.velocity = velocity
    }

    init(position: Point, isBlast: Bool, velocity: Vector) {
        self.position = position.convertToVector()
        self.isBlast = isBlast
        self.velocity = velocity
    }

    init(position: Point, mass: Double, isBlast: Bool, velocity: Vector) {
        self.position = position.convertToVector()
        self.mass = mass
        self.isBlast = isBlast
        self.velocity = velocity
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
        collidee.velocity = collider.velocity.getComplement()
        guard isBlast else {
            return
        }
        collider.velocity = collider.velocity.add(vector: Vector(horizontal: 0.0, vertical: -5))
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
