//
//  UnifiedNativeAdPortraitVideoTableViewCell.swift
//  GDTMobSample-Swift
//
//  Created by 胡城阳 on 2019/10/29.
//  Copyright © 2019 Tencent. All rights reserved.
//

import UIKit

class UnifiedNativeAdPortraitVideoTableViewCell: UnifiedNativeAdBaseTableViewCell,GDTMediaViewDelegate {
    
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            let bgView:UIView = UIView(frame: CGRect(x: 0, y: Constant.ScreenHeight - 145, width: Constant.ScreenWidth, height: 145))
            bgView.backgroundColor = UIColor.black
            bgView.alpha = 0.3
            self.adView.insertSubview(bgView, aboveSubview: self.adView.mediaView)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            self.adView.backgroundColor = UIColor.gray
            self.adView.clickButton.frame = CGRect(x: 15, y: Constant.ScreenHeight - 75, width: Constant.ScreenWidth - 30, height: 44)
            self.adView.clickButton.backgroundColor = UIColor.blue
            self.adView.iconImageView.frame = CGRect(x: 15, y: Constant.ScreenHeight - 145, width: 60, height: 60)
            self.adView.iconImageView.layer.cornerRadius = 30
            self.adView.iconImageView.layer.masksToBounds = true
            self.adView.titleLabel.frame = CGRect(x: 85, y: Constant.ScreenHeight - 145, width: Constant.ScreenWidth - 100, height: 30)
            self.adView.titleLabel.textColor = UIColor.white
            self.adView.descLabel.frame = CGRect(x: 85, y: Constant.ScreenHeight - 115, width: Constant.ScreenWidth - 100, height: 30)
            self.adView.descLabel.textColor = UIColor.white
            //    CGFloat imageWidth = width;
            self.adView.frame = self.bounds
            // mediaView logoView frame 更新在父view之后设置
            self.adView.mediaView.frame = self.adView.bounds
            
            self.adView.logoView.frame = CGRect(x: self.adView.frame.width - kGDTLogoImageViewDefaultWidth, y: self.adView.frame.height - kGDTLogoImageViewDefaultHeight - 60, width: kGDTLogoImageViewDefaultWidth, height: kGDTLogoImageViewDefaultHeight);
        }
        
        override func setupWithUnifiedNativeAdDataObject(dataObject: GDTUnifiedNativeAdDataObject, delegate: GDTUnifiedNativeAdViewDelegate, vc: UIViewController) {
            self.adView.delegate = delegate
            self.adView.viewController = vc
            self.adView
                .mediaView.delegate = self
            self.adView.setupWithUnifiedNativeAdObject(unifiedNativeDataObject: dataObject)
            self.adView.registerDataObject(dataObject, clickableViews: [self.adView.clickButton,self.adView.iconImageView,self.adView.imageView,self.adView.titleLabel,self.adView.descLabel])
        }
        
    }

    extension UnifiedNativePortraitCollectionViewCell{
        func gdt_mediaViewDidPlayFinished(_ mediaView: GDTMediaView!) {
            mediaView.play()
        }
        
        func gdt_mediaViewDidTapped(_ mediaView: GDTMediaView!) {
            
        }
}
