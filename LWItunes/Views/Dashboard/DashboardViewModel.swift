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
        // initalize the favorite manager with a specific StorageType
        // from Favorable.swift
        self.favoriteManager = FavoriteManager(withStorageType: .Plist)
        self.numberOfFavorites = self.favoriteManager.favorites.count
        
        updateFavorites()

        // this notificaiton is used when the user taps to add / remove
        // a favorite media result. It updates numberOfFavorites
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateFavorites),
                                               name: .UpdateFavorites,
                                               object: nil)
        
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @Published public var searchTerm = ""
    
    ///
    /// This is a toggle that is set when the user taps
    /// on show favorites on the DashboardView
    ///
    @Published public private(set) var showOnlyFavorite = false

    ///
    /// This is allows DashboardView to know when there is a network
    /// request happening
    ///
    @Published public private(set) var networkIsFetching : Bool = false
    
    ///
    /// This is used to store sorted data from
    /// apiReturn.results
    ///
    /// The keys are the results kind [String], and the value is an array
    /// of all items of the kind [MediaResult]
    ///
    @Published public private(set) var sortedData = SortedMediaInfo()
    
    ///
    /// This error is passed through the networkManger
    /// to show on the DashboardView if there is an error
    ///
    @Published public private(set) var error: Error?
    
    ///
    /// This is allows for fetching of data. It is set in
    /// LWItunesApp.swift
    ///
    /// DashboardView<Network>()
    ///
    private var netorkManager = Network()

    ///
    /// This is all the keys from the sortedData. This is used
    /// on DashboardView to pouplate the action sheet filter.
    /// Will only populate with keys that we have items for
    ///
    public private(set) var mediaKeys = [String]()

    ///
    /// This is used to to show the number of favorites on the
    /// home screen. (Currently not is use)
    ///
    public private(set) var numberOfFavorites : Int
    
    ///
    /// This is used to give access to the user's favorites
    ///
    public private(set) var favoriteManager : Favorable
    
    ///
    /// This is the variable stores the results from a network request
    /// It'll will be nil first run, and is used in DashboardView to
    /// know when to show the search screen.
    ///
    public private(set) var apiReturn : APIReturn?{
        didSet{
            resetSortedData()
        }
    }
    
    ///
    /// This is the key that is used on the main screen to reset the
    /// filter back to all results in sortedData. Both the DashboardView and
    /// DashboardViewModel use this to as a specifier
    ///
    public let filterResetKey = "Reset"
    
    ///
    /// This function initiates a search based on the passed in
    /// <Network : Fetchable> init
    ///
    public func search(){
        do{
            networkIsFetching = true
            try netorkManager.fetchFrom(endpoint: EndPoint.search,
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
    
    /// This function filters the current SortedMediaInfo,
    /// thats stored in sortedData, to show items that belong
    /// to a specific key
    ///
    /// Usage:
    ///
    /// - Parameter key : String: The kind the user wants to see
    ///
    /// - Returns: void
    public func filterMedia(forKey key : String){
        resetSortedData()
        if key != filterResetKey{
            var tmpData = SortedMediaInfo()
            tmpData[key] = sortedData[key]
            sortedData = tmpData
        }
    }
    
    ///
    /// This function is the public interfacing bool to view
    /// only favorites on the main screen
    ///
    public func toggleOnlyShowFavorites() {
        showOnlyFavorite = !showOnlyFavorite
        if showOnlyFavorite{
           sortFavoriteData()
        }else{
            resetSortedData()
        }
    }
    
    /// This function returns a SortedMediaInfo from a given data set
    ///
    /// Usage:
    ///
    /// - Parameter [MediaResult]: The media results to be sorted
    ///
    /// - Returns: SortedMediaInfo
    private func sort(data : [MediaResult]) -> SortedMediaInfo{
        var tmpSortedData =  [String : [MediaResult]]()
        
        for result in data{
            let kind = result.kind
            (tmpSortedData[kind.uppercased(), default: []]).append(result)
        }
        
        return tmpSortedData
    }
    
    ///
    /// This function sort fetched data into SortedMediaInfo
    ///
    private func resetSortedData(){
        if let _apiReturn = apiReturn{
            sortedData = sort(data: _apiReturn.results)
            mediaKeys = sortedData.keys.sorted(by: <)
        }
    }
    
    ///
    /// This function sort favorites into SortedMediaInfo
    ///
    private func sortFavoriteData(){
        sortedData = sort(data: self.favoriteManager.favorites)
        mediaKeys = sortedData.keys.sorted(by: <)
    }
    
    ///
    /// This function updates the public number of favorites and will
    /// re-initalize the data set if we're currently viewing the favorites
    ///
    @objc private func updateFavorites(){
        self.numberOfFavorites = favoriteManager.favorites.count
        
        if showOnlyFavorite{
           sortFavoriteData()
        }
    }
}
