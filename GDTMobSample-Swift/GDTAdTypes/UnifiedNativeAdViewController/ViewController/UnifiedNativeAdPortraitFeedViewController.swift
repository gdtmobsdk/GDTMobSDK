//
//  UnifiedNativeAdPortraitFeedViewController.swift
//  GDTMobSample-Swift
//
//  Created by 胡城阳 on 2019/10/28.
//  Copyright © 2019 Tencent. All rights reserved.
//

import UIKit

class UnifiedNativeAdPortraitFeedViewController: UnifiedNativeAdBaseViewController,GDTUnifiedNativeAdDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    

    var nativeAd:GDTUnifiedNativeAd?
    var collectionView:UICollectionView?
    var adArray:Array<Any> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        initView()
        self.adArray = Array()
        
        //---- 视频配置项，整段注释可使用外部VC开关控制
        self.placementId = "3050349752532954"; // 需要只出视频的广告位，请联系商务同学开通
        self.videoConfig!.videoMuted = false;
        self.videoConfig!.autoPlayPolicy = GDTVideoAutoPlayPolicy.never; // 手动控制播放
        self.videoConfig!.userControlEnable = true;
        self.videoConfig!.autoResumeEnable = false;
        self.videoConfig!.detailPageEnable = false;
        //-----
        self.nativeAd = GDTUnifiedNativeAd.init(appId: self.appId, placementId: self.placementId)
        self.nativeAd?.delegate = self
        self.nativeAd?.maxVideoDuration = self.maxVideoDuration
        self.nativeAd?.loadAd(withAdCount: 10)
        // Do any additional setup after loading the view.
    }
    
    func initView(){
        self.view.addSubview(self.collectionView!)
        self.collectionView!.register(UnifiedNativePortraitCollectionViewCell.self, forCellWithReuseIdentifier: "UnifiedNativePortraitCollectionViewCell")
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
    }
    
    func setCollectionView(){
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView!.translatesAutoresizingMaskIntoConstraints = true
        collectionView!.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.flexibleWidth.rawValue | UIViewAutoresizing.flexibleHeight.rawValue)
        collectionView!.backgroundColor = UIColor.gray
        collectionView!.delegate = self
        collectionView!.dataSource = self
    }
}
// GDTUnifiedNativeAdDelegate
extension UnifiedNativeAdPortraitFeedViewController{
    func gdt_unifiedNativeAdLoaded(_ unifiedNativeAdDataObjects: [GDTUnifiedNativeAdDataObject]?, error: Error?) {
        if (error != nil) {
            print("error is \(error)")
            return
        }
        
        for dataObject in unifiedNativeAdDataObjects! {
            if dataObject.isVideoAd{
                self.adArray.append("test")
                self.adArray.append("test")
                self.adArray.append(dataObject)
            }
            
        }
        self.collectionView!.reloadData()
    }
}

extension UnifiedNativeAdPortraitFeedViewController{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.adArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = self.adArray[indexPath.row]
        if item is GDTUnifiedNativeAdDataObject {
            let cell:UnifiedNativePortraitCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UnifiedNativePortraitCollectionViewCell", for: indexPath) as! UnifiedNativePortraitCollectionViewCell
            cell.setupWithUnifiedNativeAdDataObject(nativeAdDataObject: item as! GDTUnifiedNativeAdDataObject)
            return cell
        }else{
            let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
            cell.backgroundColor = UIColor.red
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width / 2 - 20 , height: 320)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.adArray[indexPath.row]
        if item is GDTUnifiedNativeAdDataObject {
            let vc:UnifiedNativeAdPortraitDetailViewController = UnifiedNativeAdPortraitDetailViewController()
            vc.dataObject = (item as! GDTUnifiedNativeAdDataObject)
            vc.dataObject?.videoConfig = self.videoConfig
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
