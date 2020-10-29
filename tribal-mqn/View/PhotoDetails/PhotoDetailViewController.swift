//
//  PhotoDetailViewController.swift
//  tribal-mqn
//
//  Created by Daniel Durán Schutz on 28/10/20.
//

import Foundation
import UIKit

class PhotoDetailViewController:UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var photo:Photo?
    var localPhoto:LocalPhoto?
    var originFav:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewCells()
    }

    private func registerTableViewCells() {
        let userProfileCell = UINib(nibName: "UserProfileCell",
                                  bundle: nil)
        self.tableView.register(userProfileCell,
                                forCellReuseIdentifier: "UserProfileCell")
        let imageDetailsCell = UINib(nibName: "ImageDetailsCell",
                                  bundle: nil)
        self.tableView.register(imageDetailsCell,
                                forCellReuseIdentifier: "ImageDetailsCell")
    }
    
}

extension PhotoDetailViewController:UITableViewDelegate {
    
}

extension PhotoDetailViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 30))
        headerView.backgroundColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.clipsToBounds = true
        
        button.addTarget(self, action: #selector(navigateBack), for: .touchUpInside)
        button.setTitle(" < ", for: .normal)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.setTitleColor(.lightGray, for: .normal)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowRadius = 30 / 2
        button.layer.shadowOpacity = 0.5
        button.backgroundColor = UIColor.clear
        
        headerView.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 2, constant: 30).isActive = true

        NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 2, constant: 30).isActive = true

        NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: headerView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0).isActive = true

        NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: headerView, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: 7).isActive = true
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileCell") as? UserProfileCell {
                !originFav ? cell.setDataUser(user: (self.photo?.user!)!) : cell.setDataUser(user: localPhoto!)
                return cell
            }
        }else{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ImageDetailsCell") as? ImageDetailsCell {
                !originFav ? cell.setDataPhoto(photo: self.photo!) : cell.setDataPhoto(photo: self.localPhoto!)
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 290
        }else{
            return 500
        }
        
    }
    
}
