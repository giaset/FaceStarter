//
//  PermissionsViewController.swift
//  FaceStarter
//
//  Created by Gianni Settino on 2017-03-19.
//  Copyright © 2017 Jack Rogers. All rights reserved.
//

import UIKit

class PermissionsViewController: UIViewController {
    
    let client = ClarifaiClient(appID: "Au7oy8WFvhMXGVFWvpZmrOcKg6sKUIHH4asWAfXa", appSecret: "luabv1TNQn0gXMaTkfz20ho4_AjOF7Wp3xNkQ8Ye")
    let faceDetector = FaceDetector()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        client?.enableFaceModel = true
        client?.enableEmbed = true
        
        let lorne = UIImage(named: "geth.jpg")!
        let faceBounds = (faceDetector.faces(from: lorne) as? [NSValue] ?? []).map{ $0.cgRectValue }
        let faceJpegs = faceBounds.flatMap{ (faceBound: CGRect) -> Data? in
            let faceImage = faceDetector.faceImage(from: lorne, faceBounds: faceBound)!
            return UIImageJPEGRepresentation(faceImage, 0.9)
        }
        
        client?.recognizeJpegs(faceJpegs, completion: { (results, error) in
            print("embedding: \(results!.first!.embed!)")
        })
    }
}
