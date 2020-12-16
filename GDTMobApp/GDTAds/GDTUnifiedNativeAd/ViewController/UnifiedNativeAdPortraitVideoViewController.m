//
//  UnifiedNativeAdPortraitVideoViewController.m
//  GDTMobApp
//
//  Created by royqpwang on 2019/5/16.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "UnifiedNativeAdPortraitVideoViewController.h"
#import "GDTUnifiedNativeAd.h"
#import "GDTAppDelegate.h"
#import "DemoPlayerTableViewCell.h"
#import "UnifiedNativeAdPortraitVideoTableViewCell.h"

@interface UnifiedNativeAdPortraitVideoViewController () <GDTUnifiedNativeAdDelegate, UITableViewDelegate, UITableViewDataSource, GDTUnifiedNativeAdViewDelegate>

@property (nonatomic, strong) GDTUnifiedNativeAd *nativeAd;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UITableViewCell *lastCell;
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation UnifiedNativeAdPortraitVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    
//    //---- 视频配置项，整段注释可使用外部VC开关控制
//    self.placementId = @"3080163449595027";
//    self.videoConfig.videoMuted = NO;
//    self.videoConfig.autoPlayPolicy = GDTVideoAutoPlayPolicyAlways;
//    self.videoConfig.userControlEnable = YES;
//    self.videoConfig.autoResumeEnable = NO;
//    self.videoConfig.detailPageEnable = NO;
//    //-----
    //---- 视频配置项，整段注释可使用外部VC开关控制
    if ([self.placementId  isEqual: @"3050349752532954"]) {
        self.placementId = @"3080163449595027";
    }
//    self.videoConfig.videoMuted = NO;
//    self.videoConfig.autoPlayPolicy = GDTVideoAutoPlayPolicyAlways;
//    self.videoConfig.userControlEnable = YES;
//    self.videoConfig.autoResumeEnable = NO;
//    self.videoConfig.detailPageEnable = NO;
    //-----
    
    
    self.nativeAd = [[GDTUnifiedNativeAd alloc] initWithPlacementId:self.placementId];
    self.nativeAd.delegate = self;
    self.nativeAd.minVideoDuration = self.minVideoDuration;
    self.nativeAd.maxVideoDuration = self.maxVideoDuration;
    [self.nativeAd loadAdWithAdCount:10];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)initView
{
    [self.view addSubview:self.tableView];
#if defined(__IPHONE_11_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0
    if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
#else
    self.automaticallyAdjustsScrollViewInsets = NO;
#endif
    [self.tableView registerClass:[DemoPlayerTableViewCell class] forCellReuseIdentifier:@"DemoPlayerTableViewCell"];
    [self.tableView registerClass:[UnifiedNativeAdPortraitVideoTableViewCell class] forCellReuseIdentifier:@"UnifiedNativeAdPortraitVideoTableViewCell"];
    [self.view addSubview:self.closeButton];
    self.closeButton.frame = CGRectMake(20, 60, 60, 40);
    
}

#pragma mark - GDTUnifiedNativeAdDelegate
- (void)gdt_unifiedNativeAdLoaded:(NSArray<GDTUnifiedNativeAdDataObject *> *)unifiedNativeAdDataObjects error:(NSError *)error
{
    if (error) {
        NSLog(@"error %@", error);
        return;
    }
    NSMutableArray *dataArray = [NSMutableArray new];
    for (GDTUnifiedNativeAdDataObject *dataObject in unifiedNativeAdDataObjects) {
        [dataArray addObject:dataObject];
        [dataArray addObject:@"demo"];
        NSLog(@"eCPM:%ld eCPMLevel:%@", [dataObject eCPM], [dataObject eCPMLevel]);
    }
    self.dataArray = [dataArray copy];
    [self.tableView reloadData];
}


#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.bounds.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = self.dataArray[indexPath.row];
    if ([item isKindOfClass:[GDTUnifiedNativeAdDataObject class]]) {
        GDTUnifiedNativeAdDataObject *nativeAdDataObject = item;
        NSLog(@"videoDuration:%lf", nativeAdDataObject.duration);
        nativeAdDataObject.videoConfig = self.videoConfig;
        UnifiedNativeAdPortraitVideoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"UnifiedNativeAdPortraitVideoTableViewCell"];
        [cell setupWithUnifiedNativeAdDataObject:nativeAdDataObject delegate:self vc:self];
        return cell;
    } else {
        DemoPlayerTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DemoPlayerTableViewCell"];
        cell.backgroundColor = [UIColor colorWithRed:((20 * indexPath.row) / 255.0) green:((50 * indexPath.row)/255.0) blue:((80 * indexPath.row)/255.0) alpha:1.0f];
        return cell;
    }
}

#pragma mark - private
- (void)clickClose
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - property getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.frame = self.view.bounds;
        _tableView.pagingEnabled = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.accessibilityIdentifier = @"tableView_id";
    }
    return _tableView;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
        _closeButton.backgroundColor = [UIColor grayColor];
        _closeButton.accessibilityIdentifier = @"closeButton_id";
    }
    return _closeButton;
}
@end
