//
//  RewardVideoViewController.swift
//  GDTMobSample-Swift
//
//  Created by royqpwang on 2018/10/15.
//  Copyright © 2018年 Tencent. All rights reserved.
//

import UIKit


class RewardVideoViewController: UIViewController, GDTRewardedVideoAdDelegate {

    private var rewardVideoAd:GDTRewardVideoAd!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var placementIdTextField: UITextField!
    
    @IBOutlet weak var videoMutedSwitch: UISwitch!
    @IBOutlet weak var audioSessionSwitch: UISwitch!
    
    var supportOrientation: UIInterfaceOrientation!
    var placementId : String?
  
    //    var portraitAdIdAction : UIAlertAction
//
 
    override func viewDidLoad() {
        super.viewDidLoad()
       // configAlertController()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    func configAlertController()->UIAlertController{
        

              let PORTRAIT_AD_PLACEMENTID = "8020744212936426";
               let PORTRAIT_LANDSCAPE_AD_PLACEMENTID = "9070098640008762";
               let MEDIATION_AD_PLACEMENTID = "5040546242831432"

              let changePosIdController = UIAlertController(title: "请选择广告类型", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            

                   
                   let device = UIDevice.current
                   if(device.orientation == UIDeviceOrientation.portrait){
                       let portraitAdIdAction = UIAlertAction(title: "竖屏广告", style: .default, handler: {(UIAlertAction) in
                           self.placementIdTextField.placeholder = PORTRAIT_AD_PLACEMENTID
                           return;
                       })
                       changePosIdController.addAction(portraitAdIdAction)
                   }else{
                       let portraitAdIdAction = UIAlertAction(title: "横屏广告", style: .default, handler: {(UIAlertAction) in
                           self.placementIdTextField.placeholder = PORTRAIT_AD_PLACEMENTID
                           return;
                       })
                       changePosIdController.addAction(portraitAdIdAction)
                   }
                   
                   let portraitLandscapeAdIdAction = UIAlertAction(title: "横竖屏", style: .default, handler: {(UIAlertAction) in
                       self.placementIdTextField.placeholder = PORTRAIT_LANDSCAPE_AD_PLACEMENTID
                       return;
                   })
                   changePosIdController.addAction(portraitLandscapeAdIdAction)
                   let mediationAdIdAction = UIAlertAction(title: "流量分配广告", style: .default, handler: {(UIAlertAction) in
                       self.placementIdTextField.placeholder = MEDIATION_AD_PLACEMENTID
                       return;
                   })
                   changePosIdController.addAction(mediationAdIdAction)
                   return changePosIdController
    }
    @IBAction func changePlacementId(_ sender: UIButton) {
//            self.present(changePosIdController, animated: false, completion: {
//                self.clicktoBackController()
//            })
        let changePosIdController=configAlertController()
        self.present(changePosIdController, animated: false, completion: nil)

        //
       
        
    }
//    func clicktoBackController(){
//
//        var backToMainView = UIView()
//        if let arrayViews = UIApplication.shared.keyWindow?.subviews{
//        for x in arrayViews {
//            let viewNameStr = NSString(format: "%s", object_getClassName(x))
//            if viewNameStr.isEqual(to: "UITransitionView"){
//            backToMainView = x.subviews[0]
//                break;
//            }
//        }
//        }
//        //    UIView *backToMainView = [arrayViews.lastObject subviews][0];
//        backToMainView.isUserInteractionEnabled = true
//        let mybackTap = UITapGestureRecognizer(target: self, action: #selector(backTap))
//        backToMainView.addGestureRecognizer(mybackTap)
//           }
//
//        @objc func backTap(){
//               self.changePosIdController.dismiss(animated: true, completion: nil)
//           }
//

    
    @IBAction func loadAd(_ sender: UIButton) {
        self.placementId = placementIdTextField.text?.count ?? 0 > 0 ? placementIdTextField.text : placementIdTextField.placeholder

        self.rewardVideoAd = GDTRewardVideoAd.init(placementId: self.placementId!)
        self.rewardVideoAd.videoMuted = self.videoMutedSwitch.isOn
        
        self.rewardVideoAd.delegate = self
        self.rewardVideoAd.load()
    }
    
    
    @IBAction func playVideo(_ sender: Any) {
        if self.rewardVideoAd != nil{
        
        if (self.rewardVideoAd.expiredTimestamp <= Int(Date.init().timeIntervalSince1970)) {
            self.statusLabel.text = "广告已过期，请重新拉取"
            return
        }
        if (!self.rewardVideoAd.isAdValid) {
            self.statusLabel.text = "广告失效，请重新拉取"
            return
        }
        
       // self.rewardVideoAd.show(fromRootViewController: self)
        GDTSDKConfig.enableDefaultAudioSessionSetting(!self.audioSessionSwitch.isOn)
        
        self.rewardVideoAd.show(fromRootViewController: self)
        
        if self.audioSessionSwitch.isOn {
            // AVAu检测不到，没改过来
        }
        }
    }
    
  
    
    @IBAction func changeOrientation(_ sender: UIButton) {
        if UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation) {
                  self.supportOrientation = UIInterfaceOrientation.landscapeRight
              } else {
                  self.supportOrientation = UIInterfaceOrientation.portrait
              }
              UIDevice.current.setValue(self.supportOrientation.rawValue, forKey: "orientation")
    }
    
    override var shouldAutorotate: Bool
    {
        return true
    }
    
    func gdt_rewardVideoAdDidLoad(_ rewardedVideoAd: GDTRewardVideoAd) {
        self.statusLabel.text = "广告数据加载成功"
    }
    
    func gdt_rewardVideoAdVideoDidLoad(_ rewardedVideoAd: GDTRewardVideoAd) {
        self.statusLabel.text = "视频文件加载成功"
    }
    
    func gdt_rewardVideoAdWillVisible(_ rewardedVideoAd: GDTRewardVideoAd) {
        print("视频播放页即将打开")
    }
    
    func gdt_rewardVideoAdDidExposed(_ rewardedVideoAd: GDTRewardVideoAd) {
        print("广告已曝光")
    }
    
    func gdt_rewardVideoAdDidClicked(_ rewardedVideoAd: GDTRewardVideoAd) {
        self.statusLabel.text = "广告已关闭"
        print("广告已关闭")
    }
    
    func gdt_rewardVideoAdDidClose(_ rewardedVideoAd: GDTRewardVideoAd) {
        print("广告已点击")
    }
    
    func gdt_rewardVideoAd(_ rewardedVideoAd: GDTRewardVideoAd, didFailWithError error: Error) {
        let code = (error as NSError).code
        if (code == 4014) {
            print("请拉取到广告后再调用展示接口")
            self.statusLabel.text = "请拉取到广告后再调用展示接口"
        } else if (code == 4016) {
            print("应用方向与广告位支持方向不一致")
            self.statusLabel.text = "应用方向与广告位支持方向不一致"
        } else if (code == 5012) {
            print("广告已过期")
            self.statusLabel.text = "广告已过期"
        } else if (code == 4015) {
            print("广告已经播放过，请重新拉取")
            self.statusLabel.text = "广告已经播放过，请重新拉取"
        } else if (code == 5002) {
            print("视频下载失败")
            self.statusLabel.text = "视频下载失败"
        } else if (code == 5003) {
            print("视频播放失败")
            self.statusLabel.text = "视频播放失败"
        } else if (code == 5004) {
            print("没有合适的广告")
            self.statusLabel.text = "没有合适的广告"
        } else if (code == 5013) {
            print("请求太频繁，请稍后再试")
            self.statusLabel.text = "请求太频繁，请稍后再试"
        }
        print("\(error)")
    }
    
    func gdt_rewardVideoAdDidRewardEffective(_ rewardedVideoAd: GDTRewardVideoAd) {
        print("播放达到激励条件")
    }
    
    func gdt_rewardVideoAdDidPlayFinish(_ rewardedVideoAd: GDTRewardVideoAd) {
        print("播放达到激励条件")
    }
    
}
