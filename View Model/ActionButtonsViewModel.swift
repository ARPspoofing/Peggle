//
//  ActionButtonsViewModel.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 25/1/24.
//

import Foundation

class ActionButtonsViewModel: ObservableObject {

    let constants = ActionViewModelConstants()
    let manager = CoreDataManager()

    init() {
        saveLevels()
    }

    func getLevels() -> [String] {
        manager.getLevelNames()
    }

    func convertToLowerCase(_ levelName: String) -> String {
        levelName.lowercased()
    }

    func isAlphaNumeric(_ levelName: String) -> Bool {
        let allowedCharacterSet = CharacterSet.alphanumerics.union(.whitespaces)
        return levelName.rangeOfCharacter(from: allowedCharacterSet.inverted) == nil
    }

    func checkValidity(levelName: String, gameObjects: [GameObject]) -> String? {
        if gameObjects.isEmpty {
            return constants.noPegMessage
        }

        if levelName.isEmpty {
            return constants.emptyLevelMessage
        }

        let lowercasedLevelName = convertToLowerCase(levelName)
        if !isAlphaNumeric(lowercasedLevelName) {
            return constants.alphaNumericLevelMessage
        }

        return nil
    }

    func checkLevelExistence(levelName: String) -> Bool {
        let lowercasedLevelName = convertToLowerCase(levelName)
        return getLevels().contains(lowercasedLevelName)
    }

    func saveLevel(levelName: String, gameObjects: [GameObject]) -> String {
        guard let errorMessage = checkValidity(levelName: levelName, gameObjects: gameObjects) else {
            return manager.saveLevel(Level(levelName: convertToLowerCase(levelName),
                                           isPreloadedLevel: false, gameObjects: gameObjects))
        }
        return errorMessage
    }

    func loadLevel(_ levelName: String, _ gameObjects: inout [GameObject]) -> String? {

        let lowercasedLevelName = convertToLowerCase(levelName)

        let gameObjectsAndErrorStatus = manager.getLevelObjects(lowercasedLevelName)

        guard let fetchedGameObjects = gameObjectsAndErrorStatus.objects else {
            return gameObjectsAndErrorStatus.errorMessage
        }
        gameObjects = fetchedGameObjects
        return nil
    }

    func saveLevels() {
        savePreloadedLevel(FirstLevel(), name: constants.firstLevel)
        savePreloadedLevel(SecondLevel(), name: constants.secondLevel)
        savePreloadedLevel(ThirdLevel(), name: constants.thirdLevel)
    }

    func savePreloadedLevel(_ levelInfo: PreloadedLevel, name: String) {
        let levelData = levelInfo.level
        guard let level = levelData?.data(using: .utf8) else {
            return
        }
        let decodedLevel = try? JSONDecoder().decode(Level.self, from: level)
        guard let decodedLevelObjects = decodedLevel?.gameObjects else {
            return
        }
        let message = saveLevel(levelName: name, gameObjects: decodedLevelObjects)
        print(message)
    }

    func resetLevel(_ gameObjects: inout [GameObject]) {
        gameObjects = []
    }
}
