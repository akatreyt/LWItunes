//
//  ListView.swift
//  LWItunes
//
//  Created by Gary Tartt on 2/16/21.
//

import SwiftUI

struct ListView: View {
    var viewModel : DashboardViewModelProtocol
    var mediaResults : SortedMediaInfo
    var imageCache = ImageCache()
    
    private var mediaKeys : [String]{
        get{
            Array(viewModel.sortedData.keys).sorted(by: <)
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
                                    ResultCell(mediaResult: result,
                                               favoriteManager: viewModel.favoriteManager,
                                               imageCache: imageCache)
                                }
                            })
                }
            }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var viewModel : DashboardViewModel<MockNetwork> {
        get{
            let viewModel = DashboardViewModel<MockNetwork>()
            viewModel.search()
            return viewModel
        }
    }
    
    static var previews: some View {
        ListView(viewModel: viewModel, mediaResults: viewModel.sortedData)
        ListView(viewModel: viewModel, mediaResults: viewModel.sortedData).preferredColorScheme(.dark)
    }
}
