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
        guard let url = loadingRequest.request.url else {
            print(#function, "Unable to read the url/host data.")
            loadingRequest.finishLoading(with: NSError(domain: "url_error", code: -1, userInfo: nil))
            return false // e.g. hls.conviva.error
        }
        print(#function, url)
        
        /// If the url is correctly found we try to load the certificate date.
        /// For this example the certificate resides inside the bundle. Preferably, it should be fetched from the server.
        guard
            let certificateURL = Bundle.main.url(forResource: "certificate", withExtension: "der"),
            let certificateData = try? Data(contentsOf: certificateURL) else {
                print(#function, "Unable to read the certificate data.")
                loadingRequest.finishLoading(with: NSError(domain: "cert_error", code: -2, userInfo: nil)) // e.g. hls.conviva.error
                return false
        }
        
        /// Request the Server Playback Context.
        let contentId = "content_id" // e.g. hls.conviva.com
        guard
            let contentIdData = contentId.data(using: String.Encoding.utf8),
            let spcData = try? loadingRequest.streamingContentKeyRequestData(forApp: certificateData, contentIdentifier: contentIdData, options: nil),
            let dataRequest = loadingRequest.dataRequest else {
                loadingRequest.finishLoading(with: NSError(domain: "content_error", code: -3, userInfo: nil)) // e.g. hls.conviva.error
                print(#function, "Unable to read the SPC data.")
                return false
        }
        
        /// Request the Content Key Context from the Key Server Module.
        let ckcURL = URL(string: "ckc_url")! // https://hls.conviva.com/ckc
        var request = URLRequest(url: ckcURL)
        request.httpMethod = "POST"
        request.httpBody = spcData
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request) { data, response, error in
            if let data = data {
                // The CKC is correctly returned and is now send to the `AVPlayer` instance so we
                // can continue to play the stream.
                dataRequest.respond(with: data)
                loadingRequest.finishLoading()
            } else {
                print(#function, "Unable to fetch the CKC.")
                loadingRequest.finishLoading(with: NSError(domain: "ckc_error", code: -4, userInfo: nil)) // e.g. hls.conviva.error
            }
        }
        task.resume()
        return true
    }
}
