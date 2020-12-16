//
//  UnifiedNativeAdThreeImageCell.swift
//  GDTMobSample-Swift
//
//  Created by 胡城阳 on 2019/10/28.
//  Copyright © 2019 Tencent. All rights reserved.
//

import UIKit

class UnifiedNativeAdThreeImageCell: UnifiedNativeAdBaseTableViewCell {

    override func setupWithUnifiedNativeAdDataObject(dataObject: GDTUnifiedNativeAdDataObject, delegate: GDTUnifiedNativeAdViewDelegate, vc: UIViewController) {
        
        var imageRate:CGFloat = 228 / 150.0
        if dataObject.imageHeight > 0 {
            imageRate = CGFloat(dataObject.imageWidth / dataObject.imageHeight)
        }
        let width = UIScreen.main.bounds.width - 16
        self.adView.backgroundColor = UIColor.gray
        self.adView.clickButton.frame = CGRect(x: width - 68, y: 8, width: 60, height: 44)
        self.adView.titleLabel.frame = CGRect(x: 8, y: 8, width: 250, height: 30)
        self.adView.descLabel.frame = CGRect(x: 8, y: 46, width: width, height: 30)
        let imageWidth:CGFloat = (width - 16) / 3
        self.adView.leftImageView.frame = CGRect(x: 8, y: 84, width: imageWidth, height: imageWidth / imageRate)
        self.adView.midImageView.frame = CGRect(x: 16 + imageWidth, y: 84, width: imageWidth, height: imageWidth / imageRate)
        self.adView.rightImageView.frame = CGRect(x: 24 + imageWidth * 2, y: 84, width: imageWidth, height: imageWidth / imageRate)
        self.adView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 92 + imageWidth / imageRate)
        self.adView.logoView.frame = CGRect(x: self.adView.frame.width - kGDTLogoImageViewDefaultWidth, y: self.adView.frame.height - kGDTLogoImageViewDefaultHeight, width: kGDTLogoImageViewDefaultWidth, height: kGDTLogoImageViewDefaultHeight)
        self.adView.viewController = vc
        self.adView.delegate = delegate
        self.adView.setupWithUnifiedNativeAdObject(unifiedNativeDataObject: dataObject)
        self.adView.registerDataObject(dataObject, clickableViews: [self.adView.clickButton,self.adView.leftImageView,self.adView.midImageView,self.adView.rightImageView])
        
    }
    
    override class func cellHeightWithUnifiedNativeAdDataObject(dataObject:GDTUnifiedNativeAdDataObject)->CGFloat{
        var height:CGFloat = 0
        var imageRate:CGFloat = 228 / 150.0
        if dataObject.imageHeight > 0 {
            imageRate = CGFloat(dataObject.imageWidth / dataObject.imageHeight)
        }
        let width:CGFloat = UIScreen.main.bounds.width - 16
        let imageWidth = (width - 16) / 3;
        height = 92 + imageWidth / imageRate
        return height
    }

}
