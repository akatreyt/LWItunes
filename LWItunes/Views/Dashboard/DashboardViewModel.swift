//
//  DashboardViewModel.swift
//  LWItunes
//
//  Created by Gary Tartt on 2/16/21.
//

import SwiftUI

typealias SortedMediaInfo = [String: [MediaResult]]

class DashboardViewModel<Network : Fetchable, Storage : Storable> : ObservableObject, DashboardViewModelProtocol{
    
    init() {
        self.storageManger = Storage()
        self.favorites = [MediaResult]()
        
        updateFavorites()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateFavorites),
                                               name: .UpdateFavorites,
                                               object: nil)
        
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public var storageManger: Storable
    
    private var network = Network()
    
    public private(set) var apiReturn : APIReturn?{
        didSet{
            resetSortedData()
        }
    }
    
    public private(set) var mediaKeys = [String]()

    public private(set) var sortedData = SortedMediaInfo()
        
    public let filterResetKey = "Reset"
    
    @Published public private(set) var favorites : [MediaResult]
    
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
    
    @objc private func updateFavorites(){
        do{
            self.favorites = try storageManger.getFavorites()
        }catch{
            fatalError()
        }
    }
}
