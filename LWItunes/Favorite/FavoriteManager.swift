//
//  Favorites.swift
//  LWItunes
//
//  Created by Gary Tartt on 2/17/21.
//

import Foundation
import Combine


class FavoriteManager : ObservableObject, Favorable{
    var storageType: StorageType
    @Published var favorites = [MediaResult](){
        didSet{
            NotificationCenter.default.post(name: .UpdateFavorites, object: nil)
        }
    }

    let saveFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("favorites.plist")
    
    required init(withStorageType storageType : StorageType) {
        self.storageType = storageType
        do{
            try getFavorites()
        }catch{
            fatalError()
        }
    }
    
    func checkIfFavorites(media : MediaResult) -> Bool{
        if favorites.contains(where: {
            $0.trackId == media.trackId
        }){
            return true
        }
        return false
    }

    func save(favorable fav: MediaResult) throws {
        do{
            switch storageType {
            case .Plist:
                try saveToPlist(favorable: fav)
            case .Memory:
                fatalError("Not implemented")
            case .CoreData:
                fatalError("Not implemented")
            }
            try getFavorites()
        }catch{
            fatalError()
        }
    }
    
    private func saveToPlist(favorable fav: MediaResult) throws {
        do{
            var data = try Data.init(contentsOf: saveFileURL)
            var allItems = try PropertyListDecoder().decode([MediaResult].self, from: data)
            
            if allItems.contains(where: {
                $0.trackId == fav.trackId
            }){
                allItems.removeAll(where: {
                    $0.trackId == fav.trackId
                })
            }else{
                allItems.append(fav)
            }
            
            data = try PropertyListEncoder().encode(allItems)
            try data.write(to: saveFileURL)
        }catch{
            fatalError()
        }
    }
    
    func getFavorites() throws {
        do{
            switch storageType {
            case .Plist:
                self.favorites = try getFromPlist()
            case .Memory:
                fatalError("Not implemented")
            case .CoreData:
                fatalError("Not implemented")
            }
        }catch{
            fatalError()
        }
    }
    
    private func getFromPlist() throws -> [MediaResult] {
        if !FileManager.default.fileExists(atPath: saveFileURL.path){
            do{
                let values = [MediaResult]()
                let data = try PropertyListEncoder().encode(values)
                try data.write(to: saveFileURL)
            }catch{
                fatalError()
            }
        }
        do{
            let data = try Data.init(contentsOf: saveFileURL)
            let allItems = try PropertyListDecoder().decode([MediaResult].self, from: data)
            return allItems
        }catch{
            fatalError()
        }
    }
}
