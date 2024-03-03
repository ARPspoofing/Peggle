//
//  MyCodingKey.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 18/2/24.
//

struct MyCodingKey: CodingKey {
    var stringValue: String
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    var intValue: Int?
    init?(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }
}
