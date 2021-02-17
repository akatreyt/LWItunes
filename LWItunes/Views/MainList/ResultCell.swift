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
    @ObservedObject var imageCache : ImageCache
    
    @State var mediaIsFavorite : Bool = false
    
    var body: some View {
        VStack{
            HStack{
                if let data = checkForDataFetchIfNotFound(media: mediaResult),
                   let image = UIImage(data: data){
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                    
                }else{
                    ProgressView()
                        .padding()
                }
                
                
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
                            .foregroundColor(mediaIsFavorite ? .yellow : .blue)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            .padding([.leading, .trailing])
        }.onAppear{
            mediaIsFavorite = favoriteManager.checkIfFavorites(media: mediaResult)
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
            mediaIsFavorite = favoriteManager.checkIfFavorites(media: mediaResult)
        }catch{
            fatalError()
        }
    }
    
    private func checkForDataFetchIfNotFound(media : MediaResult) -> Data?{
        if let data = imageCache.hasImageData(forMedia: mediaResult){
            return data
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            fetchImageFor(media: media)
        }
    
        return nil
    }
    
    private func fetchImageFor(media : MediaResult){
        imageCache.loadImage(forMedia: media, completion: { result in
            switch result{
            case .success(_):
                break
            case .failure(let error):
                print(error)
            }
        })
    }
}


struct ResultCell_Previews: PreviewProvider {
    static var previews: some View {
        let apiResults = MockNetwork().getMockData()
        let favoriteManager = FavoriteManager(withStorageType: .Plist)
        let imageCache = ImageCache()
        
        ResultCell(mediaResult: apiResults.results[0],
                   favoriteManager: favoriteManager,
                   imageCache: imageCache)
        
        ResultCell(mediaResult: apiResults.results[0],
                   favoriteManager: favoriteManager,
                   imageCache: imageCache).preferredColorScheme(.dark)
    }
}
