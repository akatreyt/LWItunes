//
//  DashboardViewModel.swift
//  LWItunes
//
//  Created by Gary Tartt on 2/16/21.
//

import SwiftUI

typealias SortedMediaInfo = [String: [MediaResult]]

final class DashboardViewModel<Network : Fetchable> : ObservableObject, DashboardViewModelProtocol{
    
    init() {
        self.favoriteManager = FavoriteManager(withStorageType: .Plist)
        self.numberOfFavorites = self.favoriteManager.favorites.count
        
        updateFavorites()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateFavorites),
                                               name: .UpdateFavorites,
                                               object: nil)
        
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @Published public var searchTerm = ""
    
    @Published public private(set) var showOnlyFavorite = false

    @Published public private(set) var networkIsFetching : Bool = false
    
    @Published public private(set) var sortedData = SortedMediaInfo()
    
    @Published public private(set) var error: Error?
    
    private var network = Network()

    public private(set) var mediaKeys = [String]()

    public private(set) var numberOfFavorites : Int
    
    public private(set) var favoriteManager : Favorable
    
    public private(set) var apiReturn : APIReturn?{
        didSet{
            resetSortedData()
        }
    }
    
    public let filterResetKey = "Reset"
    
    public func search(){
        do{
            networkIsFetching = true
            try network.fetchFrom(endpoint: EndPoint.search,
                                  forTerm: searchTerm,
                                  completionHandler: { [weak self] result in
                                    DispatchQueue.main.async {
                                        self?.networkIsFetching = false
                                        
                                        switch result{
                                        case .success(let apiResults):
                                            self?.apiReturn = apiResults
                                        case .failure(let error):
                                            self?.error = error
                                        }
                                    }
                                  })
        }catch{
            print(error)
        }
    }
    
    public func filterMedia(forKey key : String){
        resetSortedData()
        if key != filterResetKey{
            var tmpData = SortedMediaInfo()
            tmpData[key] = sortedData[key]
            sortedData = tmpData
        }
    }
    
    public func toggleOnlyShowFavorites() {
        showOnlyFavorite = !showOnlyFavorite
        if showOnlyFavorite{
           sortFavoriteData()
        }else{
            resetSortedData()
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
        if let _apiReturn = apiReturn{
            sortedData = sort(data: _apiReturn.results)
            mediaKeys = sortedData.keys.sorted(by: <)
        }
    }
    
    private func sortFavoriteData(){
        sortedData = sort(data: self.favoriteManager.favorites)
        mediaKeys = sortedData.keys.sorted(by: <)
    }
    
    @objc private func updateFavorites(){
        self.numberOfFavorites = favoriteManager.favorites.count
        
        if showOnlyFavorite{
           sortFavoriteData()
        }
    }
}
