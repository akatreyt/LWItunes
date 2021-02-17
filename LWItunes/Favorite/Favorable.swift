//
//  Favorable.swift
//  LWItunes
//
//  Created by Gary Tartt on 2/16/21.
//

import Foundation

enum StorageType{
    case Plist
    case Memory
    case CoreData
}

protocol Favorable {
    init(withStorageType storageType : StorageType)
    var storageType : StorageType { get }
    func checkIfFavorites(media : MediaResult) -> Bool
    var favorites : [MediaResult] { get }
    
    func save(favorable fav : MediaResult) throws
    func getFavorites() throws
}
