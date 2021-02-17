//
//  SearchView.swift
//  LWItunes
//
//  Created by Gary Tartt on 2/16/21.
//

import SwiftUI

struct SearchView : View {
    var body: some View {
        VStack{
            Text("Search")
                .fontWeight(.bold)
                .font(.title)
        }
    }
}


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
        
        SearchView().preferredColorScheme(.dark)
    }
}
