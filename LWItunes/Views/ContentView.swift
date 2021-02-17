//
//  ContentView.swift
//  LWItunes
//
//  Created by Gary Tartt on 2/16/21.
//

import SwiftUI
import CoreData
import Combine

struct ContentView <Network : Fetchable> : View {
    @ObservedObject var viewModel = ContentViewModel<Network>()
    
    var body: some View {
        ZStack{
            if viewModel.networkIsFetching{
                LoadingView()
            }
            else{
                VStack{
                    HStack{
                        TextField("Search", text: $viewModel.searchTerm)
                            
                        Button("Search", action: {
                            viewModel.search()
                        })
                    }.padding()
                    
                    Divider()
                    
                    Spacer()
                    
                    if let returnData = viewModel.returnData{
                        if returnData.count > 0{
                            ListView(mediaResults: returnData)
                        }else{
                            NoDataView()
                        }
                    }else{
                        SearchView()
                    }
                    Spacer()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView<MockNetwork>()
        
        ContentView<MockNetwork>().preferredColorScheme(.dark)
    }
}
