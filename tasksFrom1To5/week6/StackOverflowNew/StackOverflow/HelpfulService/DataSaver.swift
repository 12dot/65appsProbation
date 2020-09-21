//
//  DataSaver.swift
//  StackOverflow
//
//  Created by 12dot on 11.09.2020.
//  Copyright © 2020 12dot. All rights reserved.
//

import Foundation


class DataSaver {

    // MARK: - Properties
    private static let fileManager = FileManager()
    private static let defaults = UserDefaults.standard
      
    // MARK: - Private methods
    private static func deleteFile(filename : String) {
        
        do {
            guard let url = makeURL(fileName: filename) else {
                print("Invalid Directory")
                return
            }
            let filepath = url.path
            try fileManager.removeItem(atPath: filepath)
        } catch let error as NSError {
            print("Error deleting : \(error)")
        }
    }
    
    private static func makeURL(fileName: String) -> URL? {
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(fileName)
    }
    
    
    private static func isFileExist(filename : String, url : URL) -> Bool {
        
        let filePath = url.path
        if fileManager.fileExists(atPath: filePath) {
            
            let lastUpdate = defaults.object(forKey: "lastUpdate") as? Date
            if lastUpdate != nil {
                let date = Date()
                let timeintervalInSecs = date.timeIntervalSince(lastUpdate!)
                if timeintervalInSecs >= 3600{
                    deleteFile(filename: filename)
                    print("File deleted cas time is reached")
                    return false
                } else {
                    return true
                }
            } else {
                print("havent last update")
                return false
            }
        } else {
            return false
        }
    }
    
    // MARK: - Public methods
    public static func readDataFromFile(filename : String) -> Data? {
        guard let url = makeURL(fileName: filename) else {
            print("Invalid Directory")
            return nil
        }
        
        if isFileExist(filename: filename, url: url){
            do{
                return try Data(contentsOf: url)
            } catch let error as NSError{
                print("Error reading: \(error)")
            }
        }
        return nil
    }
    
    public static func createFileAndSave(filename : String, data: Data){
        guard let url = makeURL(fileName: filename) else {
                   print("Invalid Directory")
                   return
        }
        
        if isFileExist(filename: filename, url: url){
            return print("File already exists to save")
        }
        
        do{
            try data.write(to: url)
            defaults.set(Date(), forKey: "lastUpdate")
        } catch let error as NSError {
            print("error creating: \(error)")
        }
    }
    
    
}
