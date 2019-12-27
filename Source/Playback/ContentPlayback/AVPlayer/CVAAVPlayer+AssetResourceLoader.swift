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
            self.didFailedAssetLoading(domain: PlayerError.Encrypted_Key_URL_Error.domain, code: PlayerError.Encrypted_Key_URL_Error.code, userInfo: nil, loadingRequest: loadingRequest)
            return false // e.g. hls.conviva.error
        }
        
        print(#function, contentKeyUrl)
        
        var contentKeyUrlString = contentKeyUrl.absoluteString;
        guard true == contentKeyUrlString.contains("ckm://"), !contentKeyUrlString.isEmpty else {
            print(#function, "Unable to read the url/host data.")
            self.didFailedAssetLoading(domain: PlayerError.Encrypted_Key_URL_Error.domain, code: PlayerError.Encrypted_Key_URL_Error.code, userInfo: nil, loadingRequest: loadingRequest)
            return false // e.g. hls.conviva.error
        }
        
        /// Replace conviva.ckm:// with server url
        contentKeyUrlString = contentKeyUrlString.replacingOccurrences(of: "ckm://", with: "http://")

        if let serverContentKeyUrl = URL(string: contentKeyUrlString) {
            
            var request = URLRequest(url: serverContentKeyUrl)
            request.httpMethod = "GET"
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task = session.dataTask(with: request) { data, response, error in
                if let httpResponse = response as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    switch statusCode {
                    case 200..<300:
                        if let data = data {
                            loadingRequest.dataRequest?.respond(with: data)
                            loadingRequest.finishLoading()
                            self.playerEventManager.didFinishEncryptedAssetLoading(player: self.avPlayer as Any, assetInfo: self.asset)
                        } else {    //  Data not available
                            print(#function, "Unable to fetch the key.")
                            self.didFailedAssetLoading(domain: PlayerError.Encrypted_Key_Error.domain, code: PlayerError.Encrypted_Key_Error.code, userInfo: nil, loadingRequest: loadingRequest)
                        }
                    default:    //  Response code other than 200...300
                        print(#function, "Unable to fetch the key.")
                        self.didFailedAssetLoading(domain: PlayerError.Encrypted_Key_Error.domain, code: statusCode, userInfo: nil, loadingRequest: loadingRequest)
                    }
                }
                else {  //  No Response
                    print(#function, "Unable to fetch the key.")
                    self.didFailedAssetLoading(domain: PlayerError.Encrypted_Key_Error.domain, code: PlayerError.Encrypted_Key_Error.code, userInfo: nil, loadingRequest: loadingRequest)
                }
            }
            task.resume()
        }
        else {  //  Key URL not available
            print(#function, "Unable to fetch the key.")
            self.didFailedAssetLoading(domain: PlayerError.Encrypted_Key_URL_Error.domain, code: PlayerError.Encrypted_Key_URL_Error.code, userInfo: nil, loadingRequest: loadingRequest)
        }
        return true
    }
    
    func didFailedAssetLoading(domain: String, code: Int, userInfo dict: [String : Any]? = nil, loadingRequest: AVAssetResourceLoadingRequest) {
        let error = NSError(domain: domain, code: code, userInfo: dict)
        loadingRequest.finishLoading(with: error)
        self.playerEventManager.didFailPlayback(player: self.avPlayer as Any, error: error)
    }
}
