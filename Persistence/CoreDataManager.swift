//
//  CoreDataManager.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 3/2/24.
//

import SwiftUI
import CoreData

class CoreDataManager: ObservableObject {

    private let levelEntity = "LevelEntity"
    private let containerName = "LevelManager"
    private let predFormat = "id == %@"

    private let errorLoadCoreData = "Error loading Core Data."
    private let errorFetch = "Error fetching."
    private let errorDelete = "Error deleting level."
    private let errorLoadingPrompt = "Level not found!"
    private let errorDetingLevelFolder = "Error deleting level folder!"
    private let emptyErrorMessage = ""

    private let successSavingLevelMessage = "Successfully saved level!"
    private let successDelete = "Success deleting level."

    private let failedToSaveLevel = "Failed to save level!"

    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    let request = NSFetchRequest<LevelEntity>(entityName: "LevelEntity")
    let modelMap = ModelMap()
    @Published var levelEntities: [LevelEntity] = []

    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("\("Error loading Core Data.") \(error)")
            }
        }
        context = container.viewContext
    }

    private func createRequest() -> NSFetchRequest<LevelEntity> {
        NSFetchRequest<LevelEntity>(entityName: levelEntity)
    }

    private func fetchLevelEntities(with request: NSFetchRequest<LevelEntity>) -> [LevelEntity] {
        do {
            return try context.fetch(request)
        } catch let error as NSError {
            print("\(errorFetch) \(error.localizedDescription)")
            return []
        }
    }

    private func fetchAndSortLevelEntities() {
        let request = createRequest()
        let sort = NSSortDescriptor(keyPath: \LevelEntity.id, ascending: true)
        request.sortDescriptors = [sort]

        levelEntities = fetchLevelEntities(with: request)
    }

    private func fetchLevelEntity(name: String) -> LevelEntity? {
        let request = createRequest()
        let filter = NSPredicate(format: predFormat, name)
        request.predicate = filter
        let filteredLevels = fetchLevelEntities(with: request)
        return filteredLevels.first
    }

    private func convertToGameObjects(gameEntities: NSSet) -> [GameObject]? {
        let gameObjects = gameEntities.compactMap { gameEntity -> GameObject? in
            guard let gameEntity = gameEntity as? GameObjectEntity,
                  let pointEntity = gameEntity.point,
                  let gameEntityType = gameEntity.name else {
                return nil
            }
            let center = Point(xCoord: pointEntity.xCoord, yCoord: pointEntity.yCoord)
            let orientation = gameEntity.orientation
            return modelMap.getEntity(center: center, type: gameEntityType, halfWidth: gameEntity.halfWidth, orientation: orientation)
        }
        return gameObjects.isEmpty ? nil : gameObjects
    }

    private func fetchGameObjects(from levelEntity: LevelEntity) -> [GameObject]? {
        guard let gameEntities = levelEntity.gameObjects else {
            return nil
        }
        return convertToGameObjects(gameEntities: gameEntities)
    }

    func getLevelNames() -> [String] {
        fetchAndSortLevelEntities()
        return levelEntities.compactMap({ $0.id })
    }

    private func getLevel(_ name: String) -> Level? {
        guard let levelEntity = fetchLevelEntity(name: name),
              let gameObjects = fetchGameObjects(from: levelEntity),
              let id = levelEntity.id else {
            return nil
        }
        return Level(levelName: id, isPreloadedLevel: levelEntity.isPreloadedLevel, gameObjects: gameObjects)
    }

    func getLevelObjects(_ levelName: String) -> (objects: [GameObject]?, errorMessage: String) {
        guard let level = getLevel(levelName) else {
            return (nil, errorLoadingPrompt)
        }
        return (level.gameObjects, emptyErrorMessage)
    }

    private func updateOrCreateLevelEntity(for level: Level) -> LevelEntity {
        let request = createRequest()
        request.predicate = NSPredicate(format: predFormat, level.id)
        guard let fetchLevel = fetchLevelEntity(name: level.id) else {
            let newLevel = LevelEntity(context: context)
            newLevel.id = level.id
            newLevel.isPreloadedLevel = level.isPreloadedLevel
            return newLevel
        }
        return fetchLevel
    }

    private func createGameEntity(from game: GameObject, context: NSManagedObjectContext) -> GameObjectEntity {
        let gameEntity = GameObjectEntity(context: context)
        gameEntity.name = game.name
        gameEntity.halfWidth = game.halfWidth
        gameEntity.orientation = game.orientation

        let pointEntity = PointEntity(context: context)
        pointEntity.xCoord = game.center.xCoord
        pointEntity.yCoord = game.center.yCoord

        gameEntity.point = pointEntity

        return gameEntity
    }

    func saveLevel(_ level: Level) -> String {
        let levelEntity = updateOrCreateLevelEntity(for: level)

        let gameEntities = level.gameObjects.map { game in
            createGameEntity(from: game, context: context)
        }

        levelEntity.gameObjects = NSSet(array: gameEntities)

        return save()
    }

    func deleteLevel(name: String) -> String {
        guard let levelEntity = fetchLevelEntity(name: name) else {
            return errorDetingLevelFolder
        }

        return delete(entity: levelEntity)
    }

    private func save() -> String {
        do {
            try context.save()
            return successSavingLevelMessage
        } catch {
            return failedToSaveLevel
        }
    }

    private func delete(entity: LevelEntity) -> String {
        do {
            context.delete(entity)
            try context.save()
            return successDelete
        } catch {
            return errorDelete
        }
    }
}
