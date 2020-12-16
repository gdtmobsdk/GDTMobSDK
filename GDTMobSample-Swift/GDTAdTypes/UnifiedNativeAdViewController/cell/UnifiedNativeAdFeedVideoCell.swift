//
//  UnifiedNativeAdFeedVideoCell.swift
//  GDTMobSample-Swift
//
//  Created by 胡城阳 on 2019/10/29.
//  Copyright © 2019 Tencent. All rights reserved.
//

import UIKit

class UnifiedNativeAdFeedVideoCell: UnifiedNativeAdBaseTableViewCell {

    private let muteLabel:UILabel = {
        let _muteLabel = UILabel()
        _muteLabel.text = "静音"
        return _muteLabel
    }()
    private let muteSwitch:UISwitch = {
        let _muteSwitch = UISwitch()
        return _muteSwitch
    }()
    private let pauseButton:UIButton = {
        let _pauseButton = UIButton()
        _pauseButton.setTitle("pause", for: .normal)
        return _pauseButton
    }()
    private let playButton:UIButton = {
        let _playButton = UIButton()
        _playButton.setTitle("play", for: .normal)
        return _playButton
    }()
    private let stopButton:UIButton = {
        let _stopButton = UIButton()
        _stopButton.setTitle("stop", for: .normal)
        return _stopButton
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(muteLabel)
        self.addSubview(muteSwitch)
        self.addSubview(pauseButton)
        self.addSubview(playButton)
        self.addSubview(stopButton)
        
        muteSwitch.addTarget(self, action: #selector(clickMuteSwitch), for: .valueChanged)
        pauseButton.addTarget(self, action: #selector(clickPause), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(clickPlay), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(clickStop), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.muteLabel.isHidden = true
        self.muteSwitch.isHidden = true
        self.pauseButton.isHidden = true
        self.playButton.isHidden = true
        self.stopButton.isHidden = true
    }
    
    @objc func clickMuteSwitch(){
        self.adView.mediaView.muteEnable(self.muteSwitch.isOn)
    }
    
    @objc func clickPlay(){
        self.adView.mediaView.play()
    }
    
    @objc func clickPause(){
        self.adView.mediaView.pause()
    }
    
    @objc func clickStop(){
        self.adView.mediaView.stop()
    }
    
    override func setupWithUnifiedNativeAdDataObject(dataObject: GDTUnifiedNativeAdDataObject, delegate: GDTUnifiedNativeAdViewDelegate, vc: UIViewController) {
        self.adView.delegate = delegate
        self.adView.viewController = vc
        var imageRate:CGFloat = 16 / 9.0
        if dataObject.imageHeight > 0 {
            imageRate = CGFloat(dataObject.imageWidth / dataObject.imageHeight)
        }
        let width = UIScreen.main.bounds.width - 16
        self.adView.backgroundColor = UIColor.gray
        self.adView.iconImageView.frame = CGRect(x: 8, y: 8, width: 60, height: 60);
        self.adView.clickButton.frame = CGRect(x: width - 68, y: 8, width: 60, height: 44);
        self.adView.titleLabel.frame = CGRect(x: 76, y: 8, width: 250, height: 30);
        self.adView.descLabel.frame = CGRect(x: 8, y: 76, width: width, height: 30);
        let imageWidth:CGFloat = width
        self.adView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 122 + imageWidth / imageRate)
        
        self.adView.mediaView.frame = CGRect(x: 8, y: 114, width: imageWidth, height: imageWidth / imageRate)
        self.adView.logoView.frame = CGRect(x: self.adView.frame.width - kGDTLogoImageViewDefaultWidth, y: self.adView.frame.height - kGDTLogoImageViewDefaultHeight, width: kGDTLogoImageViewDefaultWidth, height: kGDTLogoImageViewDefaultHeight)
        self.adView.setupWithUnifiedNativeAdObject(unifiedNativeDataObject: dataObject)
        self.adView.registerDataObject(dataObject, clickableViews: [self.adView.clickButton,self.adView.iconImageView,self.adView.imageView])
        self.adView.mediaView.setPlayButtonImage(UIImage(named: "play"), size: CGSize(width: 60, height: 60))
        if dataObject.isVideoAd {
            self.muteLabel.frame = CGRect(x: 76, y: 40, width: 50, height: 40);
            self.muteLabel.isHidden = false;
            self.muteSwitch.frame = CGRect(x: 120, y: 40, width: 50, height: 40);
            self.muteSwitch.isOn = dataObject.videoConfig.videoMuted;
            self.muteSwitch.isHidden = false;
            self.playButton.frame = CGRect(x: 170, y: 40, width: 40, height: 40);
            self.playButton.isHidden = false;
            self.pauseButton.frame = CGRect(x: 210, y: 40, width: 50, height: 40);
            self.pauseButton.isHidden = false;
            self.stopButton.frame = CGRect(x: 260, y: 40, width: 40, height: 40);
            self.stopButton.isHidden = false;
        }
    }

    override class func cellHeightWithUnifiedNativeAdDataObject(dataObject: GDTUnifiedNativeAdDataObject) -> CGFloat {
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
