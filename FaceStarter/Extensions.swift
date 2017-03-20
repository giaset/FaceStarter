//
//  Extensions.swift
//  FaceStarter
//
//  Created by Gianni Settino on 2017-03-19.
//  Copyright © 2017 Jack Rogers. All rights reserved.
//

extension UIView {
    
    func addSubviewForAutolayout(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
    }
}

extension NSLayoutXAxisAnchor {
    
    func activateConstraint(equalTo anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) {
        constraint(equalTo: anchor, constant: constant).isActive = true
    }
}

extension NSLayoutYAxisAnchor {
    
    func activateConstraint(equalTo anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) {
        constraint(equalTo: anchor, constant: constant).isActive = true
    }
}

extension NSLayoutDimension {
    
    func activateConstraint(equalTo anchor: NSLayoutDimension, constant: CGFloat = 0) {
        constraint(equalTo: anchor, constant: constant).isActive = true
    }
}

extension UIColor {
    
    convenience init(hexString: String) {
        let hex = hexString.replacingOccurrences(of: "#", with: "")
        let length = hex.characters.count
        
        let scanner = Scanner(string:hex)
        var hexValue: CUnsignedLongLong = 0
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 1
        
        if scanner.scanHexInt64(&hexValue) {
            if length == 6 {
                red = CGFloat(Double((hexValue & 0xFF0000) >> 16) / 255)
                green = CGFloat(Double((hexValue & 0x00FF00) >> 8) / 255)
                blue = CGFloat(Double(hexValue & 0x0000FF) / 255)
            } else if length == 8 {
                red = CGFloat(Double((hexValue & 0xFF000000) >> 24) / 255)
                green = CGFloat(Double((hexValue & 0x00FF0000) >> 16) / 255)
                blue = CGFloat(Double((hexValue & 0x0000FF00) >> 8) / 255)
                alpha = CGFloat(Double(hexValue & 0x000000FF) / 255)
            } else {
                print("invalid hex string")
            }
        } else {
            print("hex scan error")
        }
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
