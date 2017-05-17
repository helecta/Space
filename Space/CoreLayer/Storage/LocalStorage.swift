//
//  StorageWrapper.swift
//  Space
//
//  Created by Liliya Fedotova on 12/05/2017.
//  Copyright © 2017 peekaboo. All rights reserved.
//

import Foundation

protocol Storage {
  func set<T: AnyObject>(_ object: T, forKey key: String) where T: NSCoding
  func object(forKey key: String) -> AnyObject?
  func bool(forKey key: String) -> Bool?
  func set(_ bool: Bool, forKey key: String)
  func removeObject(forKey key: String)
  func removeAll()
}

//Storage, now it use userDefaults 

class LocalStorage: Storage {
  
  fileprivate var _storage = UserDefaults.standard
  
  func set<T : AnyObject>(_ object: T, forKey key: String) where T : NSCoding {
    //archive key
    let data = NSKeyedArchiver.archivedData(withRootObject: object)
    self._storage.set(data, forKey: key)
    self._storage.synchronize()
  }
  
  func set(_ bool: Bool, forKey key: String) {
    self._storage.set(bool, forKey: key)
    self._storage.synchronize()
  }
  
  func object(forKey key: String) -> AnyObject? {
    if let obj = self._storage.object(forKey: key) as? Data {
      return NSKeyedUnarchiver.unarchiveObject(with: obj) as AnyObject?
    }
    return nil
  }
  
  func bool(forKey key: String) -> Bool? {
    return self._storage.bool(forKey: key)
		
  }
  
  func removeObject(forKey key: String) {
    self._storage.removeObject(forKey: key)
    self._storage.synchronize()
  }
  
  func removeAll() {
    self._storage.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    self._storage.synchronize()
  }
  
}
