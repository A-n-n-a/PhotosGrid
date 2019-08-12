//
//  RealmManager.swift
//  PhotosGrid
//
//  Created by Anna on 8/12/19.
//  Copyright © 2019 Anna. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmManager {
    
    static let schemaVersion: UInt64 = 1
    
    //=========================================================
    // MARK: - Initialization
    //=========================================================
    @discardableResult init?() {
        RealmManager.prepareRealmDatabase()
    }
    
    private static func prepareRealmDatabase() {
        
        let configCheck = Realm.Configuration();
        do {
            let fileUrlIs = try schemaVersionAtURL(configCheck.fileURL!)
            #if DEBUG
            print("schema version \(fileUrlIs)")
            #endif
        } catch  {
            #if DEBUG
            print(error)
            #endif
        }
        
        let config = Realm.Configuration(
            schemaVersion: RealmManager.schemaVersion,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < RealmManager.schemaVersion {
                    //TODO: migration
                }
        })
        Realm.Configuration.defaultConfiguration = config
        
        let realm = try! Realm()
    }
    
    //=========================================================
    // MARK: - Actions
    //=========================================================
    /// Add any object to database
    ///
    /// - Parameter object: Object that is child of Object class
    /// - Returns: Returns true if operatio was successful
    @discardableResult class func add(object: Object) -> Bool {
        do {
            let realm = try Realm(configuration: Realm.Configuration.defaultConfiguration)
            
            try realm.write {
                realm.add(object)
            }
            return true
        } catch {
            return false
        }
    }
    
    /// Get a list of object from database
    ///
    /// - Parameters:
    ///   - type: Type of needed object
    ///   - withFilter: Rooles to find objects from response
    /// - Returns: List of objects
    class func getObjects<T: Object>(type: T.Type, withFilter: String?) -> Results<T>? {
        do {
            let realm = try Realm(configuration: Realm.Configuration.defaultConfiguration)
            if let filter = withFilter {
                return realm.objects(type).filter(filter)
            } else {
                return realm.objects(type)
            }
        } catch {
            return nil
        }
    }
    
    /// Get object from database
    ///
    /// - Parameters:
    ///   - type: Type of needed object
    ///   - forPrimaryKey: Object's primaryKey
    /// - Returns: Object
    class func getObject<T: Object>(type: T.Type, forPrimaryKey: String?) -> T? {
        do {
            let realm = try Realm(configuration: Realm.Configuration.defaultConfiguration)
            return realm.object(ofType: type, forPrimaryKey: forPrimaryKey)
        } catch {
            return nil
        }
    }
    
    
    /// Delete object from database
    ///
    /// - Parameter Object: object from database
    /// - Returns: Returns true if operation was successful
    @discardableResult class func deleteObject<T: Object>(object: T) -> Bool {
        let list = List<T>()
        list.append(object)
        
        return RealmManager.deleteObjects(objects: list)
    }
    
    private class func deleteObjects<T: Object>(objects: List<T>) -> Bool {
        do {
            let realm = try Realm(configuration: Realm.Configuration.defaultConfiguration)
            try realm.write {
                realm.delete(objects)
            }
            
            return true
        } catch {
            return false
        }
    }
    
    /// Delete object from database
    ///
    /// - Parameter Object: object from database
    /// - Returns: Returns true if operation was successful
    @discardableResult class func deleteObject<T: Object>(object: T?) -> Bool {
        guard let object = object else {
            return false
        }
        
        return deleteObject(object: object)
    }
    
    /// Add any object to database or update it if its already exists.
    ///
    /// - Parameter object: Object that is child of Object class
    /// - Returns: Returns true if operation was successful
    @discardableResult class func addOrUpdate(object: Object) -> Bool {
        do {
            let realm = try Realm(configuration: Realm.Configuration.defaultConfiguration)
            
            try realm.write {
                realm.add(object, update: true)
            }
            
            return true
        } catch {
            return false
        }
    }
    
    /// Add any objects to database or update it if its already exists.
    ///
    /// - Parameter object: Objects that is child of Object class
    /// - Returns: Returns true if operation was successful
    @discardableResult class func addOrUpdate(objects: [Object]) -> Bool {
        do {
            let realm = try Realm(configuration: Realm.Configuration.defaultConfiguration)
            
            try realm.write {
                realm.add(objects, update: true)
            }
            
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult class func update<T: Object>(object: T, type: T.Type, value: Any, key: CodingKey) -> Bool {
        guard let primaryKey = type.primaryKey() else {
            return false
        }
        
        do {
            let realm = try Realm(configuration: Realm.Configuration.defaultConfiguration)
            guard let primaryKeyValue = object.value(forKey: primaryKey) as? String else {
                return false
            }
            let primaryKeyFilter = primaryKey + " == \"\(primaryKeyValue)\""
            let resultObject = realm.objects(type).filter(primaryKeyFilter).first
            try realm.write {
                resultObject?.setValue(value, forKey: key.stringValue)
            }
            return true
        } catch {
            return false
        }
    }
}


