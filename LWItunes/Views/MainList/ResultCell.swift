//
//  ResultCell.swift
//  LWItunes
//
//  Created by Gary Tartt on 2/16/21.
//

import SwiftUI


struct ResultCell: View {
    let mediaResult : MediaResult
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "arrow.up.message")
                    .frame(width:50, height:50)
                VStack(alignment: .leading){
                    Text("\(mediaResult.trackName)")
                        .fontWeight(.medium)
                        .font(.title)
                    Text("\(mediaResult.primaryGenreName)")
                        .fontWeight(.light)
                        .font(.body)
                }
                Spacer()
            }
            HStack{
                Button("Click here for Media", action: {
                    open(link: mediaResult.trackViewUrl)
                })
                .font(.body)
                .foregroundColor(.blue)
            }
            .padding([.leading, .trailing])
        }
    }
    
    private func open(link lk : String){
        if let link = URL(string: lk){
            UIApplication.shared.open(link)
        }
    }
}


struct ResultCell_Previews: PreviewProvider {
    static var previews: some View {
        let apiResults = MockNetwork().getMockData()
        
        ResultCell(mediaResult: apiResults.results[0])
        
        ResultCell(mediaResult: apiResults.results[0]).preferredColorScheme(.dark)
    }
}
