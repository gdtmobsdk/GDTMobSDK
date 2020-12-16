//
//  UnifiedNativePortraitCollectionViewCell.swift
//  GDTMobSample-Swift
//
//  Created by 胡城阳 on 2019/10/29.
//  Copyright © 2019 Tencent. All rights reserved.
//

import UIKit

class UnifiedNativePortraitCollectionViewCell: UICollectionViewCell {
    
    var theImageView:UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.blue
        theImageView = UIImageView(frame: self.bounds)
        theImageView?.translatesAutoresizingMaskIntoConstraints = true
        theImageView?.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.flexibleWidth.rawValue | UIViewAutoresizing.flexibleHeight.rawValue)
        self.addSubview(theImageView!)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWithUnifiedNativeAdDataObject(nativeAdDataObject: GDTUnifiedNativeAdDataObject){
        let imageURL:NSURL = NSURL.init(string: nativeAdDataObject.imageUrl)!
        DispatchQueue.global(qos: .default).async {
            let imageData = NSData.init(contentsOf: imageURL as URL)
            DispatchQueue.main.async {
                self.theImageView!.image = UIImage(data: imageData! as Data)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.theImageView?.image = nil
    }
}
