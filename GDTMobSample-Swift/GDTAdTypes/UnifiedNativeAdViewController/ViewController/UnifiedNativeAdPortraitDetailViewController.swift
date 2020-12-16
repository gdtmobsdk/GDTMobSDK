//
//  UnifiedNativeAdPortraitDetailViewController.swift
//  GDTMobSample-Swift
//
//  Created by 胡城阳 on 2019/10/29.
//  Copyright © 2019 Tencent. All rights reserved.
//

import UIKit

class UnifiedNativeAdPortraitDetailViewController:UIViewController,GDTUnifiedNativeAdViewDelegate{
    
    var dataObject:GDTUnifiedNativeAdDataObject? = nil
    let nativeAdView:UnifiedNativeAdCustomView = {
        let _nativeAdView = UnifiedNativeAdCustomView()
        return _nativeAdView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        self.nativeAdView.viewController = self
        self.nativeAdView.delegate = self
        self.nativeAdView.registerDataObject(self.dataObject, clickableViews: [self.nativeAdView.titleLabel,self.nativeAdView.iconImageView,self.nativeAdView.descLabel,self.nativeAdView.clickButton])
        self.nativeAdView.setupWithUnifiedNativeAdObject(unifiedNativeDataObject: dataObject!)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.nativeAdView.mediaView.play()
    }
    
    func initViews(){
        self.view.addSubview(nativeAdView)
        self.nativeAdView.translatesAutoresizingMaskIntoConstraints = false
        self.nativeAdView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.nativeAdView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.nativeAdView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.nativeAdView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.nativeAdView.clickButton.translatesAutoresizingMaskIntoConstraints = false
        self.nativeAdView.clickButton.leftAnchor.constraint(equalTo: self.nativeAdView.leftAnchor, constant: 15).isActive = true
        self.nativeAdView.clickButton.rightAnchor.constraint(equalTo: self.nativeAdView.rightAnchor, constant: -20).isActive = true
        self.nativeAdView.clickButton.bottomAnchor.constraint(equalTo: self.nativeAdView.bottomAnchor, constant: -15).isActive = true
        self.nativeAdView.clickButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.nativeAdView.clickButton.backgroundColor = UIColor.orange
        
        self.nativeAdView.descLabel.translatesAutoresizingMaskIntoConstraints = false
        self.nativeAdView.descLabel.textColor = UIColor.red
        self.nativeAdView.descLabel.leftAnchor.constraint(equalTo: self.nativeAdView.clickButton.leftAnchor).isActive = true
        self.nativeAdView.descLabel.rightAnchor.constraint(equalTo: self.nativeAdView.clickButton.rightAnchor).isActive = true
        self.nativeAdView.descLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.nativeAdView.descLabel.bottomAnchor.constraint(equalTo: self.nativeAdView.clickButton.topAnchor, constant: -10).isActive = true

        self.nativeAdView.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.nativeAdView.titleLabel.textColor = UIColor.blue
        self.nativeAdView.titleLabel.leftAnchor.constraint(equalTo: self.nativeAdView.clickButton.leftAnchor).isActive = true
        self.nativeAdView.titleLabel.rightAnchor.constraint(equalTo: self.nativeAdView.clickButton.rightAnchor).isActive = true
        self.nativeAdView.titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.nativeAdView.titleLabel.bottomAnchor.constraint(equalTo: self.nativeAdView.descLabel.topAnchor, constant: -10).isActive = true
        
        self.nativeAdView.iconImageView.translatesAutoresizingMaskIntoConstraints = false
        self.nativeAdView.iconImageView.leftAnchor.constraint(equalTo: self.nativeAdView.clickButton.leftAnchor).isActive = true
        self.nativeAdView.iconImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.nativeAdView.iconImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
    self.nativeAdView.iconImageView.bottomAnchor.constraintEqualToSystemSpacingBelow(self.nativeAdView.titleLabel.topAnchor, multiplier: -10).isActive = true
        
        self.nativeAdView.addSubview(self.nativeAdView.logoView)
        self.nativeAdView.logoView.translatesAutoresizingMaskIntoConstraints = false
        self.nativeAdView.logoView.widthAnchor.constraint(equalToConstant: kGDTLogoImageViewDefaultWidth).isActive = true
        self.nativeAdView.logoView.heightAnchor.constraint(equalToConstant: kGDTLogoImageViewDefaultHeight).isActive = true
        self.nativeAdView.logoView.rightAnchor.constraint(equalTo: self.nativeAdView.rightAnchor).isActive = true
        self.nativeAdView.logoView.bottomAnchor.constraintEqualToSystemSpacingBelow(self.nativeAdView.bottomAnchor, multiplier: -20).isActive = true
    }
    
}


extension UnifiedNativeAdPortraitDetailViewController{
    func gdt_unifiedNativeAdViewWillExpose(_ unifiedNativeAdView: GDTUnifiedNativeAdView!) {
        print(#function)
        print("\(unifiedNativeAdView.dataObject.title ?? "") 广告曝光")
    }
    
    func gdt_unifiedNativeAdDetailViewWillPresentScreen(_ unifiedNativeAdView: GDTUnifiedNativeAdView!) {
        print(#function)
        self.nativeAdView.mediaView.pause()
    }
    
    func gdt_unifiedNativeAdDetailViewClosed(_ unifiedNativeAdView: GDTUnifiedNativeAdView!) {
        print(#function)
        self.nativeAdView.mediaView.play()
    }
    
    func gdt_unifiedNativeAdView(_ unifiedNativeAdView: GDTUnifiedNativeAdView!, playerStatusChanged status: GDTMediaPlayerStatus, userInfo: [AnyHashable : Any]! = [:]) {
        print(#function)
    }
}
