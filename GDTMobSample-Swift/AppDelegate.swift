//
//  AppDelegate.swift
//  GDTMobSample-Swift
//
//  Created by nimomeng on 2018/8/14.
//  Copyright © 2018 Tencent. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GDTSplashAdDelegate {
    var viewController: ViewController?
    var window: UIWindow?
    var splash: GDTSplashAd!
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        viewController = ViewController()
        let navigationController = GDTNavigationController(rootViewController: viewController!)
        navigationController.navigationBar.topItem?.title = "广告形式   ver \(GDTSDKConfig.sdkVersion()!)"
        navigationController.navigationBar.isTranslucent = false
        let dict:NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18)]
        //标题颜色
        navigationController.navigationBar.titleTextAttributes = dict as? [NSAttributedStringKey : AnyObject]
        navigationController.navigationBar.barStyle = UIBarStyle.blackOpaque
        navigationController.navigationBar.isTranslucent = false
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            splash = GDTSplashAd.init(appId: Constant.appID, placementId: Constant.placementID)
            splash.delegate = self
            
            var splashImage = UIImage(named: "SplashNormal-swift")
            if Util.isIphoneX() {
                splashImage = UIImage(named: "SplashX-swift")
            } else if Util.isSmallIphone() {
                splashImage = UIImage(named: "SplashSmall-swift")
            }
            splash.backgroundImage = splashImage
            splash.fetchDelay = 3
            splash.loadAndShow(in: window)
        }
        
        return true

    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

//    MARK:GDTSplashAdDelegate
    func splashAdSuccessPresentScreen(_ splashAd: GDTSplashAd!) {
        print(#function)
    }
    
    func splashAdFail(toPresent splashAd: GDTSplashAd!, withError error: Error!) {
        print(#function,error)
        self.splash = nil
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
        self.splash = nil
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

