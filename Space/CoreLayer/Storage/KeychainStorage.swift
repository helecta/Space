//
//  KeychainStorage.swift
//  Space
//
//  Created by Liliya Fedotova on 12/05/2017.
//  Copyright © 2017 peekaboo. All rights reserved.
//

import UIKit
import KeychainSwift


class KeychainStorage: Storage {

	let keychain = KeychainSwift()
	
	func set<T: AnyObject>(_ object: T, forKey key: String) where T: NSCoding {
		if let str = object as? String {
			self.keychain.set(str, forKey: key)
		}
		else {
			let data = NSKeyedArchiver.archivedData(withRootObject: object)
			self.keychain.set(data, forKey: key)
		}
	}
	
	func object(forKey key: String) -> AnyObject? {
		let val = self.keychain.get(key)
		if let data = val as? NSData {
			return NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! (Data) as (Data) as AnyObject?
		}
		return val as AnyObject?
	}
	
	func bool(forKey key: String) -> Bool? {
		return self.keychain.getBool(key)
	}
	
	func set(_ bool: Bool, forKey key: String) {
		self.keychain.set(bool, forKey: key)
	}
	
	func removeObject(forKey key: String) {
		self.keychain.delete(key)
	}
	
	func removeAll() {
		self.keychain.clear()
	}
	
	
}
