//
//  CollisionGameEngine.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 17/2/24.
//

protocol CollisionGameEngine {
    var gameObjectMass: Double { get }
    var intersectThrsh: Int { get }
    func handleObjectBoundaries(_ object: inout MotionObject)
    func handleIntersection(for peg: inout Peg, and object: inout MotionObject)
    func handleObjectCollisions(_ object: inout MotionObject)
    func handleCollision(motionObject: inout MotionObject, gameObject: Peg)
    func updateObjectPosition(_ object: inout MotionObject)
}
