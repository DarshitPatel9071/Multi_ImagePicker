//
//  ClassMultipleImagePicker.swift
//  PHPickerViewController
//
//  Created by iMac on 27/04/22.
//

import Foundation
import UIKit
import PhotosUI
import Photos

public protocol MultiImagePickerDelegate {
    func selectedMedia(allMedia:[PHAsset])
}

// using PHAsset
public class MultiImagePicker:NSObject{
    
    //MARK:- Varible's
    public static let shared = MultiImagePicker()
    private var superVC = UIViewController()
    private var delegate : MultiImagePickerDelegate?
    
    
    //MARK:- All Function's
    
    public func openPicker(maxLimit:Int=5,
                           tintColor:UIColor = .black,
                           VC:UIViewController,
                           tempDelegate:MultiImagePickerDelegate){
        delegate = tempDelegate
        superVC = VC
        MultiImagePickerConst.viewTintColor = tintColor
        MultiImagePickerConst.selectionLimit = maxLimit
        photoLibraryPermission()
    }
    
    private func photoLibraryPermission(){
        
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized,.limited:
                self.fetchAllMedia()
                break
            case .denied, .restricted:
                self.alertForAskPermission()
                break
            case .notDetermined:
                self.alertForAskPermission()
                break
            @unknown default:
                break
            }
        }
    }
    
    private func fetchAllMedia(){
        DispatchQueue.main.async {
            self.addNotiObserver()
            let vc = MultiImagePickerConst.storyBoard.instantiateViewController(withIdentifier: "MultiImagePickerNC") as! UINavigationController
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .coverVertical
            self.superVC.present(vc, animated: true, completion: nil)
        }
    }
    
    private func alertForAskPermission(){
        superVC.showSystemAlert(title: MultiImagePickerConst.permissionAlertTitle,
                                message: MultiImagePickerConst.permissionAlertMessage,
                                otherBtnTitle: ["Allow"],
                                cancelTitle: "Don't Allow",
                                cancelBtnTap: nil) { (index, title) in
            
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }
    }
    
    private func addNotiObserver(){
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(mediaSelectedNoti), name: NSNotification.Name("multiMediaSelected"), object: nil)
    }
    
    @objc func mediaSelectedNoti(noti:NSNotification){
        if let selectedMedia = noti.userInfo?["data"] as? [PHAsset]{
            delegate?.selectedMedia(allMedia: selectedMedia)
        }
    }
}
