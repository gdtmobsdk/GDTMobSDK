//
//  UnifiedNativeAdViewController.m
//  GDTMobApp
//
//  Created by nimomeng on 2018/10/12.
//  Copyright © 2018 Tencent. All rights reserved.
//

#import "UnifiedNativeAdViewController.h"
#import "GDTUnifiedNativeAd.h"
#import "GDTAppDelegate.h"
#import "UnifiedNativeAdPortraitVideoViewController.h"
#import "UnifiedNativeAdFeedVideoTableViewController.h"
#import "GDTUnifiedNativeAdVideoConfigView.h"


@interface UnifiedNativeAdViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *placementTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic)  float minVideoDurationSliderValue;
@property (assign, nonatomic)  float maxVideoDurationSliderValue;
@property (nonatomic, strong) GDTVideoConfig *videoConfig;
@property (nonatomic, strong) NSArray *demoArray;

//自渲染增加广告位选择功能
@property (nonatomic, strong) UIAlertController *advStyleAlertController;

@property (nonatomic, strong) NSArray *advTypeTextArray;

@property (nonatomic, strong) UIButton *changAdvStyleButton;

@end

@implementation UnifiedNativeAdViewController

static NSString *ONE_BIGPHOTO_STR = @"2010198333498040";

static NSString *ONE_SMALL_PHOTO_STR = @"6060695393196051";

static NSString *ONE_WIDER_PHOTO_STR = @"4030598303592073";

static NSString *THREE_PHOTO_OR_ONE_PHOTO_STR = @"2000566593234845";

static NSString *ONE_BIG_WIDER_PHOTO_STR = @"1050394363190036";

//video
static NSString *ONE_LONGER_VIDEO_STR = @"3050349752532954";

static NSString *THREE_VIDEO_OR_ONE_VIDEO_STR = @"5040995343496165";

static NSString *ONE_WIDER_VIDEO_STR = @"7000593393992138";

static NSString *ONE_WIDER_OR_LONGER_VIDEO_STR = @"2040594303892119";

static NSInteger ADVTYPE_COUNT = 5;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initVideoConfig];
    self.advTypeTextArray = @[
                                  @[@"主图尺寸1280×720（纯图）",@"UnifiedNativeAdFeedImageViewController"],
                                  @[@"三小图或一张1280*720（纯图）",@"UnifiedNativeAdFeedImageViewController"],
                                  @[@"主图尺寸1080×1920或800×1200（纯图）", @"UnifiedNativeAdFeedImageViewController"],
                                  @[@"主图尺寸1280×720（视频）", @"UnifiedNativeAdFeedVideoTableViewController"],
                                  @[@"主图尺寸720×1280（视频）", @"UnifiedNativeAdFeedVideoTableViewController"],
    ];
    self.demoArray = @[
                        @[@"图片Feed", @"UnifiedNativeAdFeedImageViewController"],
                        @[@"视频Feed", @"UnifiedNativeAdFeedVideoTableViewController"],
                        @[@"竖版全屏视频", @"UnifiedNativeAdPortraitVideoViewController"],
                        @[@"竖版Feed视频", @"UnifiedNativeAdPortraitFeedViewController"],
                        @[@"视频贴片广告", @"UnifiedNativePreVideoViewController"],
                        ];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}

- (IBAction)selectADVStyle:(id)sender {
    self.advStyleAlertController = [UIAlertController alertControllerWithTitle:@"请选择需要的广告样式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *advTypePosIDArray = @[
                                  ONE_BIGPHOTO_STR,
                                  THREE_PHOTO_OR_ONE_PHOTO_STR,
                                  ONE_BIG_WIDER_PHOTO_STR,
                                  THREE_VIDEO_OR_ONE_VIDEO_STR,
                                  ONE_WIDER_VIDEO_STR,
    ];
        for (NSInteger i = 0; i < ADVTYPE_COUNT; i++) {
            if (i == 10) {
                
            }
            
            UIAlertAction *advTypeAction = [UIAlertAction actionWithTitle:self.advTypeTextArray[i][0]
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * _Nonnull action) {
                self.placementTextField.placeholder = advTypePosIDArray[i];
            }];
            [self.advStyleAlertController addAction:advTypeAction];
        }
        [self presentViewController:self.advStyleAlertController
                           animated:YES
                         completion:^{
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
//    UIView *backToMainView = [arrayViews.lastObject subviews][0];
    backToMainView.userInteractionEnabled = YES;
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTap)];
    [backToMainView addGestureRecognizer:backTap];
}

- (void)backTap {
    [self.advStyleAlertController dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)jumpToAnotherView{
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    GDTUnifiedNativeAdVideoConfigView *UnifiedNativeAdVideoConfigView = [[GDTUnifiedNativeAdVideoConfigView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) theVideoConfig:self.videoConfig];
    __weak typeof(self) _weakSelf = self;
    UnifiedNativeAdVideoConfigView.minVideoDurationSlider.value = self.minVideoDurationSliderValue;
    UnifiedNativeAdVideoConfigView.maxVideoDurationSlider.value = self.maxVideoDurationSliderValue;
    UnifiedNativeAdVideoConfigView.callBackBlock = ^(GDTVideoConfig *videoConfig,float MinVideoDurationSliderValue,float MaxVideoDurationSliderValue,BOOL navigationRightButtonIsenabled){
        _weakSelf.videoConfig = videoConfig;
        [self.navigationItem.rightBarButtonItem setEnabled:navigationRightButtonIsenabled];
        _weakSelf.minVideoDurationSliderValue = MinVideoDurationSliderValue;
        _weakSelf.maxVideoDurationSliderValue = MaxVideoDurationSliderValue;
    };
    [UnifiedNativeAdVideoConfigView showInView:self.view];
}
- (void)initVideoConfig
{
    self.videoConfig = [[GDTVideoConfig alloc] init];
    self.minVideoDurationSliderValue = 5;
    self.maxVideoDurationSliderValue = 60;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更多视频配置" style:UIBarButtonItemStylePlain target:self action:@selector(jumpToAnotherView)];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.demoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    }
    cell.textLabel.text = self.demoArray[indexPath.row][0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *className = self.demoArray[indexPath.row][1];
    UnifiedNativeAdBaseViewController *vc = [[NSClassFromString(className) alloc] init];
    vc.appId = kGDTMobSDKAppId;
    vc.placementId = self.placementTextField.text.length > 0? self.placementTextField.text: self.placementTextField.placeholder;
//    vc.maxVideoDuration = (NSInteger)self.maxVideoDurationSlider.value;
//    GDTVideoConfig *videoConfig = [[GDTVideoConfig alloc] init];
//    videoConfig.autoPlayPolicy = [self.autoPlayPolicyTextField.text integerValue];
//    videoConfig.videoMuted = self.shouldMuteOnVideoSwitch.isOn;
//    videoConfig.detailPageEnable = self.videoDetailPageEnableSwitch.isOn;
//    videoConfig.autoResumeEnable = self.autoResumeEnableSwitch.isOn;
//    videoConfig.userControlEnable = self.userControlEnableSwitch.isOn;
//    videoConfig.progressViewEnable = self.progressViewEnableSwitch.isOn;
//    videoConfig.coverImageEnable = self.coverImageEnableSwitch.isOn;
//    vc.videoConfig = videoConfig;
    vc.minVideoDuration = (NSInteger)self.minVideoDurationSliderValue;
    vc.maxVideoDuration = (NSInteger)self.maxVideoDurationSliderValue;
    vc.videoConfig = self.videoConfig;
    if ([vc isKindOfClass:[UnifiedNativeAdPortraitVideoViewController class]]) {
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
