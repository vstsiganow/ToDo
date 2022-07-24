//
//  DefaultsKeyHelper.swift
//  ToDo
//
//  Created by vtsyganov on 24.07.2022.
//

import Foundation

final class DefaultsKeyHelper {
    // -MARK: Static properties
    static let shared = DefaultsKeyHelper()
    
    // -MARK: Private properties
    public struct DefaultsKey: Equatable {
        let key: String
    }
    
    private let defaults = UserDefaults.standard
    
    private var defaultsKeys: [DefaultsKey] = []
    
    private var currentDefaultsKey: DefaultsKey? = nil
    
    // -MARK: INIT
    private init() {}
    
    // -MARK: Methods
    func getDataFor(_ key: String) -> [Any] {
        if checkDefaultsKeyExisting(key), let index = getDefaultsKeyIndex(key)  {
            let defaultsKey = defaultsKeys[index]
            
            setCurrentDefaultsKey(defaultsKey)
            
            return defaults.object(forKey: key) as! [Any]
        } else {
            return []
        }
    }
    
    func setDataWith(data: [Any], key: String) {
        guard !checkDefaultsKeyExisting(key) else { return }
        
        let defaultsKey = DefaultsKey(key: key)
        defaultsKeys.append(defaultsKey)
        
        setCurrentDefaultsKey(defaultsKey)
        
        defaults.set(data, forKey: key)
    }
    
    // -MARK: Public methods
    public func getCurrentDefaultsKey() -> String? {
        currentDefaultsKey?.key
    }
    
    public func getAllKeys() -> [String] {
        var keys: [String] = []
        for key in defaultsKeys {
            keys.append(key.key)
        }
        
        return keys
    }
    
    // -MARK: Private methods
    private func checkDefaultsKeyExisting(_ key: String) -> Bool {
        let keys = getAllKeys()
        return keys.contains(key) ? true : false
    }

    private func setCurrentDefaultsKey(_ defaultsKey: DefaultsKey) {
        if currentDefaultsKey != defaultsKey {
            currentDefaultsKey = defaultsKey
        }
    }
    
    private func getDefaultsKeyIndex(_ key: String) -> Int? {
        if checkDefaultsKeyExisting(key) {
            for item in 0...defaultsKeys.count-1 {
                if defaultsKeys[item].key == key {
                    return item
                }
            }
        }
        
        return nil
    }
}
