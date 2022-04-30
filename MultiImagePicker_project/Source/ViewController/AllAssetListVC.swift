//
//  AllAssetListVC.swift
//  PHPickerViewController
//
//  Created by iMac on 27/04/22.
//

import UIKit
import Photos

class AllAssetListVC: UIViewController {
    
    //MARK:- Outlet's
    @IBOutlet weak var cvMediaList: UICollectionView!
    
    //MARK:- Varible's
    private var allMedia : PHFetchResult<PHAsset>? = nil
    private var selectedMedia = [PHAsset]()
    
    //MARK:- Viewcontroller LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationbar()
        
        cvMediaList.register(UINib(nibName: "cellMediaList", bundle: MultiImagePickerConst.bundle), forCellWithReuseIdentifier: "cellMediaList")
        
        getAllAsset()
    }
    
    //MARK:- Custom Function's
    private func setupNavigationbar(){
        
        let doneBarButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(btnDoneSelection_Clk(_:)))
        doneBarButton.tintColor = MultiImagePickerConst.viewTintColor
        
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(btnCancel_Clk(_:)))
        cancelBarButton.tintColor = MultiImagePickerConst.viewTintColor
        
        navigationItem.leftBarButtonItem = cancelBarButton
        navigationItem.rightBarButtonItem = doneBarButton
        
        setNavigationTitle()
    }
    
    private func setNavigationTitle(){
        navigationItem.title = "\(selectedMedia.count) / \(MultiImagePickerConst.selectionLimit)"
    }
    
    private func getAllAsset(){
        let fetchOptions = PHFetchOptions()
        fetchOptions.includeAssetSourceTypes = .init([.typeCloudShared,.typeUserLibrary,.typeiTunesSynced])
        fetchOptions.includeAllBurstAssets = true
        fetchOptions.includeHiddenAssets = true
        self.allMedia = PHAsset.fetchAssets(with: fetchOptions)
    }
    
    private func getImgFromAsset(asset:PHAsset,img:@escaping ((UIImage) -> Void)) {
        
        PHImageManager.default().requestImageData(for: asset, options: nil) { (data, str, ori, dic) in
            
            autoreleasepool{
                if let imgData = data{
                    img(UIImage(data: imgData)!)
                }}
        }
    }
    
    private func getSizeOfCell() -> CGSize{
        let twmpWidth = view.frame.size.width / MultiImagePickerConst.intNoOfCellinRow
        return CGSize(width: twmpWidth, height: twmpWidth)
    }
    
    //MARK:- IBAction Function's
    @objc private func btnCancel_Clk(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func btnDoneSelection_Clk(_ sender: UIButton) {
        if !selectedMedia.isEmpty{
            NotificationCenter.default.post(name: NSNotification.Name("multiMediaSelected"), object: nil, userInfo: ["data":selectedMedia])
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension AllAssetListVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allMedia?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cvCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellMediaList", for: indexPath) as! cellMediaList
        
        cvCell.imgShowSelection.isHidden = true
        
        if let mediaInfo = allMedia?[indexPath.item]{
            getImgFromAsset(asset: mediaInfo) { (img) in
                cvCell.imgViewPlaceHolder.image = img
            }
            cvCell.imgPlayBtn.isHidden = mediaInfo.mediaType != .video
            cvCell.imgShowSelection.isHidden = !selectedMedia.contains(mediaInfo)
        }
        
        return cvCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let mediaInfo = allMedia?[indexPath.item],let cvCell = collectionView.cellForItem(at: indexPath) as? cellMediaList{
            
            if let fIndex = selectedMedia.firstIndex(of: mediaInfo){
                selectedMedia.remove(at: fIndex)
            }else{
                if selectedMedia.count < MultiImagePickerConst.selectionLimit{
                    selectedMedia.append(mediaInfo)
                }
            }
            
            cvCell.imgShowSelection.isHidden = !selectedMedia.contains(mediaInfo)
            setNavigationTitle()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        getSizeOfCell()
    }
}
