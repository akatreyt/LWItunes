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

class MockNetwork : Fetchable{
    var isFetching: Bool = false
    
    required init() {}
    
    public func getMockData() -> APIReturn{
        do{
            isFetching = true
            let path = Bundle.main.bundleURL.appendingPathComponent(MockFileLocations.TestResults.rawValue)
            let data = try Data.init(contentsOf: path)
            let testResults = try JSONDecoder().decode(APIReturn.self, from: data)
            isFetching = false
            return testResults
        }catch{
            fatalError()
        }
    }
    
    func fetchFrom(endpoint ep : EndPoint,
                   forTerm term : String,
                   completionHandler comp : @escaping (Result<APIReturn, Error>) -> Void) throws{
        do{
            isFetching = true
            let path = Bundle.main.bundleURL.appendingPathComponent(MockFileLocations.TestResults.rawValue)
            let data = try Data.init(contentsOf: path)
            let testResults = try JSONDecoder().decode(APIReturn.self, from: data)
            comp(.success(testResults))
            isFetching = false
        }catch{
            fatalError()
        }
    }
}