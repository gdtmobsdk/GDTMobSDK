//
//  HybridAdViewController.swift
//  GDTMobSample-Swift
//
//  Created by royqpwang on 2019/3/9.
//  Copyright © 2019 Tencent. All rights reserved.
//

import UIKit

class HybridAdViewController: UIViewController, GDTHybridAdDelegate {
    
    @IBOutlet weak var urlTestField: UITextField!
    override func viewDidLoad() {
        
    }
    @IBAction func clickLoad(_ sender: Any) {
        GDTSDKConfig.registerAppId(Constant.appID)
        let hybridAD = GDTHybridAd.init(type: GDTHybridAdOptions.rewardVideo)
        hybridAD.delegate = self
        hybridAD.load(withUrl: self.urlTestField.text!)
        hybridAD.show(withRootViewController: self)
    }
    
    func gdt_hybridAdDidPresented(_ hybridAd: GDTHybridAd) {
        print("浏览器展示成功")
    }
    
    func gdt_hybridAdDidClose(_ hybridAd: GDTHybridAd) {
        print("浏览器关闭")
    }
    
    func gdt_hybridAdLoadURLSuccess(_ hybridAd: GDTHybridAd) {
        print("URL 加载成功")
    }
    
    func gdt_hybridAd(_ hybridAd: GDTHybridAd, didFailWithError error: Error) {
        let code = (error as NSError).code
        if (code == 3001) {
            print("加载失败")
        }
    }
}
