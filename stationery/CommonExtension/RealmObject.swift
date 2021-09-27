//
//  RealmObject.swift
//  Isetan
//
//  Created by Kaung Soe on 5/20/19.
//  Copyright © 2019 codigo. All rights reserved.
//

import Foundation
import RealmSwift

import RealmSwift

public extension Object {
    func delete() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(self)
            }
        } catch {
            print("Realm Delete Exception: \(error)")
        }
    }
    
    func save() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(self)
            }
        } catch {
            print("Realm Save Exception: \(error)")
        }
    }
    
    func save(updatePolicy: Realm.UpdatePolicy) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(self, update: updatePolicy)
            }
        } catch {
            print("Realm Save Exception: \(error)")
        }
    }
    
    static func get<T: Object>() -> T? {
        do {
            let realm = try Realm()
            return realm.objects(T.self).first
        } catch {
            print("Realm getFirst Exception: \(error)")
            return nil
        }
    }
    
    static func getList<T: Object>() -> [T]? {
        do {
            let realm = try Realm()
            return Array(realm.objects(T.self))
        } catch {
            print("Realm get Exception: \(error)")
            return nil
        }
    }
    
    static func hasSaved() -> Bool {
          do {
              let realm = try Realm()
            return !(Array(realm.objects(self)).isEmpty)
          } catch {
              print("Realm get Exception: \(error)")
              return false
          }
      }
    
    func saveValue(toSave: () -> Void) {
        do {
            let realm = try Realm()
            try realm.write { toSave() }
        } catch {
            print("Realm Save Exception: \(error)")
        }
    }
}

public extension Array where Element: Object {
    func delete() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(self)
            }
        } catch {
            print("Realm Delete Exception: \(error)")
        }
    }
    
    func save() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(self)
            }
        } catch {
            print("Realm Save Exception: \(error)")
        }
    }
    
    func save(updatePolicy: Realm.UpdatePolicy) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(self, update: updatePolicy)
            }
        } catch {
            print("Realm Save Exception: \(error)")
        }
    }
}
