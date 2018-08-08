//
//  UIViewAutoLayoutExtension.swift
//  AutolayoutDemo
//
//  Created by Stephen Yao on 8/07/2015.
//  Copyright (c) 2015 SilverBear. All rights reserved.
//
import UIKit

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
            for i in 1 ... views.count - 1 {
                constraints.append(NSLayoutConstraint.init(item: views[i - 1], attribute: attribute, relatedBy: .equal, toItem: views[i], attribute: attribute, multiplier: 1, constant: 0))
            }
            NSLayoutConstraint.activate(constraints)
        }
        return constraints
    }
    
    func setMultiplier(multiplier: CGFloat) -> NSLayoutConstraint {
        
        NSLayoutConstraint.deactivate([self])
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        
        NSLayoutConstraint.activate([newConstraint])
        
        return newConstraint
    }
    
}

extension UIView {
    var safeLeadingAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor> {
        get {
            if #available(iOS 11.0, *) {
                return self.safeAreaLayoutGuide.leadingAnchor
            } else {
                return self.leadingAnchor
            }
        }
    }
    var safeTrailingAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor> {
        get {
            if #available(iOS 11.0, *) {
                return self.safeAreaLayoutGuide.trailingAnchor
            } else {
                return self.trailingAnchor
            }
        }
    }
    var safeLeftAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor> {
        get {
            if #available(iOS 11.0, *) {
                return self.safeAreaLayoutGuide.leftAnchor
            } else {
                return self.leftAnchor
            }
        }
    }
    var safeRightAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor> {
        get {
            if #available(iOS 11.0, *) {
                return self.safeAreaLayoutGuide.rightAnchor
            } else {
                return self.rightAnchor
            }
        }
    }
    var safeTopAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor> {
        get {
            if #available(iOS 11.0, *) {
                return self.safeAreaLayoutGuide.topAnchor
            } else {
                return self.topAnchor
            }
        }
    }
    var safeBottomAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor> {
        get {
            if #available(iOS 11.0, *) {
                return self.safeAreaLayoutGuide.bottomAnchor
            } else {
                return self.bottomAnchor
            }
        }
    }
}

extension UIView {
    
    @available(iOS 9.0, *)
    @discardableResult
    func anchorTo(
        // anchors
        top: NSLayoutAnchor<NSLayoutYAxisAnchor>? = nil,
        leading: NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil,
        right: NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil,
        bottom: NSLayoutAnchor<NSLayoutYAxisAnchor>? = nil,
        trailing: NSLayoutAnchor<NSLayoutXAxisAnchor>? = nil,
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
        leadingPadding: CGFloat? = nil,
        rightPadding: CGFloat? = nil,
        bottomPadding: CGFloat? = nil,
        trailingPadding: CGFloat? = nil,
        leftPadding: CGFloat? = nil,
        centerXOffset: CGFloat? = nil,
        centerYOffset: CGFloat? = nil,
        priority: Float? = nil,
        setActive: Bool = true
        ) -> [NSLayoutConstraint] {
        
        // constrain view
        self.translatesAutoresizingMaskIntoConstraints = false
        var constraints: [NSLayoutConstraint] = []
        
        // side anchors
        if let top = top {
            constraints.append(self.topAnchor.constraint(equalTo: top, constant: (topPadding ?? padding) ?? 0))
        }
        if let leading = leading {
            constraints.append(self.leadingAnchor.constraint(equalTo: leading, constant: (leadingPadding ?? padding) ?? 0))
        }
        if let right = right {
            constraints.append(self.rightAnchor.constraint(equalTo: right, constant: -((rightPadding ?? padding) ?? 0)))
        }
        if let bottom = bottom {
            constraints.append(self.bottomAnchor.constraint(equalTo: bottom, constant: -((bottomPadding ?? padding) ?? 0)))
        }
        if let trailing = trailing {
            constraints.append(self.trailingAnchor.constraint(equalTo: trailing, constant: -((trailingPadding ?? padding) ?? 0)))
        }
        if let left = left {
            constraints.append(self.leftAnchor.constraint(equalTo: left, constant: (leftPadding ?? padding) ?? 0))
        }
        
        // centers
        if let centerX = centerX {
            constraints.append(self.centerXAnchor.constraint(equalTo: centerX, constant: centerXOffset ?? 0))
        }
        if let centerY = centerY {
            constraints.append(self.centerYAnchor.constraint(equalTo: centerY, constant: centerYOffset ?? 0))
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
        
        if let priority = priority {
            constraints.forEach { (constraint) in
                constraint.priority = UILayoutPriority.init(priority)
            }
        }
        
        if setActive {
            NSLayoutConstraint.activate(constraints)
        }
        return constraints
        
    }
    
    func turnOffMaskResizing() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // Given an item, stretches the width and height of the view to the toItem.
    @discardableResult
    func stretchToBoundsOfSuperView(_ padding: CGFloat = 0) -> [NSLayoutConstraint] {
        return self.stretchToWidthOfSuperView(padding) + self.stretchToHeightOfSuperView(padding)
    }
    
    @discardableResult
    func stretchToWidthOfSuperView(_ padding: CGFloat = 0) -> [NSLayoutConstraint] {
        return self.constrainToLeftOfSuperView(padding) + self.constrainToRightOfSuperView(padding)
    }
    
    @discardableResult
    func stretchToHeightOfSuperView(_ padding: CGFloat = 0) -> [NSLayoutConstraint] {
        return self.constrainToTopOfSuperView(padding) + self.constrainToBottomOfSuperView(padding)
    }
    
    @discardableResult
    func constrainToTopOfSuperView(_ padding: CGFloat) -> [NSLayoutConstraint] {
        self.turnOffMaskResizing()
        guard let superview = self.superview else {
            return []
        }
        return self.anchorTo(top: superview.safeTopAnchor, padding: padding)
    }
    
    @discardableResult
    func constrainToLeftOfSuperView(_ padding: CGFloat) -> [NSLayoutConstraint] {
        self.turnOffMaskResizing()
        guard let superview = self.superview else {
            return []
        }
        return self.anchorTo(leading: superview.safeLeadingAnchor, padding: padding)
    }
    
    @discardableResult
    func constrainToBottomOfSuperView(_ padding: CGFloat) -> [NSLayoutConstraint] {
        self.turnOffMaskResizing()
        guard let superview = self.superview else {
            return []
        }
        return self.anchorTo(bottom: superview.safeBottomAnchor, padding: padding)
    }
    
    @discardableResult
    func constrainToRightOfSuperView(_ padding: CGFloat) -> [NSLayoutConstraint] {
        self.turnOffMaskResizing()
        guard let superview = self.superview else {
            return []
        }
        return self.anchorTo(trailing: superview.safeTrailingAnchor, padding: padding)
    }
    
}

