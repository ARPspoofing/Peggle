//
//  DisappearObject.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 15/2/24.
//

import Foundation

protocol DisappearObject {
    var isHandleOverlap: Bool { get set }
    var isDisappear: Bool { get set }
    var handleOverlapCount: Int { get set }
    func checkBorders() -> Bool
    func checkSafeToInsert(with gameObject: GameObject) -> Bool
}
