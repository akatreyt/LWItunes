//
//  Network.swift
//  LWItunes
//
//  Created by Gary Tartt on 2/16/21.
//

import Foundation

class Network : Fetchable{
    var isFetching: Bool = false

    required init() {}
    
    func fetchFrom(endpoint ep: EndPoint, forTerm term: String, completionHandler comp: @escaping (Result<APIReturn, Error>) -> Void) throws {
        
    }
}
