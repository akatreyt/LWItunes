//
//  PlistStorable.swift
//  LWItunes
//
//  Created by Gary Tartt on 2/16/21.
//

import Foundation


class PlistStorage : Storable{
    required init() {
        do{
            self.favorites = try self.getFavorites()
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
    
    var favorites : [MediaResult] = [MediaResult]()
    
    let saveFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("favorites.plist")
    
    func save(favorable fav: MediaResult) throws {
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
    
    func getFavorites() throws -> [MediaResult] {
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
            print(allItems)
            return allItems
        }catch{
            fatalError()
        }
    }
}

