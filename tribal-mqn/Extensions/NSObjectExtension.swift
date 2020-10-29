//
//  NSObjectExtension.swift
//  tribal-mqn
//
//  Created by Daniel Durán Schutz on 28/10/20.
//

import Foundation

extension NSObject {
    @objc class var stringRepresentation:String {
        let name = String(describing: self)
        return name
    }
}
