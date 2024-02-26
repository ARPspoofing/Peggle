//
//  StateChangeObject.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 11/2/24.
//

protocol StateChangeObject {
    var velocity: Vector { get set }
}

extension StateChangeObject {
    mutating func reverseHorizontalVelocity() {
        velocity.changeHorizontalDir()
    }

    mutating func reverseVerticalVelocity() {
        velocity.changeVerticalDir()
    }

    func speedUpVelocity(factor: Double, vector: Vector) -> Vector {
        vector.scale(factor)
    }
}
