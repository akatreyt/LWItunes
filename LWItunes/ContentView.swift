//
//  ContentView.swift
//  LWItunes
//
//  Created by Gary Tartt on 2/16/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    private let fetch : Fetchable = MockEndPoint()
    fileprivate var apiReturn : APIReturn = try! MockEndPoint().fetchFrom(endpoint: EndPoint.search,
                                                                          forTerm: "test")
    
    var body: some View {
        List {
            ForEach(apiReturn.results) { item in
                Text("\(item.trackName)")
            }
            Text("\(apiReturn.resultCount) Results")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
