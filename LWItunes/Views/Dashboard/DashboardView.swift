//
//  DashboardView.swift
//  LWItunes
//
//  Created by Gary Tartt on 2/16/21.
//

import SwiftUI
import CoreData
import Combine

struct DashboardView<Network : Fetchable> : View {
    @ObservedObject var viewModel = DashboardViewModel<Network>()
    @State private var showFilter = false
    
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
                    
                    Button("Filter", action: {
                        toggleFilter()
                    }).disabled(viewModel.mediaKeys.isEmpty)
                    
                    Divider()
                    
                    Spacer()
                    
                    if let _error = viewModel.error{
                        NoDataView(error: _error)
                    }else if viewModel.showOnlyFavorite{
                        ListView(viewModel: viewModel, mediaResults: viewModel.sortedData)
                    }else{
                        if let _ = viewModel.apiReturn{
                            if viewModel.sortedData.count > 0{
                                ListView(viewModel: viewModel, mediaResults: viewModel.sortedData)
                            }else{
                                NoDataView()
                            }
                        }else{
                            SearchView()
                        }
                    }
                    Spacer()
                    HStack{
                        Text("\(viewModel.numberOfFavorites) Favorites")
                        Spacer()
                        Button(viewModel.showOnlyFavorite ? "Show all results" : "Show Favorites",
                               action: {
                                toggleFavoriteView()
                               })
                            .buttonStyle(BorderlessButtonStyle())
                            .font(.body)
                            .foregroundColor(.blue)
                    }
                    .padding()
                }
            }
        }.actionSheet(isPresented: $showFilter, content: {
            var buttons = [ActionSheet.Button]()
            
            for i in 0..<viewModel.mediaKeys.count {
                let button: ActionSheet.Button = .default(Text(viewModel.mediaKeys[i])) {
                    filterData(key: viewModel.mediaKeys[i])
                }
                buttons.append(button)
            }
            
            let button: ActionSheet.Button = .destructive(Text(viewModel.filterResetKey)) {
                filterData(key: viewModel.filterResetKey)
            }
            buttons.append(button)
            
            buttons.append(.cancel())
            
            return ActionSheet(title: Text("Choose a filter"),
                               message: Text("Filter the media list based on media kind"),
                               buttons: buttons)
        })
    }
    
    private func toggleFilter(){
        showFilter = !showFilter
    }
    
    private func filterData(key : String){
        viewModel.filterMedia(forKey: key)
    }
    
    private func toggleFavoriteView(){
        viewModel.toggleOnlyShowFavorites()
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView<MockNetwork>()
        
        DashboardView<MockNetwork>().preferredColorScheme(.dark)
    }
}
