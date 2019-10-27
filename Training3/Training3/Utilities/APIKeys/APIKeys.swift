//
//  ApiKeys.swift
//  Training3
//
//  Created by Yuki Okudera on 2019/10/26.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation

struct APIKeys {
    
    /// APIKeys.plistのKeyをenumで管理する
    enum KeyName: String {
        case recruitApiKey = "RECRUIT_API_KEY"
    }
    
    static func valueForAPIKey(named keyname: APIKeys.KeyName) -> String {
        let propertyList = readPropertyList()
        guard let value = propertyList?[keyname.rawValue] as? String else {
            assertionFailure("APIKeys.plist has not \(keyname) key.")
            return ""
        }
        return value
    }
}

extension APIKeys {
    
    private static func readPropertyList() -> [String: Any]? {
        var propertyListFormat =  PropertyListSerialization.PropertyListFormat.xml
        guard let plistPath = Bundle.main.path(forResource: "APIKeys", ofType: "plist") else {
            assertionFailure("APIKeys.plist is nil.")
            return nil
        }
        guard let plistXML = FileManager.default.contents(atPath: plistPath) else {
            assertionFailure("APIKeys.plist data is nil.")
            return nil
        }
        do {
            let plistData = try PropertyListSerialization.propertyList(from: plistXML,
                                                                       options: .mutableContainersAndLeaves,
                                                                       format: &propertyListFormat) as? [String: Any]
            return plistData
        } catch {
            print("Error reading plist: \(error), format: \(propertyListFormat)")
            return nil
        }
    }
}
