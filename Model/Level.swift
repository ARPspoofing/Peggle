//
//  Level.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 22/1/24.
//

import Foundation

struct Level: Identifiable, Codable {

    private(set) var id: String = ""
    private(set) var isPreloadedLevel = false
    private(set) var gameObjects: [GameObject]

    init(levelName: String, isPreloadedLevel: Bool, gameObjects: [GameObject]) {
        self.id = levelName
        self.isPreloadedLevel = isPreloadedLevel
        self.gameObjects = gameObjects
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(isPreloadedLevel, forKey: .isPreloadedLevel)
        try encodeGameObjects(container: &container)
    }

    func encodeGameObjects(container: inout KeyedEncodingContainer<CodingKeys>) throws {
        var wrapperArray = [GameObjectWrapper]()
        for gameObject in gameObjects {
            if let gameObject = gameObject as? Peg {
                let typeString = String(describing: type(of: gameObject))
                let data = try JSONEncoder().encode(gameObject)
                let wrapper = GameObjectWrapper(type: typeString, data: data)
                wrapperArray.append(wrapper)
            }
        }
        try container.encode(wrapperArray, forKey: .gameObjects)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)

        isPreloadedLevel = try container.decode(Bool.self, forKey: .isPreloadedLevel)
        let wrapperArray = try container.decode([GameObjectWrapper].self, forKey: .gameObjects)

        gameObjects = try wrapperArray.compactMap { wrapper in
            guard let gameObjectType = NSClassFromString(wrapper.type) as? GameObject.Type else {
                return nil
            }
            return try JSONDecoder().decode(gameObjectType, from: wrapper.data)
        }
    }

    enum CodingKeys: String, CodingKey {
        case id, isPreloadedLevel, gameObjects
    }

    mutating func addGameObject(_ gameObject: GameObject) {
        gameObjects.append(gameObject)
    }

    mutating func removeGameObject(_ gameObject: GameObject) {
        gameObjects.removeAll { $0 == gameObject }
    }

    mutating func setName(as name: String) {
        id = name
    }

    mutating func removeAll() {
        gameObjects.removeAll()
    }
}

struct GameObjectWrapper: Codable {
    let type: String
    let data: Data
}
