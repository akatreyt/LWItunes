//
//  ListView.swift
//  LWItunes
//
//  Created by Gary Tartt on 2/16/21.
//

import SwiftUI

struct ListView: View {
    var mediaResults : SortedMediaInfo
    
    private var mediaKeys : [String]{
        get{
            Array(mediaResults.keys).sorted(by: <)
        }
    }
    
    var body: some View {
        VStack{
            List {
                ForEach(mediaKeys, id: \.self) { key in
                    Section(header: Text(key)
                                .font(.footnote),
                            content: {
                                ForEach(mediaResults[key]!) { result in
                                    ResultCell(mediaResult: result)
                                }
                            })
                }
            }
            Text("\(mediaResults.count) Results")
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var mockData : SortedMediaInfo {
        get{
            let viewModel = DashboardViewModel<MockNetwork>()
            viewModel.search()
            return viewModel.sortedData
        }
    }
    
    static var previews: some View {
        ListView(mediaResults: mockData)
        ListView(mediaResults: mockData).preferredColorScheme(.dark)
    }
}
