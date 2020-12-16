//
//  UnifiedNativeAdViewController.swift
//  GDTMobSample-Swift
//
//  Created by nimomeng on 2018/11/28.
//  Copyright © 2018 Tencent. All rights reserved.
//

import UIKit

class UnifiedNativeAdViewController: UIViewController{
    
    @IBOutlet weak var placementTextField: UITextField!
    @IBOutlet weak var autoPlayPolicyTextField: UITextField!
    @IBOutlet weak var shouldMuteOnVideoSwitch: UISwitch!
    @IBOutlet weak var videoDetailPageEnableSwitch: UISwitch!
    @IBOutlet weak var userControlEnableSwitch: UISwitch!
    @IBOutlet weak var autoResumeEnableSwitch: UISwitch!
    @IBOutlet weak var progressViewEnableSwitch: UISwitch!
    @IBOutlet weak var coverImageEnableSwitch: UISwitch!
    @IBOutlet weak var maxVideoDurationLabel: UILabel!
    @IBOutlet weak var maxVideoDurationSlider: UISlider!
    @IBOutlet weak var tableView: UITableView!
    
    var videoConfig:GDTVideoConfig!
    private var demoArray =
        ["图片Feed",
        "视频Feed",
        "竖版全屏视频",
        "竖版Feed视频",
        "视频贴片广告"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initVideoConfig()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.maxVideoDurationSlider.addTarget(self, action: #selector(sliderMaxVideoDurationChanged), for: .valueChanged)
        self.maxVideoDurationLabel.text = String(format:"视频最大长: %.f",maxVideoDurationSlider.value)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    @objc func sliderMaxVideoDurationChanged(){
        self.maxVideoDurationLabel.text = String(format:"视频最大长: %.f",maxVideoDurationSlider.value)
    }
    
    func initVideoConfig(){
        self.videoConfig = GDTVideoConfig()
        self.autoPlayPolicyTextField.text = String(format:" %d",self.videoConfig.autoPlayPolicy.rawValue)
        self.shouldMuteOnVideoSwitch.isOn = self.videoConfig.videoMuted
        self.videoDetailPageEnableSwitch.isOn = self.videoConfig.detailPageEnable
        self.userControlEnableSwitch.isOn = self.videoConfig.userControlEnable
        self.autoResumeEnableSwitch.isOn = self.videoConfig.autoResumeEnable
        self.progressViewEnableSwitch.isOn = self.videoConfig.progressViewEnable
        self.coverImageEnableSwitch.isOn = self.videoConfig.coverImageEnable
    }
}
// tableVIewDelegate
extension UnifiedNativeAdViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.demoArray.count
    }
    
        

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let SimpleTableIdentifier = "SimpleTableIdentifier"
        let cell = UITableViewCell(style: .default, reuseIdentifier: SimpleTableIdentifier)
        cell.textLabel?.text = self.demoArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vcType = demoArray[indexPath.row]
        let vc:UnifiedNativeAdBaseViewController?
        
        
        switch vcType {
        case "图片Feed":
            vc = UnifiedNativeAdFeedImageViewController()
        case "视频Feed":
            vc = UnifiedNativeAdFeedVideoTableViewController()
        case "竖版全屏视频":
            vc = UnifiedNativeAdPortraitVideoViewController()
        case "竖版Feed视频":
            vc = UnifiedNativeAdPortraitFeedViewController()
        case "视频贴片广告":
            vc = UnifiedNativePreVideoViewController()
        default:
            vc = nil
        }
        
        vc?.appId = Constant.kGDTMobSDKAppId
        vc?.placementId = (self.placementTextField.text!.count > 0 ? self.placementTextField!.text:self.placementTextField!.placeholder)!
        vc?.maxVideoDuration = Int(self.maxVideoDurationSlider.value)

        let videoConfig:GDTVideoConfig = GDTVideoConfig()
        videoConfig.videoMuted = self.shouldMuteOnVideoSwitch.isOn;
        videoConfig.detailPageEnable = self.videoDetailPageEnableSwitch.isOn;
        videoConfig.autoResumeEnable = self.autoResumeEnableSwitch.isOn;
        videoConfig.userControlEnable = self.userControlEnableSwitch.isOn;
        videoConfig.progressViewEnable = self.progressViewEnableSwitch.isOn;
        videoConfig.coverImageEnable = self.coverImageEnableSwitch.isOn;
        vc?.videoConfig = videoConfig
        
        if vc is UnifiedNativeAdPortraitVideoViewController {
            self.present(vc!, animated: true, completion: nil)
        }else {
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        
        
    }
}

