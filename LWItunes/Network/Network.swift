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
    
    func fetchFrom(endpoint ep: EndPoint, forTerm term: String, completionHandler comp: @escaping (Result<APIReturn, NetworkError>) -> Void) throws {
        
        guard let encodedStr = term.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            comp(.failure(.InvalidURL(EndPoint.search.rawValue+term)))
            return
        }
        
        let fullURLStr = EndPoint.search.rawValue+encodedStr

        let url = URL(string:fullURLStr)!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            
            guard let data = data else {
                comp(.failure(.NoData))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    comp(.failure(.InvalidHTTPCode(httpResponse.statusCode)))
                    return
                }
            }else{
                comp(.failure(.InvalidResponse))
                return
            }
            
            do{
                print(String(data: data, encoding: .utf8))
                let apiReturn  = try JSONDecoder().decode(APIReturn.self, from: data)
                comp(.success(apiReturn))
            }catch{
                comp(.failure(.ErrorDecoding(error)))
            }
        }

        task.resume()
    }
}
