//
//  NativeExpressProAdViewController.m
//  GDTMobApp
//
//  Created by michaelxing on 2017/4/17.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "NativeExpressProAdViewController.h"
#import "GDTNativeExpressProAdManager.h"
#import "GDTNativeExpressProAdView.h"
#import "GDTAppDelegate.h"
#import "NativeExpressVideoConfigView.h"

@interface NativeExpressProAdViewController ()<GDTNativeExpressProAdManagerDelegate, GDTNativeExpressProAdViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *expressAdViews;

@property (nonatomic, strong) GDTNativeExpressProAdManager *adManager;

@property (weak, nonatomic) IBOutlet UITextField *placementIdTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic)  float widthSliderValue;
@property (assign, nonatomic)  float heightSliderValue;
@property (assign, nonatomic)  float adCountSliderValue;
@property (nonatomic) float minVideoDuration;
@property (nonatomic) float maxVideoDuration;
@property (nonatomic) BOOL videoAutoPlay;
@property (nonatomic) BOOL videoMuted;
@property (nonatomic) BOOL videoDetailPageVideoMuted;

//切换广告样式
@property (nonatomic, strong) UIAlertController *advStyleAlertController;

@end

@implementation NativeExpressProAdViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.widthSliderValue = [UIScreen mainScreen].bounds.size.width;
    self.heightSliderValue = 50;
    self.adCountSliderValue = 1;
    self.minVideoDuration = 5;
    self.maxVideoDuration = 30;
    self.videoMuted = YES;
    self.videoDetailPageVideoMuted = YES;
    self.videoAutoPlay = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"nativeexpresscell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"splitnativeexpresscell"];
    
    [self initVideoConfig];
    [self refreshButton:nil];
}

- (IBAction)selectADVStyle:(id)sender {
    self.advStyleAlertController = [UIAlertController alertControllerWithTitle:@"请选择需要的广告样式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *advTypeTextArray = @[@[@"上图下文(图片尺寸1280×720)", @"2011313603627732"],
                                  @[@"上文下图(图片尺寸1280×720)", @"7011619603027733"],
                                  @[@"左图右文(图片尺寸1200×800)", @"1001317613724659"],
                                  @[@"左文右图(图片尺寸1200×800)", @"3061112693227741"],
                                  @[@"双图双文-图文(大图尺寸1280×720)", @"6001113663823874"],
                                  @[@"文字浮层(上图下文1280×720)", @"6021015693625724"],
                                  @[@"文字浮层(上文下图1280×720)", @"2021617633021755"],
                                  @[@"文字浮层(单图1280×720)", @"7011916673826880"],
                                  @[@"横版纯图片(图片尺寸1280×720)", @"8031910693627892"],
                                  @[@"竖版纯图片(图片尺寸800×1200)", @"6021618693720821"],
                                  @[@"三小图双文(图片尺寸228×150)", @"4091615693423843"],
                                  @[@"双图双文-视频(尺寸1280×720)", @"8061016643928855"]];
    
    for (NSArray *item in advTypeTextArray) {
        __weak typeof(self) _weakSelf = self;
        UIAlertAction *advTypeAction = [UIAlertAction actionWithTitle:item[0]
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
            _weakSelf.placementIdTextField.placeholder = item[1];
            [_weakSelf refreshButton:nil];
        }];
        [_weakSelf.advStyleAlertController addAction:advTypeAction];
    }
    [self presentViewController:self.advStyleAlertController animated:YES completion:^{
        [self clickBackToMainView];
    }];
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
    backToMainView.userInteractionEnabled = YES;
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTap)];
    [backToMainView addGestureRecognizer:backTap];
}

- (void)backTap {
    [self.advStyleAlertController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)refreshButton:(id)sender {
    NSString *placementId = self.placementIdTextField.text.length > 0? self.placementIdTextField.text: self.placementIdTextField.placeholder;
    GDTAdParams *adParams = [[GDTAdParams alloc] init];
    adParams.adSize = CGSizeMake(self.widthSliderValue, self.heightSliderValue);
    adParams.maxVideoDuration = self.maxVideoDuration;
    adParams.minVideoDuration = self.minVideoDuration;
    adParams.detailPageVideoMuted = self.videoDetailPageVideoMuted;
    adParams.videoMuted = self.videoMuted;
    adParams.videoAutoPlayOnWWAN = self.videoAutoPlay;
    self.adManager = [[GDTNativeExpressProAdManager alloc] initWithPlacementId:placementId
                                                                           adPrams:adParams];
    self.adManager.delegate = self;
    [self.adManager loadAd:(NSInteger)self.adCountSliderValue];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)initVideoConfig
{
    self.widthSliderValue = [UIScreen mainScreen].bounds.size.width;
    self.heightSliderValue = 50;
    self.adCountSliderValue = 1;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更多视频配置" style:UIBarButtonItemStylePlain target:self action:@selector(jumpToAnotherView)];
}

- (void)jumpToAnotherView{
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    NativeExpressVideoConfigView *configView = [[NativeExpressVideoConfigView alloc]
                                                initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
                                                minVideoDuration:self.minVideoDuration
                                                maxVideoDuration:self.maxVideoDuration
                                                videoAutoPlay:self.videoAutoPlay
                                                videoMuted:self.videoMuted
                                                videoDetailPlageMuted:self.videoDetailPageVideoMuted];
    __weak typeof(self) _weakSelf = self;
    configView.widthSlider.value = self.widthSliderValue;
    configView.heightSlider.value = self.heightSliderValue;
    configView.adCountSlider.value = self.adCountSliderValue;
    configView.callBackBlock = ^(float widthSliderValue,
                                 float heightSliderValue,
                                 float adCountSliderValue,
                                 BOOL navigationRightButtonIsenabled,
                                 float minVideoDuration,
                                 float maxVideoDuration,
                                 BOOL videoAutoPlay,
                                 BOOL videoMuted,
                                 BOOL videoDetailPageVideoMuted) {
        [self.navigationItem.rightBarButtonItem setEnabled:navigationRightButtonIsenabled];
        _weakSelf.minVideoDuration = minVideoDuration;
        _weakSelf.maxVideoDuration = maxVideoDuration;
        _weakSelf.videoAutoPlay = videoAutoPlay;
        _weakSelf.videoMuted = videoMuted;
        _weakSelf.videoDetailPageVideoMuted = videoDetailPageVideoMuted;
        _weakSelf.widthSliderValue = widthSliderValue;
        _weakSelf.heightSliderValue = heightSliderValue;
        _weakSelf.adCountSliderValue = adCountSliderValue;
    };
    [configView showInView:self.view];
}

#pragma mark - GDTNativeExpressProAdManagerDelegete
/**
 * 拉取广告成功的回调
 */
- (void)gdt_nativeExpressProAdSuccessToLoad:(GDTNativeExpressProAdManager *)adManager views:(NSArray<__kindof GDTNativeExpressProAdView *> *)views
{
    NSLog(@"%s",__FUNCTION__);
    self.expressAdViews = [NSMutableArray arrayWithArray:views];
    if (self.expressAdViews.count) {
        [self.expressAdViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GDTNativeExpressProAdView *adView = (GDTNativeExpressProAdView *)obj;
            adView.controller = self;
            adView.delegate = self;
            [adView render];
            NSLog(@"eCPM:%ld eCPMLevel:%@", [adView eCPM], [adView eCPMLevel]);
        }];
    }
    [self.tableView reloadData];
}

/**
 * 拉取广告失败的回调
 */
- (void)gdt_nativeExpressProAdFailToLoad:(GDTNativeExpressProAdManager *)adManager error:(NSError *)error
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"Express Ad Load Fail : %@",error);
}


#pragma mark - GDTNativeExpressProAdViewDelegate;
- (void)gdt_NativeExpressProAdViewRenderSuccess:(GDTNativeExpressProAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
    [self.tableView reloadData];
}

- (void)gdt_NativeExpressProAdViewRenderFail:(GDTNativeExpressProAdView *)nativeExpressProAdView
{
    
}

- (void)gdt_NativeExpressProAdViewClicked:(GDTNativeExpressProAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)gdt_NativeExpressProAdViewClosed:(GDTNativeExpressProAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
    [self.expressAdViews removeObject:nativeExpressAdView];
    [nativeExpressAdView removeFromSuperview];
    [self.tableView reloadData];
    
}

- (void)gdt_NativeExpressProAdViewExposure:(GDTNativeExpressProAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)gdt_NativeExpressProAdViewWillPresentScreen:(GDTNativeExpressProAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)gdt_NativeExpressProAdViewDidPresentScreen:(GDTNativeExpressProAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)gdt_NativeExpressProAdViewWillDissmissScreen:(GDTNativeExpressProAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)gdt_NativeExpressProAdViewDidDissmissScreen:(GDTNativeExpressProAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)gdt_NativeExpressProAdView:(GDTNativeExpressProAdView *)nativeExpressProAdView playerStatusChanged:(GDTMediaPlayerStatus)status
{
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        UIView *view = [self.expressAdViews objectAtIndex:indexPath.row / 2];
        return view.bounds.size.height;
    }
    else {
        return 44;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.expressAdViews.count * 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.row % 2 == 0) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"nativeexpresscell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *subView = (UIView *)[cell.contentView viewWithTag:1000];
        if ([subView superview]) {
            [subView removeFromSuperview];
            subView = nil;
        }
        UIView *view = [self.expressAdViews objectAtIndex:indexPath.row / 2];
        view.tag = 1000;
        [cell.contentView addSubview:view];
        cell.accessibilityIdentifier = @"nativeTemp_even_ad";
    } else {
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"splitnativeexpresscell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessibilityIdentifier = @"nativeTemp_odd_ad";
    }
    return cell;
}

@end
