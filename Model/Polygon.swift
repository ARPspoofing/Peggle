//
//  Polygon.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 23/2/24.
//

protocol Polygon {
    var circumradius: Double { get set }
    var base: Double { get set }
    var height: Double { get set }
    var edges: [Line] { get set }
}
