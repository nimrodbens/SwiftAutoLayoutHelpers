//
//  Extenstions+UIViewConstraints.swift
//  table
//
//  Created by Nimrod Ben Simon on 03/07/2017.
//  Copyright © 2017 Nimrod Ben Simon. All rights reserved.
//

import UIKit

extension UIView {
    
    @discardableResult
    func anchorTo(
        // anchors
        top: NSLayoutAnchor<NSLayoutYAxisAnchor>? = nil,
        right: NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil,
        bottom: NSLayoutAnchor<NSLayoutYAxisAnchor>? = nil,
        left: NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil,
        centerX: NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil,
        centerY: NSLayoutAnchor<NSLayoutYAxisAnchor>? = nil,
        widthAnchor: NSLayoutAnchor<NSLayoutDimension>? = nil,
        heightAnchor: NSLayoutAnchor<NSLayoutDimension>? = nil,
        // constants
        widthConstant: CGFloat? = nil,
        heightConstant: CGFloat? = nil,
        // paddings
        padding: CGFloat? = nil,
        topPadding: CGFloat? = nil,
        rightPadding: CGFloat? = nil,
        bottomPadding: CGFloat? = nil,
        leftPadding: CGFloat? = nil) -> [NSLayoutConstraint] {
        
        // constrain view
        self.translatesAutoresizingMaskIntoConstraints = false
        var constraints: [NSLayoutConstraint] = []
        
        // side anchors
        if let top = top {
            constraints.append(self.topAnchor.constraint(equalTo: top, constant: (topPadding ?? padding) ?? 0))
        }
        if let right = right {
            constraints.append(self.rightAnchor.constraint(equalTo: right, constant: -((rightPadding ?? padding) ?? 0)))
        }
        if let bottom = bottom {
            constraints.append(self.bottomAnchor.constraint(equalTo: bottom, constant: -((bottomPadding ?? padding) ?? 0)))
        }
        if let left = left {
            constraints.append(self.leftAnchor.constraint(equalTo: left, constant: (leftPadding ?? padding) ?? 0))
        }
        
        // centers
        if let centerX = centerX {
            constraints.append(self.centerXAnchor.constraint(equalTo: centerX))
        }
        if let centerY = centerY {
            constraints.append(self.centerYAnchor.constraint(equalTo: centerY))
        }
        
        // length anchors
        if let widthAnchor = widthAnchor {
            constraints.append(self.widthAnchor.constraint(equalTo: widthAnchor))
        }
        if let heightAnchor = heightAnchor {
            constraints.append(self.heightAnchor.constraint(equalTo: heightAnchor))
        }
        
        // length constants
        if let widthConstant = widthConstant {
            constraints.append(self.widthAnchor.constraint(equalToConstant: widthConstant))
        }
        if let heightConstant = heightConstant {
            constraints.append(self.heightAnchor.constraint(equalToConstant: heightConstant))
        }
        
        NSLayoutConstraint.activate(constraints)
        return constraints
        
    }
    
}

extension NSLayoutConstraint {
    
    @discardableResult
    class func constraints(withVisualFormat visualFormat: String, views: UIView ..., options: NSLayoutFormatOptions? = nil, priority: UILayoutPriority? = nil) -> [NSLayoutConstraint] {
        var viewsDic: [String : UIView] = [String : UIView]()
        for (i, view) in views.enumerated() {
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDic["v\(i)"] = view
        }
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: visualFormat, options: options ?? [], metrics: nil, views: viewsDic)
        if let priority = priority {
            constraints.forEach { (con) in
                con.priority = priority
            }
        }
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
    
    @discardableResult
    class func alignAttribute(_ attribute: NSLayoutAttribute, ofViews views: UIView ...) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        if views.count > 1 {
            views.forEach { (view) in
                view.translatesAutoresizingMaskIntoConstraints = false
            }
            constraints = []
            for i in 1 ... views.count - 1 {
                constraints.append(NSLayoutConstraint.init(item: views[i - 1], attribute: attribute, relatedBy: .equal, toItem: views[i], attribute: attribute, multiplier: 1, constant: 0))
            }
            NSLayoutConstraint.activate(constraints)
        }
        return constraints
    }
    
}
