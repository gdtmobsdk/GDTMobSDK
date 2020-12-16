//
//  Util.swift
//  GDTMobSample-Swift
//
//  Created by nimomeng on 2018/8/22.
//  Copyright © 2018 Tencent. All rights reserved.
//

import UIKit

class Util: NSObject {
    class public func isIphoneX() -> Bool {
        return UIScreen.main.nativeBounds.size.height-2436 == 0 ? true : false
    }
    class public func isSmallIphone() -> Bool {
        return UIScreen.main.bounds.size.height == 480 ? true : false
    }
}
