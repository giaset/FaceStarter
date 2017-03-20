//
//  FaceStarterButton.swift
//  FaceStarter
//
//  Created by Gianni Settino on 2017-03-19.
//  Copyright © 2017 Jack Rogers. All rights reserved.
//

import UIKit

enum FaceStarterButtonType {
    case defaultButton, greenButton
    
    func normalColor() -> UIColor {
        switch self {
        case .greenButton:
            return UIColor(hexString: "08A045")
        default:
            return UIColor(hexString: "B2B2B2")
        }
    }
    
    func highlightedColor() -> UIColor {
        switch self {
        case .greenButton:
            return UIColor(hexString: "033F1B")
        default:
            return UIColor(hexString: "3F3F3F")
        }
    }
}

class FaceStarterButton: UIButton {
    
    let type: FaceStarterButtonType
    
    var title: String? {
        didSet {
            setTitle(title, for: .normal)
        }
    }
    
    init(type: FaceStarterButtonType) {
        self.type = type
        super.init(frame: .zero)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        layer.cornerRadius = 4
        setTitleColor(UIColor(white: 0, alpha: 0.3), for: .disabled)
        refreshColors()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: 66)
    }
    
    override var isHighlighted: Bool {
        didSet {
            refreshColors()
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            refreshColors()
        }
    }
    
    func refreshColors() {
        if !isEnabled {
            backgroundColor = .white
        } else {
            backgroundColor = isHighlighted ? type.highlightedColor() : type.normalColor()
        }
    }
}
