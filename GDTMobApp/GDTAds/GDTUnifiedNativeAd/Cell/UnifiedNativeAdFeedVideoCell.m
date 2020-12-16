//
//  UnifiedNativeAdFeedVideoCell.m
//  GDTMobApp
//
//  Created by qpwang on 2019/5/18.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "UnifiedNativeAdFeedVideoCell.h"

@interface UnifiedNativeAdFeedVideoCell()

@property (nonatomic, strong) UILabel *muteLabel;
@property (nonatomic, strong) UISwitch *muteSwitch;
@property (nonatomic, strong) UIButton *pauseButton;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *stopButton;

@end

@implementation UnifiedNativeAdFeedVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.muteLabel];
        [self addSubview:self.muteSwitch];
        [self addSubview:self.playButton];
        [self addSubview:self.pauseButton];
        [self addSubview:self.stopButton];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.muteLabel.hidden = YES;
    self.muteSwitch.hidden = YES;
    self.playButton.hidden = YES;
    self.pauseButton.hidden = YES;
    self.stopButton.hidden = YES;
}

#pragma mark - public
- (void)setupWithUnifiedNativeAdDataObject:(GDTUnifiedNativeAdDataObject *)dataObject delegate:(id<GDTUnifiedNativeAdViewDelegate>)delegate vc:(UIViewController *)vc
{
    self.adView.delegate = delegate; // adView 广告回调
    self.adView.viewController = vc; // 跳转 VC
    CGFloat imageRate = 16 / 9.0;
    if (dataObject.imageHeight > 0) {
        imageRate = dataObject.imageWidth / (CGFloat)dataObject.imageHeight;
    }
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 16;
    self.adView.backgroundColor = [UIColor grayColor];
    self.adView.iconImageView.frame = CGRectMake(8, 8, 60, 60);
    self.adView.clickButton.frame = CGRectMake(width - 68, 8, 60, 44);
    self.adView.titleLabel.frame = CGRectMake(76, 8, 250, 30);
    self.adView.descLabel.frame = CGRectMake(8, 76, width, 30);
    CGFloat imageWidth = width;
    self.adView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 122 + imageWidth / imageRate);
    // mediaView logoView frame 更新在父view之后设置
    self.adView.mediaView.frame = CGRectMake(8, 114, imageWidth, imageWidth / imageRate);
    
    self.adView.logoView.frame = CGRectMake(CGRectGetWidth(self.adView.frame) - kGDTLogoImageViewDefaultWidth, CGRectGetHeight(self.adView.frame) - kGDTLogoImageViewDefaultHeight, kGDTLogoImageViewDefaultWidth, kGDTLogoImageViewDefaultHeight);
    [self.adView setupWithUnifiedNativeAdObject:dataObject];
    if ([dataObject isVideoAd]) {
        [self.adView registerDataObject:dataObject clickableViews:@[self.adView.iconImageView,
        self.adView.imageView] customClickableViews:@[self.adView.clickButton]];
    }
    else {
        [self.adView registerDataObject:dataObject clickableViews:@[self.adView.clickButton, self.adView.iconImageView,
                                                                self.adView.imageView]];
    }
    [self.adView.mediaView setPlayButtonImage:[UIImage imageNamed:@"play"] size:CGSizeMake(60, 60)]; // register方法后调用
    if (dataObject.isVideoAd) {
        self.muteLabel.frame = CGRectMake(76, 40, 50, 40);
        self.muteLabel.hidden = NO;
        self.muteSwitch.frame = CGRectMake(120, 40, 50, 40);
        self.muteSwitch.on = dataObject.videoConfig.videoMuted;
        self.muteSwitch.hidden = NO;
        self.playButton.frame = CGRectMake(170, 40, 40, 40);
        self.playButton.hidden = NO;
        self.pauseButton.frame = CGRectMake(210, 40, 50, 40);
        self.pauseButton.hidden = NO;
        self.stopButton.frame = CGRectMake(260, 40, 40, 40);
        self.stopButton.hidden = NO;
    }
    
}

+ (CGFloat)cellHeightWithUnifiedNativeAdDataObject:(GDTUnifiedNativeAdDataObject *)dataObject
{
    CGFloat height = 0;
    CGFloat imageRate = 16 / 9;
    if (dataObject.imageHeight > 0) {
        imageRate = dataObject.imageWidth / (CGFloat)dataObject.imageHeight;
    }
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 16;
    CGFloat imageWidth = width;
    height = 130 + imageWidth / imageRate;
    NSLog(@"cell height %@", @(height));
    return height;
}

#pragma mark - private
- (void)clickMuteSwitch
{
    [self.adView.mediaView muteEnable:self.muteSwitch.on];
}

- (void)clickPlay
{
    [self.adView.mediaView play];
}

- (void)clickPause
{
    [self.adView.mediaView pause];
}

- (void)clickStop
{
    [self.adView.mediaView stop];
}

#pragma mark - property getter
- (UISwitch *)muteSwitch
{
    if (!_muteSwitch) {
        _muteSwitch = [[UISwitch alloc] init];
        [_muteSwitch addTarget:self action:@selector(clickMuteSwitch) forControlEvents:UIControlEventValueChanged];
        _muteSwitch.accessibilityIdentifier = @"muteSwitch_id";
    }
    return _muteSwitch;
}

- (UILabel *)muteLabel
{
    if (!_muteLabel) {
        _muteLabel = [[UILabel alloc] init];
        _muteLabel.text = @"静音";
        _muteLabel.accessibilityIdentifier = @"muteLabel_id";
    }
    return _muteLabel;
}

- (UIButton *)playButton
{
    if (!_playButton) {
        _playButton = [[UIButton alloc] init];
        [_playButton setTitle:@"play" forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(clickPlay) forControlEvents:UIControlEventTouchUpInside];
        _playButton.accessibilityIdentifier = @"playButton_id";
    }
    return _playButton;
}

- (UIButton *)pauseButton
{
    if (!_pauseButton) {
        _pauseButton = [[UIButton alloc] init];
        [_pauseButton setTitle:@"pause" forState:UIControlStateNormal];
        [_pauseButton addTarget:self action:@selector(clickPause) forControlEvents:UIControlEventTouchUpInside];
        _pauseButton.accessibilityIdentifier = @"pauseButton_id";
    }
    return _pauseButton;
}

- (UIButton *)stopButton
{
    if (!_stopButton) {
        _stopButton = [[UIButton alloc] init];
        [_stopButton setTitle:@"stop" forState:UIControlStateNormal];
        [_stopButton addTarget:self action:@selector(clickStop) forControlEvents:UIControlEventTouchUpInside];
        _stopButton.accessibilityIdentifier = @"stopButton_id";
    }
    return _stopButton;
}
@end
