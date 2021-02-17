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
    @State var network = Network()
    
    // when view is init will be nil, and will show the search screen
    @State fileprivate var apiReturn : APIReturn?
    
    @State private var searchTerm = ""
    
    var body: some View {
        ZStack{
            if network.isFetching{
                LoadingView()
            }
            else{
                VStack{
                    HStack{
                        TextField("Search", text: $searchTerm)
                            
                        Button("Search", action: {
                            search(forTerm: searchTerm)
                        })
                    }.padding()
                    
                    Divider()
                    
                    Spacer()
                    
                    if let _apiReturn = apiReturn{
                        if _apiReturn.resultCount > 0{
                            ListView(apiReturn: _apiReturn)
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
    
    private func search(forTerm term : String){
        do{
            apiReturn = try network.fetchFrom(endpoint: EndPoint.search,
                                           forTerm: term)
        }catch{
            print(error)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView<MockEndPoint>()
    }
}
