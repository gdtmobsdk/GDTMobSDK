//
//  UnifiedNativeAdImageCell.swift
//  GDTMobSample-Swift
//
//  Created by 胡城阳 on 2019/10/28.
//  Copyright © 2019 Tencent. All rights reserved.
//

import UIKit

class UnifiedNativeAdImageCell: UnifiedNativeAdBaseTableViewCell {

    override func setupWithUnifiedNativeAdDataObject(dataObject: GDTUnifiedNativeAdDataObject, delegate: GDTUnifiedNativeAdViewDelegate, vc: UIViewController) {
        self.adView.delegate = delegate
        self.adView.viewController = vc
        var imageRate:CGFloat = 16 / 9
        if dataObject.imageHeight > 0 {
            imageRate = CGFloat(dataObject.imageWidth / dataObject.imageHeight)
        }
        let width = UIScreen.main.bounds.width - 16
        self.adView.backgroundColor = UIColor.gray
        self.adView.iconImageView.frame = CGRect(x: 8, y: 8, width: 60, height: 60);
        self.adView.clickButton.frame = CGRect(x: width - 68, y: 8, width: 60, height: 44);
        self.adView.CTAButton.frame = CGRect(x: width - 100, y: 8, width: 100, height: 44);
        self.adView.titleLabel.frame = CGRect(x: 76, y: 8, width: 250, height: 30);
        self.adView.descLabel.frame = CGRect(x: 8, y: 76, width: width, height: 30);
        let imageWidth:CGFloat = width
        self.adView.imageView.frame = CGRect(x: 8, y: 114, width: imageWidth, height: imageWidth / imageRate)
        self.adView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 122 + imageWidth / imageRate)
        self.adView.logoView.frame = CGRect(x: self.adView.frame.width - kGDTLogoImageViewDefaultWidth, y: self.adView.frame.height - kGDTLogoImageViewDefaultHeight, width: kGDTLogoImageViewDefaultWidth, height: kGDTLogoImageViewDefaultHeight)
        self.adView.setupWithUnifiedNativeAdObject(unifiedNativeDataObject: dataObject)
        self.adView.registerDataObject(dataObject, clickableViews: [self.adView.clickButton,self.adView.iconImageView,self.adView.imageView])
        if let newDataObject = dataObject.callToAction {
            if newDataObject.count > 0 {
                self.adView.registerClickableCall(toActionView: self.adView.CTAButton)
            }
        }
    }
    
    override class func cellHeightWithUnifiedNativeAdDataObject(dataObject:GDTUnifiedNativeAdDataObject)->CGFloat{
        var height:CGFloat = 0
        var imageRate:CGFloat = 16 / 9
        if dataObject.imageHeight > 0 {
            imageRate = CGFloat(dataObject.imageWidth / dataObject.imageHeight)
        }
        let width:CGFloat = UIScreen.main.bounds.width - 16
        let imageWidth = width
        height = 130 + imageWidth / imageRate
        return height
    }

}
