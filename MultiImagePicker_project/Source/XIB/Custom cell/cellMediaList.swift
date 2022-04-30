//
//  cellMediaList.swift
//  PHPickerViewController
//
//  Created by iMac on 27/04/22.
//

import UIKit

class cellMediaList: UICollectionViewCell {

    //MARK:- Outlet's
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgViewPlaceHolder: UIImageView!
    @IBOutlet weak var imgPlayBtn: UIImageView!
    @IBOutlet weak var imgShowSelection: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgPlayBtn.tintColor = MultiImagePickerConst.viewTintColor
        viewContainer.layer.cornerRadius = MultiImagePickerConst.isiPhone ? 15 : 20
    }

}
