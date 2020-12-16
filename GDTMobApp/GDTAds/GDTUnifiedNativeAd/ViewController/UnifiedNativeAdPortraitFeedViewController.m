//
//  UnifiedNativeAdPortraitVideoViewController.m
//  GDTMobApp
//
//  Created by royqpwang on 2019/5/16.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "UnifiedNativeAdPortraitFeedViewController.h"
#import "GDTUnifiedNativeAd.h"
#import "UnifiedNativePortraitCollectionViewCell.h"
#import "GDTAppDelegate.h"
#import "UnifiedNativeAdPortraitDetailViewController.h"

@interface UnifiedNativeAdPortraitFeedViewController () <GDTUnifiedNativeAdDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) GDTUnifiedNativeAd *nativeAd;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *adArray;

@end

@implementation UnifiedNativeAdPortraitFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    self.adArray = [NSMutableArray new];
    
    //---- 视频配置项，整段注释可使用外部VC开关控制
//    self.videoConfig.videoMuted = NO;
//    self.videoConfig.autoPlayPolicy = GDTVideoAutoPlayPolicyNever; // 手动控制播放
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

- (void)initView
{
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[UnifiedNativePortraitCollectionViewCell class]
            forCellWithReuseIdentifier:@"UnifiedNativePortraitCollectionViewCell"];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
}

#pragma mark - GDTUnifiedNativeAdDelegate
- (void)gdt_unifiedNativeAdLoaded:(NSArray<GDTUnifiedNativeAdDataObject *> *)unifiedNativeAdDataObjects error:(NSError *)error
{
    if (error) {
        NSLog(@"error %@", error);
        return;
    }
    
    for (GDTUnifiedNativeAdDataObject *dataObject in unifiedNativeAdDataObjects) {
        if (dataObject.isVideoAd) {
            [self.adArray addObject:@"test"];
            [self.adArray addObject:@"test"];
            [self.adArray addObject:dataObject];
        }
        NSLog(@"eCPM:%ld eCPMLevel:%@", [dataObject eCPM], [dataObject eCPMLevel]);
    }
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.adArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id item = self.adArray[indexPath.row];
    if ([item isKindOfClass:[GDTUnifiedNativeAdDataObject class]]) {
        UnifiedNativePortraitCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UnifiedNativePortraitCollectionViewCell" forIndexPath:indexPath];
        [cell setupWithUnifiedNativeAdDataObject:item];
        return cell;
        
    } else {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithRed:((10 * indexPath.row) / 255.0) green:((20 * indexPath.row)/255.0) blue:((30 * indexPath.row)/255.0) alpha:1.0f];
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.bounds.size.width / 2 - 20, 320);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id item = self.adArray[indexPath.row];
    if ([item isKindOfClass:[GDTUnifiedNativeAdDataObject class]]) {
        UnifiedNativeAdPortraitDetailViewController *vc = [[UnifiedNativeAdPortraitDetailViewController alloc] init];
        vc.dataObject = item;
        vc.dataObject.videoConfig = self.videoConfig;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - property getter
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        layout.minimumLineSpacing = 2;
        _collectionView.frame = self.view.bounds;
        _collectionView.translatesAutoresizingMaskIntoConstraints = YES;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor grayColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.accessibilityIdentifier = @"collectionView_id";
    }
    return _collectionView;
}


@end
