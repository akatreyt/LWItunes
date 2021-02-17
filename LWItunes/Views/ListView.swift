//
//  ListView.swift
//  LWItunes
//
//  Created by Gary Tartt on 2/16/21.
//

import SwiftUI

struct ListView: View {
    var mediaResults : [MediaResult]
    
    var body: some View {
        VStack{
            List {
                ForEach(mediaResults) { result in
                    ResultCell(mediaResult: result)
                }
            }
            Text("\(mediaResults.count) Results")
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        let results = MockNetwork().getMockData()
        
        ListView(mediaResults: results.results)

        ListView(mediaResults: results.results).preferredColorScheme(.dark)
    }
}
