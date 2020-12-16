//
//  SplashViewContronller.m
//  GDTMobApp
//
//  Created by GaoChao on 15/8/21.
//  Copyright © 2015年 Tencent. All rights reserved.
//

#import "SplashViewController.h"
#import "GDTSplashAd.h"
#import "GDTAppDelegate.h"
#import "GDTSplashZoomOutView.h"
#import "GDTSplashZoomOutView+GDTDraggable.h"

static NSString *IMAGE_AD_PLACEMENTID = @"9040714184494018";
static NSString *VIDEO_AD_PLACEMENTID = @"8071800142568576";
static NSString *VIDEO_ZOOMOUT_AD_PLACEMENTID = @"9011003132560597";

@interface SplashViewController () <GDTSplashAdDelegate,GDTSplashZoomOutViewDelegate>

@property (nonatomic, strong) GDTSplashAd *splashAd;
@property (nonatomic, strong) UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITextField *placementIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *logoHeightTextField;
@property (weak, nonatomic) IBOutlet UILabel *logoDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (nonatomic, assign) BOOL isParallelLoad;
@property (nonatomic, strong) UIAlertController *changePosIdController;
@property (weak, nonatomic) IBOutlet UISwitch *supportZoomoutViewSwitch;

@end

@implementation SplashViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.logoHeightTextField.text = [NSString stringWithFormat:@"%@", @([[UIScreen mainScreen] bounds].size.height * 0.25)] ;
    self.logoDescLabel.text = [NSString stringWithFormat:@"底部logo高度上限：\n %@(屏幕高度) * 25%% = %@", @([[UIScreen mainScreen] bounds].size.height), @([[UIScreen mainScreen] bounds].size.height * 0.25)];
    [self.supportZoomoutViewSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)switchChanged:(id)sender
{
    if ([sender isOn]) {
        [self.navigationController setNavigationBarHidden:YES];
    } else {
        [self.navigationController setNavigationBarHidden:NO];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (IBAction)preloadContractSplashAd:(id)sender {
    self.isParallelLoad = NO;
    self.tipsLabel.text = nil;
    NSString *placementId = self.placementIdTextField.text.length > 0?self.placementIdTextField.text:self.placementIdTextField.placeholder;
    [GDTSplashAd preloadSplashOrderWithPlacementId:placementId];
}
- (IBAction)changePlacementID:(id)sender {
    self.changePosIdController = [UIAlertController alertControllerWithTitle:@"选择广告类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if (self.changePosIdController.popoverPresentationController) {
        [self.changePosIdController.popoverPresentationController setPermittedArrowDirections:0];//去掉arrow箭头
        self.changePosIdController.popoverPresentationController.sourceView=self.view;
        self.changePosIdController.popoverPresentationController.sourceRect=CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
    }
    UIAlertAction *portraitLandscapeAdIdAction = [UIAlertAction actionWithTitle:@"图文广告" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.placementIdTextField.placeholder = IMAGE_AD_PLACEMENTID;
    }];
    [self.changePosIdController addAction:portraitLandscapeAdIdAction];
    
    UIAlertAction *mediationAdIdAction = [UIAlertAction actionWithTitle:@"视频广告" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           self.placementIdTextField.placeholder = VIDEO_AD_PLACEMENTID;
    }];
    [self.changePosIdController addAction:mediationAdIdAction];
    
    
    UIAlertAction *splashZoomoutAdIdAction = [UIAlertAction actionWithTitle:@"开屏视频V+广告" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.placementIdTextField.placeholder = VIDEO_ZOOMOUT_AD_PLACEMENTID;
    }];
    [self.changePosIdController addAction:splashZoomoutAdIdAction];
    
    [self presentViewController:self.changePosIdController animated:YES completion:^{ [self clickBackToMainView];}];
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

- (IBAction)parallelLoadAd:(id)sender {
    self.tipsLabel.text = nil;
    self.isParallelLoad = YES;
    
    NSString *placementId = self.placementIdTextField.text.length > 0?self.placementIdTextField.text:self.placementIdTextField.placeholder;
    self.splashAd = [[GDTSplashAd alloc] initWithPlacementId:placementId];
    self.splashAd.delegate = self;
    self.splashAd.fetchDelay = 5;
    UIImage *splashImage = [UIImage imageNamed:@"SplashNormal"];
    if (isIPhoneXSeries()) {
        splashImage = [UIImage imageNamed:@"SplashX"];
    } else if ([UIScreen mainScreen].bounds.size.height == 480) {
        splashImage = [UIImage imageNamed:@"SplashSmall"];
    }
    self.splashAd.needZoomOut = self.supportZoomoutViewSwitch.isOn;
    self.splashAd.backgroundImage = splashImage;
    self.splashAd.backgroundImage.accessibilityIdentifier = @"splash_ad";

    [self.splashAd loadAd];
    self.tipsLabel.text = @"拉取中...";
}

- (IBAction)parallelShowAd:(id)sender {
    if (self.isParallelLoad) {
        CGFloat logoHeight = [self.logoHeightTextField.text floatValue];
        if (logoHeight > 0 && logoHeight <= [[UIScreen mainScreen] bounds].size.height * 0.25) {
            self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, logoHeight)];
            self.bottomView.backgroundColor = [UIColor whiteColor];
            UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SplashLogo"]];
            logo.accessibilityIdentifier = @"splash_logo";
            logo.frame = CGRectMake(0, 0, 311, 47);
            logo.center = self.bottomView.center;
            [self.bottomView addSubview:logo];
        } else {
            return;
        }
        
        UIWindow *fK = [[UIApplication sharedApplication] keyWindow];
        [self.splashAd showAdInWindow:fK withBottomView:self.bottomView skipView:nil];
    }
}

#pragma mark - GDTSplashAdDelegate

- (void)splashAdDidLoad:(GDTSplashAd *)splashAd {
    
    if (splashAd.splashZoomOutView) {
        [self.view addSubview:splashAd.splashZoomOutView];
        splashAd.splashZoomOutView.rootViewController = self;
        // 支持拖拽
        [splashAd.splashZoomOutView supportDrag];
    }
    NSLog(@"%s", __func__);
    self.tipsLabel.text = @"广告拉取成功";
    NSLog(@"ecpmLevel:%@", splashAd.eCPMLevel);
}

- (void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
    self.tipsLabel.text = @"广告展示成功";
}

- (void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error
{
    NSLog(@"%s%@",__FUNCTION__,error);
    if (self.isParallelLoad) {
        self.tipsLabel.text = @"广告展示失败";
    }
    else {
        self.tipsLabel.text = @"广告拉取失败";
    }
}

- (void)splashAdExposured:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdClicked:(GDTSplashAd *)splashAd
{
    if (splashAd.splashZoomOutView) {
        [splashAd.splashZoomOutView removeFromSuperview];
    }
    NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdApplicationWillEnterBackground:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdWillClosed:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdClosed:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
   self.splashAd = nil;
}

- (void)splashAdWillPresentFullScreenModal:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdDidPresentFullScreenModal:(GDTSplashAd *)splashAd
{
     NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdWillDismissFullScreenModal:(GDTSplashAd *)splashAd
{
     NSLog(@"%s",__FUNCTION__);
}

- (void)splashAdDidDismissFullScreenModal:(GDTSplashAd *)splashAd
{
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark - GDTSplashZoomOutViewDelegate
- (void)splashZoomOutViewDidClick:(GDTSplashZoomOutView *)splashZoomOutView
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)splashZoomOutViewAdDidClose:(GDTSplashZoomOutView *)splashZoomOutView
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)splashZoomOutViewAdVideoFinished:(GDTSplashZoomOutView *)splashZoomOutView
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)splashZoomOutViewAdDidPresentFullScreenModal:(GDTSplashZoomOutView *)splashZoomOutView
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)splashZoomOutViewAdDidDismissFullScreenModal:(GDTSplashZoomOutView *)splashZoomOutView
{
    NSLog(@"%s",__FUNCTION__);
}


@end
