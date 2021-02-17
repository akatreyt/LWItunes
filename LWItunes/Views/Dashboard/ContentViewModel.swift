//
//  DashboardViewModel.swift
//  LWItunes
//
//  Created by Gary Tartt on 2/16/21.
//

import SwiftUI

class DashboardViewModel<Network : Fetchable> : ObservableObject{
    private var network = Network()
    
    private var apiReturn : APIReturn?
    
    public var returnData : [MediaResult]?{
        get{
            if let _apiReturn = apiReturn{
                return _apiReturn.results
            }
            return nil
        }
    }
    
    @Published public var searchTerm = ""
    
    
    @Published public private(set) var networkIsFetching : Bool = false
    
    
    public func search(){
        do{
            networkIsFetching = true
            try network.fetchFrom(endpoint: EndPoint.search,
                                  forTerm: searchTerm,
                                  completionHandler: { [weak self] result in
                                    switch result{
                                    
                                    case .success(let apiResults):
                                        self?.apiReturn = apiResults
                                    case .failure(let error):
                                        print(error)
                                    }
                                  })
            
            networkIsFetching = false
        }catch{
            print(error)
        }
    }
}
