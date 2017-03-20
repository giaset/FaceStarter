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
