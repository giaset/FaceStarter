//
//  LocalStorage.swift
//  FaceStarter
//
//  Created by Gianni Settino on 2017-03-20.
//  Copyright © 2017 Jack Rogers. All rights reserved.
//

import Foundation

class LocalStorage {
    
    static let friendsKey = "friendsKey"
    static let taggedIdentifiersKey = "taggedIdentifiers"
    
    class func addEmbedding(embedding: [NSNumber], forFriend friend: String) {
        var dict = friends()
        var embeddings = dict[friend] ?? []
        embeddings.append(embedding)
        dict[friend] = embeddings
        UserDefaults.standard.set(dict, forKey: friendsKey)
        UserDefaults.standard.synchronize()
    }
    
    class func friends() -> [String: [[NSNumber]]] {
        return UserDefaults.standard.dictionary(forKey: friendsKey) as? [String: [[NSNumber]]] ?? [:]
    }
    
    class func markPhotoAsTagged(uuid: String) {
        var dict = taggedIdentifiers()
        dict[uuid] = true
        UserDefaults.standard.set(dict, forKey: taggedIdentifiersKey)
        UserDefaults.standard.synchronize()
    }
    
    class func taggedIdentifiers() -> [String: Bool] {
        return UserDefaults.standard.dictionary(forKey: taggedIdentifiersKey) as? [String: Bool] ?? [:]
    }
}
