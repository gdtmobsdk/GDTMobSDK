//
//  PlayableAdTestViewController.m
//  GDTMobApp
//
//  Created by Nancy on 2020/8/12.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "PlayableAdTestViewController.h"
#import "GDTRewardVideoAd.h"
#import "GDTSDKConfig.h"

#define kPlayableTestPlacementId @"9070098640008762"

@interface PlayableAdTestViewController () <GDTRewardedVideoAdDelegate>
@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UISwitch *muteSwitch;
@property (nonatomic, strong) GDTRewardVideoAd *rewardAd;
 
@end

@implementation PlayableAdTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    GDTAdTestSetting *debugSetting = [[GDTAdTestSetting alloc] init];
    [GDTSDKConfig setDebugSetting:debugSetting];
    
    self.textField.text = @"http://developers.adnet.qq.com/open/tryable?debug=unsdk";
}

- (void)dealloc {
    [GDTSDKConfig setDebugSetting:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)showAdButtonTouched:(id)sender {
    //step1:设置playableUrl
    [GDTSDKConfig debugSetting].playableUrl = self.textField.text;
    
    //step2:拉广告
    GDTRewardVideoAd *rewardAd = [[GDTRewardVideoAd alloc] initWithPlacementId:kPlayableTestPlacementId];
    rewardAd.videoMuted = self.muteSwitch.on;
    rewardAd.delegate = self;
    [rewardAd loadAd];
    self.rewardAd = rewardAd;
}

- (void)gdt_rewardVideoAdDidLoad:(GDTRewardVideoAd *)rewardedVideoAd {
    
}

- (void)gdt_rewardVideoAdVideoDidLoad:(GDTRewardVideoAd *)rewardedVideoAd {
    [self.rewardAd showAdFromRootViewController:self];
}

- (void)gdt_rewardVideoAd:(GDTRewardVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    NSLog(@"发生错误，请稍后重试 %@", error);
}

@end
