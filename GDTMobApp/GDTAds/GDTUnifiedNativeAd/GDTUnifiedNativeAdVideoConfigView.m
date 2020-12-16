//
//  GDTUnifiedNativeAdVideoConfigViewViewController.m
//  GDTMobApp
//
//  Created by 胡城阳 on 2019/11/12.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "GDTUnifiedNativeAdVideoConfigView.h"

#define View_Height (UIScreenHeight-100)
///******* 屏幕尺寸 *******/
#define     UIScreenWidth      [UIScreen mainScreen].bounds.size.width
#define     UIScreenHeight     [UIScreen mainScreen].bounds.size.height
@interface GDTUnifiedNativeAdVideoConfigView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) GDTVideoConfig *videoConfig;
@property (nonatomic, weak) UIScrollView *contentView;
@end

@implementation GDTUnifiedNativeAdVideoConfigView


- (instancetype)initWithFrame:(CGRect)frame theVideoConfig:(GDTVideoConfig *)videoConfig 
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.videoConfig = videoConfig;
        [self configView];
    }
    return self;
}


- (void)configView{
    
    
    self.autoPlayPolicyTextField.text = [NSString stringWithFormat:@"%@", @(self.videoConfig.autoPlayPolicy)];
    self.shouldMuteOnVideoSwitch.on = self.videoConfig.videoMuted;
    self.videoDetailPageEnableSwitch.on = self.videoConfig.detailPageEnable;
    self.userControlEnableSwitch.on = self.videoConfig.userControlEnable;
    self.autoResumeEnableSwitch.on = self.videoConfig.autoResumeEnable;
    self.progressViewEnableSwitch.on = self.videoConfig.progressViewEnable;
    self.coverImageEnableSwitch.on = self.videoConfig.coverImageEnable;
    self.videoDetailPageMuteSwitch.on = self.videoConfig.detailPageVideoMuted;
    
        // 添加手势，点击背景视图消失
    UITapGestureRecognizer *tapBackGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)];
    tapBackGesture.delegate = self;
    [self addGestureRecognizer:tapBackGesture];
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.contentSize = CGSizeMake(UIScreenWidth, UIScreenHeight + View_Height);
    contentView.showsHorizontalScrollIndicator = NO;
    [self addSubview:contentView];
    self.contentView = contentView;
    [self initBaseControlFrame];
}

- (void)initBaseControlFrame{
    [self.contentView addSubview:self.autoPlayPolicyTextFieldLabel];
    self.autoPlayPolicyTextFieldLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.autoPlayPolicyTextFieldLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:20].active = YES;
    [self.autoPlayPolicyTextFieldLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:12].active = YES;
    [self.autoPlayPolicyTextFieldLabel.widthAnchor constraintEqualToConstant:180].active = YES;
    [self.autoPlayPolicyTextFieldLabel.heightAnchor constraintEqualToConstant:44].active = YES;
    
    [self.contentView addSubview:self.shouldMuteOnVideoSwitchLabel];
    self.shouldMuteOnVideoSwitchLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.shouldMuteOnVideoSwitchLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:20].active = YES;
    [self.shouldMuteOnVideoSwitchLabel.topAnchor constraintEqualToAnchor:self.autoPlayPolicyTextFieldLabel.bottomAnchor constant:8].active = YES;
    [self.shouldMuteOnVideoSwitchLabel.widthAnchor constraintEqualToConstant:150].active = YES;
    [self.shouldMuteOnVideoSwitchLabel.heightAnchor constraintEqualToConstant:44].active = YES;
    
    [self.contentView addSubview:self.videoDetailPageEnableSwitchLabel];
    self.videoDetailPageEnableSwitchLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoDetailPageEnableSwitchLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:20].active = YES;
    [self.videoDetailPageEnableSwitchLabel.topAnchor constraintEqualToAnchor:self.shouldMuteOnVideoSwitchLabel.bottomAnchor constant:8].active = YES;
    [self.videoDetailPageEnableSwitchLabel.widthAnchor constraintEqualToConstant:150].active = YES;
    [self.videoDetailPageEnableSwitchLabel.heightAnchor constraintEqualToConstant:44].active = YES;
    
    [self.contentView addSubview:self.userControlEnableSwitchLabel];
    self.userControlEnableSwitchLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.userControlEnableSwitchLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:20].active = YES;
    [self.userControlEnableSwitchLabel.topAnchor constraintEqualToAnchor:self.videoDetailPageEnableSwitchLabel.bottomAnchor constant:8].active = YES;
    [self.userControlEnableSwitchLabel.widthAnchor constraintEqualToConstant:150].active = YES;
    [self.userControlEnableSwitchLabel.heightAnchor constraintEqualToConstant:44].active = YES;
    
    [self.contentView addSubview:self.autoResumeEnableSwitchLabel];
    self.autoResumeEnableSwitchLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.autoResumeEnableSwitchLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:20].active = YES;
    [self.autoResumeEnableSwitchLabel.topAnchor constraintEqualToAnchor:self.userControlEnableSwitchLabel.bottomAnchor constant:8].active = YES;
    [self.autoResumeEnableSwitchLabel.widthAnchor constraintEqualToConstant:150].active = YES;
    [self.autoResumeEnableSwitchLabel.heightAnchor constraintEqualToConstant:44].active = YES;
    
    [self.contentView addSubview:self.progressViewEnableSwitchLabel];
    self.progressViewEnableSwitchLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.progressViewEnableSwitchLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:20].active = YES;
    [self.progressViewEnableSwitchLabel.topAnchor constraintEqualToAnchor:self.autoResumeEnableSwitchLabel.bottomAnchor constant:8].active = YES;
    [self.progressViewEnableSwitchLabel.widthAnchor constraintEqualToConstant:150].active = YES;
    [self.progressViewEnableSwitchLabel.heightAnchor constraintEqualToConstant:44].active = YES;
    
    [self.contentView addSubview:self.coverImageEnableSwitchLabel];
    self.coverImageEnableSwitchLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.coverImageEnableSwitchLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:20].active = YES;
    [self.coverImageEnableSwitchLabel.topAnchor constraintEqualToAnchor:self.progressViewEnableSwitchLabel.bottomAnchor constant:8].active = YES;
    [self.coverImageEnableSwitchLabel.widthAnchor constraintEqualToConstant:150].active = YES;
    [self.coverImageEnableSwitchLabel.heightAnchor constraintEqualToConstant:44].active = YES;
    
    [self.contentView addSubview:self.autoPlayPolicyTextField];
    self.autoPlayPolicyTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.autoPlayPolicyTextField.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-20].active = YES;
    [self.autoPlayPolicyTextField.centerYAnchor constraintEqualToAnchor:self.autoPlayPolicyTextFieldLabel.centerYAnchor].active = YES;
    [self.autoPlayPolicyTextField.widthAnchor constraintEqualToConstant:50].active = YES;
    [self.autoPlayPolicyTextField.heightAnchor constraintEqualToConstant:30].active = YES;
    
    [self.contentView addSubview:self.shouldMuteOnVideoSwitch];
    self.shouldMuteOnVideoSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.shouldMuteOnVideoSwitch.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-20].active = YES;
    [self.shouldMuteOnVideoSwitch.centerYAnchor constraintEqualToAnchor:self.shouldMuteOnVideoSwitchLabel.centerYAnchor].active = YES;
    
    [self.contentView addSubview:self.videoDetailPageEnableSwitch];
    self.videoDetailPageEnableSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoDetailPageEnableSwitch.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-20].active = YES;
    [self.videoDetailPageEnableSwitch.centerYAnchor constraintEqualToAnchor:self.videoDetailPageEnableSwitchLabel.centerYAnchor].active = YES;
    
    [self.contentView addSubview:self.userControlEnableSwitch];
    self.userControlEnableSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.userControlEnableSwitch.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-20].active = YES;
    [self.userControlEnableSwitch.centerYAnchor constraintEqualToAnchor:self.userControlEnableSwitchLabel.centerYAnchor].active = YES;
    
    [self.contentView addSubview:self.autoResumeEnableSwitch];
    self.autoResumeEnableSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.autoResumeEnableSwitch.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-20].active = YES;
    [self.autoResumeEnableSwitch.centerYAnchor constraintEqualToAnchor:self.autoResumeEnableSwitchLabel.centerYAnchor].active = YES;
    
    [self.contentView addSubview:self.progressViewEnableSwitch];
    self.progressViewEnableSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.progressViewEnableSwitch.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-20].active = YES;
    [self.progressViewEnableSwitch.centerYAnchor constraintEqualToAnchor:self.progressViewEnableSwitchLabel.centerYAnchor].active = YES;
    
    [self.contentView addSubview:self.coverImageEnableSwitch];
    self.coverImageEnableSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.coverImageEnableSwitch.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-20].active = YES;
    [self.coverImageEnableSwitch.centerYAnchor constraintEqualToAnchor:self.coverImageEnableSwitchLabel.centerYAnchor].active = YES;
    //
    [self.contentView addSubview:self.minVideoDurationLabel];
    self.minVideoDurationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.minVideoDurationLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:20].active = YES;
    [self.minVideoDurationLabel.topAnchor constraintEqualToAnchor:self.coverImageEnableSwitchLabel.bottomAnchor constant:8].active = YES;
    [self.minVideoDurationLabel.widthAnchor constraintEqualToConstant:150].active = YES;
    [self.minVideoDurationLabel.heightAnchor constraintEqualToConstant:44].active = YES;
    
    [self.contentView addSubview:self.maxVideoDurationLabel];
    self.maxVideoDurationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.maxVideoDurationLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:20].active = YES;
    [self.maxVideoDurationLabel.topAnchor constraintEqualToAnchor:self.minVideoDurationLabel.bottomAnchor constant:8].active = YES;
    [self.maxVideoDurationLabel.widthAnchor constraintEqualToConstant:150].active = YES;
    [self.maxVideoDurationLabel.heightAnchor constraintEqualToConstant:44].active = YES;
    
    [self.contentView addSubview:self.videoDetailPageMuteSwitchLabel];
    self.videoDetailPageMuteSwitchLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoDetailPageMuteSwitchLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:20].active = YES;
    [self.videoDetailPageMuteSwitchLabel.topAnchor constraintEqualToAnchor:self.maxVideoDurationLabel.bottomAnchor constant:8].active = YES;
    [self.videoDetailPageMuteSwitchLabel.widthAnchor constraintEqualToConstant:180].active = YES;
    [self.videoDetailPageMuteSwitchLabel.heightAnchor constraintEqualToConstant:44].active = YES;
    
    [self.contentView addSubview:self.minVideoDurationSlider];
    self.minVideoDurationSlider.translatesAutoresizingMaskIntoConstraints = NO;
    [self.minVideoDurationSlider.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-20].active = YES;
    [self.minVideoDurationSlider.centerYAnchor constraintEqualToAnchor:self.minVideoDurationLabel.centerYAnchor].active = YES;
    [self.minVideoDurationSlider.widthAnchor constraintEqualToConstant:120].active = YES;
    
    [self.contentView addSubview:self.maxVideoDurationSlider];
    self.maxVideoDurationSlider.translatesAutoresizingMaskIntoConstraints = NO;
    [self.maxVideoDurationSlider.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-20].active = YES;
    [self.maxVideoDurationSlider.centerYAnchor constraintEqualToAnchor:self.maxVideoDurationLabel.centerYAnchor].active = YES;
    [self.maxVideoDurationSlider.widthAnchor constraintEqualToConstant:120].active = YES;
    
    [self.contentView addSubview:self.videoDetailPageMuteSwitch];
    self.videoDetailPageMuteSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoDetailPageMuteSwitch.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-20].active = YES;
    [self.videoDetailPageMuteSwitch.centerYAnchor constraintEqualToAnchor:self.videoDetailPageMuteSwitchLabel.centerYAnchor].active = YES;
    

    
}


- (void)showInView:(UIView *)view {
    [view addSubview:self];
    __weak typeof(self) _weakSelf = self;
    self.contentView.frame = CGRectMake(0, UIScreenHeight, UIScreenWidth, View_Height);;
    [self.minVideoDurationSlider addTarget:self action:@selector(sliderMinVideoDurationChanged) forControlEvents:UIControlEventValueChanged];
    self.minVideoDurationLabel.text = [NSString stringWithFormat:@"视频最小长:%ld",(long)self.minVideoDurationSlider.value];

    [self.maxVideoDurationSlider addTarget:self action:@selector(sliderMaxVideoDurationChanged) forControlEvents:UIControlEventValueChanged];
    self.maxVideoDurationLabel.text = [NSString stringWithFormat:@"视频最大长:%ld",(long)self.maxVideoDurationSlider.value];
    [UIView animateWithDuration:0.3 animations:^{
        _weakSelf.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _weakSelf.contentView.frame = CGRectMake(0, UIScreenHeight - View_Height, UIScreenWidth, View_Height);
    }];
}

- (void)removeView {
    __weak typeof(self) _weakSelf = self;
    self.videoConfig.autoPlayPolicy = [self.autoPlayPolicyTextField.text integerValue];
    self.videoConfig.videoMuted = self.shouldMuteOnVideoSwitch.on;
    self.videoConfig.detailPageEnable = self.videoDetailPageEnableSwitch.on;
    self.videoConfig.autoResumeEnable = self.autoResumeEnableSwitch.on;
    self.videoConfig.userControlEnable = self.userControlEnableSwitch.on;
    self.videoConfig.progressViewEnable = self.progressViewEnableSwitch.on;
    self.videoConfig.coverImageEnable = self.coverImageEnableSwitch.on;
    self.videoConfig.detailPageVideoMuted = self.videoDetailPageMuteSwitch.on;
    _weakSelf.callBackBlock((self.videoConfig),self.minVideoDurationSlider.value, self.maxVideoDurationSlider.value,YES);
    [UIView animateWithDuration:0.3 animations:^{
        _weakSelf.backgroundColor = [UIColor clearColor];
        _weakSelf.contentView.frame = CGRectMake(0, UIScreenHeight, UIScreenWidth, View_Height);
    } completion:^(BOOL finished) {
        [_weakSelf removeFromSuperview];
    }];
}
#pragma mark - UIGestureRecognizerDelegate
//确定点击范围
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:self.contentView]) {
        return NO;
    }
    return YES;
}

#pragma mark - private
- (void)sliderMaxVideoDurationChanged {
    self.maxVideoDurationLabel.text = [NSString stringWithFormat:@"视频最大长:%ld",(long)self.maxVideoDurationSlider.value];
}

- (void)sliderMinVideoDurationChanged {
    self.minVideoDurationLabel.text = [NSString stringWithFormat:@"视频最小长:%ld",(long)self.minVideoDurationSlider.value];
}

#pragma mark - proerty getter
- (UITextField *)autoPlayPolicyTextField
{
    if (!_autoPlayPolicyTextField) {
        _autoPlayPolicyTextField = [[UITextField alloc] init];
        _autoPlayPolicyTextField.placeholder = @"0";
        _autoPlayPolicyTextField.textAlignment = NSTextAlignmentLeft;
        _autoPlayPolicyTextField.textColor = [UIColor blackColor];
        _autoPlayPolicyTextField.font = [UIFont systemFontOfSize:12];
        _autoPlayPolicyTextField.borderStyle = UITextBorderStyleRoundedRect;
        _autoPlayPolicyTextField.accessibilityIdentifier = @"autoPlayPolicyTextField_id";
    }
    return _autoPlayPolicyTextField;
}

- (UISwitch *)shouldMuteOnVideoSwitch
{
    if (!_shouldMuteOnVideoSwitch) {
        _shouldMuteOnVideoSwitch = [[UISwitch alloc] init];
        _shouldMuteOnVideoSwitch.accessibilityIdentifier = @"shouldMuteOnVideoSwitch_id";
    }
    return _shouldMuteOnVideoSwitch;
}

- (UISwitch *)videoDetailPageEnableSwitch
{
    if (!_videoDetailPageEnableSwitch) {
        _videoDetailPageEnableSwitch = [[UISwitch alloc] init];
        _videoDetailPageEnableSwitch.accessibilityIdentifier = @"videoDetailPageEnableSwitch_id";
    }
    return _videoDetailPageEnableSwitch;
}

- (UISwitch *)userControlEnableSwitch
{
    if (!_userControlEnableSwitch) {
        _userControlEnableSwitch = [[UISwitch alloc] init];
        _userControlEnableSwitch.accessibilityIdentifier = @"userControlEnableSwitch_id";
    }
    return _userControlEnableSwitch;
}

- (UISwitch *)autoResumeEnableSwitch
{
    if (!_autoResumeEnableSwitch) {
        _autoResumeEnableSwitch = [[UISwitch alloc] init];
        _autoResumeEnableSwitch.accessibilityIdentifier = @"autoResumeEnableSwitch_id";
    }
    return _autoResumeEnableSwitch;
}

- (UISwitch *)progressViewEnableSwitch
{
    if (!_progressViewEnableSwitch) {
        _progressViewEnableSwitch = [[UISwitch alloc] init];
        _progressViewEnableSwitch.accessibilityIdentifier = @"progressViewEnableSwitch_id";
    }
    return _progressViewEnableSwitch;
}

- (UISwitch *)coverImageEnableSwitch
{
    if (!_coverImageEnableSwitch) {
        _coverImageEnableSwitch = [[UISwitch alloc] init];
        _coverImageEnableSwitch.accessibilityIdentifier = @"coverImageEnableSwitch_id";
    }
    return _coverImageEnableSwitch;
}

- (UILabel *)autoPlayPolicyTextFieldLabel
{
    if (!_autoPlayPolicyTextFieldLabel) {
        _autoPlayPolicyTextFieldLabel = [[UILabel alloc] init];
        _autoPlayPolicyTextFieldLabel.text = @"自动播放策略(0/1/2)";
        _autoPlayPolicyTextFieldLabel.textColor = UIColor.blackColor;
        _autoPlayPolicyTextFieldLabel.accessibilityIdentifier = @"autoPlayPolicyTextFieldLabel_id";
    }
    return _autoPlayPolicyTextFieldLabel;
}

- (UILabel *)shouldMuteOnVideoSwitchLabel
{
    if (!_shouldMuteOnVideoSwitchLabel) {
        _shouldMuteOnVideoSwitchLabel = [[UILabel alloc] init];
        _shouldMuteOnVideoSwitchLabel.text = @"视频静音播放";
        _shouldMuteOnVideoSwitchLabel.textColor = UIColor.blackColor;
        _shouldMuteOnVideoSwitchLabel.accessibilityIdentifier = @"shouldMuteOnVideoSwitchLabel_id";
    }
    return _shouldMuteOnVideoSwitchLabel;
}

- (UILabel *)videoDetailPageEnableSwitchLabel
{
    if (!_videoDetailPageEnableSwitchLabel) {
        _videoDetailPageEnableSwitchLabel = [[UILabel alloc] init];
        _videoDetailPageEnableSwitchLabel.text = @"视频详情页";
        _videoDetailPageEnableSwitchLabel.textColor = UIColor.blackColor;
        _videoDetailPageEnableSwitchLabel.accessibilityIdentifier = @"videoDetailPageEnableSwitchLabel_id";
    }
    return _videoDetailPageEnableSwitchLabel;
}

- (UILabel *)userControlEnableSwitchLabel
{
    if (!_userControlEnableSwitchLabel) {
        _userControlEnableSwitchLabel = [[UILabel alloc] init];
        _userControlEnableSwitchLabel.text = @"手动暂停播放";
        _userControlEnableSwitchLabel.textColor = UIColor.blackColor;
        _userControlEnableSwitchLabel.accessibilityIdentifier = @"userControlEnableSwitchLabel_id";
    }
    return _userControlEnableSwitchLabel;
}

- (UILabel *)autoResumeEnableSwitchLabel
{
    if (!_autoResumeEnableSwitchLabel) {
        _autoResumeEnableSwitchLabel = [[UILabel alloc] init];
        _autoResumeEnableSwitchLabel.text = @"自动续播";
        _autoResumeEnableSwitchLabel.textColor = UIColor.blackColor;
        _autoResumeEnableSwitchLabel.accessibilityIdentifier = @"autoResumeEnableSwitchLabel_id";
    }
    return _autoResumeEnableSwitchLabel;
}

- (UILabel *)progressViewEnableSwitchLabel
{
    if (!_progressViewEnableSwitchLabel) {
        _progressViewEnableSwitchLabel = [[UILabel alloc] init];
        _progressViewEnableSwitchLabel.text = @"展示进度条";
        _progressViewEnableSwitchLabel.textColor = UIColor.blackColor;
        _progressViewEnableSwitchLabel.accessibilityIdentifier = @"progressViewEnableSwitchLabel_id";
    }
    return _progressViewEnableSwitchLabel;
}

- (UILabel *)coverImageEnableSwitchLabel
{
    if (!_coverImageEnableSwitchLabel) {
        _coverImageEnableSwitchLabel = [[UILabel alloc] init];
        _coverImageEnableSwitchLabel.text = @"展示封面图";
        _coverImageEnableSwitchLabel.textColor = UIColor.blackColor;
        _coverImageEnableSwitchLabel.accessibilityIdentifier = @"coverImageEnableSwitchLabel_id";
    }
    return _coverImageEnableSwitchLabel;
}

- (UILabel *)minVideoDurationLabel
{
    if (!_minVideoDurationLabel) {
        _minVideoDurationLabel = [[UILabel alloc] init];
        _minVideoDurationLabel.text = @"视频最小长";
        _minVideoDurationLabel.textColor = UIColor.blackColor;
        _minVideoDurationLabel.accessibilityIdentifier = @"minVideoDurationLabel_id";
    }
    return _minVideoDurationLabel;
}

- (UISlider *)minVideoDurationSlider
{
    if (!_minVideoDurationSlider) {
        _minVideoDurationSlider = [[UISlider alloc] init];
        _minVideoDurationSlider.minimumValue = 5;
        _minVideoDurationSlider.maximumValue = 60;
        _minVideoDurationSlider.accessibilityIdentifier = @"minVideoDurationSlider_id";
    }
    return _minVideoDurationSlider;
}

- (UILabel *)maxVideoDurationLabel
{
    if (!_maxVideoDurationLabel) {
        _maxVideoDurationLabel = [[UILabel alloc] init];
        _maxVideoDurationLabel.text = @"视频最大长";
        _maxVideoDurationLabel.textColor = UIColor.blackColor;
        _maxVideoDurationLabel.accessibilityIdentifier = @"maxVideoDurationLabel_id";
    }
    return _maxVideoDurationLabel;
}

- (UISlider *)maxVideoDurationSlider
{
    if (!_maxVideoDurationSlider) {
        _maxVideoDurationSlider = [[UISlider alloc] init];
        _maxVideoDurationSlider.minimumValue = 5;
        _maxVideoDurationSlider.maximumValue = 60;
        _maxVideoDurationSlider.accessibilityIdentifier = @"maxVideoDurationSlider_id";
    }
    return _maxVideoDurationSlider;
}

- (UISwitch *)videoDetailPageMuteSwitch
{
    if (!_videoDetailPageMuteSwitch) {
        _videoDetailPageMuteSwitch = [[UISwitch alloc] init];
        _videoDetailPageMuteSwitch.accessibilityIdentifier = @"videoDetailPageMuteSwitch_id";
    }
    return _videoDetailPageMuteSwitch;
}

- (UILabel *)videoDetailPageMuteSwitchLabel
{
    if (!_videoDetailPageMuteSwitchLabel) {
        _videoDetailPageMuteSwitchLabel = [[UILabel alloc] init];
        _videoDetailPageMuteSwitchLabel.text = @"视频详情页静音播放";
        _videoDetailPageMuteSwitchLabel.textColor = UIColor.blackColor;
        _videoDetailPageMuteSwitchLabel.accessibilityIdentifier = @"videoDetailPageMuteSwitchLabel_id";
    }
    return _videoDetailPageMuteSwitchLabel;
}
@end

