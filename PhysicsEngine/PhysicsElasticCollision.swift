//
//  PhysicsElasticCollision.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 17/2/24.
//

protocol PhysicsElasticCollision {
    func doElasticCollision(collider: inout PhysicsBody, collidee: inout PhysicsBody)
}
