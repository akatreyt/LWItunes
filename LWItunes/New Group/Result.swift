//
//  Result.swift
//  LWItunes
//
//  Created by Gary Tartt on 2/16/21.
//

import Foundation


struct Result : Decodable, Identifiable{
    let id = UUID()

    let wrapperType : String
    let kind : String
    let artistId : Int
    let collectionId : Int
    let trackId : Int
    let artistName : String
    let collectionName : String
    let trackName : String
    let collectionCensoredName : String
    let trackCensoredName : String
    let artistViewUrl : String
    let collectionViewUrl : String
    let trackViewUrl : String
    let previewUrl : String
    let artworkUrl30 : String
    let artworkUrl60 : String
    let artworkUrl100 : String
    let collectionPrice : Float
    let trackPrice : Float
    let releaseDate : String
    let collectionExplicitness : String
    let trackExplicitness : String
    let discCount : Int
    let discNumber : Int
    let trackCount : Int
    let  trackNumber : Int
    let trackTimeMillis : Int
    let country : String
    let currency : String
    let primaryGenreName : String
    let isStreamable : Bool
}


extension Result : Favorable{
    func toggleFarovite<S>(usingStorable storable: S) throws where S : Storable {
        try S.save(favorable: self)
    }
}
