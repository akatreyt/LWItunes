//
//  Result.swift
//  LWItunes
//
//  Created by Gary Tartt on 2/16/21.
//

import Foundation

struct APIReturn : Decodable{
    let resultCount : Int
    let results : [MediaResult]
}
