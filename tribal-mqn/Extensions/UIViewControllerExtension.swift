//
//  UIViewControllerExtension.swift
//  tribal-mqn
//
//  Created by Daniel Durán Schutz on 26/10/20.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    internal class func instantiateFromXIB<T:UIViewController>() -> T{
        let xibName = T.stringRepresentation
        let vc = T(nibName: xibName, bundle: nil)
        return vc
    }
    
    
    
    @objc internal func navigateBack(){
        if isModal {
            dismiss(animated: true, completion: nil)
        }else{
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    var isModal:Bool {
        if presentingViewController != nil {
            return true
        }
        if presentingViewController?.presentedViewController == self {
            return true
        }
        if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        }
        if tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        
        return false
    }
    
    func pushVc(_ uiViewController: UIViewController, animated:Bool = true, navigationBarIsHidden:Bool, presentStyle:UIModalPresentationStyle = .fullScreen, transitionStyle:UIModalTransitionStyle = .coverVertical){
        uiViewController.modalPresentationStyle = presentStyle
        
        
        self.navigationController?.modalPresentationStyle = presentStyle
        self.navigationController?.modalTransitionStyle = transitionStyle
        
        if navigationBarIsHidden{
            self.navigationController?.navigationBar.isHidden = true
        }else{
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.barTintColor = UIColor.black
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 16)]
        }
        
        self.navigationController?.pushViewController(uiViewController, animated: animated)

    }
    
    func presentWithStyle1(vcFrom:UIViewController, vcTo:UIViewController, animated:Bool = true, presentStyle:UIModalPresentationStyle = .fullScreen, transitionStyle:UIModalTransitionStyle = .coverVertical){
            vcTo.modalPresentationStyle = presentStyle
            vcTo.modalTransitionStyle = transitionStyle
            vcFrom.present(vcTo, animated: true, completion: nil)
        }
    
    
    
    
}
