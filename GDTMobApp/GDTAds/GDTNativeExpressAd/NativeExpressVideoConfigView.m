//
//  NativeExpressVideoConfigView.m
//  GDTMobApp
//
//  Created by 胡城阳 on 2019/11/15.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "NativeExpressVideoConfigView.h"


#define View_Height (UIScreenHeight-100)
///******* 屏幕尺寸 *******/
#define     UIScreenWidth      [UIScreen mainScreen].bounds.size.width
#define     UIScreenHeight     [UIScreen mainScreen].bounds.size.height
@interface NativeExpressVideoConfigView ()<UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIScrollView *contentView;
@end

@implementation NativeExpressVideoConfigView


- (instancetype)initWithFrame:(CGRect)frame
             minVideoDuration:(float)minVideoDuration
             maxVideoDuration:(float)maxVideoDuration
                videoAutoPlay:(BOOL)videoAutoPlay
                   videoMuted:(BOOL)videoMuted
        videoDetailPlageMuted:(BOOL)videoDetailPageMuted
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.minVideoDurationSlider.value = minVideoDuration;
        self.maxVideoDurationSlider.value = maxVideoDuration;
        self.videoAutoPlaySwitch.on = videoAutoPlay;
        self.videoMutedSwitch.on = videoMuted;
        self.videoDetailPageMutedSwitch.on = videoDetailPageMuted;
        
        [self configView];
    }
    return self;
}

- (void)configView{
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

- (void)initBaseControlFrame {
    [self.contentView addSubview:self.widthLabel];
    self.widthLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.widthLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:20].active = YES;
    [self.widthLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:20].active = YES;
    [self.widthLabel.widthAnchor constraintEqualToConstant:150].active = YES;
    [self.widthLabel.heightAnchor constraintEqualToConstant:25].active = YES;
    
    [self.contentView addSubview:self.heightLabel];
    self.heightLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.heightLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:20].active = YES;
    [self.heightLabel.topAnchor constraintEqualToAnchor:self.widthLabel.bottomAnchor constant:20].active = YES;
    [self.heightLabel.widthAnchor constraintEqualToConstant:150].active = YES;
    [self.heightLabel.heightAnchor constraintEqualToConstant:25].active = YES;
    
    [self.contentView addSubview:self.adCountLabel];
    self.adCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.adCountLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:20].active = YES;
    [self.adCountLabel.topAnchor constraintEqualToAnchor:self.heightLabel.bottomAnchor constant:20].active = YES;
    [self.adCountLabel.widthAnchor constraintEqualToConstant:150].active = YES;
    [self.adCountLabel.heightAnchor constraintEqualToConstant:25].active = YES;
    
    [self.contentView addSubview:self.minVideoDurationLabel];
    self.minVideoDurationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.minVideoDurationLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:20].active = YES;
    [self.minVideoDurationLabel.topAnchor constraintEqualToAnchor:self.adCountLabel.bottomAnchor constant:20].active = YES;
    [self.minVideoDurationLabel.widthAnchor constraintEqualToConstant:150].active = YES;
    [self.minVideoDurationLabel.heightAnchor constraintEqualToConstant:25].active = YES;
    
    [self.contentView addSubview:self.maxVideoDurationLabel];
    self.maxVideoDurationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.maxVideoDurationLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:20].active = YES;
    [self.maxVideoDurationLabel.topAnchor constraintEqualToAnchor:self.minVideoDurationLabel.bottomAnchor constant:20].active = YES;
    [self.maxVideoDurationLabel.widthAnchor constraintEqualToConstant:150].active = YES;
    [self.maxVideoDurationLabel.heightAnchor constraintEqualToConstant:25].active = YES;
    
    [self.contentView addSubview:self.widthSlider];
    self.widthSlider.translatesAutoresizingMaskIntoConstraints = NO;
    [self.widthSlider.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-20].active = YES;
    [self.widthSlider.centerYAnchor constraintEqualToAnchor:self.widthLabel.centerYAnchor].active = YES;
    [self.widthSlider.widthAnchor constraintEqualToConstant:150].active = YES;
    
    [self.contentView addSubview:self.heightSlider];
    self.heightSlider.translatesAutoresizingMaskIntoConstraints = NO;
    [self.heightSlider.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-20].active = YES;
    [self.heightSlider.centerYAnchor constraintEqualToAnchor:self.heightLabel.centerYAnchor].active = YES;
    [self.heightSlider.widthAnchor constraintEqualToConstant:150].active = YES;
    
    [self.contentView addSubview:self.adCountSlider];
    self.adCountSlider.translatesAutoresizingMaskIntoConstraints = NO;
    [self.adCountSlider.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-20].active = YES;
    [self.adCountSlider.centerYAnchor constraintEqualToAnchor:self.adCountLabel.centerYAnchor].active = YES;
    [self.adCountSlider.widthAnchor constraintEqualToConstant:150].active = YES;
    
    [self.contentView addSubview:self.minVideoDurationSlider];
    self.minVideoDurationSlider.translatesAutoresizingMaskIntoConstraints = NO;
    [self.minVideoDurationSlider.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-20].active = YES;
    [self.minVideoDurationSlider.centerYAnchor constraintEqualToAnchor:self.minVideoDurationLabel.centerYAnchor].active = YES;
    [self.minVideoDurationSlider.widthAnchor constraintEqualToConstant:150].active = YES;
    
    [self.contentView addSubview:self.maxVideoDurationSlider];
    self.maxVideoDurationSlider.translatesAutoresizingMaskIntoConstraints = NO;
    [self.maxVideoDurationSlider.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-20].active = YES;
    [self.maxVideoDurationSlider.centerYAnchor constraintEqualToAnchor:self.maxVideoDurationLabel.centerYAnchor].active = YES;
    [self.maxVideoDurationSlider.widthAnchor constraintEqualToConstant:150].active = YES;
    
    [self.contentView addSubview:self.videoAutoPlaySwitchLabel];
    self.videoAutoPlaySwitchLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoAutoPlaySwitchLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:20].active = YES;
    [self.videoAutoPlaySwitchLabel.topAnchor constraintEqualToAnchor:self.maxVideoDurationLabel.bottomAnchor constant:20].active = YES;
    [self.videoAutoPlaySwitchLabel.widthAnchor constraintEqualToConstant:120].active = YES;
    [self.videoAutoPlaySwitchLabel.heightAnchor constraintEqualToConstant:25].active = YES;
    
    [self.contentView addSubview:self.videoAutoPlaySwitch];
    self.videoAutoPlaySwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoAutoPlaySwitch.leftAnchor constraintEqualToAnchor:self.videoAutoPlaySwitchLabel.rightAnchor constant:10].active = YES;
    [self.videoAutoPlaySwitch.centerYAnchor constraintEqualToAnchor:self.videoAutoPlaySwitchLabel.centerYAnchor].active = YES;
    
    [self.contentView addSubview:self.videoMutedSwitch];
    self.videoMutedSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoMutedSwitch.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-20].active = YES;
    [self.videoMutedSwitch.centerYAnchor constraintEqualToAnchor:self.videoAutoPlaySwitchLabel.centerYAnchor].active = YES;

    [self.contentView addSubview:self.videoDetailPageMutedSwitch];
    self.videoDetailPageMutedSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoDetailPageMutedSwitch.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-20].active = YES;
    [self.videoDetailPageMutedSwitch.topAnchor constraintEqualToAnchor:self.videoMutedSwitch.bottomAnchor constant:20].active = YES;

    [self.contentView addSubview:self.videoMutedSwitchLabel];
    self.videoMutedSwitchLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoMutedSwitchLabel.rightAnchor constraintEqualToAnchor:self.videoMutedSwitch.leftAnchor].active = YES;
    [self.videoMutedSwitchLabel.centerYAnchor constraintEqualToAnchor:self.videoMutedSwitch.centerYAnchor].active = YES;
    [self.videoMutedSwitchLabel.widthAnchor constraintEqualToConstant:120].active = YES;
    [self.videoMutedSwitchLabel.heightAnchor constraintEqualToConstant:25].active = YES;

    [self.contentView addSubview:self.videoDetailPageMutedSwitchLabel];
    self.videoDetailPageMutedSwitchLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.videoDetailPageMutedSwitchLabel.rightAnchor constraintEqualToAnchor:self.videoDetailPageMutedSwitch.leftAnchor].active = YES;
    [self.videoDetailPageMutedSwitchLabel.centerYAnchor constraintEqualToAnchor:self.videoDetailPageMutedSwitch.centerYAnchor].active = YES;
    [self.videoDetailPageMutedSwitchLabel.widthAnchor constraintEqualToConstant:170].active = YES;
    [self.videoDetailPageMutedSwitchLabel.heightAnchor constraintEqualToConstant:25].active = YES;
}

- (void)showInView:(UIView *)view {
    [view addSubview:self];
    __weak typeof(self) _weakSelf = self;
    self.contentView.frame = CGRectMake(0, UIScreenHeight, UIScreenWidth, View_Height);;
    [self.widthSlider addTarget:self action:@selector(sliderWithdDurationChanged) forControlEvents:UIControlEventValueChanged];
    self.widthLabel.text = [NSString stringWithFormat:@"宽:%ld",(long)self.widthSlider.value];

    [self.heightSlider addTarget:self action:@selector(sliderHeightDurationChanged) forControlEvents:UIControlEventValueChanged];
    self.heightLabel.text = [NSString stringWithFormat:@"高:%ld",(long)self.heightSlider.value];
    
    [self.adCountSlider addTarget:self action:@selector(sliderCountDurationChanged) forControlEvents:UIControlEventValueChanged];
    self.adCountLabel.text = [NSString stringWithFormat:@"count:%ld",(long)self.adCountSlider.value];
    
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
 _weakSelf.callBackBlock(self.widthSlider.value,
                            self.heightSlider.value,
                            self.adCountSlider.value,
                            YES,
                            (float)self.minVideoDurationSlider.value,
                            (float)self.maxVideoDurationSlider.value,
                            self.videoAutoPlaySwitch.on,
                            self.videoMutedSwitch.on,
                            self.videoDetailPageMutedSwitch.on);
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
- (void)sliderWithdDurationChanged {
    self.widthLabel.text = [NSString stringWithFormat:@"宽:%ld",(long)self.widthSlider.value];
}

- (void)sliderHeightDurationChanged {
    self.heightLabel.text = [NSString stringWithFormat:@"高:%ld",(long)self.heightSlider.value];
}

- (void)sliderCountDurationChanged {
    self.adCountLabel.text = [NSString stringWithFormat:@"count:%ld",(long)self.adCountSlider.value];
}

- (void)sliderMaxVideoDurationChanged {
    self.maxVideoDurationLabel.text = [NSString stringWithFormat:@"视频最大长:%ld",(long)self.maxVideoDurationSlider.value];
}

- (void)sliderMinVideoDurationChanged {
    self.minVideoDurationLabel.text = [NSString stringWithFormat:@"视频最小长:%ld",(long)self.minVideoDurationSlider.value];
}

#pragma mark - proerty getter
- (UILabel *)widthLabel
{
    if (!_widthLabel) {
        _widthLabel = [[UILabel alloc] init];
        _widthLabel.text = @"模版宽";
        _widthLabel.textColor = UIColor.blackColor;
        _widthLabel.accessibilityIdentifier = @"widthLabel_id";
    }
    return _widthLabel;
}

- (UISlider *)widthSlider
{
    if (!_widthSlider) {
        _widthSlider = [[UISlider alloc] init];
        _widthSlider.minimumValue = 0;
        _widthSlider.maximumValue = 500;
        _widthSlider.accessibilityIdentifier = @"widthSlider_id";
    }
    return _widthSlider;
}

- (UILabel *)heightLabel
{
    if (!_heightLabel) {
        _heightLabel = [[UILabel alloc] init];
        _heightLabel.text = @"模版高";
        _heightLabel.textColor = UIColor.blackColor;
        _heightLabel.accessibilityIdentifier = @"heightLabel_id";
    }
    return _heightLabel;
}

- (UISlider *)heightSlider
{
    if (!_heightSlider) {
        _heightSlider = [[UISlider alloc] init];
        _heightSlider.minimumValue = 0;
        _heightSlider.maximumValue = 500;
        _heightSlider.accessibilityIdentifier = @"heightSlider_id";
    }
    return _heightSlider;
}

- (UILabel *)adCountLabel
{
    if (!_adCountLabel) {
        _adCountLabel = [[UILabel alloc] init];
        _adCountLabel.text = @"count";
        _adCountLabel.textColor = UIColor.blackColor;
        _adCountLabel.accessibilityIdentifier = @"adCountLabel_id";
    }
    return _adCountLabel;
}

- (UISlider *)adCountSlider
{
    if (!_adCountSlider) {
        _adCountSlider = [[UISlider alloc] init];
        _adCountSlider.minimumValue = 0;
        _adCountSlider.maximumValue = 15;
        _adCountSlider.accessibilityIdentifier = @"adCountSlider_id";
    }
    return _adCountSlider;
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
        _minVideoDurationSlider.maximumValue = 30;
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
        _maxVideoDurationSlider.maximumValue = 30;
        _maxVideoDurationSlider.accessibilityIdentifier = @"maxVideoDurationSlider_id";
    }
    return _maxVideoDurationSlider;
}

- (UISwitch *)videoMutedSwitch
{
    if (!_videoMutedSwitch) {
        _videoMutedSwitch = [[UISwitch alloc] init];
        _videoMutedSwitch.accessibilityIdentifier = @"videoMutedSwitch_id";
    }
    return _videoMutedSwitch;
}

- (UISwitch *)videoDetailPageMutedSwitch
{
    if (!_videoDetailPageMutedSwitch) {
        _videoDetailPageMutedSwitch = [[UISwitch alloc] init];
        _videoDetailPageMutedSwitch.accessibilityIdentifier = @"videoDetailPageMutedSwitch_id";
    }
    return _videoDetailPageMutedSwitch;
}

- (UISwitch *)videoAutoPlaySwitch
{
    if (!_videoAutoPlaySwitch) {
        _videoAutoPlaySwitch = [[UISwitch alloc] init];
        _videoAutoPlaySwitch.accessibilityIdentifier = @"videoAutoPlaySwitch_id";
    }
    return _videoAutoPlaySwitch;
}

- (UILabel *)videoMutedSwitchLabel
{
    if (!_videoMutedSwitchLabel) {
        _videoMutedSwitchLabel = [[UILabel alloc] init];
        _videoMutedSwitchLabel.text = @"视频静音播放";
        _videoMutedSwitchLabel.textColor = UIColor.blackColor;
        _videoMutedSwitchLabel.accessibilityIdentifier = @"videoMutedSwitchLabel_id";
    }
    return _videoMutedSwitchLabel;
}

- (UILabel *)videoDetailPageMutedSwitchLabel
{
    if (!_videoDetailPageMutedSwitchLabel) {
        _videoDetailPageMutedSwitchLabel = [[UILabel alloc] init];
        _videoDetailPageMutedSwitchLabel.text = @"视频详情页静音播放";
        _videoDetailPageMutedSwitchLabel.textColor = UIColor.blackColor;
        _videoDetailPageMutedSwitchLabel.accessibilityIdentifier = @"videoDetailPageMutedSwitchLabel_id";
    }
    return _videoDetailPageMutedSwitchLabel;
}

- (UILabel *)videoAutoPlaySwitchLabel
{
    if (!_videoAutoPlaySwitchLabel) {
        _videoAutoPlaySwitchLabel = [[UILabel alloc] init];
        _videoAutoPlaySwitchLabel.text = @"非WiFi自动播放";
        _videoAutoPlaySwitchLabel.textColor = UIColor.blackColor;
        _videoAutoPlaySwitchLabel.accessibilityIdentifier = @"videoAutoPlaySwitchLabel_id";
    }
    return _videoAutoPlaySwitchLabel;
}

@end

