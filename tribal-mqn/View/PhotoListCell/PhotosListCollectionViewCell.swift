//
//  PhotosListCollectionViewCell.swift
//  tribal-mqn
//
//  Created by Daniel Durán Schutz on 25/10/20.
//

import Foundation
import UIKit
import Kingfisher
import Lottie

class PhotosListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var image: UIImageView!
    var imageUrl:String?

    var animationContainer: UIView!
    private var animationView: AnimationView?
    var favoritesButton:UIButton!
    
    var photosListViewModel:PhotosListViewModel!
    var photo:Photo?
    var localPhoto:LocalPhoto?
    var originFav: Bool?
    var currentId: String?
    var isFavorite:Bool?
    var likesNumber:String?
    var userImage: String?
    var userName:String?
    
    var width:CGFloat?
    var height:CGFloat?
    
    var imageViewLike: UIImageView?
    var labelLike: UILabel?
    var containerLikes:UIView?
    
    var containerUser:UIView?
    var imageViewUser:UIImageView?
    var labelNameUser:UILabel?
    var showUser:Bool? = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("prueba  init A::")
        initMainImage()
        initFavoritesAnimation()
        likesInit()
        initUserContainer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    func setData(photo: Photo, viewModel: PhotosListViewModel){
        self.photosListViewModel = viewModel
        self.photo = photo
        self.originFav = false
        self.currentId = photo.id
        self.isFavorite = checkIsFavorite()
        self.likesNumber = String(photo.likes ?? 0)
        self.userName = photo.user?.name
        self.userImage = photo.user?.profileImage?.medium
        
        setMainImage(url: photo.urls?.regular ?? "")
        
    }
    
    func setData(photo: LocalPhoto, viewModel: PhotosListViewModel ){
        self.photosListViewModel = viewModel
        self.localPhoto = photo
        self.originFav = true
        self.currentId = photo.id_image
        self.isFavorite = checkIsFavorite()
        self.likesNumber = String(photo.likes_image)
        self.userName = photo.lu_name 
        self.userImage = photo.lu_user_profile_image
        
        
        setMainImage(url: photo.url_image ?? "")

    }
    
    func initMainImage(){
        let imageNew = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        image = imageNew
        
        self.addSubview(image)
        image.layer.cornerRadius = 10
        image.layer.borderWidth = 0.0
    }
    
    func setMainImage(url: String){
        self.imageUrl = url
        if let url = URL(string: imageUrl!) {
            image.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            image.contentMode = .scaleAspectFill
           
            image.clipsToBounds = true
            image.kf.setImage(with: url, completionHandler: {_,_,_,_ in
                self.setFavStatus()
                self.setLikes()
                self.setUserInfo()
            })
        }
    }
    
    
    
    func initFavoritesAnimation(){
        animationView = .init(name:"fav")
        self.addSubview(animationView!)
        animationView?.contentMode = .scaleAspectFit
        
        animationView!.animationSpeed = 0.5

        let gestureFavorite = UITapGestureRecognizer(target: self, action:  #selector(self.favAction))
        animationView?.addGestureRecognizer(gestureFavorite)
        
        animationView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: animationView!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 2, constant: 45).isActive = true
        
        NSLayoutConstraint(item: animationView!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 2, constant: 45).isActive = true

        
        NSLayoutConstraint(item: animationView!, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: animationView!, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: 0).isActive = true
        
    }
    
    @objc func favAction(sender : UITapGestureRecognizer) {
        // Do what you want
        if originFav ?? false {
            delFav()
        }else{
            isFavorite ?? false ? delFav() : addFav()
        }
    }
    
    private func startProgress() {
      animationView?.play(fromFrame: 0, toFrame: 0, loopMode: .none) { [weak self] (_) in
      }
    }
    
    private func fullProgress(){
        animationView?.play(fromFrame: 100, toFrame: 100, loopMode: .none) { [weak self] (_) in
        }
    }
    
    private func setFavStatus(){
        self.bringSubviewToFront(animationView!)
        isFavorite ?? false ? fullProgress() : startProgress()
    }
    
    private func addFav() {
        photosListViewModel?.createFavorite(photo: self.photo!, complete: { (result) in
            switch result {
            case .Success(_, _):
                self.animationView!.loopMode = .playOnce
                self.animationView?.play()
                self.isFavorite = true
            case .Error(let message, let statusCode):
                print("Error: \(message), code: \(statusCode)")
            }
        })
        
    }
    
    private func delFav(){
        photosListViewModel?.deleteFavorite(id_image: currentId ?? "", complete: { (result) in
            switch result {
            case .Success(_, _):
                self.startProgress()
                self.isFavorite = false
            case .Error(let message, let statusCode):
                print("Error: \(message), code: \(statusCode)")
            }
        })
        
    }
    
    func checkIsFavorite() -> Bool {
        return photosListViewModel.isFavorite(id_image: currentId ?? "")
    }
    
    
    func likesInit(){
        containerLikes = UIView()
        containerLikes?.clipsToBounds = true
        containerLikes?.backgroundColor = .init(white: 1.0, alpha: 0.4)
        containerLikes?.layer.cornerRadius = 10
        
        imageViewLike = UIImageView(frame: self.bounds)
        imageViewLike?.image = UIImage(named: "like")
        imageViewLike?.backgroundColor = .clear
        imageViewLike?.clipsToBounds = true
        
        labelLike = UILabel()
        labelLike?.backgroundColor = .clear
        labelLike?.layer.cornerRadius = 10
        labelLike?.layer.masksToBounds = true
        
        containerLikes?.addSubview(imageViewLike!)
        containerLikes?.addSubview(labelLike!)
        self.addSubview(containerLikes!)
        
        containerLikes?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: containerLikes!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 2, constant: 50).isActive = true
        
        NSLayoutConstraint(item: containerLikes!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 2, constant: 25).isActive = true

        NSLayoutConstraint(item: containerLikes!, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 10).isActive = true
        
        NSLayoutConstraint(item: containerLikes!, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 5).isActive = true
        
        
        labelLike?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: labelLike!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 2, constant: 25).isActive = true
        
        NSLayoutConstraint(item: labelLike!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 2, constant: 25).isActive = true

        NSLayoutConstraint(item: labelLike!, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: containerLikes, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: labelLike!, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: containerLikes, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: 0).isActive = true
        
        
        imageViewLike?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: imageViewLike!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 2, constant: 20).isActive = true
        
        NSLayoutConstraint(item: imageViewLike!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 2, constant: 20).isActive = true

        NSLayoutConstraint(item: imageViewLike!, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: containerLikes, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: imageViewLike!, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: labelLike, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0).isActive = true
        
    }
    
    func setLikes(){
        labelLike?.text = likesNumber
        labelLike?.adjustsFontSizeToFitWidth = true
        labelLike?.textAlignment = .center
        labelLike?.font = UIFont.systemFont(ofSize: 10.0)
        
    }
    
    func initUserContainer(){
        containerUser = UIView()
        imageViewUser = UIImageView()
        imageViewLike?.clipsToBounds = true
        labelNameUser = UILabel()
        
        containerUser?.addSubview(imageViewUser!)
        containerUser?.addSubview(labelNameUser!)
        self.addSubview(containerUser!)
    
        let gestureImageUser = UITapGestureRecognizer(target: self, action:  #selector(self.userAction))
        imageViewUser?.addGestureRecognizer(gestureImageUser)
        
        let gestureUserName = UITapGestureRecognizer(target: self, action:  #selector(self.userNameAction))
        labelNameUser?.addGestureRecognizer(gestureUserName)
        
        
    }
    
    func setUserInfo(){
        self.bringSubviewToFront(containerUser!)
        self.bringSubviewToFront(imageViewUser!)
        
        containerUser?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: containerUser!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 2, constant: 36).isActive = true
        
        NSLayoutConstraint(item: containerUser!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 2, constant: 36).isActive = true

        NSLayoutConstraint(item: containerUser!, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: -5).isActive = true
        
        NSLayoutConstraint(item: containerUser!, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 5).isActive = true
        
        
        imageViewUser?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: imageViewUser!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 2, constant: 36).isActive = true
        
        NSLayoutConstraint(item: imageViewUser!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 2, constant: 36).isActive = true
        
        NSLayoutConstraint(item: imageViewUser!, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: containerUser, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: imageViewUser!, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: containerUser, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 0).isActive = true
        
        
        labelNameUser?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: labelNameUser!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 2, constant: self.frame.width - 57).isActive = true
        
        NSLayoutConstraint(item: labelNameUser!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 2, constant: 36).isActive = true

        NSLayoutConstraint(item: labelNameUser!, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: containerUser, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: labelNameUser!, attribute: NSLayoutConstraint.Attribute.leftMargin, relatedBy: NSLayoutConstraint.Relation.equal, toItem: imageViewUser, attribute: NSLayoutConstraint.Attribute.leftMargin, multiplier: 1, constant: 40).isActive = true
        
        containerUser?.clipsToBounds = true
        containerUser?.backgroundColor = .init(white: 1.0, alpha: 1.0)
        containerUser?.layer.borderWidth = 2.0
        containerUser?.layer.borderColor = UIColor.white.cgColor
        containerUser?.layer.cornerRadius = (containerUser?.frame.height ?? 0) / 2
        
        
        if let url = URL(string: userImage ?? "") {
            imageViewUser?.kf.setImage(with: url, completionHandler: {_,_,_,_ in
            })
            imageViewUser?.clipsToBounds = true
            imageViewUser?.layer.cornerRadius = (containerUser?.frame.height ?? 0) / 2
            imageViewUser?.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            imageViewUser?.contentMode = .scaleAspectFill
            imageViewUser?.isUserInteractionEnabled = true
        }
        
        labelNameUser?.backgroundColor = .clear
        labelNameUser?.layer.cornerRadius = 10
        labelNameUser?.layer.masksToBounds = true
        labelNameUser?.text = userName
        labelNameUser?.adjustsFontSizeToFitWidth = true
        labelNameUser?.font = UIFont.systemFont(ofSize: 11.0)
        labelNameUser?.lineBreakMode = .byTruncatingMiddle
        labelNameUser?.numberOfLines = 2
        
    }
    
    @objc func userAction(sender : UITapGestureRecognizer) {
        if !(showUser ?? false) {
            showUserNow()
        }else{
            hideUserNow()
        }
        
    }
    
    func showUserNow(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.containerUser!.frame = CGRect(x: self.containerUser!.frame.origin.x, y: self.containerUser!.frame.origin.y, width: self.frame.width - 10, height: self.containerUser!.frame.height)
        }, completion: {_ in
            self.showUser = true
            self.labelNameUser?.isUserInteractionEnabled = true
        })
        
        containerUser?.translatesAutoresizingMaskIntoConstraints = true
        self.containerUser!.layoutIfNeeded()

    }
    
    func hideUserNow(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.containerUser!.frame = CGRect(x: self.containerUser!.frame.origin.x, y: self.containerUser!.frame.origin.y, width: (self.imageViewUser?.frame.size.width)!, height: self.containerUser!.frame.height)
        }, completion: {_ in
            self.showUser = false
        })
        self.containerUser!.layoutIfNeeded()
    }
    
    
    @objc func userNameAction(sender : UITapGestureRecognizer) {}
    
}
