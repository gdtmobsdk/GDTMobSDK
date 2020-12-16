//
//  NativeExpressAdViewController.swift
//  GDTMobSample-Swift
//
//  Created by nimomeng on 2018/8/15.
//  Copyright © 2018 Tencent. All rights reserved.
//

import UIKit

class NativeExpressAdViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,GDTNativeExpressAdDelegete {

    private var expressAdViews:Array<GDTNativeExpressAdView>!
    private var nativeExpressAd:GDTNativeExpressAd!
    
    @IBOutlet weak var placementIdTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    // 初始值
    var widthSliderValue = UIScreen.main.bounds.size.width
    var heightSliderValue : CGFloat = 50
    var adCountSliderValue = 3
    let ABOVEPH_BLOWTEXT_STR = "5030722621265924"

    let ABOVETEXT_BLOW_PH_STR = "8010090333885456"

    let LEFTPH_RIHGTTEXT_STR = "1080793303881448"

    let LEFTTEXT_RIGHTPH_STR = "9050097313684512"

    let TWOPH_AND_TEXT_STR = "5070297373087567"

    let WIDTHPHOTO_STR = "5070791337820394"

    let HEIGHTPHOTO_STR = "6090492353182599"

    let THREE_SMALLPH_STR = "9050492343889611"

    let ABOVETEXT_SURFACE_BLOWPH_STR = "9010495393982624"

    let ABOVEPH_BLOWTEXT_SURFACE_STR = "6020493353488605"

    let TEXTSURFACE_ONEPHOTO_STR = "3030690323789618"

    let HEIGHTERPHOTO_STR = "6060290383380659"

    let ADVTYPE_COUNT = 12
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInsetAdjustmentBehavior = .never
        
      
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(object_getClass(UITableViewCell()), forCellReuseIdentifier: "nativeexpresscell")
        tableView.register(object_getClass(UITableViewCell()), forCellReuseIdentifier: "splitnativeexpresscell")
        configAlertController()
        
    }
    func configAlertController()->UIAlertController{
        let changePosIdController = UIAlertController(title: "请选择广告类型", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let advTypeTextArray : [String] = ["上图下文(图片尺寸1280×720)",
                                             "上文下图(图片尺寸1280×720)",
                                             "左图右文(图片尺寸1200×800)",
                                             "左文右图(图片尺寸1200×800)",
                                             "双图双文(大图尺寸1280×720)",
                                             "纯图片(图片尺寸1280×720)",
                                             "纯图片(图片尺寸800×1200)",
                                             "三小图(图片尺寸228×150)",
                                             "文字浮层(上文下图1280×720)",
                                             "文字浮层(上图下文1280×720)",
                                             "文字浮层(单图1280×720)",
                                             "纯图片(图片尺寸1080×1920或800×1200)"]
            
        
        
        let placeholderArray : [String] = [ABOVEPH_BLOWTEXT_STR,
                                ABOVETEXT_BLOW_PH_STR,
                                           LEFTPH_RIHGTTEXT_STR,
                                           LEFTTEXT_RIGHTPH_STR,
                                           TWOPH_AND_TEXT_STR,
                                           WIDTHPHOTO_STR,
                                           HEIGHTPHOTO_STR,
                                           THREE_SMALLPH_STR,
                                           ABOVETEXT_SURFACE_BLOWPH_STR,
                                           ABOVEPH_BLOWTEXT_SURFACE_STR,
                                           TEXTSURFACE_ONEPHOTO_STR,
                                           HEIGHTERPHOTO_STR]
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
        let changePosIdController = configAlertController()
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
//        backToMainView.addGestureRecognizer(mybackTap)
//    }
//
//    @objc func backTap(){
//        self.changePosIdController.dismiss(animated: true, completion: nil)
//    }
    @IBAction func loadAd(_ sender: UIButton) {
        let placementId = self.placementIdTextField.text?.count ?? 0 > 0 ? self.placementIdTextField.text : self.placementIdTextField.placeholder
        self.nativeExpressAd = GDTNativeExpressAd(placementId: placementId, adSize: CGSize(width: widthSliderValue, height: heightSliderValue))
        self.nativeExpressAd.delegate = self
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
