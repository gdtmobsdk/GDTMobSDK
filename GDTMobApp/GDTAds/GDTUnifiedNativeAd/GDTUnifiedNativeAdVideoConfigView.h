//
//  GDTUnifiedNativeAdVideoConfigViewViewController.h
//  GDTMobApp
//
//  Created by 胡城阳 on 2019/11/12.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDTUnifiedNativeAd.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^CallBackBlcok) (GDTVideoConfig *theVideConfig,float MinVideoDurationSliderValue,float maxVideoDurationSliderValue,BOOL navigationRightButtonIsenabled);
@interface GDTUnifiedNativeAdVideoConfigView : UIView
@property (copy,nonatomic) CallBackBlcok callBackBlock;
@property (strong, nonatomic)  UITextField *autoPlayPolicyTextField;
@property (strong, nonatomic)  UISwitch *shouldMuteOnVideoSwitch;
@property (strong, nonatomic)  UISwitch *videoDetailPageEnableSwitch;
@property (strong, nonatomic)  UISwitch *userControlEnableSwitch;
@property (strong, nonatomic)  UISwitch *autoResumeEnableSwitch;
@property (strong, nonatomic)  UISwitch *progressViewEnableSwitch;
@property (strong, nonatomic)  UISwitch *coverImageEnableSwitch;

@property (strong, nonatomic)  UILabel *autoPlayPolicyTextFieldLabel;
@property (strong, nonatomic)  UILabel *shouldMuteOnVideoSwitchLabel;
@property (strong, nonatomic)  UILabel *videoDetailPageEnableSwitchLabel;
@property (strong, nonatomic)  UILabel *userControlEnableSwitchLabel;
@property (strong, nonatomic)  UILabel *autoResumeEnableSwitchLabel;
@property (strong, nonatomic)  UILabel *progressViewEnableSwitchLabel;
@property (strong, nonatomic)  UILabel *coverImageEnableSwitchLabel;

@property (strong, nonatomic)  UILabel *minVideoDurationLabel;
@property (strong, nonatomic)  UISlider *minVideoDurationSlider;
@property (strong, nonatomic)  UILabel *maxVideoDurationLabel;
@property (strong, nonatomic)  UISlider *maxVideoDurationSlider;
@property (strong, nonatomic)  UISwitch *videoDetailPageMuteSwitch;
@property (strong, nonatomic)  UILabel *videoDetailPageMuteSwitchLabel;
- (instancetype)initWithFrame:(CGRect)frame theVideoConfig:(GDTVideoConfig *)videoConfig;
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
