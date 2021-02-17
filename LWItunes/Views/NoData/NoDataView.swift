//
//  NoDataView.swift
//  LWItunes
//
//  Created by Gary Tartt on 2/16/21.
//

import SwiftUI

struct NoDataView : View {
    var error : Error?
    
    var body: some View {
        VStack{
            Text("No Data")
                .fontWeight(.bold)
                .font(.title)
            if let _error = error{
                Text(_error.localizedDescription)
                    .fontWeight(.bold)
                    .font(.title)
            }
        }
    }
}

struct NoDataView_Previews: PreviewProvider {
    static var previews: some View {
        NoDataView()
        
        NoDataView().preferredColorScheme(.dark)
    }
}
