//
//  FakeUserDefaults.swift
//  Aite
//
//  Created by Jose Tlacuilo on 22/03/25.
//

import Foundation

class FakeUserDefaults: UserDefaults {
    private var store: [String: Any] = [:]
    
    override func object(forKey key: String) -> Any? {
        return store[key]
    }
    
    override func set(_ value: Any?, forKey key: String) {
        store[key] = value
    }
    
    override func data(forKey key: String) -> Data? {
        store[key] as? Data
    }
    
    override func removeObject(forKey key: String) {
        store.removeValue(forKey: key)
    }
    
    func clearStore() {
        store.removeAll()
    }
}
