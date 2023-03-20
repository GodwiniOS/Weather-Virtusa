//
//  Label.swift
//  Weather-Virtusa
//
//  Created by Godwin A on 20/03/2023.
//

import UIKit

extension UIView {
    
    func prepareLayout(_ attribute: NSLayoutConstraint.Attribute,
                       toItem :UIView? = nil,
                       toAttribute: NSLayoutConstraint.Attribute? = nil,
                       constant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        var withItem: UIView! =  toItem != nil ? toItem! : superview
        var withAttribute: NSLayoutConstraint.Attribute! = toAttribute ?? attribute

        if attribute == .height,attribute == .width {
            withItem = nil
            withAttribute = .notAnAttribute
        }
        let layout = NSLayoutConstraint(item: self,
                                        attribute: attribute,
                                        relatedBy: .equal,
                                        toItem: withItem,
                                        attribute: withAttribute,
                                        multiplier: 1,
                                        constant: constant)
        NSLayoutConstraint.activate([layout])
    }
    
}
