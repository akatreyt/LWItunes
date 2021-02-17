//
//  Fetchable.swift
//  LWItunes
//
//  Created by Gary Tartt on 2/16/21.
//

import Foundation

protocol Fetchable {
    init()
    var isFetching : Bool { get }
    func fetchFrom(endpoint ep : EndPoint,
                   forTerm term : String,
                   completionHandler comp : @escaping (Result<APIReturn, Error>) -> Void) throws
}
