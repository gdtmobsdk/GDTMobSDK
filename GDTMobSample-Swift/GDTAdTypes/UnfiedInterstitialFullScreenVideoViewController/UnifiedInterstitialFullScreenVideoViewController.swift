//
//  UnifiedInterstitialFullScreenVideoViewController.swift
//  GDTMobSample-Swift
//
//  Created by 龙锐 on 2020/4/29.
//  Copyright © 2020 Tencent. All rights reserved.
//

import Foundation
import UIKit
class UnifiedInterstiutialFullScreenVideoViewController : UIViewController,GDTUnifiedInterstitialAdDelegate{
    @IBOutlet weak var interstitialStateLabel: UILabel!
       

    @IBOutlet weak var positionIdTextField: UITextField!
    
    @IBOutlet weak var minVideoDurationLabel: UILabel!

       
    @IBOutlet weak var videoMutedSwitch: UISwitch!
    @IBOutlet weak var maxVideoDurationLabel: UILabel!
    
    @IBOutlet weak var maxVideoDurationSlider: UISlider!
    @IBOutlet weak var minVideoDurationSlider: UISlider!
  
       
       
       private var interstitial: GDTUnifiedInterstitialAd?
       private var placeId : String?
       private let INTERSTITIAL_STATE_TEXT = "插屏2.0全屏状态"
       
       override func viewDidLoad() {
           super.viewDidLoad()
           maxVideoDurationLabel.text = String.init(format:"视频最大长: %.f",maxVideoDurationSlider.value)
           maxVideoDurationSlider.addTarget(self, action: #selector(sliderMaxVideoDurationChanged), for: .valueChanged)
           
           minVideoDurationLabel.text = String.init(format:"视频最小长: %.f",minVideoDurationSlider.value)
           minVideoDurationSlider.addTarget(self, action: #selector(sliderMinVideoDurationChanged), for: .valueChanged)
           // Do any additional setup after loading the view.
       }
       
       override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           super.touchesBegan(touches, with: event)
           view.endEditing(true)
       }
       
       @IBAction func loadAd(_ sender: Any) {
           if (interstitial != nil) {
               interstitial?.delegate = nil
               interstitial = nil
           }
           self.placeId = self.positionIdTextField.text?.count ?? 0 > 0 ? self.positionIdTextField.text : self.positionIdTextField.placeholder
           self.interstitial = GDTUnifiedInterstitialAd.init(placementId: self.placeId!)
           interstitial?.videoMuted = videoMutedSwitch.isOn
           interstitial?.maxVideoDuration = Int(maxVideoDurationSlider.value)
           interstitial?.minVideoDuration = Int(minVideoDurationSlider.value)
           interstitial?.delegate = self
           
           interstitial?.loadFullScreenAd()       }
       
       @IBAction func showAd(_ sender: Any) {
        self.interstitial?.presentFullScreenAd(fromRootViewController: self)
       }
       
       @objc func sliderMaxVideoDurationChanged (){
           maxVideoDurationLabel.text = String.init(format:"视频最大长: %.f",maxVideoDurationSlider.value)
       }
       @objc func sliderMinVideoDurationChanged (){
           minVideoDurationLabel.text = String.init(format:"视频最小长: %.f",minVideoDurationSlider.value)
       }


       //GDTUnifiedInterstitialAdDelegate
       
       func unifiedInterstitialSuccess(toLoad unifiedInterstitial: GDTUnifiedInterstitialAd) {
           interstitialStateLabel.text = "\(INTERSTITIAL_STATE_TEXT): load successfully."
       }
       
       func unifiedInterstitialFail(toLoad unifiedInterstitial: GDTUnifiedInterstitialAd, error: Error) {
           interstitialStateLabel.text = "\(INTERSTITIAL_STATE_TEXT): load error."
       }
       
       func unifiedInterstitialWillPresentScreen(_ unifiedInterstitial: GDTUnifiedInterstitialAd) {
           interstitialStateLabel.text = "\(INTERSTITIAL_STATE_TEXT): is going to present."
       }
       
       func unifiedInterstitialDidPresentScreen(_ unifiedInterstitial: GDTUnifiedInterstitialAd) {
           interstitialStateLabel.text = "\(INTERSTITIAL_STATE_TEXT): successfully presented."
       }
       
       func unifiedInterstitialDidDismissScreen(_ unifiedInterstitial: GDTUnifiedInterstitialAd) {
           interstitialStateLabel.text = "\(INTERSTITIAL_STATE_TEXT): finish presenting."
       }
       
       func unifiedInterstitialWillLeaveApplication(_ unifiedInterstitial: GDTUnifiedInterstitialAd) {
           print(#function)
       }
       
       func unifiedInterstitialWillExposure(_ unifiedInterstitial: GDTUnifiedInterstitialAd) {
           print(#function)
       }
       
       func unifiedInterstitialClicked(_ unifiedInterstitial: GDTUnifiedInterstitialAd) {
           print(#function)
       }
       
       func unifiedInterstitialAdWillPresentFullScreenModal(_ unifiedInterstitial: GDTUnifiedInterstitialAd) {
           print(#function)
       }
       
       func unifiedInterstitialAdDidPresentFullScreenModal(_ unifiedInterstitial: GDTUnifiedInterstitialAd) {
           print(#function)
       }
       
       func unifiedInterstitialAdWillDismissFullScreenModal(_ unifiedInterstitial: GDTUnifiedInterstitialAd) {
           print(#function)
       }
       
       func unifiedInterstitialAdDidDismissFullScreenModal(_ unifiedInterstitial: GDTUnifiedInterstitialAd) {
           print(#function)
       }

}
