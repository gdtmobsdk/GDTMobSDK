//
//  UIViewController+Extension.swift
//  GDTMobSample-Swift
//
//  Created by 胡城阳 on 2019/10/28.
//  Copyright © 2019 Tencent. All rights reserved.
//

import UIKit

extension UIViewController {
    func newNSClassfromString(str:String) -> UnifiedNativeAdBaseViewController {
        let projectName = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String
        let className = projectName! + "." + str
        let vc = NSClassFromString(className) as! UnifiedNativeAdBaseViewController
        return vc
    }
}
