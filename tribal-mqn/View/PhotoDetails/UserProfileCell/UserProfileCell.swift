//
//  UserProfileCell.swift
//  tribal-mqn
//
//  Created by Daniel Durán Schutz on 28/10/20.
//

import Foundation
import UIKit

class UserProfileCell:UITableViewCell {
    
    
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var bio: UILabel!
    @IBOutlet weak var totalPhotos: UILabel!
    @IBOutlet weak var totalCollections: UILabel!
    @IBOutlet weak var totalLikes: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var facebook: UIImageView!
    @IBOutlet weak var twitter: UIImageView!
    @IBOutlet weak var linkedin: UIImageView!
    @IBOutlet weak var instagram: UIImageView!
    
    
    var userPhoto_string: String?
    var name_string:String?
    var bio_string:String?
    var totalPhotos_string:String?
    var totalCollections_string:String?
    var totalLikes_string:String?
    var location_string:String?
    var facebook_string:String?
    var twitter_string:String?
    var linkedin_string:String?
    var instagram_string:String?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        userPhoto.layer.cornerRadius = 0.5 * userPhoto.bounds.size.width
    }
    
    func setDataUser(user:LocalPhoto){
        self.userPhoto_string = user.lu_user_profile_image
        self.name_string = user.lu_name
        self.bio_string = user.lu_bio
        self.totalPhotos_string = String(user.lu_total_photos)
        self.totalCollections_string = String(user.lu_total_collections)
        self.totalLikes_string = String(user.lu_total_likes)
        self.location_string = user.lu_location
        self.facebook_string = user.lu_facebook
        self.twitter_string = user.lu_twitter
        self.linkedin_string = user.lu_linkedin
        self.instagram_string = user.lu_instagram
        setContentUser()
    }
    
    func setDataUser(user:User){
        self.userPhoto_string = user.profileImage?.medium
        self.name_string = user.name
        self.bio_string = user.bio
        self.totalPhotos_string = String(user.totalPhotos ?? 0)
        self.totalCollections_string = String(user.totalCollections ?? 0)
        self.totalLikes_string = String(user.totalLikes ?? 0)
        self.location_string = user.location
        self.facebook_string = ""
        self.twitter_string = user.twitterUsername
        self.linkedin_string = ""
        self.instagram_string = user.instagramUsername
        setContentUser()
    }
    
    func setContentUser(){
        if let url = URL(string: userPhoto_string ?? "") {
            self.userPhoto.kf.setImage(with: url)
        }
        self.name.text = self.name_string
        self.bio.text = self.bio_string
        self.totalPhotos.text = self.totalPhotos_string
        self.totalCollections.text = self.totalCollections_string
        self.totalLikes.text = self.totalLikes_string
        self.location.text = self.location_string
        
    }
    
    
}
