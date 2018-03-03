//
//  CoreDataHelper.swift
//  TimeMyCommute
//
//  Created by C4Q  on 2/7/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import UIKit
import CoreData

enum ManagedObjectType: String {
    case activity = "Activity"
    case component = "Component"
}

class CoreDataHelper {
    private init() {}
    static let manager = CoreDataHelper()
    private let delegate = (UIApplication.shared.delegate as! AppDelegate)
    var context: NSManagedObjectContext {
        return delegate.persistentContainer.viewContext
    }
    
    var allActivities: [Activity] {
        var activites = [Activity]()
        do {
            activites = try context.fetch(Activity.fetchRequest())
        }
        catch {
            print(error)
        }
        return activites
    }
    
    func save() {
        delegate.saveContext()
    }
    
    func deleteAll(managedObjectType: ManagedObjectType) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: managedObjectType.rawValue)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print(error)
        }
    }
}
