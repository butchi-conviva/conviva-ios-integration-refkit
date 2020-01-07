//
//  CVAContentInsightsRef.swift
//  ConvivaIntegrationRefKit
//
//  Created by Sandeep Madineni on 03/01/20.
//  Copyright © 2020 Butchi peddi. All rights reserved.
//

import Foundation

extension CVAAsset {
    func getCustomTagsForCI() -> [String: Any] {
        var customDictionary = [String: Any]()
        
        if self.islive {
            customDictionary[Conviva.Keys.Metadata.contentType] = "Live"
        }
        else {
            customDictionary[Conviva.Keys.Metadata.contentType] = "VOD"
        }

        customDictionary[Conviva.Keys.Metadata.channel] = Conviva.Values.Metadata.channel
        customDictionary[Conviva.Keys.Metadata.brand] = Conviva.Values.Metadata.brand
        customDictionary[Conviva.Keys.Metadata.affiliate] = Conviva.Values.Metadata.affiliate
        
        if let mediaType = self.mediaType, mediaType == "movie" {
            customDictionary[Conviva.Keys.Metadata.categoryType] = "Movies"
        }
        else if let mediaType = self.mediaType, mediaType == "tv" {
            customDictionary[Conviva.Keys.Metadata.categoryType] = "Episodic"
            customDictionary[Conviva.Keys.Metadata.seriesName] = Conviva.Values.Metadata.seriesName
            customDictionary[Conviva.Keys.Metadata.seasonNumber] = Conviva.Values.Metadata.seasonNumber
            customDictionary[Conviva.Keys.Metadata.showTitle] = Conviva.Values.Metadata.showTitle
            customDictionary[Conviva.Keys.Metadata.episodeNumber] = Conviva.Values.Metadata.episodeNumber
        }
        else {
            customDictionary[Conviva.Keys.Metadata.categoryType] = Conviva.Values.Metadata.categoryType
        }
               
        customDictionary[Conviva.Keys.Metadata.genre] = Conviva.Values.Metadata.genre
        customDictionary[Conviva.Keys.Metadata.genreList] = Conviva.Values.Metadata.genreList
       
        if let desc = self.desc {
            customDictionary[Conviva.Keys.Metadata.description] = desc
        }
        else {
            customDictionary[Conviva.Keys.Metadata.description] = Conviva.Values.Metadata.description
        }
        
        customDictionary[Conviva.Keys.Metadata.originalAirDate] = Conviva.Values.Metadata.originalAirDate
        
        if let thumbnail = self.thumbnail {
            customDictionary[Conviva.Keys.Metadata.imageURL_4x3] = thumbnail
        }
        else {
            customDictionary[Conviva.Keys.Metadata.imageURL_4x3] = Conviva.Values.Metadata.imageURL_4x3
        }
        
        if let backdropImage = self.backdropImage {
            customDictionary[Conviva.Keys.Metadata.imageURL_16x9] = backdropImage
        }
        else {
            customDictionary[Conviva.Keys.Metadata.imageURL_16x9] = Conviva.Values.Metadata.imageURL_16x9
        }

        customDictionary[Conviva.Keys.Metadata.castList] = Conviva.Values.Metadata.castList
        customDictionary[Conviva.Keys.Metadata.awardsList] = Conviva.Values.Metadata.awardsList
        
        customDictionary[Conviva.Keys.Metadata.marketingID] = Conviva.Values.Metadata.marketingID
        customDictionary[Conviva.Keys.Metadata.sourceType] = Conviva.Values.Metadata.sourceType
        customDictionary[Conviva.Keys.Metadata.sourceURL] = Conviva.Values.Metadata.sourceURL
        
        customDictionary[Conviva.Keys.Metadata.subscriptionType] = Conviva.Values.Metadata.subscriptionType
        customDictionary[Conviva.Keys.Metadata.subscriptionTier] = Conviva.Values.Metadata.subscriptionTier
        customDictionary[Conviva.Keys.Metadata.viewerClassification] = Conviva.Values.Metadata.viewerClassification
        customDictionary[Conviva.Keys.Metadata.acqusitionSource] = Conviva.Values.Metadata.acqusitionSource

        return customDictionary
    }
}
