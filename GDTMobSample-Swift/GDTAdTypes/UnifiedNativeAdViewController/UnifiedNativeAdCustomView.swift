//
//  UnifiedNativeAdCustomView.swift
//  GDTMobSample-Swift
//
//  Created by 胡城阳 on 2019/10/28.
//  Copyright © 2019 Tencent. All rights reserved.
//

import UIKit

class UnifiedNativeAdCustomView: GDTUnifiedNativeAdView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        self.addSubview(mediaView)
        self.addSubview(iconImageView)
        self.addSubview(titleLabel)
        self.addSubview(descLabel)
        self.addSubview(clickButton)
        self.addSubview(leftImageView)
        self.addSubview(midImageView)
        self.addSubview(rightImageView)
        self.addSubview(CTAButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWithUnifiedNativeAdObject(unifiedNativeDataObject:GDTUnifiedNativeAdDataObject){
        self.titleLabel.text = unifiedNativeDataObject.title
        self.descLabel.text = unifiedNativeDataObject.desc
        
        if let iconString = unifiedNativeDataObject.iconUrl, let imageString = unifiedNativeDataObject.imageUrl {
            let iconURL = URL(string: iconString)
            let imageURL = URL(string: imageString)
            DispatchQueue.global(qos: .background).async {
                let iconData = NSData.init(contentsOf: iconURL!)
                let imageData = NSData.init(contentsOf: imageURL!)
                DispatchQueue.main.async {
                    self.iconImageView.image = UIImage(data: iconData! as Data)
                    self.imageView.image = UIImage(data: imageData! as Data)
                }
            }
        }
        
        if unifiedNativeDataObject.callToAction != nil {
            if unifiedNativeDataObject.callToAction.count > 0 {
                self.clickButton.isHidden = true
                self.CTAButton.isHidden = false
                self.CTAButton.setTitle(unifiedNativeDataObject.callToAction, for: .normal)
            }
        }else{
            self.clickButton.isHidden = false
            self.CTAButton.isHidden = true
            
            if unifiedNativeDataObject.isAppAd {
                self.clickButton.setTitle("下载", for: .normal)
            }else{
                self.clickButton.setTitle("打开", for: .normal)
            }
        }
        
        if (unifiedNativeDataObject.isVideoAd) {
            self.mediaView.isHidden = false
        } else {
            self.mediaView.isHidden = true
        }
        
        if unifiedNativeDataObject.isThreeImgsAd {
            self.imageView.isHidden = true
            self.leftImageView.isHidden = false
            self.midImageView.isHidden = false
            self.rightImageView.isHidden = false
            let leftURL:NSURL = NSURL(string: unifiedNativeDataObject.mediaUrlList![0] as! String)!
            let midURL:NSURL = NSURL(string: unifiedNativeDataObject.mediaUrlList![1] as! String)!
            let rightURL:NSURL = NSURL(string: unifiedNativeDataObject.mediaUrlList![2] as! String)!
            
        DispatchQueue.global(qos: .background).async {
            let leftData = NSData.init(contentsOf: leftURL as URL)
            let midData = NSData.init(contentsOf: midURL as URL)
            let rightData = NSData.init(contentsOf: rightURL as URL)
            DispatchQueue.main.async {
                self.leftImageView.image = UIImage(data: leftData! as Data)
                self.midImageView.image = UIImage(data: midData! as Data)
                self.rightImageView.image = UIImage(data: rightData! as Data)
            }
        }
            
        }else{
            self.imageView.isHidden = false
            self.leftImageView.isHidden = true
            self.midImageView.isHidden = true
            self.rightImageView.isHidden = true
        }
    }
    
    var titleLabel:UILabel = {
        let theTitleLabel = UILabel()
        return theTitleLabel
    }()

    var imageView:UIImageView = {
        let theImageView = UIImageView()
        return theImageView
    }()
    
    var descLabel:UILabel = {
        let theDescLabel = UILabel()
        return theDescLabel
    }()
    
    var clickButton:UIButton = {
        let theClickButton = UIButton()
        return theClickButton
    }()
    
    var iconImageView:UIImageView = {
        let theIconImageView = UIImageView()
        return theIconImageView
    }()
    
    var leftImageView:UIImageView = {
        let theLeftImageView = UIImageView()
        return theLeftImageView
    }()
    
    var midImageView:UIImageView = {
        let theMidImageView = UIImageView()
        return theMidImageView
    }()
    
    var rightImageView:UIImageView = {
        let theRightImageView = UIImageView()
        return theRightImageView
    }()
    
    var CTAButton:UIButton = {
        let theCTAButton = UIButton()
        return theCTAButton
    }()
    
}
