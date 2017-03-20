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
    let skipButton = FaceStarterButton(type: .blueButton)
    let spacerView2 = UIView()
    
    let faceIterator = FaceIterator()
    var faces = [UIImage]()
    
    var currentEmbedding: [NSNumber]?
    var currentAsset: String? {
        didSet {
            if let oldValue = oldValue, currentAsset != oldValue {
                LocalStorage.markPhotoAsTagged(uuid: oldValue)
            }
        }
    }
    
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
        
        setButtonsEnabled(false)
        
        suggestedButton.title = "Suggestion: None"
        view.addSubviewForAutolayout(suggestedButton)
        suggestedButton.leadingAnchor.activateConstraint(equalTo: view.leadingAnchor, constant: padding)
        suggestedButton.trailingAnchor.activateConstraint(equalTo: view.trailingAnchor, constant: -padding)
        suggestedButton.topAnchor.activateConstraint(equalTo: spacerView1.bottomAnchor)
        
        otherButton.title = "Select Other Friend"
        otherButton.addTarget(self, action: #selector(presentSelectFriendController), for: .touchUpInside)
        view.addSubviewForAutolayout(otherButton)
        otherButton.leadingAnchor.activateConstraint(equalTo: view.leadingAnchor, constant: padding)
        otherButton.trailingAnchor.activateConstraint(equalTo: view.trailingAnchor, constant: -padding)
        otherButton.topAnchor.activateConstraint(equalTo: suggestedButton.bottomAnchor, constant: padding)
        
        skipButton.title = "Skip For Now"
        skipButton.addTarget(self, action: #selector(nextFace), for: .touchUpInside)
        view.addSubviewForAutolayout(skipButton)
        skipButton.leadingAnchor.activateConstraint(equalTo: view.leadingAnchor, constant: padding)
        skipButton.trailingAnchor.activateConstraint(equalTo: view.trailingAnchor, constant: -padding)
        skipButton.topAnchor.activateConstraint(equalTo: otherButton.bottomAnchor, constant: padding)
        
        view.addSubviewForAutolayout(spacerView2)
        spacerView2.leadingAnchor.activateConstraint(equalTo: view.leadingAnchor)
        spacerView2.trailingAnchor.activateConstraint(equalTo: view.trailingAnchor)
        spacerView2.topAnchor.activateConstraint(equalTo: skipButton.bottomAnchor)
        spacerView2.bottomAnchor.activateConstraint(equalTo: view.bottomAnchor)
        spacerView2.heightAnchor.activateConstraint(equalTo: spacerView1.heightAnchor)
    }
    
    func setButtonsEnabled(_ enabled: Bool) {
        suggestedButton.isEnabled = enabled
        otherButton.isEnabled = enabled
        skipButton.isEnabled = enabled
    }
    
    func presentSelectFriendController() {
        let selectFriendController = SelectFriendViewController { friend in
            self.dismiss(animated: true)
            if let friend = friend {
                self.tagImageAs(friend: friend)
            }
        }
        present(UINavigationController(rootViewController: selectFriendController), animated: true)
    }
    
    func tagImageAs(friend: String) {
        guard let currentEmbedding = currentEmbedding else { return }
        LocalStorage.addEmbedding(embedding: currentEmbedding, forFriend: friend)
        nextFace()
    }
    
    func nextFace() {
        if faces.count > 0 {
            let nextFace = faces.removeFirst()
            imageView.image = nextFace
            getEmbedding(faceImage: nextFace)
        } else {
            faceIterator.nextFaces{ faces, localIdentifier in
                if let faces = faces {
                    self.currentAsset = localIdentifier
                    self.faces = faces
                    self.nextFace()
                } else {
                    print("WE ARE DONE")
                }
            }
        }
    }
    
    func getEmbedding(faceImage: UIImage) {
        guard let data = UIImageJPEGRepresentation(faceImage, 0.9) else { return }
        setButtonsEnabled(false)
        client?.recognizeJpegs([data], completion: { (results, error) in
            if let embedding = results?.first?.embed {
                self.currentEmbedding = embedding
                self.setButtonsEnabled(true)
            } else {
                self.nextFace()
            }
        })
    }
}
