//
//  Fetchable.swift
//  LWItunes
//
//  Created by Gary Tartt on 2/16/21.
//

import Foundation

protocol Fetchable {
    func fetchFrom(endpoint ep : EndPoint, forTerm term : String) throws -> APIReturn
}
