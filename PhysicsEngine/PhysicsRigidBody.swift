//
//  PhysicsRididBody.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 17/2/24.
//

protocol PhysicsRigidBody {
    func resultantNormVec(normVec: Vector, src: PhysicsBody, dst: PhysicsBody) -> Vector
    func resultantTanVector(tanVec: Vector, src: PhysicsBody) -> Vector
    func assignResultantVel(normVel: Vector,
                            tanVel: Vector,
                            collider: inout PhysicsBody,
                            collidee: inout PhysicsBody)
}
