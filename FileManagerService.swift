//
//  FileManager.swift
//  project1
//
//  Created by Tino Krzelj on 15/04/2023.
//

import Foundation

struct FileManagerService<T: Any> where T: Codable, T: Equatable {
    
    // MARK: - Enums
    
    enum FileManagerServiceError: Error {
        case saveDataFailed
        case loadDataFailed
    }
    
    // MARK: - Properties
    
    private var appendPathName: String
    
    private var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private var savePathUrl: URL {
        documentsDirectory.appendingPathComponent(appendPathName)
    }
    
    // MARK: - Public Methods
        
    func saveData(_ data: [T]) throws {
        do {
            let data = try JSONEncoder().encode(data)
            try data.write(to: savePathUrl, options: [.atomic, .completeFileProtection])
        } catch {
            throw FileManagerServiceError.saveDataFailed
        }
        
    }
    
    func loadData() throws -> [T] {
        do {
            let rawData = try Data(contentsOf: savePathUrl)
            let decodedData = try JSONDecoder().decode([T].self, from: rawData)
            return decodedData
        } catch {
            throw FileManagerServiceError.loadDataFailed
        }
    }
    
    func removeData(_ data: T) throws {
        do {
            var loadedData = try loadData()
            loadedData.removeAll { $0 == data }
            try saveData(loadedData)
        } catch let error as FileManagerServiceError {
            throw error
        }
    }
    
    func removeAllData() throws {
        do {
            try saveData([])
        } catch let error as FileManagerServiceError {
            throw error
        }
    }
    
    // MARK: - Instance Lifecycle
    
    init(appendPathName: String) {
        self.appendPathName = appendPathName
    }
    
}
