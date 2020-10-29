//
//  ImageDetailsCell.swift
//  tribal-mqn
//
//  Created by Daniel Durán Schutz on 28/10/20.
//

import Foundation
import UIKit
import Kingfisher
import Lottie

class ImageDetailsCell: UITableViewCell{
    
    @IBOutlet weak var detailedImage: UIImageView!
    var detailedImage_string:String?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setDataPhoto(photo:LocalPhoto){
        self.detailedImage_string = photo.url_image
        setContentImage()
    }
    
    func setDataPhoto(photo:Photo){
        self.detailedImage_string = photo.urls?.full
        setContentImage()
    }
    
    func setContentImage(){
        if let url = URL(string: detailedImage_string ?? "") {
            self.detailedImage.kf.setImage(with: url)
        }
    }
    
}
