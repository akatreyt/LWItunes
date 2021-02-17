//
//  ListView.swift
//  LWItunes
//
//  Created by Gary Tartt on 2/16/21.
//

import SwiftUI

struct ListView: View {
    var apiReturn : APIReturn
    
    var body: some View {
        VStack{
            List {
                ForEach(apiReturn.results) { item in
                    Text("\(item.trackName)")
                }
            }
            Text("\(apiReturn.resultCount) Results")
        }
    }
}


struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        let results = try! MockEndPoint().fetchFrom(endpoint: EndPoint.search, forTerm: "test")
        ListView(apiReturn: results)
    }
}
