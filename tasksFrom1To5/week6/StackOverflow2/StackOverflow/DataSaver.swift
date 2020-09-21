//
//  DataSaver.swift
//  StackOverflow
//
//  Created by 12dot on 11.09.2020.
//  Copyright © 2020 12dot. All rights reserved.
//
import Foundation
import CoreData
import UIKit

class DataSaver {

    // MARK: - Properties
    private var lastUpdate : Date?
    let fileManager = FileManager()
      
    // MARK: - Private methods
    private func deleteFile(filename : String) {
        
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
    
    private func makeURL(fileName: String) -> URL? {
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(fileName)
    }
    
    
    private func isFileExist(filename : String, url : URL) -> Bool {
        
        //print(url.absoluteString)
        let filePath = url.path
        if fileManager.fileExists(atPath: filePath) {
            retrieveDate()
           if lastUpdate != nil {
                let date = Date()
                let timeintervalInSecs = date.timeIntervalSince(lastUpdate!)
                if timeintervalInSecs >= 3600{
                    deleteFile(filename: filename)
                    print("File deleted cas time is reached")
                    return false
                } else {
                    print("time normal")
                    return true
                }
            } else {
                print("havent last update")
                return false
            }
        } else {
            print("file not exist")
            return false
        }
    }
    
    // MARK: - Public properties
    public func readDataFromFile(filename : String) -> Data? {
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
        print("Haven't read cas not exist")
        return nil
    }
    
    public func createFileAndSave(filename : String, data: Data){
        guard let url = makeURL(fileName: filename) else {
                   print("Invalid Directory")
                   return
        }
        
        if isFileExist(filename: filename, url: url){
            return print("File already exists to save")
        }
        
        do{
            try data.write(to: url)
            print("file saved")
                if lastUpdate == nil {
                    DispatchQueue.main.async {
                        self.createDate()
                    }
                }else{
                    DispatchQueue.main.async {
                        self.updateDate()
                    }
                }
            //defaults.set(Date(), forKey: "lastUpdate")
        } catch let error as NSError {
            print("error creating: \(error)")
        }
    }
 
    // MARK: - Core Data methods
    private func createDate(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let lastDate = NSEntityDescription.entity(forEntityName: "LastUpdate", in: managedContext)!
        let dateLast = NSManagedObject(entity: lastDate, insertInto: managedContext)
        dateLast.setValue(Date(), forKeyPath: "lastUpdate")
        do {
        try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

     private func retrieveDate() {
           guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
           let managedContext = appDelegate.persistentContainer.viewContext
           let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LastUpdate")
           do {
               let result = try managedContext.fetch(fetchRequest)
               for data in result as! [NSManagedObject] {
                   //print(data.value(forKey: "lastUpdate"))
                    lastUpdate = data.value(forKey: "lastUpdate") as? Date
                    return
               }
           } catch {
               print("Failed")
               return
           }
       }

    private func updateDate(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "LastUpdate")
       do
        {
            let test = try managedContext.fetch(fetchRequest)
                let objectUpdate = test[0] as! NSManagedObject
                objectUpdate.setValue(Date(), forKey: "lastUpdate")
                do{
                    try managedContext.save()
                }
                catch
                {
                    print(error)
                }
            }
        catch
        {
            print(error)
        }

    }
}
