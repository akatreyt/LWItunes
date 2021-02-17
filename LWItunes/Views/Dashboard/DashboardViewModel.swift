//
//  DashboardViewModel.swift
//  LWItunes
//
//  Created by Gary Tartt on 2/16/21.
//

import SwiftUI

typealias SortedMediaInfo = [String: [MediaResult]]

class DashboardViewModel<Network : Fetchable> : ObservableObject{
    private var network = Network()
    
    private var apiReturn : APIReturn?{
        didSet{
            resetSortedData()
        }
    }
    
    public private(set) var mediaKeys = [String]()

    public var sortedData = SortedMediaInfo()
    
    public var returnData : [MediaResult]?{
        get{
            if let _apiReturn = apiReturn{
                return _apiReturn.results
            }
            return nil
        }
    }
    
    public let filterResetKey = "Reset"
    
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
    
    private func sort(data : [MediaResult]) -> [String : [MediaResult]]{
        var tmpSortedData =  [String : [MediaResult]]()
        
        for result in data{
            let kind = result.kind
            (tmpSortedData[kind.uppercased(), default: []]).append(result)
        }
        
        return tmpSortedData
    }
    
    private func resetSortedData(){
        sortedData = sort(data: self.apiReturn!.results)
        mediaKeys = sortedData.keys.sorted(by: <)
    }
    
    public func filterMedia(forKey key : String){
        resetSortedData()
        if key != filterResetKey{
            var tmpData = SortedMediaInfo()
            tmpData[key] = sortedData[key]
            sortedData = tmpData
        }
    }
}
