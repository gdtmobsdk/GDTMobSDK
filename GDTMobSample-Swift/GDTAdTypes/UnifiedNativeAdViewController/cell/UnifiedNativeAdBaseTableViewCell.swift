//
//  UnifiedNativeAdBaseTableViewCell.swift
//  GDTMobSample-Swift
//
//  Created by 胡城阳 on 2019/10/28.
//  Copyright © 2019 Tencent. All rights reserved.
//

import UIKit

class UnifiedNativeAdBaseTableViewCell: UITableViewCell {

    var adView:UnifiedNativeAdCustomView
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.adView = UnifiedNativeAdCustomView()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.addSubview(adView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.adView.unregisterDataObject()
        self.adView.titleLabel.text = ""
        self.adView.descLabel.text = ""
        self.adView.imageView.image = nil
        self.adView.iconImageView.image = nil
        self.adView.leftImageView.image = nil
        self.adView.midImageView.image = nil
        self.adView.rightImageView.image = nil
    }
    
    //public func
    func setupWithUnifiedNativeAdDataObject(dataObject:GDTUnifiedNativeAdDataObject,delegate:GDTUnifiedNativeAdViewDelegate,vc:UIViewController){
        
    }

    class func cellHeightWithUnifiedNativeAdDataObject(dataObject:GDTUnifiedNativeAdDataObject)->CGFloat{
        return 0
    }
}
