//
//  Storable.swift
//  LWItunes
//
//  Created by Gary Tartt on 2/16/21.
//

import Foundation

protocol Storable {
    init()
    func save(favorable fav : MediaResult) throws
    func getFavorites() throws -> [MediaResult]
}
