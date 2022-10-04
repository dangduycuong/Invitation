//
//  UIView.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 11/26/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    static func nibName() -> String {
        let nameSpaceClassName = NSStringFromClass(self)
        let className = nameSpaceClassName.components(separatedBy: ".").last! as String
        return className
    }
    
    static func nib() -> UINib {
        return UINib(nibName: self.nibName(), bundle: nil)
    }
    
    static func loadFromNib<T: UIView>() -> T {
        let nameStr = "\(self)"
        let arrName = nameStr.split { $0 == "." }
        let nibName = arrName.map(String.init).last!
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! T
    }
    func fill(left: CGFloat? = 0, top: CGFloat? = 0, right: CGFloat? = 0, bottom: CGFloat? = 0) {
        guard let superview = superview else {
            print("\(self.description): there is no superView")
            return
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        if let left = left {
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: left).isActive = true
        }
        if let top = top  {
            self.topAnchor.constraint(equalTo: superview.topAnchor, constant: top).isActive = true
        }
        
        if let right = right {
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -right).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -bottom).isActive = true
        }
    }
    
    @objc func setDefaultCorner() {
        self.layer.cornerRadius = 4.0
    }
    
    @objc func setCornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
    }
    
    @objc func setDefaultButton() {
        self.backgroundColor = Constant.color.blueVSmart
        self.setDefaultCorner()
        self.setShadow()
    }
    
    @objc func setBackgroundColor(color: UIColor) {
        self.backgroundColor = color
    }
    
    @objc func setDefaultButtonWithoutCorner(){
        self.backgroundColor = Constant.color.blueVSmart
        self.setShadow()
    }
    
    @objc func setShadow(size: CGFloat = 2.0) {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: size)
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
    }
    
    func lock() {
        if let _ = viewWithTag(10) {
            //View is already locked
        }
        else {
            let lockView = UIView(frame: bounds)
            lockView.backgroundColor = UIColor(white: 0.0, alpha: 0.75)
            lockView.tag = 10
            lockView.alpha = 0.0
            let activity = UIActivityIndicatorView(style: .medium)
            activity.color = .white
            activity.hidesWhenStopped = true
            activity.center = lockView.center
            lockView.addSubview(activity)
            activity.startAnimating()
            addSubview(lockView)
            
            UIView.animate(withDuration: 0.2) {
                lockView.alpha = 1.0
            }
        }
    }
    
    func unlock() {
        if let lockView = viewWithTag(10) {
            UIView.animate(withDuration: 0.2, animations: {
                lockView.alpha = 0.0
            }, completion: { finished in
                lockView.removeFromSuperview()
            })
        }
    }
    
    func fadeOut(_ duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.alpha = 0.0
        }
    }
    
    func fadeIn(_ duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.alpha = 1.0
        }
    }
}
