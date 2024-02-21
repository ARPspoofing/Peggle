//
//  GravityGameEngine.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 17/2/24.
//

protocol GravityGameEngine {
    var gravityVelocity: Vector { get }
    func addGravity(to object: inout MotionObject)
}
