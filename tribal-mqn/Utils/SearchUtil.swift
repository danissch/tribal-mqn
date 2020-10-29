//
//  SearchUtil.swift
//  tribal-mqn
//
//  Created by Daniel Durán Schutz on 26/10/20.
//

import Foundation
import UIKit

class SearchUtil: UISearchBar {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        self.autoresizingMask = [.flexibleWidth]
        self.autoresizesSubviews = true
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    func getSearchBar(delegate:UISearchBarDelegate) -> UISearchBar{
        self.delegate = delegate
        customizeSearchField()
        return self
    }
    
    fileprivate func customizeSearchField(){
        UISearchBar.appearance().setSearchFieldBackgroundImage(UIImage(), for: .normal)
        self.backgroundColor = .white
        if let searchTextField = self.value(forKey: "searchField") as? UITextField {
            NSLayoutConstraint.activate([
                searchTextField.heightAnchor.constraint(equalToConstant: 50),
                searchTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                searchTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
                searchTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
            ])
            
            let borderBottom = CALayer()
            let borderWidth = CGFloat(2.0)
            borderBottom.borderColor = UIColor.lightGray.cgColor
            borderBottom.frame = CGRect(x: 0, y: searchTextField.frame.height - 1.0, width: searchTextField.frame.width , height: searchTextField.frame.height - 1.0)
            borderBottom.borderWidth = borderWidth
            searchTextField.layer.addSublayer(borderBottom)
            searchTextField.placeholder = "Search by name or username"

        }
        
    }
        
        
    func setNoResultsMessageSearch(viewController:UIViewController){
        let alert = UIAlertController(title: "No results", message: "“Your search does not exist", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
        self.text = ""
    }
        
    
}

