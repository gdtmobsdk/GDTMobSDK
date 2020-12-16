//
//  HybridAdViewController.m
//  GDTMobApp
//
//  Created by royqpwang on 2018/12/20.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import "HybridAdViewController.h"
#import "GDTAppDelegate.h"
#import "GDTHybridAd.h"

@interface HybridAdViewController () <GDTHybridAdDelegate>
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (nonatomic, strong) GDTHybridAd *hybridAd;

@end

@implementation HybridAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.urlTextField.text = @"https://developers.adnet.qq.com/open/hybridH5?placement_id=5060996645157430&app_id=1109524399&xflow_lp_data=open_id%3D12345656%26nicename%3Dtencent&xflow_pos_id=1111";
}

- (IBAction)clickOpenUrl:(id)sender {
    self.hybridAd = [[GDTHybridAd alloc] initWithType:GDTHybridAdOptionRewardVideo];
    self.hybridAd.delegate = self;
    self.hybridAd.navigationBarColor = [UIColor whiteColor];
    self.hybridAd.titleFont = [UIFont systemFontOfSize:16];
    [self.hybridAd loadWithUrl:self.urlTextField.text];
    [self.hybridAd showWithRootViewController:self];
}

- (void)gdt_hybridAdDidPresented:(GDTHybridAd *)hybridAd
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"浏览器展示成功");
}

- (void)gdt_hybridAdDidClose:(GDTHybridAd *)hybridAd
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"浏览器关闭");
    self.hybridAd = nil;
}

- (void)gdt_hybridAdLoadURLSuccess:(GDTHybridAd *)hybridAd
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"URL 加载成功");
}

- (void)gdt_hybridAd:(GDTHybridAd *)hybridAd didFailWithError:(NSError *)error
{
    NSLog(@"%s",__FUNCTION__);
    if ([error code] == 3001) {
        NSLog(@"URL 加载失败");
    }
}


@end
