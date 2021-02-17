//
//  Favorable.swift
//  LWItunes
//
//  Created by Gary Tartt on 2/16/21.
//

import Foundation

protocol Favorable  {
    func checkIfFavorites(media : MediaResult) -> Bool
    var favorites : [MediaResult] { get }
}
