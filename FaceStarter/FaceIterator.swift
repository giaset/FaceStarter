//
//  FaceIterator.swift
//  FaceStarter
//
//  Created by Gianni Settino on 2017-03-19.
//  Copyright © 2017 Jack Rogers. All rights reserved.
//

import Foundation
import Photos

class FaceIterator {
    
    var assets: PHFetchResult<PHAsset>?
    private var currentIndex = 0
    
    private let faceDetector = FaceDetector()
    
    func nextFaces(_ completion: @escaping (([UIImage]?, String?) -> Void)) {
        guard let assets = assets, currentIndex < assets.count else {
            completion(nil, nil)
            return
        }
        
        let asset = assets[currentIndex]
        currentIndex += 1
        
        if LocalStorage.taggedIdentifiers()[asset.localIdentifier] == true {
            nextFaces(completion)
            return
        }
        
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: options) { (image, info) in
            guard let image = image else {
                self.nextFaces(completion)
                return
            }
            
            let faceBounds = (self.faceDetector.faces(from: image) as? [NSValue] ?? []).map{ $0.cgRectValue }
            if faceBounds.count > 0 {
                let faceImages = faceBounds.flatMap{
                    self.faceDetector.faceImage(from: image, faceBounds: $0)
                }
                completion(faceImages, asset.localIdentifier)
            } else {
                self.nextFaces(completion)
            }
        }
    }
}
