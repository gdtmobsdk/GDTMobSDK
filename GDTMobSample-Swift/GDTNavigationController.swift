//
//  GDTNavigationControllerViewController.swift
//  GDTMobSample-Swift
//
//  Created by nimomeng on 2018/8/17.
//  Copyright © 2018 Tencent. All rights reserved.
//

import UIKit

class GDTNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.all
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return (viewControllers.last?.preferredInterfaceOrientationForPresentation)!
    }
    
}
