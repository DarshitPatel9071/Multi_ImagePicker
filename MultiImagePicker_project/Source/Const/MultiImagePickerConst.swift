//
//  MultiImagePickerConst.swift
//  PHPickerViewController
//
//  Created by iMac on 27/04/22.
//

import Foundation
import UIKit

public struct MultiImagePickerConst
{
    static let bundle = Bundle(for: AllAssetListVC.self)
    static let storyBoard = UIStoryboard(name: "MultiImagePicker", bundle: bundle)
    static let isiPhone = UIDevice.current.userInterfaceIdiom == .phone
    static let intNoOfCellinRow : CGFloat = isiPhone ? 3 : 5
    static let permissionAlertTitle = "Permission Required"
    static let permissionAlertMessage = "Need photo library permission for fetch all media."
    
    static var viewTintColor = UIColor.black
    static var selectionLimit = 5
}

extension UIViewController{
    func showSystemAlert(title:String,
                         message:String,
                         otherBtnTitle:[String],
                         cancelTitle:String,
                         cancelBtnTap: (() -> Void)?,
                         otherBtnTap: ((Int,String) -> Void)?){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for otherBtnIndex in 0..<otherBtnTitle.count{
            
            let btnTitle = otherBtnTitle[otherBtnIndex]
            alert.addAction(UIAlertAction(title: btnTitle, style: .default, handler: { (act) in
                otherBtnTap?(otherBtnIndex,btnTitle)
            }))
        }
        
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: { (act) in
            cancelBtnTap?()
        }))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
