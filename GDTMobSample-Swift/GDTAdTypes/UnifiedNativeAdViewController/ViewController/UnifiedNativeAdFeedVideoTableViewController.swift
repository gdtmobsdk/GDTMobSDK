//
//  UnifiedNativeAdFeedVideoTableViewController.swift
//  GDTMobSample-Swift
//
//  Created by 胡城阳 on 2019/10/28.
//  Copyright © 2019 Tencent. All rights reserved.
//

import UIKit

class UnifiedNativeAdFeedVideoTableViewController: UnifiedNativeAdBaseViewController {

    private var unifiedNativeAd:GDTUnifiedNativeAd?
    private var adDataArray:Array<Any> = []
    private var tableView:UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.unifiedNativeAd = GDTUnifiedNativeAd.init(appId: self.appId, placementId: self.placementId)
        self.unifiedNativeAd?.delegate = self
        self.tableView = UITableView()
        self.tableView!.frame = self.view.bounds
        self.tableView!.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.flexibleWidth.rawValue | UIViewAutoresizing.flexibleHeight.rawValue)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.view.addSubview(tableView!)
        self.tableView!.register(UnifiedNativeAdFeedVideoCell.self, forCellReuseIdentifier: "UnifiedNativeAdFeedVideoCell")
        self.tableView!.register(UnifiedNativeAdImageCell.self, forCellReuseIdentifier: "UnifiedNativeAdImageCell")
        self.tableView!.register(UnifiedNativeAdThreeImageCell.self, forCellReuseIdentifier: "UnifiedNativeAdThreeImageCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.unifiedNativeAd?.maxVideoDuration = self.maxVideoDuration
        self.unifiedNativeAd?.loadAd(withAdCount: 10)
    }
    



}


extension UnifiedNativeAdFeedVideoTableViewController:GDTUnifiedNativeAdDelegate,GDTUnifiedNativeAdViewDelegate {

        func gdt_unifiedNativeAdViewWillExpose(_ unifiedNativeAdView: GDTUnifiedNativeAdView!) {
            print("广告被曝光")
        }
    
        func gdt_unifiedNativeAdViewDidClick(_ unifiedNativeAdView: GDTUnifiedNativeAdView!) {
            print("广告被点击")
        }
    
        func gdt_unifiedNativeAdDetailViewClosed(_ unifiedNativeAdView: GDTUnifiedNativeAdView!) {
            print("广告详情页已关闭")
        }
    
        func gdt_unifiedNativeAdViewApplicationWillEnterBackground(_ unifiedNativeAdView: GDTUnifiedNativeAdView!) {
            print("广告进入后台")
        }
    
        func gdt_unifiedNativeAdDetailViewWillPresentScreen(_ unifiedNativeAdView: GDTUnifiedNativeAdView!) {
            print("广告详情页面即将打开")
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
    
        func gdt_unifiedNativeAdLoaded(_ unifiedNativeAdDataObjects: [GDTUnifiedNativeAdDataObject]?, error: Error?) {
                if unifiedNativeAdDataObjects != nil {
                    self.adDataArray = unifiedNativeAdDataObjects!
                    self.tableView!.reloadData()
                }
                
                if let err = error {
                    let code = (error as! NSError).code
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

}


extension UnifiedNativeAdFeedVideoTableViewController:UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.adDataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dataObject:GDTUnifiedNativeAdDataObject = self.adDataArray[indexPath.row] as! GDTUnifiedNativeAdDataObject
        if dataObject.isVideoAd {
            return UnifiedNativeAdFeedVideoCell.cellHeightWithUnifiedNativeAdDataObject(dataObject: dataObject)
        }else if dataObject.isThreeImgsAd {
            return UnifiedNativeAdThreeImageCell.cellHeightWithUnifiedNativeAdDataObject(dataObject: dataObject)
        }else{
            return UnifiedNativeAdImageCell.cellHeightWithUnifiedNativeAdDataObject(dataObject: dataObject)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataObject:GDTUnifiedNativeAdDataObject = self.adDataArray[indexPath.row] as! GDTUnifiedNativeAdDataObject
        print("eCPM:\(dataObject.eCPM) eCPMLevel:\(dataObject.eCPMLevel ?? "")")
        
        if dataObject.isVideoAd {
            dataObject.videoConfig = self.videoConfig
            let cell:UnifiedNativeAdFeedVideoCell = tableView.dequeueReusableCell(withIdentifier: "UnifiedNativeAdFeedVideoCell") as! UnifiedNativeAdFeedVideoCell
            cell.setupWithUnifiedNativeAdDataObject(dataObject: dataObject, delegate: self, vc: self)
            dataObject
            return cell
        }else if dataObject.isThreeImgsAd {
            let cell:UnifiedNativeAdThreeImageCell = tableView.dequeueReusableCell(withIdentifier: "UnifiedNativeAdThreeImageCell") as! UnifiedNativeAdThreeImageCell
            cell.setupWithUnifiedNativeAdDataObject(dataObject: dataObject, delegate: self, vc: self)
            return cell
        }else {
            let cell:UnifiedNativeAdImageCell = tableView.dequeueReusableCell(withIdentifier: "UnifiedNativeAdImageCell") as! UnifiedNativeAdImageCell
            cell.setupWithUnifiedNativeAdDataObject(dataObject: dataObject, delegate: self, vc: self)
            return cell
        }
    }
    
}
