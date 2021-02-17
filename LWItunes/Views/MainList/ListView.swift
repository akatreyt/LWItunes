//
//  ListView.swift
//  LWItunes
//
//  Created by Gary Tartt on 2/16/21.
//

import SwiftUI

struct ListView: View {
    var viewModel : DashboardViewModelProtocol
    
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
                                ForEach(viewModel.sortedData[key]!) { result in
                                    ResultCell(mediaResult: result,
                                               favoriteManager: viewModel.favoriteManager)
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
        ListView(viewModel: viewModel)
        ListView(viewModel: viewModel).preferredColorScheme(.dark)
    }
}
