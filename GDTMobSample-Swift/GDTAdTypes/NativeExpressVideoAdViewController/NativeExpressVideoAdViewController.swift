//
//  NativeExpressAdViewController.swift
//  GDTMobSample-Swift
//
//  Created by nimomeng on 2018/8/15.
//  Copyright © 2018 Tencent. All rights reserved.
//

import UIKit

class NativeExpressVideoAdViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,GDTNativeExpressAdDelegete {

    private var expressAdViews:Array<GDTNativeExpressAdView>!
    private var nativeExpressAd:GDTNativeExpressAd!
    
    @IBOutlet weak var placementIdTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var videoAutoPlay: UISwitch!
    
    @IBOutlet weak var videoMutedPlay: UISwitch!
    
    
    @IBOutlet weak var videoDetailMutedPlay: UISwitch!
    
    // 定义初始值
    var widthSliderValue = UIScreen.main.bounds.size.width
    var heightSliderValue : CGFloat = 50
    var adCountSliderValue = 3
    var minVideoDuration = 5
    var maxVideoDuration = 30
    
    // 定义静态变量
    let ABOVEPH_BLOWTEXT_STR = "1020922903364636"
    let ABOVETEXT_BLOW_PH_STR = "1070493363284797"
    let TWOPH_AND_TEXT_STR = "8070996313484739"
    let ONE_PHOTO_STR = "1010197333187887"
    let ADVTYPE_COUNT = 4

    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInsetAdjustmentBehavior = .never
        
      
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(object_getClass(UITableViewCell()), forCellReuseIdentifier: "nativeexpresscell")
        tableView.register(object_getClass(UITableViewCell()), forCellReuseIdentifier: "splitnativeexpresscell")
        
    }
    
    func configController()->UIAlertController{
       
       let changePosIdController = UIAlertController(title: "请选择广告类型", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let advTypeTextArray : [String] = ["上图下文(图片尺寸1280×720)",
            "上文下图(图片尺寸1280×720)",
            "双图双文(大图尺寸1280×720)",
            "纯图片(图片尺寸1280×720)"];
        
        let placeholderArray : [String] = [ABOVEPH_BLOWTEXT_STR,
        ABOVETEXT_BLOW_PH_STR,    TWOPH_AND_TEXT_STR,
        ONE_PHOTO_STR]
            
            
            for i in Range(0..<ADVTYPE_COUNT){
            
            let adIdAction = UIAlertAction(title: advTypeTextArray[i], style: .default, handler: {(UIAlertAction) in
                           self.placementIdTextField.placeholder = placeholderArray[i]
                           return;
                       })
                changePosIdController.addAction(adIdAction)
            }
        return changePosIdController
    }
    @IBAction func selectAdType(_ sender: UIButton) {
        let changePosIdController = configController()

                     self.present(changePosIdController, animated: false, completion: nil)
                 
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
//               backToMainView.addGestureRecognizer(mybackTap)
//           }
//           
//           @objc func backTap(){
//               self.changePosIdController.dismiss(animated: true, completion: nil)
//           }
    
    @IBAction func loadAd(_ sender: UIButton) {
        let placementId = self.placementIdTextField.text?.count ?? 0 > 0 ? self.placementIdTextField.text : self.placementIdTextField.placeholder
              self.nativeExpressAd = GDTNativeExpressAd(placementId: placementId, adSize: CGSize(width: widthSliderValue, height: heightSliderValue))
              self.nativeExpressAd.delegate = self
              self.nativeExpressAd.maxVideoDuration = self.maxVideoDuration
              self.nativeExpressAd.minVideoDuration = self.minVideoDuration
        self.nativeExpressAd.detailPageVideoMuted = self.videoDetailMutedPlay.isOn
        self.nativeExpressAd.videoAutoPlayOnWWAN = self.videoAutoPlay.isOn
        self.nativeExpressAd.videoMuted = self.videoMutedPlay.isOn
        self.nativeExpressAd.load(self.adCountSliderValue)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    //    Mark:UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 == 0 {
            let view: UIView = expressAdViews[indexPath.row/2]
            return view.bounds.size.height
        }
        return 44
    }
    
    //    MARK:UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (expressAdViews != nil) ? expressAdViews.count * 2 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        
        if indexPath.row % 2 == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "nativeexpresscell", for: indexPath)
            cell.selectionStyle = .none
            
            let subView: UIView? = cell!.contentView.viewWithTag(1000)
            if (subView?.superview != nil) {
                subView?.removeFromSuperview()
            }
            
            let view: UIView = expressAdViews[indexPath.row / 2]
            view.tag = 1000
            cell.contentView.addSubview(view)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "splitnativeexpresscell", for: indexPath)
            cell.backgroundColor = .gray
        }
        
        return cell
    }
    
    //    Mark:GDTNativeExpressAdDelegete
    func nativeExpressAdSuccess(toLoad nativeExpressAd: GDTNativeExpressAd!, views: [GDTNativeExpressAdView]!) {
        expressAdViews = Array.init(views)
        if expressAdViews.count > 0 {
            for obj in expressAdViews {
                let expressView:GDTNativeExpressAdView = obj
                expressView.controller = self
                expressView.render()
            }
        }
        tableView.reloadData()
    }
    
    func nativeExpressAdFail(toLoad nativeExpressAd: GDTNativeExpressAd!, error: Error!) {
        print("Express Ad Load Fail : \(String(describing: error))")
    }
    
    func nativeExpressAdViewRenderSuccess(_ nativeExpressAdView: GDTNativeExpressAdView!) {
        tableView.reloadData()
    }
    
    func nativeExpressAdViewClicked(_ nativeExpressAdView: GDTNativeExpressAdView!) {
        print(#function)
    }
    
    func nativeExpressAdViewClosed(_ nativeExpressAdView: GDTNativeExpressAdView!) {
        print(#function)
        if let removeIndex = expressAdViews.index(of: nativeExpressAdView) {
            expressAdViews.remove(at: removeIndex)
            tableView.reloadData()
        }
    }
}
