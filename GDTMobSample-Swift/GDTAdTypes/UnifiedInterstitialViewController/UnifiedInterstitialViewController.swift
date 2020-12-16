//
//  UnifiedInterstitialViewController.swift
//  GDTMobSample-Swift
//
//  Created by nimomeng on 2019/3/19.
//  Copyright © 2019 Tencent. All rights reserved.
//

import UIKit

class UnifiedInterstitialViewController: UIViewController,GDTUnifiedInterstitialAdDelegate {
    
    @IBOutlet weak var interstitialStateLabel: UILabel!
    
    @IBOutlet weak var positionIdTextField: UITextField!
    @IBOutlet weak var videoMutedSwitch: UISwitch!
    @IBOutlet weak var videoAutoPlaySwitch: UISwitch!
    
    @IBOutlet weak var maxVideoDurationLabel: UILabel!
    @IBOutlet weak var minVideoDurationLabel: UILabel!
    
    @IBOutlet weak var maxVideoDurationSlider: UISlider!
    @IBOutlet weak var minVideoDurationSlider: UISlider!
    @IBOutlet weak var detailPageVideoMutedSwitch: UISwitch!
    
    
    private var interstitial: GDTUnifiedInterstitialAd?
    private var placeId : String?
    private let INTERSTITIAL_STATE_TEXT = "插屏状态"
    
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
        interstitial?.videoAutoPlayOnWWAN = videoAutoPlaySwitch.isOn
        interstitial?.detailPageVideoMuted = videoMutedSwitch.isOn
        interstitial?.maxVideoDuration = Int(maxVideoDurationSlider.value)
        interstitial?.minVideoDuration = Int(minVideoDurationSlider.value)
        interstitial?.delegate = self
        
        interstitial?.load()
    }
    
    @IBAction func showAd(_ sender: Any) {
        interstitial?.present(fromRootViewController: self)
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
