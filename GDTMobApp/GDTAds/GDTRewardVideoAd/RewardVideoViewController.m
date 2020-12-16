//
//  RewardVideoViewController.m
//  GDTMobApp
//
//  Created by royqpwang on 2018/9/5.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "RewardVideoViewController.h"
#import "GDTRewardVideoAd.h"
#import "GDTAppDelegate.h"
#import "GDTSDKConfig.h"
#import <AVFoundation/AVFoundation.h>


static NSString *PORTRAIT_AD_PLACEMENTID = @"8020744212936426";
static NSString *PORTRAIT_LANDSCAPE_AD_PLACEMENTID = @"9070098640008762";
static NSString *MEDIATION_AD_PLACEMENTID = @"5040546242831432";


@interface RewardVideoViewController () <GDTRewardedVideoAdDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) GDTRewardVideoAd *rewardVideoAd;
@property (weak, nonatomic) IBOutlet UITextField *placementIdTextField;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic, assign) UIInterfaceOrientation supportOrientation;
@property (weak, nonatomic) IBOutlet UIButton *portraitButton;
@property (weak, nonatomic) IBOutlet UIButton *changePlacementId;
@property (weak, nonatomic) IBOutlet UISwitch *videoMutedSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *audioSessionSwitch;


@property (nonatomic, strong) UIAlertController *changePosIdController;
@property (nonatomic, strong) UIAlertAction *portraitAdIdAction;

@end

@implementation RewardVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    UIDevice *device = [UIDevice currentDevice];
    if (device.orientation == UIInterfaceOrientationPortrait) {
        self.portraitAdIdAction = [UIAlertAction actionWithTitle:@"竖屏广告" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.placementIdTextField.placeholder = PORTRAIT_AD_PLACEMENTID;
        }];
    } else {
        self.portraitAdIdAction = [UIAlertAction actionWithTitle:@"横屏广告" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.placementIdTextField.placeholder = PORTRAIT_AD_PLACEMENTID;
        }];
    }
    [self.changePosIdController addAction:self.portraitAdIdAction];
    
    UIAlertAction *portraitLandscapeAdIdAction = [UIAlertAction actionWithTitle:@"横竖屏广告" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.placementIdTextField.placeholder = PORTRAIT_LANDSCAPE_AD_PLACEMENTID;
    }];
    [self.changePosIdController addAction:portraitLandscapeAdIdAction];
    
    UIAlertAction *mediationAdIdAction = [UIAlertAction actionWithTitle:@"流量分配广告" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           self.placementIdTextField.placeholder = MEDIATION_AD_PLACEMENTID;
       }];
    [self.changePosIdController addAction:mediationAdIdAction];
    
    [self presentViewController:self.changePosIdController animated:YES completion:^{ [self clickBackToMainView];}];
    
}

- (IBAction)loadAd:(id)sender {
    NSString *placementId = self.placementIdTextField.text.length > 0 ?self.placementIdTextField.text: self.placementIdTextField.placeholder;
    //placementId = @"1040149434136928";
    self.rewardVideoAd = [[GDTRewardVideoAd alloc] initWithPlacementId:placementId];
    self.rewardVideoAd.videoMuted = self.videoMutedSwitch.on;
    self.rewardVideoAd.delegate = self;
    [self.rewardVideoAd loadAd];
}

- (IBAction)playVideo:(UIButton *)sender {
    if (self.rewardVideoAd.expiredTimestamp <= [[NSDate date] timeIntervalSince1970]) {
        self.statusLabel.text = @"广告已过期，请重新拉取";
        return;
    }
    if (!self.rewardVideoAd.isAdValid) {
        self.statusLabel.text = @"广告失效，请重新拉取";
        return;
    }
    
    [GDTSDKConfig enableDefaultAudioSessionSetting:!self.audioSessionSwitch.on];
    
    [self.rewardVideoAd showAdFromRootViewController:self];
    
    if (self.audioSessionSwitch.on) {
        [[AVAudioSession sharedInstance] setActive:NO error:nil];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
    }
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - GDTRewardVideoAdDelegate
- (void)gdt_rewardVideoAdDidLoad:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__FUNCTION__);
    self.statusLabel.text = [NSString stringWithFormat:@"%@ 广告数据加载成功", rewardedVideoAd.adNetworkName];
    NSLog(@"eCPM:%ld eCPMLevel:%@", [rewardedVideoAd eCPM], [rewardedVideoAd eCPMLevel]);
    NSLog(@"videoDuration :%lf rewardAdType:%ld", rewardedVideoAd.videoDuration, rewardedVideoAd.rewardAdType);
}


- (void)gdt_rewardVideoAdVideoDidLoad:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__FUNCTION__);
    self.statusLabel.text = [NSString stringWithFormat:@"%@ 视频文件加载成功", rewardedVideoAd.adNetworkName];
}


- (void)gdt_rewardVideoAdWillVisible:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"视频播放页即将打开");
}

- (void)gdt_rewardVideoAdDidExposed:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__FUNCTION__);
    self.statusLabel.text = [NSString stringWithFormat:@"%@ 广告已曝光", rewardedVideoAd.adNetworkName];
    NSLog(@"广告已曝光");
}

- (void)gdt_rewardVideoAdDidClose:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__FUNCTION__);
    self.statusLabel.text = [NSString stringWithFormat:@"%@ 广告已关闭", rewardedVideoAd.adNetworkName];
//    广告关闭后释放ad对象
    self.rewardVideoAd = nil;
    NSLog(@"广告已关闭");
}


- (void)gdt_rewardVideoAdDidClicked:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__FUNCTION__);
    self.statusLabel.text = [NSString stringWithFormat:@"%@ 广告已点击", rewardedVideoAd.adNetworkName];
    NSLog(@"广告已点击");
}

- (void)gdt_rewardVideoAd:(GDTRewardVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error
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
    NSLog(@"ERROR: %@", error);
}

- (void)gdt_rewardVideoAdDidRewardEffective:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"播放达到激励条件");
}

- (void)gdt_rewardVideoAdDidPlayFinish:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"视频播放结束");
    
    if (self.audioSessionSwitch.on) {
        [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    }
}


@end
