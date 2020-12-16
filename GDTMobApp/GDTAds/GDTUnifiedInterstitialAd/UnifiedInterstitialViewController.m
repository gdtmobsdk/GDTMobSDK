//
//  UnifiedInterstitialViewController.m
//  GDTMobApp
//
//  Created by nimomeng on 2019/3/13.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "UnifiedInterstitialViewController.h"
#import "GDTUnifiedInterstitialAd.h"
#import "GDTAppDelegate.h"

@interface UnifiedInterstitialViewController () <GDTUnifiedInterstitialAdDelegate>
@property (nonatomic, strong) GDTUnifiedInterstitialAd *interstitial;
@property (weak, nonatomic) IBOutlet UILabel *interstitialStateLabel;
@property (weak, nonatomic) IBOutlet UITextField *positionID;
@property (weak, nonatomic) IBOutlet UISwitch *videoMutedSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *detailPageVideoMutedSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *videoAutoPlaySwitch;
@property (weak, nonatomic) IBOutlet UILabel *maxVideoDurationLabel;
@property (weak, nonatomic) IBOutlet UISlider *maxVideoDurationSlider;

@property (weak, nonatomic) IBOutlet UILabel *minVideoDurationLabel;
@property (weak, nonatomic) IBOutlet UISlider *minVideoDurationSlider;

//插屏视频按钮
@property (nonatomic, strong) UISwitch *changADVStyleSwitch;
@property (nonatomic, copy) NSString *placeHolderString;
@property (nonatomic, strong) UILabel * changeADVStyleLabel;

@end

@implementation UnifiedInterstitialViewController

static NSString *INTERSTITIAL_STATE_TEXT = @"插屏状态";

static NSString *CHANGE_ADVSTYLE_TEXT = @"切换插屏视频";

static NSString *VIDEO_PLACEMENT_ID_STR = @"6050298509489032";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.minVideoDurationLabel.text = [NSString stringWithFormat:@"视频最小长:%ld",(long)self.minVideoDurationSlider.value];
    
    self.maxVideoDurationLabel.text = [NSString stringWithFormat:@"视频最大长:%ld",(long)self.maxVideoDurationSlider.value];
    [self.maxVideoDurationSlider addTarget:self action:@selector(sliderMaxVideoDurationChanged) forControlEvents:UIControlEventValueChanged];
    
    [self.minVideoDurationSlider addTarget:self action:@selector(sliderMinVideoDurationChanged) forControlEvents:UIControlEventValueChanged];
    
    self.changeADVStyleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.maxVideoDurationLabel.frame.origin.x, 299, 80, 17)];
    self.changeADVStyleLabel.text = CHANGE_ADVSTYLE_TEXT;
    self.changeADVStyleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:self.changeADVStyleLabel];
    
    self.placeHolderString = self.positionID.placeholder;
    self.changADVStyleSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(110, 290, CGRectGetWidth(self.videoMutedSwitch.frame), CGRectGetHeight(self.videoMutedSwitch.frame))];
    [self.changADVStyleSwitch addTarget:self action:@selector(changeADVStyle:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.changADVStyleSwitch];

}

- (void)changeADVStyle:(UISwitch *)sender {
    if (sender.on) {
        self.positionID.placeholder = VIDEO_PLACEMENT_ID_STR;
    } else {
        self.positionID.placeholder = self.placeHolderString;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (IBAction)loadAd:(id)sender {
    if (self.interstitial) {
        self.interstitial.delegate = nil;
    }
    self.interstitial = [[GDTUnifiedInterstitialAd alloc] initWithPlacementId:self.positionID.text.length > 0? self.positionID.text: self.positionID.placeholder];
    self.interstitial.delegate = self;
    self.interstitial.videoMuted = self.videoMutedSwitch.on;
    self.interstitial.detailPageVideoMuted = self.detailPageVideoMutedSwitch.on;
    self.interstitial.videoAutoPlayOnWWAN = self.videoAutoPlaySwitch.on;
    self.interstitial.minVideoDuration = (NSInteger)self.minVideoDurationSlider.value;
    self.interstitial.maxVideoDuration = (NSInteger)self.maxVideoDurationSlider.value;  // 如果需要设置视频最大时长，可以通过这个参数来进行设置

    [self.interstitial loadAd];
}

- (IBAction)showAd:(id)sender {
    [self.interstitial presentAdFromRootViewController:self];
}

- (void)sliderMaxVideoDurationChanged {
    self.maxVideoDurationLabel.text = [NSString stringWithFormat:@"视频最大长:%ld",(long)self.maxVideoDurationSlider.value];
}

- (void)sliderMinVideoDurationChanged {
    self.minVideoDurationLabel.text = [NSString stringWithFormat:@"视频最小长:%ld",(long)self.minVideoDurationSlider.value];
}

#pragma mark - GDTUnifiedInterstitialAdDelegate

/**
 *  插屏2.0广告预加载成功回调
 *  当接收服务器返回的广告数据成功后调用该函数
 */
- (void)unifiedInterstitialSuccessToLoadAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
    self.interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Load Success." ];
    NSLog(@"eCPM:%ld eCPMLevel:%@", [unifiedInterstitial eCPM], [unifiedInterstitial eCPMLevel]);
    NSLog(@"videoDuration:%lf isVideo: %@", unifiedInterstitial.videoDuration, @(unifiedInterstitial.isVideoAd));
}

/**
 *  插屏2.0广告预加载失败回调
 *  当接收服务器返回的广告数据失败后调用该函数
 */
- (void)unifiedInterstitialFailToLoadAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial error:(NSError *)error
{
    NSLog(@"%s",__FUNCTION__);
    self.interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@,Error : %@",INTERSTITIAL_STATE_TEXT,@"Fail Loaded.",error ];
    NSLog(@"interstitial fail to load, Error : %@",error);
}

/**
 *  插屏2.0广告将要展示回调
 *  插屏2.0广告即将展示回调该函数
 */
- (void)unifiedInterstitialWillPresentScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
    self.interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Going to present." ];
}

- (void)unifiedInterstitialFailToPresent:(GDTUnifiedInterstitialAd *)unifiedInterstitial error:(NSError *)error {
    NSLog(@"%s",__FUNCTION__);
    self.interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@",INTERSTITIAL_STATE_TEXT,@"fail to present." ];
}

/**
 *  插屏2.0广告视图展示成功回调
 *  插屏2.0广告展示成功回调该函数
 */
- (void)unifiedInterstitialDidPresentScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
    self.interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Success Presented." ];
}

/**
 *  插屏2.0广告展示结束回调
 *  插屏2.0广告展示结束回调该函数
 */
- (void)unifiedInterstitialDidDismissScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
    self.interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Finish Presented." ];
}

/**
 *  当点击下载应用时会调用系统程序打开
 */
- (void)unifiedInterstitialWillLeaveApplication:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
    self.interstitialStateLabel.text = [NSString stringWithFormat:@"%@:%@",INTERSTITIAL_STATE_TEXT,@"Application enter background." ];
}

/**
 *  插屏2.0广告曝光回调
 */
- (void)unifiedInterstitialWillExposure:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  插屏2.0广告点击回调
 */
- (void)unifiedInterstitialClicked:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  点击插屏2.0广告以后即将弹出全屏广告页
 */
- (void)unifiedInterstitialAdWillPresentFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  点击插屏2.0广告以后弹出全屏广告页
 */
- (void)unifiedInterstitialAdDidPresentFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  全屏广告页将要关闭
 */
- (void)unifiedInterstitialAdWillDismissFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 *  全屏广告页被关闭
 */
- (void)unifiedInterstitialAdDidDismissFullScreenModal:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
}


/**
 * 插屏2.0视频广告 player 播放状态更新回调
 */
- (void)unifiedInterstitialAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial playerStatusChanged:(GDTMediaPlayerStatus)status
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 * 插屏2.0视频广告详情页 WillPresent 回调
 */
- (void)unifiedInterstitialAdViewWillPresentVideoVC:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 * 插屏2.0视频广告详情页 DidPresent 回调
 */
- (void)unifiedInterstitialAdViewDidPresentVideoVC:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 * 插屏2.0视频广告详情页 WillDismiss 回调
 */
- (void)unifiedInterstitialAdViewWillDismissVideoVC:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 * 插屏2.0视频广告详情页 DidDismiss 回调
 */
- (void)unifiedInterstitialAdViewDidDismissVideoVC:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSLog(@"%s",__FUNCTION__);
}
@end
