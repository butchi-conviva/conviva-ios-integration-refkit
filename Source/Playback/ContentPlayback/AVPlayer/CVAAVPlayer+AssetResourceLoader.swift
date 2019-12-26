//
//  CVAAVPlayer+AssetResourceLoader.swift
//  ConvivaIntegrationRefKit
//
//  Created by Gaurav Tiwari on 07/11/19.
//  Copyright © 2019 Butchi peddi. All rights reserved.
//

import Foundation
import AVFoundation

/// An extension of class CVAAVPlayer which is used to conform to AVAssetResourceLoaderDelegate which will capture the use cases like playing encrypted content using DRMs.
/// The AVAssetResourceLoader's delegate methods allow us to handle resource loading requests.
/// This will be useful to capture scenarios like DRM and processing/parsing m3u8 files.

extension CVAAVPlayer : AVAssetResourceLoaderDelegate {
    public func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        
        /// First check if a url is set in the manifest.
        guard let contentKeyUrl = loadingRequest.request.url else {
            print(#function, "Unable to read the url/host data.")
            loadingRequest.finishLoading(with: NSError(domain: "url_error", code: -1, userInfo: nil))
            return false // e.g. hls.conviva.error
        }
        
        print(#function, contentKeyUrl)
        
        var contentKeyUrlString = contentKeyUrl.absoluteString;
        guard true == contentKeyUrlString.contains("ckm://") else {
            
            print(#function, "Unable to read the url/host data.")
            loadingRequest.finishLoading(with: NSError(domain: "url_error", code: -1, userInfo: nil))
            return false // e.g. hls.conviva.error
        }
        
        /// Replace conviva.ckm:// with server url
        contentKeyUrlString = contentKeyUrlString.replacingOccurrences(of: "ckm://", with: "http://")

        if let serverContentKeyUrl = URL(string: contentKeyUrlString) {
            
            var request = URLRequest(url: serverContentKeyUrl)
            request.httpMethod = "GET"
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task = session.dataTask(with: request) { data, response, error in
            if let data = data {
                loadingRequest.dataRequest?.respond(with: data)
                loadingRequest.finishLoading()
            } else {
                print(#function, "Unable to fetch the key.")
                loadingRequest.finishLoading(with: NSError(domain: "content_key_error", code: -4, userInfo: nil)) // e.g. hls.conviva.error
            }
            }
            task.resume()
        }
        else {
            print(#function, "Unable to fetch the key.")
            loadingRequest.finishLoading(with: NSError(domain: "url_error", code: -1, userInfo: nil)) // e.g. hls.conviva.error
        }
        return true
    }
}
