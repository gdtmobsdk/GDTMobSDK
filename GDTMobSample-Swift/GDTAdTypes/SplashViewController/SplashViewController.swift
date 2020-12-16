//
//  SplashViewController.swift
//  GDTMobSample-Swift
//
//  Created by nimomeng on 2018/8/15.
//  Copyright © 2018 Tencent. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController,GDTSplashAdDelegate {

    private var splashAd: GDTSplashAd!
    private var bottomView: UIView!
    @IBOutlet weak var placementIdTextField: UITextField!
    @IBOutlet weak var logoHeightTextField: UITextField!
    @IBOutlet weak var logoDescLabel: UILabel!
    
    @IBOutlet weak var tipsLabel: UILabel!
    var placeID:String?
    var isParallelload:Bool = false
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoHeightTextField.text = String.init(format:"%.f",floor(UIScreen.main.bounds.height * 0.25))
        self.tipsLabel.text = nil

        logoDescLabel.text = "底部logo高度上限：\n\(UIScreen.main.bounds.height)屏幕高度 * 25% = \(UIScreen.main.bounds.height * 0.25)"
    }
    

    
    @IBAction func clickLoad(_ sender: Any) {
        self.isParallelload = true
        self.tipsLabel.text = nil
        
        self.placeID = placementIdTextField.text?.count ?? 0 > 0 ? placementIdTextField.text : placementIdTextField.placeholder
        self.splashAd = GDTSplashAd.init(placementId: self.placeID)
        self.splashAd.delegate = self
        self.splashAd.fetchDelay = 5
        
        var splashImage = UIImage.init(named: "SplashNormal")
               if Util.isIphoneX() {
                   splashImage = UIImage.init(named: "SplashX")
               } else if Util.isSmallIphone() {
                   splashImage = UIImage.init(named: "SplashSmall")
               }
        self.splashAd.backgroundImage = splashImage
        self.splashAd.load()
        self.tipsLabel.text = "拉取中.."
   
    }
    
    @IBAction func clickShowAd(_ sender: UIButton) {
        self.tipsLabel.text = nil
        if (self.isParallelload){
               let logoHeight = CGFloat(Double(logoHeightTextField.text!)!)
               if (logoHeight > 0 && logoHeight <= UIScreen.main.bounds.height * 0.25) {
                   bottomView = UIView.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.main.bounds.size.width, height: logoHeight)))
                   bottomView.backgroundColor = .white

                   let logo = UIImageView.init(image: UIImage.init(named: "SplashLogo-swift"))
                   logo.accessibilityIdentifier = "splash_ad"
                   logo.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 311, height: 47))
                   logo.center = bottomView.center
                   bottomView.addSubview(logo)
                   
                   let window = UIApplication.shared.keyWindow
                   self.splashAd.show(in: window, withBottomView:  bottomView, skip: nil)
               }
           }
    }

    
    @IBAction func preLoadContractAd(_ sender: UIButton) {
        self.isParallelload = false
                      self.placeID = placementIdTextField.text?.count ?? 0 > 0 ? placementIdTextField.text : placementIdTextField.placeholder
                             
                             // MARK:这里画有问题
              GDTSplashAd.preloadSplashOrder(withPlacementId: self.placeID)
    }
    //    MARK:GDTSplashAdDelegate
    func splashAdSuccessPresentScreen(_ splashAd: GDTSplashAd!) {
        print(#function)
    }
    
    func splashAdDidLoad(_ splashAd: GDTSplashAd!) {
        self.tipsLabel.text = "拉取成功"
        print(#function)
    }

    func splashAdFail(toPresent splashAd: GDTSplashAd!, withError error: Error!) {
        print(#function,error)
    }

    func splashAdExposured(_ splashAd: GDTSplashAd!) {
        print(#function)
    }

    func splashAdClicked(_ splashAd: GDTSplashAd!) {
        print(#function)
    }

    func splashAdApplicationWillEnterBackground(_ splashAd: GDTSplashAd!) {
        print(#function)
    }

    func splashAdWillClosed(_ splashAd: GDTSplashAd!) {
        print(#function)
        self.splashAd = nil
    }

    func splashAdClosed(_ splashAd: GDTSplashAd!) {
        print(#function)
    }

    func splashAdDidPresentFullScreenModal(_ splashAd: GDTSplashAd!) {
        print(#function)
    }

    func splashAdWillDismissFullScreenModal(_ splashAd: GDTSplashAd!) {
        print(#function)
    }

    func splashAdDidDismissFullScreenModal(_ splashAd: GDTSplashAd!) {
        print(#function)
    }


}
