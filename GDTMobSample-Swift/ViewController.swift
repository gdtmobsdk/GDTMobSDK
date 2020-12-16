//
//  ViewController.swift
//  GDTMobSample-Swift
//
//  Created by nimomeng on 2018/8/14.
//  Copyright © 2018 Tencent. All rights reserved.
//

import UIKit
import AdSupport

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    private var table : UITableView!
    private var demoArray: Array<String> = ["自渲染2.0",
                                    "开屏广告",
                                    "原生模板广告",
                                    "原生视频模板广告",
                                    "激励视频广告",
                                    "HybridAd",
                                    "Banner2.0",
                                    "插屏2.0",
                                    "插屏2.0全屏视频",
                                    "获取IDFA"]
    
    private var demoDict: Dictionary = [
                                "开屏广告":"SplashViewController",
                                "原生模板广告":"NativeExpressAdViewController",
                                "原生视频模板广告":"NativeExpressVideoAdViewController",
                                "激励视频广告":"RewardVideoViewController",
                                "自渲染2.0":"UnifiedNativeAdViewController",
                                "HybridAd":"HybridAdViewController",
                                "Banner2.0":"UnifiedBannerViewController",
                                "插屏2.0":"UnifiedInterstitialViewController",
                                "插屏2.0全屏视频":"UnifiedInterstitialFullScreenVideoViewController",
                                "获取IDFA":"1"]
    
    private let reusableTableViewCellID = "SimpleTableIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    init tableView
    private func initTableView() {
        table = UITableView(frame: self.view.bounds)
        table.frame.origin.y = 44
        self.view.addSubview(table)
        table.translatesAutoresizingMaskIntoConstraints = false
        
        let viewConstraints:[NSLayoutConstraint] = [
            NSLayoutConstraint.init(item: table, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint.init(item: table, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0),
            NSLayoutConstraint.init(item: table, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0),
            NSLayoutConstraint.init(item: table, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0)]
        self.view.addConstraints(viewConstraints)
        
        table.delegate = self
        table.dataSource = self
        table.reloadData()
    }
    
    //    MARK:UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: reusableTableViewCellID)
        cell.textLabel?.text = self.demoArray[indexPath.row]
        return cell
    }
    
    //    MARK:UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vcType = demoArray[indexPath.row]
        let vc:UIViewController?
        
        switch vcType {
//        case "Banner":
//            vc = BannerViewController(nibName: demoDict[vcType], bundle: nil)
//        case "插屏":
//            vc = InterstitialViewController(nibName: demoDict[vcType], bundle: nil)
//        case "原生广告":
//            vc = NativeViewController(nibName: demoDict[vcType], bundle: nil)
        case "开屏广告":
            vc = SplashViewController(nibName: demoDict[vcType], bundle: nil)
        case "原生模板广告":
            vc = NativeExpressAdViewController(nibName: demoDict[vcType], bundle: nil)
        case "原生视频模板广告":
            vc = NativeExpressVideoAdViewController(nibName: demoDict[vcType], bundle: nil)
        case "激励视频广告":
            vc = RewardVideoViewController(nibName: demoDict[vcType], bundle: nil)
        case "自渲染2.0":
            vc = UnifiedNativeAdViewController(nibName: demoDict[vcType], bundle: nil)
        case "HybridAd":
            vc = HybridAdViewController(nibName: demoDict[vcType], bundle:nil)
        case "Banner2.0":
            vc = UnifiedBannerViewController(nibName: demoDict[vcType], bundle:nil)
        case "插屏2.0":
            vc = UnifiedInterstitialViewController(nibName: demoDict[vcType], bundle:nil)
        case "插屏2.0全屏视频":
            vc = UnifiedInterstiutialFullScreenVideoViewController(nibName: demoDict[vcType], bundle:nil)
//        case "直播流广告":
//            vc = TangramViewController(nibName: demoDict[vcType], bundle:nil)

        case "获取IDFA":
            getIDFA()
            vc = nil
        default:
            vc = nil
        }
        if let viewController = vc {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else {
            NSLog("log")
        }
    }
    
    private func getIDFA() {
        let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        let alertController = UIAlertController(title: nil,
                                                message: "\(idfa) \n已经复制到你的粘贴板", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好的", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}


