//
//  Storable.swift
//  LWItunes
//
//  Created by Gary Tartt on 2/16/21.
//

import Foundation

protocol Storable {
    static func save(favorable fav : Favorable) throws
}
