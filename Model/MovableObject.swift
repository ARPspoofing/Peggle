//
//  MovableObject.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 23/1/24.
//

protocol MovableObject: GameObject {
    func checkNoIntersection(with gameObject: GameObject) -> Bool
    func checkRightBorder() -> Bool
    func checkLeftBorder() -> Bool
    func checkBottomBorder() -> Bool
    func checkTopBorder() -> Bool
    func checkSafeToInsert(with gameObject: GameObject) -> Bool
}
