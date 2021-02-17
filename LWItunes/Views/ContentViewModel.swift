//
//  ContentViewModel.swift
//  LWItunes
//
//  Created by Gary Tartt on 2/16/21.
//

import SwiftUI

class ContentViewModel<Network : Fetchable> : ObservableObject{
    private var network = Network()
    
    private var apiReturn : APIReturn?
    
    public var returnData : [Result]?{
        get{
            if let _apiReturn = apiReturn{
                return _apiReturn.results
            }
            return nil
        }
    }
    
    @Published public var searchTerm = ""
    
    
    @Published public var networkIsFetching : Bool = false
    
  
    public func search(){
        do{
            networkIsFetching = true
            apiReturn = try network.fetchFrom(endpoint: EndPoint.search,
                                           forTerm: searchTerm)
            
            networkIsFetching = false
        }catch{
            print(error)
        }
    }
}
