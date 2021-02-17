//
//  Fetchable.swift
//  LWItunes
//
//  Created by Gary Tartt on 2/16/21.
//

import Foundation

public enum NetworkError : Error{
    case NoData
    case InvalidResponse
    case InvalidHTTPCode(Int)
    case ErrorDecoding(Error)
    case ErrorDecodingImage
    case InvalidURL(String)
}


protocol Fetchable {
    init()
    func fetchFrom(endpoint ep : EndPoint,
                   forTerm term : String,
                   completionHandler comp : @escaping (Result<APIReturn, NetworkError>) -> Void) throws
}
