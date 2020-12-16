//
//  NativeExpressRewardVideoViewController.m
//  GDTMobApp
//
//  Created by royqpwang on 2020/7/28.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "NativeExpressRewardVideoViewController.h"
#import "GDTNativeExpressRewardVideoAd.h"
#import "GDTSDKConfig.h"
#import "GDTAppDelegate.h"
#import <AVFoundation/AVFoundation.h>

static NSString *PORTRAIT_AD_PLACEMENTID = @"1071335839472208";
static NSString *LANDSCAPE_AD_PLACEMENTID = @"4021136889274300";

@interface NativeExpressRewardVideoViewController () <GDTNativeExpressRewardedVideoAdDelegate>

@property (nonatomic, strong) GDTNativeExpressRewardVideoAd *nativeExpressRewardVideoAd;
@property (weak, nonatomic) IBOutlet UITextField *placementIdTextField;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic, assign) UIInterfaceOrientation supportOrientation;
@property (weak, nonatomic) IBOutlet UIButton *portraitButton;
@property (weak, nonatomic) IBOutlet UIButton *changePlacementId;
@property (weak, nonatomic) IBOutlet UISwitch *videoMutedSwitch;
@property (nonatomic, strong) UIAlertController *changePosIdController;

@end

@implementation NativeExpressRewardVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        self.placementIdTextField.text = PORTRAIT_AD_PLACEMENTID;
    }
    else {
        self.placementIdTextField.text = LANDSCAPE_AD_PLACEMENTID;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)clickBackToMainView {
    NSArray *arrayViews = [UIApplication sharedApplication].keyWindow.subviews;
    UIView *backToMainView = [[UIView alloc] init];
    for (int i = 1; i < arrayViews.count; i++) {
        NSString *viewNameStr = [NSString stringWithFormat:@"%s",object_getClassName(arrayViews[i])];
        if ([viewNameStr isEqualToString:@"UITransitionView"]) {
            backToMainView = [arrayViews[i] subviews][0];
            break;
        }
    }
//    UIView *backToMainView = [arrayViews.lastObject subviews][0];
    backToMainView.userInteractionEnabled = YES;
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTap)];
    [backToMainView addGestureRecognizer:backTap];
}

- (void)backTap {
    [self.changePosIdController dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)changePlacementId:(id)sender {
    self.changePosIdController = [UIAlertController alertControllerWithTitle:@"选择广告类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if (self.changePosIdController.popoverPresentationController) {
        [self.changePosIdController.popoverPresentationController setPermittedArrowDirections:0];//去掉arrow箭头
        self.changePosIdController.popoverPresentationController.sourceView=self.view;
        self.changePosIdController.popoverPresentationController.sourceRect=CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
    }
    
    UIAlertAction *portraitAction = [UIAlertAction actionWithTitle:@"竖屏广告" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.placementIdTextField.text = PORTRAIT_AD_PLACEMENTID;
    }];
    
    
    UIAlertAction *landscapeAction = [UIAlertAction actionWithTitle:@"横屏广告" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.placementIdTextField.text = LANDSCAPE_AD_PLACEMENTID;
    }];
    
    [self.changePosIdController addAction:portraitAction];
    [self.changePosIdController addAction:landscapeAction];
    
    [self presentViewController:self.changePosIdController animated:YES completion:^{ [self clickBackToMainView];}];
    
}

- (IBAction)loadAd:(id)sender {
    NSString *placementId = self.placementIdTextField.text.length > 0 ?self.placementIdTextField.text: self.placementIdTextField.placeholder;
    self.nativeExpressRewardVideoAd = [[GDTNativeExpressRewardVideoAd alloc] initWithPlacementId:placementId];
    self.nativeExpressRewardVideoAd.videoMuted = self.videoMutedSwitch.on;
    self.nativeExpressRewardVideoAd.delegate = self;
    [self.nativeExpressRewardVideoAd loadAd];
    self.statusLabel.text = @"正在拉取广告...";
}

- (IBAction)playVideo:(UIButton *)sender {
    if (!self.nativeExpressRewardVideoAd.isAdValid) {
        self.statusLabel.text = @"广告数据未准备好，请稍后重试";
        return;
    }
    
    [self.nativeExpressRewardVideoAd showAdFromRootViewController:self];
}

- (IBAction)changeOrientation:(UIButton *)sender {
    // 仅为方便调试提供的逻辑，应用接入流程中不需要程序设置方向
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        self.supportOrientation = UIInterfaceOrientationLandscapeRight;
    } else {
        self.supportOrientation = UIInterfaceOrientationPortrait;
    }
    [[UIDevice currentDevice] setValue:@(self.supportOrientation) forKey:@"orientation"];
}

#pragma mark - GDTNativeExpressRewardVideoAdDelegate
- (void)gdt_nativeExpressRewardVideoAdDidLoad:(GDTNativeExpressRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__FUNCTION__);
    self.statusLabel.text = [NSString stringWithFormat:@"%@ 广告数据加载成功", rewardedVideoAd.adNetworkName];
    NSLog(@"eCPM:%ld eCPMLevel:%@", [rewardedVideoAd eCPM], [rewardedVideoAd eCPMLevel]);
    NSLog(@"videoDuration :%lf",rewardedVideoAd.videoDuration);
}


- (void)gdt_nativeExpressRewardVideoAdVideoDidLoad:(GDTNativeExpressRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__FUNCTION__);
    self.statusLabel.text = [NSString stringWithFormat:@"%@ 视频文件和模板加载成功", rewardedVideoAd.adNetworkName];
}


- (void)gdt_nativeExpressRewardVideoAdWillVisible:(GDTNativeExpressRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"视频播放页即将打开");
}

- (void)gdt_nativeExpressRewardVideoAdDidExposed:(GDTNativeExpressRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__FUNCTION__);
    self.statusLabel.text = [NSString stringWithFormat:@"%@ 广告已曝光", rewardedVideoAd.adNetworkName];
    NSLog(@"广告已曝光");
}

- (void)gdt_nativeExpressRewardVideoAdDidClose:(GDTNativeExpressRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__FUNCTION__);
    self.statusLabel.text = [NSString stringWithFormat:@"%@ 广告已关闭", rewardedVideoAd.adNetworkName];
//    广告关闭后释放ad对象
    self.nativeExpressRewardVideoAd = nil;
    NSLog(@"广告已关闭");
}


- (void)gdt_nativeExpressRewardVideoAdDidClicked:(GDTNativeExpressRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__FUNCTION__);
    self.statusLabel.text = [NSString stringWithFormat:@"%@ 广告已点击", rewardedVideoAd.adNetworkName];
    NSLog(@"广告已点击");
}

- (void)gdt_nativeExpressRewardVideoAd:(GDTNativeExpressRewardVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error
{
    NSLog(@"%s",__FUNCTION__);
    if (error.code == 4014) {
        NSLog(@"请拉取到广告后再调用展示接口");
        self.statusLabel.text = @"请拉取到广告后再调用展示接口";
    } else if (error.code == 4016) {
        NSLog(@"应用方向与广告位支持方向不一致");
        self.statusLabel.text = @"应用方向与广告位支持方向不一致";
    } else if (error.code == 5012) {
        NSLog(@"广告已过期");
        self.statusLabel.text = @"广告已过期";
    } else if (error.code == 4015) {
        NSLog(@"广告已经播放过，请重新拉取");
        self.statusLabel.text = @"广告已经播放过，请重新拉取";
    } else if (error.code == 5002) {
        NSLog(@"视频下载失败");
        self.statusLabel.text = @"视频下载失败";
    } else if (error.code == 5003) {
        NSLog(@"视频播放失败");
        self.statusLabel.text = @"视频播放失败";
    } else if (error.code == 5004) {
        NSLog(@"没有合适的广告");
        self.statusLabel.text = @"没有合适的广告";
    } else if (error.code == 5013) {
        NSLog(@"请求太频繁，请稍后再试");
        self.statusLabel.text = @"请求太频繁，请稍后再试";
    } else if (error.code == 3002) {
        NSLog(@"网络连接超时");
        self.statusLabel.text = @"网络连接超时";
    } else if (error.code == 5027){
        NSLog(@"页面加载失败");
        self.statusLabel.text = @"页面加载失败";
    }
    else if (error.code == 5043) {
        NSLog(@"模板渲染失败");
        self.statusLabel.text = @"模板渲染失败";
    }
    else {
        self.statusLabel.text = @"拉取失败";
        NSLog(@"%@", self.statusLabel.text);
    }
    NSLog(@"ERROR: %@", error);
}

- (void)gdt_nativeExpressRewardVideoAdDidRewardEffective:(GDTNativeExpressRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"播放达到激励条件");
}

- (void)gdt_nativeExpressRewardVideoAdDidPlayFinish:(GDTNativeExpressRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"视频播放结束");
}

@end
