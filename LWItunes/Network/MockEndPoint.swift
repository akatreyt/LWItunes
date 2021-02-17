//
//  MockEndPoint.swift
//  LWItunes
//
//  Created by Gary Tartt on 2/16/21.
//

import Foundation

private enum MockFileLocations : String{
    case TestResults = "result1s.json"
}

struct MockEndPoint : Fetchable{
    func fetchFrom(endpoint ep: EndPoint, forTerm term: String) throws -> APIReturn {
        do{
            let path = Bundle.main.bundleURL.appendingPathComponent(MockFileLocations.TestResults.rawValue)
            let data = try Data.init(contentsOf: path)
            let testResults = try JSONDecoder().decode(APIReturn.self, from: data)
            return testResults
        }catch{
            fatalError()
        }
    }
}
