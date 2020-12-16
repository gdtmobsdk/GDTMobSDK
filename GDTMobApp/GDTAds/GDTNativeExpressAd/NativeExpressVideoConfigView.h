//
//  NativeExpressVideoConfigView.h
//  GDTMobApp
//
//  Created by 胡城阳 on 2019/11/15.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDTNativeExpressAd.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^CallBackBlcok) (float widthSliderValue,
                              float heightSliderValue,
                              float adCountSliderValue,
                              BOOL navigationRightButtonIsenabled,
                              float minVideoDuration,
                              float maxVideoDuration,
                              BOOL videoAutoPlay,
                              BOOL videoMuted,
                              BOOL videoDetailPageVideoMuted
                              );

@interface NativeExpressVideoConfigView : UIView
@property (copy,nonatomic) CallBackBlcok callBackBlock;
@property (strong,nonatomic) GDTNativeExpressAd *nativeExpressAd;

@property (strong, nonatomic)  UILabel *widthLabel;
@property (strong, nonatomic)  UISlider *widthSlider;
@property (strong, nonatomic)  UILabel *heightLabel;
@property (strong, nonatomic)  UISlider *heightSlider;
@property (strong, nonatomic)  UISlider *adCountSlider;
@property (strong, nonatomic)  UILabel *adCountLabel;
@property (strong, nonatomic)  UILabel *minVideoDurationLabel;
@property (strong, nonatomic)  UISlider *minVideoDurationSlider;
@property (strong, nonatomic)  UILabel *maxVideoDurationLabel;
@property (strong, nonatomic)  UISlider *maxVideoDurationSlider;
@property (strong, nonatomic)  UILabel *videoMutedSwitchLabel;
@property (strong, nonatomic)  UILabel *videoDetailPageMutedSwitchLabel;
@property (strong, nonatomic)  UILabel *videoAutoPlaySwitchLabel;
@property (strong, nonatomic)  UISwitch *videoMutedSwitch;
@property (strong, nonatomic)  UISwitch *videoDetailPageMutedSwitch;
@property (strong, nonatomic)  UISwitch *videoAutoPlaySwitch;
- (instancetype)initWithFrame:(CGRect)frame
             minVideoDuration:(float)minVideoDuration
             maxVideoDuration:(float)maxVideoDuration
                videoAutoPlay:(BOOL)videoAutoPlay
                   videoMuted:(BOOL)videoMuted
                videoDetailPlageMuted:(BOOL)videoDetailPageMuted;
/**
 *  显示属性选择视图
 *
 *  @param view 要在哪个视图中显示
 */
- (void)showInView:(UIView *)view;

/**
 *  属性视图的消失
 */
- (void)removeView;
@end

NS_ASSUME_NONNULL_END
