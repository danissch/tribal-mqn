//
//  NoFavoritesFoundCVCell.swift
//  tribal-mqn
//
//  Created by Daniel Durán Schutz on 28/10/20.
//

import Foundation
import UIKit

class NoFavoritesFoundCVCell: UICollectionViewCell{
    
    var noFavoritesLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let label = UILabel()
        noFavoritesLabel = label
        noFavoritesLabel.frame = self.frame
        noFavoritesLabel.center = self.center
        
        self.addSubview(noFavoritesLabel)
        noFavoritesLabel.text = "No favorites found!"
        noFavoritesLabel.layer.masksToBounds = true
        
        noFavoritesLabel.adjustsFontSizeToFitWidth = true
        noFavoritesLabel.textAlignment = .center
        noFavoritesLabel.textColor = UIColor.lightGray
        noFavoritesLabel.font = UIFont.systemFont(ofSize: 20.0)
        
        noFavoritesLabel?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: noFavoritesLabel!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 2, constant: self.frame.width).isActive = true
        
        NSLayoutConstraint(item: noFavoritesLabel!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 2, constant: self.frame.height).isActive = true

        NSLayoutConstraint(item: noFavoritesLabel!, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: noFavoritesLabel!, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
        
        noFavoritesLabel.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin, .flexibleWidth, .flexibleHeight]
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        fatalError("init(coder:) has not been implemented")
    }

    
}
