//
//  UnifiedNativeAdPortraitVideoTableViewCell.m
//  GDTMobApp
//
//  Created by royqpwang on 2019/5/26.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "UnifiedNativeAdPortraitVideoTableViewCell.h"

@interface UnifiedNativeAdPortraitVideoTableViewCell() <GDTMediaViewDelegate>

@end

@implementation UnifiedNativeAdPortraitVideoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, GDTScreenHeight - 145, GDTScreenWidth, 145)];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.3;
        [self.adView insertSubview:bgView aboveSubview:self.adView.mediaView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.adView.backgroundColor = [UIColor grayColor];
    self.adView.clickButton.frame = CGRectMake(15, GDTScreenHeight - 75, GDTScreenWidth - 30, 44);
    self.adView.clickButton.backgroundColor = [UIColor blueColor];
    
    self.adView.iconImageView.frame = CGRectMake(15, GDTScreenHeight - 145, 60, 60);
    self.adView.iconImageView.layer.cornerRadius = 30;
    self.adView.iconImageView.layer.masksToBounds = YES;
    self.adView.titleLabel.frame = CGRectMake(85, GDTScreenHeight - 145, GDTScreenWidth - 100, 30);
    self.adView.titleLabel.textColor = [UIColor whiteColor];
    self.adView.descLabel.frame = CGRectMake(85, GDTScreenHeight - 115, GDTScreenWidth - 100, 30);
    self.adView.descLabel.textColor = [UIColor whiteColor];
    //    CGFloat imageWidth = width;
    self.adView.frame = self.bounds;
    // mediaView logoView frame 更新在父view之后设置
    self.adView.mediaView.frame = self.adView.bounds;
    
    self.adView.logoView.frame = CGRectMake(CGRectGetWidth(self.adView.frame) - kGDTLogoImageViewDefaultWidth, CGRectGetHeight(self.adView.frame) - kGDTLogoImageViewDefaultHeight - 60, kGDTLogoImageViewDefaultWidth, kGDTLogoImageViewDefaultHeight);
}

#pragma mark - public
- (void)setupWithUnifiedNativeAdDataObject:(GDTUnifiedNativeAdDataObject *)dataObject delegate:(id<GDTUnifiedNativeAdViewDelegate>)delegate vc:(UIViewController *)vc
{
    self.adView.delegate = delegate; // adView 广告回调
    self.adView.viewController = vc; // 跳转 VC
    self.adView.mediaView.delegate = self;
    [self.adView setupWithUnifiedNativeAdObject:dataObject];
    [self.adView registerDataObject:dataObject clickableViews:@[self.adView.clickButton,
                                                                self.adView.iconImageView,
                                                                self.adView.imageView,
                                                                self.adView.titleLabel,
                                                                self.adView.descLabel]];
}

#pragma mark - GDTMediaViewDelegate
- (void)gdt_mediaViewDidPlayFinished:(GDTMediaView *)mediaView
{
    [mediaView play];
}

- (void)gdt_mediaViewDidTapped:(GDTMediaView *)mediaView
{
    
}

@end
