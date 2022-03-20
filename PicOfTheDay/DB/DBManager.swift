//
//  DBManager.swift
//  PicOfTheDay
//
//  Created by Anjaneyulu Battula on 17/03/22.
//

import Foundation
import CoreData

class DBManager {

    private init() {}
    static let shared = DBManager()

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "PicOfTheDay")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext(completion: (Result<Void, PicOfTheDayError>) -> Void) {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                completion(.success(()))
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                print("\(error.localizedDescription)")
                completion(.failure(.saveOrUpdateDBError))
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // Inserting PicOfDay
    func insertPicOfTheDay(potd: PicOfTheDayAPIModel,
                           fileName: String,
                           isFavourite: Bool,
                           favouritedDate: Date?,
                           completion: (Result<Void, PicOfTheDayError>) -> Void) {
        let picOfTheDayDB = PicOfTheDayDB(context: persistentContainer.viewContext)
        picOfTheDayDB.potdDate = potd.poctdDate
        picOfTheDayDB.explanation = potd.explanation
        picOfTheDayDB.mediaType = potd.mediaType.rawValue
        picOfTheDayDB.serviceVersion = potd.serviceVersion
        picOfTheDayDB.title = potd.title
        picOfTheDayDB.fileName = fileName
        picOfTheDayDB.thumbnailURL = potd.thumbnailURL
        picOfTheDayDB.isFavourite = isFavourite
        picOfTheDayDB.favouritedDate = isFavourite ? favouritedDate : nil
        saveContext(completion: completion)
    }

    // Get PicOfDay
    func getPicOfTheDayWith(dateStr: String, completion: (Result<PicOfTheDayDB?, PicOfTheDayError>) -> Void) {
        let fetchRequest = PicOfTheDayDB.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "potdDate LIKE %@", dateStr)

        do {
            if let picOfTheDayDB = try persistentContainer.viewContext.fetch(fetchRequest).first {
                completion(.success(picOfTheDayDB))
            } else {
                completion(.success(nil))
            }
        } catch {
            completion(.failure(.saveOrUpdateDBError))
        }
    }

    // Update PicOfDay
    func updatePicOfTheDay(potd: PicOfTheDay, completion: (Result<Void, PicOfTheDayError>) -> Void) {
        let fetchRequest = PicOfTheDayDB.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "potdDate LIKE %@", potd.date)
        do {
            if let picOfTheDayDB = try persistentContainer.viewContext.fetch(fetchRequest).first {
                picOfTheDayDB.isFavourite = potd.isFavourite
                picOfTheDayDB.favouritedDate = potd.isFavourite ? potd.favouritedDate : nil
                saveContext(completion: completion)
            }
        } catch {
            completion(.failure(.saveOrUpdateDBError))
        }
    }

    // Get Favourites List
    func getFavouriteList(completion: (Result<[PicOfTheDayDB], PicOfTheDayError>) -> Void) {
        let fetchRequest = PicOfTheDayDB.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isFavourite = %d", true)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "favouritedDate", ascending: false)]
        do {
            let favouriteList = try persistentContainer.viewContext.fetch(fetchRequest)
            completion(.success(favouriteList))
        } catch {
            completion(.failure(.saveOrUpdateDBError))
        }
    }
}
