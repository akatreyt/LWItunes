//
//  ResultCell.swift
//  LWItunes
//
//  Created by Gary Tartt on 2/16/21.
//

import SwiftUI


struct ResultCell: View {
    let mediaResult : MediaResult
    let favoriteManager : Favorable
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "arrow.up.message")
                    .frame(width:50, height:50)
                VStack(alignment: .leading){
                    Text("\(mediaResult.trackName ?? "N/A")")
                        .fontWeight(.medium)
                        .font(.title)
                    Text("\(mediaResult.primaryGenreName ?? "N/A")")
                        .fontWeight(.light)
                        .font(.body)
                }
                Spacer()
            }
            HStack{
                HStack(){
                    Button("Click here for Media", action: {
                        if let track = mediaResult.trackViewUrl{
                            open(link: track)
                        }
                    })
                    .buttonStyle(BorderlessButtonStyle())
                    .font(.body)
                    .foregroundColor(.blue)
                    
                    Spacer()
                    
                    Button(action: {
                        toggleFavorite(onMedia: mediaResult)
                    }) {
                        Image(systemName: "star.circle")
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            .padding([.leading, .trailing])
        }
    }
    
    private func open(link lk : String){
        if let link = URL(string: lk){
            UIApplication.shared.open(link)
        }
    }
    
    private func toggleFavorite(onMedia media : MediaResult){
        do{
            try favoriteManager.save(favorable: media)
            
            NotificationCenter.default.post(name: .UpdateFavorites, object: nil)
        }catch{
            fatalError()
        }
    }
}


struct ResultCell_Previews: PreviewProvider {
    static var previews: some View {
        let apiResults = MockNetwork().getMockData()
        let favoriteManager = FavoriteManager(withStorageType: .Plist)
        
        ResultCell(mediaResult: apiResults.results[0],
                   favoriteManager: favoriteManager)
        
        ResultCell(mediaResult: apiResults.results[0],
                   favoriteManager: favoriteManager).preferredColorScheme(.dark)
    }
}
