//
//  DashboardViewModelProtocol.swift
//  LWItunes
//
//  Created by Gary Tartt on 2/17/21.
//

import Foundation

protocol DashboardViewModelProtocol {
    var numberOfFavorites : Int { get }
    var favoriteManager : Favorable { get }
    var apiReturn : APIReturn? { get }
    var mediaKeys : [String] { get }
    var sortedData : SortedMediaInfo { get }
    var filterResetKey : String { get }
    var networkIsFetching : Bool { get }
    func search()
    func filterMedia(forKey key : String)
}
