//
//  ImageCache.swift
//  LWItunes
//
//  Created by Gary Tartt on 2/17/21.
//

import UIKit
import Combine

final class ImageCache : ObservableObject{
    @Published var imageCache = [String : Data]()
    
    private var currentlyFetching =  [String]()
    
    final func hasImageData(forMedia media : MediaResult)->Data?{
        if let imageURL = media.artworkUrl100,
           let data = imageCache[imageURL]{
            return data
        }
        return nil
    }
    
    final func loadImage(forMedia media : MediaResult, completion comp :@escaping (Result<MediaResult, NetworkError>) -> Void){
        if let imageURLStr = media.artworkUrl100{
            if let _ = hasImageData(forMedia: media){
                comp(.success(media))
                return
            }
            
            guard let url = URL(string: imageURLStr) else {
                comp(.failure(.NoData))
                return
            }
            
            if currentlyFetching.contains(imageURLStr){
                return
            }
            
            #warning("this is causing a few UI issues, needs to be looked at more")
            DispatchQueue.main.async {
                self.currentlyFetching.append(imageURLStr)
            }

            let task = URLSession.shared.dataTask(with: url) {[weak self] (data, response, error) in
                
                if let idx = self?.currentlyFetching.firstIndex(of: imageURLStr){
                    self?.currentlyFetching.remove(at: idx)
                }
                
                guard let data = data else {
                    comp(.failure(.NoData))
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode != 200 {
                        comp(.failure(.InvalidHTTPCode(httpResponse.statusCode)))
                        return
                    }
                }else{
                    comp(.failure(.InvalidResponse))
                    return
                }
                
                if let _ = UIImage(data: data){
                    
                    #warning("this is causing a few UI issues, needs to be looked at more")
                    DispatchQueue.main.async {
                        self?.imageCache[imageURLStr] = data
                    }
                    
                    comp(.success(media))
                    return
                }
                comp(.failure(.ErrorDecodingImage))
            }
            
            task.resume()
        }
    }
}
