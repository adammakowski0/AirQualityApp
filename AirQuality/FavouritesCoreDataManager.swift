//
//  CoreDataManager.swift
//  AirQuality
//
//  Created by Adam Makowski on 05/10/2024.
//

import Foundation
import CoreData


class FavouritesCoreDataManager {
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "AirQualityContainer")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error loading core data. \(error)")
            }
        }
    }
    
    func saveData(){
        do{
            try container.viewContext.save()
        }
        catch let error{
            print(error)
        }
    }
    
    func fetchData() -> [FavouritesEntity]{
        let request = NSFetchRequest<FavouritesEntity>(entityName: "FavouritesEntity")
        do{
            let savedEntities = try container.viewContext.fetch(request)

            return savedEntities
        }
        catch let error {
            print(error)
            return []
        }
    }
    
    func getEntity() -> FavouritesEntity{
        FavouritesEntity(context: container.viewContext)
    }
    
    func deleteEntity(entity: NSManagedObject){
        container.viewContext.delete(entity)
    }
}
