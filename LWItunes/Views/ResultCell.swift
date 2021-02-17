//
//  ResultCell.swift
//  LWItunes
//
//  Created by Gary Tartt on 2/16/21.
//

import SwiftUI


struct ResultCell: View {
    let result : Result
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "arrow.up.message")
                    .frame(width:50, height:50)
                VStack(alignment: .leading){
                    Text("\(result.trackName)")
                        .fontWeight(.medium)
                        .font(.title)
                    Text("\(result.primaryGenreName)")
                        .fontWeight(.light)
                        .font(.body)
                }
                Spacer()
            }
            HStack{
                Button("Click here for Media", action: {
                    open(link: result.trackViewUrl)
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
        let results = try! MockEndPoint().fetchFrom(endpoint: EndPoint.search, forTerm: "test")
        
        ResultCell(result: results.results[0])
        
        ResultCell(result: results.results[0]).preferredColorScheme(.dark)
    }
}
