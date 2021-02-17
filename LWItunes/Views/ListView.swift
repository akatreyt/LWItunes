//
//  ListView.swift
//  LWItunes
//
//  Created by Gary Tartt on 2/16/21.
//

import SwiftUI

struct ListView: View {
    var results : [Result]
    
    var body: some View {
        VStack{
            List {
                ForEach(results) { result in
                    ResultCell(result: result)
                }
            }
            Text("\(results.count) Results")
        }
    }
}


struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        let results = try! MockEndPoint().fetchFrom(endpoint: EndPoint.search, forTerm: "test")
        ListView(results: results.results)
        
        ListView(results: results.results).preferredColorScheme(.dark)
    }
}
