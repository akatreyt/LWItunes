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
                    
                    Divider()
                    
                    Button("Filter", action: {
                        toggleFilter()
                    }).disabled(viewModel.mediaKeys.isEmpty)
                    
                    Divider()
                    
                    Spacer()
                    
                    // If an error exist, show the no data view with the error
                    if let _error = viewModel.error{
                        NoDataView(error: _error)
                    // if we're showing only favorites we can ignore whether or not apiReturn is set
                    }else if viewModel.showOnlyFavorite{
                        ListView(viewModel: viewModel, mediaResults: viewModel.sortedData)
                    }else{
                        // if we have an apiReturn we either have results or no results
                        // if no results show the no data view with no error
                        if let _ = viewModel.apiReturn{
                            if viewModel.sortedData.count > 0{
                                ListView(viewModel: viewModel, mediaResults: viewModel.sortedData)
                            }else{
                                NoDataView()
                            }
                        }else{
                            // if there isn't an error, not showing favorites, no apiReturn show the search screen
                            SearchView()
                        }
                    }
                    Spacer()
                    HStack{
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
            // use the view model's media keys to create an action sheet that will
            // allow for filtering on the current data set.
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
    
    // show / hide the action sheet
    private func toggleFilter(){
        showFilter = !showFilter
    }
    
    // filter the data using the action sheet
    private func filterData(key : String){
        viewModel.filterMedia(forKey: key)
    }
    
    // toggle show favorites or other data set
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
