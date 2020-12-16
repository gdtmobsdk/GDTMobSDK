//
//  UnifiedBannerViewController.m
//  GDTMobApp
//
//  Created by nimomeng on 2019/3/7.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "UnifiedBannerViewController.h"
#import "GDTUnifiedBannerView.h"
#import "GDTAppDelegate.h"

@interface UnifiedBannerViewController () <GDTUnifiedBannerViewDelegate>
@property (nonatomic, strong) GDTUnifiedBannerView *bannerView;

@property (weak, nonatomic) IBOutlet UITextField *placementIdText;
@property (weak, nonatomic) IBOutlet UITextField *refreshIntervalText;
@property (weak, nonatomic) IBOutlet UISwitch *animationSwitch;

@end

@implementation UnifiedBannerViewController

#pragma mark - lifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadAdAndShow:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (IBAction)loadAdAndShow:(id)sender {
    if (self.bannerView.superview) {
        [self.bannerView removeFromSuperview];
        self.bannerView = nil;
    }

    [self.view addSubview:self.bannerView];
    [self.bannerView loadAdAndShow];
}

- (IBAction)removeAd:(id)sender {
    [self.bannerView removeFromSuperview];
    self.bannerView = nil;
}

#pragma mark - property getter
- (GDTUnifiedBannerView *)bannerView
{
    if (!_bannerView) {
        CGRect rect = {CGPointZero, CGSizeMake(375, 100)};
        _bannerView = [[GDTUnifiedBannerView alloc]
                       initWithFrame:rect
                       placementId:self.placementIdText.text.length > 0 ? self.placementIdText.text: self.placementIdText.placeholder
                       viewController:self];
        _bannerView.accessibilityIdentifier = @"banner_ad";
        _bannerView.animated = self.animationSwitch.on;
        _bannerView.autoSwitchInterval = [self.refreshIntervalText.text intValue];
        _bannerView.delegate = self;
    }
    return _bannerView;
}

#pragma mark - GDTUnifiedBannerViewDelegate
/**
 *  请求广告条数据成功后调用
 *  当接收服务器返回的广告数据成功后调用该函数
 */
- (void)unifiedBannerViewDidLoad:(GDTUnifiedBannerView *)unifiedBannerView
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"unified banner did load");
}

/**
 *  请求广告条数据失败后调用
 *  当接收服务器返回的广告数据失败后调用该函数
 */

- (void)unifiedBannerViewFailedToLoad:(GDTUnifiedBannerView *)unifiedBannerView error:(NSError *)error
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  banner2.0曝光回调
 */
- (void)unifiedBannerViewWillExpose:(nonnull GDTUnifiedBannerView *)unifiedBannerView {
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  banner2.0点击回调
 */
- (void)unifiedBannerViewClicked:(GDTUnifiedBannerView *)unifiedBannerView
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  应用进入后台时调用
 *  当点击应用下载或者广告调用系统程序打开，应用将被自动切换到后台
 */
- (void)unifiedBannerViewWillLeaveApplication:(GDTUnifiedBannerView *)unifiedBannerView
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  全屏广告页已经被关闭
 */
- (void)unifiedBannerViewDidDismissFullScreenModal:(GDTUnifiedBannerView *)unifiedBannerView
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  全屏广告页即将被关闭
 */
- (void)unifiedBannerViewWillDismissFullScreenModal:(GDTUnifiedBannerView *)unifiedBannerView
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  banner2.0广告点击以后即将弹出全屏广告页
 */
- (void)unifiedBannerViewWillPresentFullScreenModal:(GDTUnifiedBannerView *)unifiedBannerView
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  banner2.0广告点击以后弹出全屏广告页完毕
 */
- (void)unifiedBannerViewDidPresentFullScreenModal:(GDTUnifiedBannerView *)unifiedBannerView
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  banner2.0被用户关闭时调用
 */
- (void)unifiedBannerViewWillClose:(nonnull GDTUnifiedBannerView *)unifiedBannerView {
    self.bannerView = nil;
    NSLog(@"%s",__FUNCTION__);
}

@end


