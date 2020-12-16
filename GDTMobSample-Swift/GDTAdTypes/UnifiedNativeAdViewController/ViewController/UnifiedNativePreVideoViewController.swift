//
//  UnifiedNativePreVideoViewController.swift
//  GDTMobSample-Swift
//
//  Created by 胡城阳 on 2019/10/28.
//  Copyright © 2019 Tencent. All rights reserved.
//

import UIKit

class UnifiedNativePreVideoViewController: UnifiedNativeAdBaseViewController,GDTUnifiedNativeAdDelegate,GDTUnifiedNativeAdViewDelegate,GDTMediaViewDelegate {

    private var videoContainerView:UIView?
    private var unifiedNativeAd:GDTUnifiedNativeAd?
    private var nativeAdCustomView:UnifiedNativeAdCustomView?
    private var dataObject:GDTUnifiedNativeAdDataObject?
    private var countdownLabel:UILabel?
    private var skipButton:UIButton?
    private var timer:Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        //---- 视频配置项，整段注释可使用外部VC开关控制
        //    self.placementId = @"3050349752532954"
        self.videoConfig!.videoMuted = false
        self.videoConfig!.autoPlayPolicy = GDTVideoAutoPlayPolicy.always
        self.videoConfig!.userControlEnable = true
        self.videoConfig!.autoResumeEnable = false
        self.videoConfig!.detailPageEnable = false
        self.videoConfig!.coverImageEnable = true
        self.videoConfig!.progressViewEnable = false
//-----
            
        self.unifiedNativeAd = GDTUnifiedNativeAd.init(appId: self.appId, placementId: self.placementId)
        self.unifiedNativeAd!.delegate = self;
        self.unifiedNativeAd!.maxVideoDuration = self.maxVideoDuration;
        self.unifiedNativeAd?.loadAd(withAdCount: 1 )
      
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func configView(){
        nativeAdCustomView = UnifiedNativeAdCustomView.init()
        nativeAdCustomView!.delegate = self
        
        videoContainerView = UIView()
        videoContainerView?.backgroundColor = UIColor.gray
        
        countdownLabel = UILabel()
        countdownLabel?.isHidden = true
        countdownLabel?.textColor = UIColor.red
        countdownLabel?.backgroundColor = UIColor.blue
        countdownLabel?.textAlignment = .center
        
        skipButton = UIButton()
        skipButton?.backgroundColor = UIColor.gray
        skipButton?.isHidden = true
        skipButton?.setTitle("跳过", for: .normal)
        skipButton?.addTarget(self, action: #selector(clickSkip), for: .touchUpInside)
        self.view.addSubview(self.videoContainerView!)
        self.videoContainerView?.translatesAutoresizingMaskIntoConstraints = false
        self.videoContainerView?.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.videoContainerView?.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.videoContainerView?.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.videoContainerView?.heightAnchor.constraint(equalTo: self.videoContainerView!.widthAnchor, multiplier: 9 / 16.0).isActive = true
        
        self.videoContainerView?.addSubview(nativeAdCustomView!)
        self.nativeAdCustomView!.translatesAutoresizingMaskIntoConstraints = false
        self.nativeAdCustomView!.leftAnchor.constraint(equalTo: self.videoContainerView!.leftAnchor).isActive = true
        self.nativeAdCustomView!.rightAnchor.constraint(equalTo: self.videoContainerView!.rightAnchor).isActive = true
        self.nativeAdCustomView!.topAnchor.constraint(equalTo: self.videoContainerView!.topAnchor).isActive = true
        self.nativeAdCustomView!.bottomAnchor.constraint(equalTo: self.videoContainerView!.bottomAnchor).isActive = true
        
        self.nativeAdCustomView!.clickButton.translatesAutoresizingMaskIntoConstraints = false
        self.nativeAdCustomView!.clickButton.rightAnchor.constraint(equalTo: self.nativeAdCustomView!.rightAnchor, constant: -10).isActive = true
        self.nativeAdCustomView!.clickButton.bottomAnchor.constraint(equalTo: self.nativeAdCustomView!.bottomAnchor, constant: -10).isActive = true
        self.nativeAdCustomView!.clickButton.widthAnchor.constraint(equalToConstant: 88).isActive = true
        self.nativeAdCustomView!.clickButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.nativeAdCustomView!.clickButton.backgroundColor = UIColor.orange
        
        self.nativeAdCustomView!.addSubview(countdownLabel!)
        self.countdownLabel!.translatesAutoresizingMaskIntoConstraints = false
        self.countdownLabel!.rightAnchor.constraint(equalTo: self.nativeAdCustomView!.rightAnchor, constant: -10).isActive = true
        self.countdownLabel!.topAnchor.constraint(equalTo: self.nativeAdCustomView!.topAnchor, constant: 10).isActive = true
        self.countdownLabel!.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.countdownLabel!.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.nativeAdCustomView!.addSubview(skipButton!)
        self.skipButton!.translatesAutoresizingMaskIntoConstraints = false
        self.skipButton!.rightAnchor.constraint(equalTo: self.countdownLabel!.leftAnchor, constant: -10).isActive = true
        self.skipButton!.topAnchor.constraint(equalTo: self.countdownLabel!.topAnchor).isActive = true
        self.skipButton!.widthAnchor.constraint(equalToConstant: 60).isActive = true
        self.skipButton!.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.nativeAdCustomView!.addSubview(nativeAdCustomView!.logoView)
        self.nativeAdCustomView!.logoView!.translatesAutoresizingMaskIntoConstraints = false
        self.nativeAdCustomView!.logoView.rightAnchor.constraint(equalTo: self.nativeAdCustomView!.rightAnchor).isActive = true
        self.nativeAdCustomView!.logoView.bottomAnchor.constraint(equalTo: self.nativeAdCustomView!.bottomAnchor).isActive = true
        self.nativeAdCustomView!.logoView.widthAnchor.constraint(equalToConstant: kGDTLogoImageViewDefaultWidth).isActive = true
        self.nativeAdCustomView!.logoView.heightAnchor.constraint(equalToConstant: kGDTLogoImageViewDefaultHeight).isActive = true
    }
    
    func reloadAd(){
        self.dataObject?.videoConfig = self.videoConfig
        self.nativeAdCustomView!.viewController = self
        self.nativeAdCustomView!.registerDataObject(self.dataObject, clickableViews: [self.nativeAdCustomView!.clickButton])
        if self.dataObject!.isAppAd {
            self.nativeAdCustomView!.clickButton.setTitle("点击下载", for: .normal)
        }else{
            self.nativeAdCustomView!.clickButton.setTitle("查看详情", for: .normal)
        }
        self.nativeAdCustomView!.mediaView.delegate = self
        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(timeUpdate), userInfo: nil, repeats: true)
    }
    
    @objc func timeUpdate(){
        let playTime = self.nativeAdCustomView!.mediaView.videoPlayTime()
        let duration = self.nativeAdCustomView!.mediaView.videoDuration()
        if duration > 0 {
            self.countdownLabel?.isHidden = false
        }
        if playTime > 5000 {
            self.skipButton?.isHidden = false
        }
        self.countdownLabel?.text = String(format: "%d", Int(duration - playTime) / 1000)
    }
    
    @objc func clickSkip(){
        self.timer?.invalidate()
        self.timer = nil
        self.nativeAdCustomView!.removeFromSuperview()
        self.nativeAdCustomView!.unregisterDataObject()
    }

}


extension UnifiedNativePreVideoViewController{
    func gdt_unifiedNativeAdLoaded(_ unifiedNativeAdDataObjects: [GDTUnifiedNativeAdDataObject]?, error: Error?) {
        
            if error == nil && unifiedNativeAdDataObjects != nil {
                print("成功请求到广告数据")
                self.dataObject = unifiedNativeAdDataObjects![0]
                print("eCPM:\(dataObject!.eCPM) eCPMLevel:\(String(describing: dataObject!.eCPMLevel))")
                if self.dataObject!.isVideoAd {
                    self.reloadAd()
                }
            }
            
        if error != nil {
            let code = (error! as NSError).code
                if code == 5004 {
                    print("没匹配的广告，禁止重试，否则影响流量变现效果");
                } else if code == 5005 {
                    print("流量控制导致没有广告，超过日限额，请明天再尝试");
                } else if code == 5009 {
                    print("流量控制导致没有广告，超过小时限额");
                } else if code == 5006 {
                    print("包名错误");
                } else if code == 5010 {
                    print("广告样式校验失败");
                } else if code == 3001 {
                    print("网络错误");
                } else {
                    print("\(String(describing: error))");
                }
            }
            
        }
    func gdt_mediaViewDidPlayFinished(_ mediaView: GDTMediaView!) {
        print(#function)
        self.timer?.invalidate()
        self.timer = nil
        self.nativeAdCustomView!.removeFromSuperview()
        self.nativeAdCustomView!.unregisterDataObject()
    }
    
    func gdt_unifiedNativeAdViewWillExpose(_ unifiedNativeAdView: GDTUnifiedNativeAdView!) {
            print("广告被曝光")
            print(#function)
        }
    
    func gdt_unifiedNativeAdViewDidClick(_ unifiedNativeAdView: GDTUnifiedNativeAdView!) {
            print("广告被点击")
            print(#function)
        }
    
    func gdt_unifiedNativeAdDetailViewClosed(_ unifiedNativeAdView: GDTUnifiedNativeAdView!) {
            print("广告详情页已关闭")
            print(#function)
        }
    
    func gdt_unifiedNativeAdViewApplicationWillEnterBackground(_ unifiedNativeAdView: GDTUnifiedNativeAdView!) {
            print("广告进入后台")
            print(#function)
        }
    
    func gdt_unifiedNativeAdDetailViewWillPresentScreen(_ unifiedNativeAdView: GDTUnifiedNativeAdView!) {
            print("广告详情页面即将打开")
            print(#function)
        }
    
    func gdt_unifiedNativeAdView(_ nativeExpressAdView: GDTUnifiedNativeAdView!, playerStatusChanged status: GDTMediaPlayerStatus, userInfo: [AnyHashable : Any]! = [:]) {
        print("视频广告状态变更")
        switch status {
        case .initial:
            print("视频初始化")
        case .loading:
            print("视频加载中")
        case .started:
            print("视频开始播放")
        case .paused:
            print("视频暂停")
        case .stoped:
            print("视频停止")
        case .error:
            print("视频播放出错")
        default:
            break
        }
        if userInfo != nil {
            let videoDuration: CGFloat = userInfo?[kGDTUnifiedNativeAdKeyVideoDuration] as! CGFloat
            print("视频广告长度为\(videoDuration)")
        }
    }
}
