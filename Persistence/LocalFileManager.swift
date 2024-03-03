//
//  FileManager.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 25/1/24.
//

import SwiftUI

class LocalFileManager {

    // MARK: File Manager Constants
    private let mainFolderName = "levels"
    private let firstLevelName = "levelone"
    private let folderName = "levels"

    private let errorCreatingFolder = "Error creating folder"
    private let errorGettingData = "Error getting data"
    private let errorGettingPath = "Error getting path"
    private let errorDecodingData = "Error decoding data"
    private let errorDetingMainFolder = "Error deleting main folder!"
    private let errorDetingLevelFolder = "Error deleting level folder!"
    private let errorListingSubfolders = "Error listing subfolders!"
    private let errorLoadingPrompt = "Level not found!"
    private let emptyErrorMessage = ""

    private let successCreatingFolder = "Successfully created folder!"
    private let successDetingMainFolder = "Successfully deleted main folder!"
    private let successDetingLevelFolder = "Successfully deleted level folder!"
    private let successSavingLevelMessage = "Successfully saved level!"

    private let failedObtainPath = "Error obtaining folder path"
    private let failedToSaveLevel = "Failed to save level!"
    private let failedToEncodeLevelMessage = "Failed to encode level!"

    init() {
        getPathAndCreateFolder()
    }

    private func getFirstDocumentDirectoryURL() -> URL? {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(folderName)
    }

    private func getAndReturnPath(_ subfolder: String? = nil) -> String? {
        let url: URL? = getFirstDocumentDirectoryURL()

        guard let subfolderName = subfolder else {
            return url?.path
        }
        return url?.appendingPathComponent(subfolderName).path
    }

    private func createFolder(path: String) {
        if !FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.createDirectory(
                    atPath: path,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
                print("\(successCreatingFolder)")
            } catch let error as NSError {
                print("\(errorCreatingFolder) \(error)")
            }
        }
    }

    private func getPathAndCreateFolder(_ subfolder: String? = nil) {
        guard let path = getAndReturnPath(subfolder) else {
            print("\(failedObtainPath)")
            return
        }

        createFolder(path: path)
    }

    private func saveJsonEncodedLevelData(_ level: Level) -> String {
        assert(checkRepresentation())
        guard let levelData = try? JSONEncoder().encode(level),
              let path = getPathForLevel(level.id) else {
            return "\(failedToEncodeLevelMessage)"
        }

        do {
            let jsonData = String(data: levelData, encoding: .utf8)
            try jsonData?.write(to: path, atomically: true, encoding: .utf8)
            assert(checkRepresentation())
            return successSavingLevelMessage
        } catch let error as NSError {
            return "\(failedToSaveLevel) \(error)"
        }
    }

    func saveLevel(_ level: Level) -> String {
        assert(checkRepresentation())
        getPathAndCreateFolder(level.id)
        assert(checkRepresentation())

        return saveJsonEncodedLevelData(level)
    }

    func getLevel(_ levelName: String) -> Level? {
        assert(checkRepresentation())
        guard
            let path = getPathForLevel(levelName)?.path,
            FileManager.default.fileExists(atPath: path) else {
            print("\(failedObtainPath)")
            return nil
        }
        guard let url = getPathForLevel(levelName), let data = try? Data(contentsOf: url) else {
            print("\(errorGettingData)")
            return nil
        }
        guard let savedLevel = try? JSONDecoder().decode(Level.self, from: data) else {
            print("\(errorDecodingData)")
            return nil
        }
        assert(checkRepresentation())
        return savedLevel
    }

    func getLevelObjects(_ levelName: String) -> (objects: [GameObject]?, errorMessage: String) {
        assert(checkRepresentation())
        guard let level = getLevel(levelName) else {
            return (nil, errorLoadingPrompt)
        }
        assert(checkRepresentation())
        return (level.gameObjects, emptyErrorMessage)
    }

    private func getPathForLevel(_ levelName: String) -> URL? {
        assert(checkRepresentation())
        guard
            let path = getFirstDocumentDirectoryURL()?
                .appendingPathComponent(levelName)
                .appendingPathComponent("\(levelName).json") else {
            print("\(errorGettingPath)")
            return nil
        }
        assert(checkRepresentation())
        return path
    }

    private func deleteMainFolder() {
        guard
            let path = getAndReturnPath() else {
            return
        }
        do {
            try FileManager.default.removeItem(atPath: path)
            print("\(successDetingMainFolder)")
        } catch let error as NSError {
            print("\(errorDetingMainFolder) \(error)")
        }
    }

    func deleteLevel(name: String) {
        assert(checkRepresentation())
        guard
            let path = getAndReturnPath(name) else {
            return
        }
        do {
            try FileManager.default.removeItem(atPath: path)
            print("\(successDetingLevelFolder)")
        } catch let error as NSError {
            print("\(errorDetingLevelFolder) \(error)")
        }
        assert(checkRepresentation())
    }

    func getLevelNames() -> [String] {
        assert(checkRepresentation())
        guard let mainFolderPath = getAndReturnPath() else {
            print("\(errorGettingPath)")
            return []
        }

        do {
            let subfolderURLs = try FileManager.default.contentsOfDirectory(
                at: URL(fileURLWithPath: mainFolderPath),
                includingPropertiesForKeys: nil,
                options: .skipsHiddenFiles
            )
            let subfolderNames = subfolderURLs.filter { url in
                var isDirectory: ObjCBool = false
                FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory)
                return isDirectory.boolValue
            }.map { $0.lastPathComponent }
            assert(checkRepresentation())
            return subfolderNames
        } catch let error as NSError {
            print("\(errorListingSubfolders) \(error)")
            return []
        }
    }

    // MARK: CheckRepresentation
    private func checkMainFolder() -> Bool {
        guard FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(folderName)
            .path != nil else {
            return false
        }
        return true
    }

    private func isFolder(_ path: String) -> Bool {
        var isDirectory: ObjCBool = false
        return FileManager.default
            .fileExists(atPath: path, isDirectory: &isDirectory) && isDirectory.boolValue
    }

    private func getAllItemsInMainFolder() -> [String]? {
        guard let mainFolderURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(folderName)
        else { return nil }

        do {
            let mainFolderContents = try FileManager.default.contentsOfDirectory(atPath: mainFolderURL.path)
            return mainFolderContents.map { mainFolderURL.appendingPathComponent($0).path }
        } catch {
            return nil
        }
    }

    private func checkMainFolderHasOnlyFolders() -> Bool {
        guard let mainFolderItems = getAllItemsInMainFolder() else {
            return false
        }
        return mainFolderItems.allSatisfy(isFolder)
    }

    private func checkRepresentation() -> Bool {
        checkMainFolder() && checkMainFolderHasOnlyFolders()
    }
}
