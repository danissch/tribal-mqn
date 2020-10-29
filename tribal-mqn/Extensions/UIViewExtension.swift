//
//  UIViewExtension.swift
//  tribal-mqn
//
//  Created by Daniel Durán Schutz on 26/10/20.
//

import Foundation
import UIKit

extension UIView {

    func drawBorder(edges: [UIRectEdge], borderWidth: CGFloat, color: UIColor) {
        for item in edges {
            let borderLayer: CALayer = CALayer()
            borderLayer.borderColor = color.cgColor
            borderLayer.borderWidth = borderWidth
            switch item {
            case .top:
                borderLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: borderWidth)
            case .left:
                borderLayer.frame =  CGRect(x: 0, y: 0, width: borderWidth, height: frame.height)
            case .bottom:
                borderLayer.frame = CGRect(x: 0, y: frame.height - borderWidth, width: frame.width, height: borderWidth)
            case .right:
                borderLayer.frame = CGRect(x: frame.width - borderWidth, y: 0, width: borderWidth, height: frame.height)
            case .all:
                drawBorder(edges: [.top, .left, .bottom, .right], borderWidth: borderWidth, color: color)
            default:
                break
            }
            self.layer.addSublayer(borderLayer)
        }
    }
    
    func bottomBorderTF(color:UIColor) -> UIView {
        var bottomBorder = UIView()
        //MARK: Setup Bottom-Border
        self.translatesAutoresizingMaskIntoConstraints = false
        bottomBorder = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        bottomBorder.backgroundColor = color
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomBorder)
        //Mark: Setup Anchors
        bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomBorder.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        bottomBorder.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        bottomBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true // Set Border-Strength

       return bottomBorder
    }
    

    func applyCircleShadow(shadowRadius: CGFloat = 2,
                           shadowOpacity: Float = 0.3,
                           shadowColor: CGColor = UIColor.lightGray.cgColor,
                           shadowOffset: CGSize = CGSize.zero) {
        layer.cornerRadius = frame.size.height / 2
        layer.masksToBounds = false
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
    }

    
    func setRadiusWithShadow(_ radius: CGFloat? = nil) {
            self.layer.cornerRadius = radius ?? self.frame.width / 2
            self.layer.shadowColor = UIColor.darkGray.cgColor
            self.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
            self.layer.shadowRadius = 1.0
            self.layer.shadowOpacity = 0.7
            self.layer.masksToBounds = false
        }
    
    func setRoundedShadow(radius:CGFloat){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.layer.shadowRadius = radius
    }
    
}
