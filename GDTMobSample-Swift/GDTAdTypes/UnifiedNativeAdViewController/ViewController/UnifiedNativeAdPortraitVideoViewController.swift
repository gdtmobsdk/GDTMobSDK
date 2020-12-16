//
//  UnifiedNativeAdPortraitVideoViewController.swift
//  GDTMobSample-Swift
//
//  Created by 胡城阳 on 2019/10/28.
//  Copyright © 2019 Tencent. All rights reserved.
//

import UIKit

class UnifiedNativeAdPortraitVideoViewController: UnifiedNativeAdBaseViewController,GDTUnifiedNativeAdDelegate,UITableViewDelegate,UITableViewDataSource,GDTUnifiedNativeAdViewDelegate {

    private var nativeAd:GDTUnifiedNativeAd?
    private var tableView:UITableView?
    private var dataArray:Array<Any> = []
    private let lastCell:UITableViewCell? = nil
    private let closeButton:UIButton = {
        let _closeButton = UIButton()
        _closeButton.setTitle("关闭", for: .normal)
        _closeButton.backgroundColor = UIColor.gray
        return _closeButton
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        //---- 视频配置项，整段注释可使用外部VC开关控制
        self.placementId = "3080163449595027"
        self.videoConfig!.videoMuted = false
        self.videoConfig!.autoPlayPolicy = GDTVideoAutoPlayPolicy.always
        self.videoConfig!.userControlEnable = true
        self.videoConfig!.autoResumeEnable = false
        self.videoConfig!.detailPageEnable = false
        //-----
        
        
        self.nativeAd = GDTUnifiedNativeAd.init(appId: self.appId, placementId: self.placementId)
        self.nativeAd!.delegate = self;
        self.nativeAd!.maxVideoDuration = self.maxVideoDuration;
        self.nativeAd!.loadAd(withAdCount: 10)
        // Do any additional setup after loading the view.
    }
    
    func shouldAutorotate()->Bool{
     return false
    }
    
    func initView(){
        tableView = UITableView(frame: self.view.bounds)
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.isPagingEnabled = true
        tableView!.separatorStyle = .none
        tableView!.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.flexibleWidth.rawValue | UIViewAutoresizing.flexibleHeight.rawValue)
        self.view.addSubview(tableView!)
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView!.register(DemoPlayerTableViewCell.self, forCellReuseIdentifier: "DemoPlayerTableViewCell")
        self.tableView!.register(UnifiedNativeAdPortraitVideoTableViewCell.self, forCellReuseIdentifier: "UnifiedNativeAdPortraitVideoTableViewCell")
        closeButton.addTarget(self, action: #selector(clickClose), for: .touchUpInside)
        self.view.addSubview(closeButton)
        self.closeButton.frame = CGRect(x: 20, y: 60, width: 60, height: 40)
    }
    
    @objc func clickClose(){
        self.dismiss(animated: true, completion: nil)
    }
}

extension UnifiedNativeAdPortraitVideoViewController{
    func gdt_unifiedNativeAdLoaded(_ unifiedNativeAdDataObjects: [GDTUnifiedNativeAdDataObject]?, error: Error?) {
        if (error != nil) {
            print("error is \(error!)")
        }
        var dataArray:Array<Any> = []
        if unifiedNativeAdDataObjects != nil {
            for dataObject in unifiedNativeAdDataObjects! {
                dataArray.append(dataObject)
                dataArray.append("demo")
                print("eCPM:\(dataObject.eCPM) eCPMLevel:\(dataObject.eCPMLevel)")
            }
        }
        self.dataArray = dataArray
        self.tableView!.reloadData()
    }
}


extension UnifiedNativeAdPortraitVideoViewController{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.dataArray[indexPath.row]
        if item is GDTUnifiedNativeAdDataObject {
            let nativeAdDataObject:GDTUnifiedNativeAdDataObject = item as! GDTUnifiedNativeAdDataObject
            nativeAdDataObject.videoConfig = self.videoConfig
            let cell:UnifiedNativeAdPortraitVideoTableViewCell = self.tableView!.dequeueReusableCell(withIdentifier: "UnifiedNativeAdPortraitVideoTableViewCell") as! UnifiedNativeAdPortraitVideoTableViewCell
            cell.setupWithUnifiedNativeAdDataObject(dataObject: nativeAdDataObject, delegate: self, vc: self)
            return cell
        }else{
            let cell:DemoPlayerTableViewCell = self.tableView!.dequeueReusableCell(withIdentifier: "DemoPlayerTableViewCell") as! DemoPlayerTableViewCell
            cell.backgroundColor = UIColor.red
            return cell
        }
    }
    
}
