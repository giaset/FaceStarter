//
//  MainViewController.swift
//  FaceStarter
//
//  Created by Gianni Settino on 2017-03-19.
//  Copyright © 2017 Jack Rogers. All rights reserved.
//

import Photos
import UIKit

class MainViewController: UIViewController {
    
    let client = ClarifaiClient(appID: "Au7oy8WFvhMXGVFWvpZmrOcKg6sKUIHH4asWAfXa", appSecret: "luabv1TNQn0gXMaTkfz20ho4_AjOF7Wp3xNkQ8Ye")
    
    let imageView = UIImageView()
    
    let spacerView1 = UIView()
    let suggestedButton = FaceStarterButton(type: .greenButton)
    let otherButton = FaceStarterButton(type: .defaultButton)
    let spacerView2 = UIView()
    
    let faceIterator = FaceIterator()
    var faces = [UIImage]()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        client?.enableFaceModel = true
        client?.enableEmbed = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews()
        
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined, .authorized:
            faceIterator.assets = PHAsset.fetchAssets(with: .image, options: nil)
            nextFace()
        default:
            print("Must give photo access")
        }
    }
    
    func setupSubviews() {
        let padding: CGFloat = 10
        
        view.addSubviewForAutolayout(imageView)
        imageView.leadingAnchor.activateConstraint(equalTo: view.leadingAnchor)
        imageView.trailingAnchor.activateConstraint(equalTo: view.trailingAnchor)
        imageView.topAnchor.activateConstraint(equalTo: view.topAnchor, constant: 20)
        imageView.heightAnchor.activateConstraint(equalTo: imageView.widthAnchor)
        
        view.addSubviewForAutolayout(spacerView1)
        spacerView1.leadingAnchor.activateConstraint(equalTo: view.leadingAnchor)
        spacerView1.trailingAnchor.activateConstraint(equalTo: view.trailingAnchor)
        spacerView1.topAnchor.activateConstraint(equalTo: imageView.bottomAnchor)
        
        suggestedButton.title = "Suggestion: None"
        view.addSubviewForAutolayout(suggestedButton)
        suggestedButton.leadingAnchor.activateConstraint(equalTo: view.leadingAnchor, constant: padding)
        suggestedButton.trailingAnchor.activateConstraint(equalTo: view.trailingAnchor, constant: -padding)
        suggestedButton.topAnchor.activateConstraint(equalTo: spacerView1.bottomAnchor)
        
        otherButton.title = "+ Other Friend"
        view.addSubviewForAutolayout(otherButton)
        otherButton.leadingAnchor.activateConstraint(equalTo: view.leadingAnchor, constant: padding)
        otherButton.trailingAnchor.activateConstraint(equalTo: view.trailingAnchor, constant: -padding)
        otherButton.topAnchor.activateConstraint(equalTo: suggestedButton.bottomAnchor, constant: padding)
        
        view.addSubviewForAutolayout(spacerView2)
        spacerView2.leadingAnchor.activateConstraint(equalTo: view.leadingAnchor)
        spacerView2.trailingAnchor.activateConstraint(equalTo: view.trailingAnchor)
        spacerView2.topAnchor.activateConstraint(equalTo: otherButton.bottomAnchor)
        spacerView2.bottomAnchor.activateConstraint(equalTo: view.bottomAnchor)
        spacerView2.heightAnchor.activateConstraint(equalTo: spacerView1.heightAnchor)
    }
    
    func nextFace() {
        if faces.count > 0 {
            let nextFace = faces.removeFirst()
            imageView.image = nextFace
            //printEmbedding(faceImage: nextFace)
        } else {
            faceIterator.nextFaces{ faces in
                if let faces = faces {
                    self.faces = faces
                    self.nextFace()
                } else {
                    print("WE ARE DONE")
                }
            }
        }
    }
    
    func printEmbedding(faceImage: UIImage) {
        guard let data = UIImageJPEGRepresentation(faceImage, 0.9) else { return }
        client?.recognizeJpegs([data], completion: { (results, error) in
            let embedding = results!.first!.embed!
            print("embedding: \(embedding)")
        })
    }
}
