//
//  NativeExpressAdConfigView.m
//  GDTMobApp
//
//  Created by 胡城阳 on 2019/11/14.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "NativeExpressAdConfigView.h"

#define View_Height (UIScreenHeight-100)
///******* 屏幕尺寸 *******/
#define     UIScreenWidth      [UIScreen mainScreen].bounds.size.width
#define     UIScreenHeight     [UIScreen mainScreen].bounds.size.height
@interface NativeExpressAdConfigView ()<UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIScrollView *contentView;
@end

@implementation NativeExpressAdConfigView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
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
    
    [self.contentView addSubview:self.widthSlider];
    self.widthSlider.translatesAutoresizingMaskIntoConstraints = NO;
    [self.widthSlider.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-20].active = YES;
    [self.widthSlider.centerYAnchor constraintEqualToAnchor:self.widthLabel.centerYAnchor].active = YES;
    [self.widthSlider.widthAnchor constraintEqualToConstant:230].active = YES;
    
    [self.contentView addSubview:self.heightSlider];
    self.heightSlider.translatesAutoresizingMaskIntoConstraints = NO;
    [self.heightSlider.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-20].active = YES;
    [self.heightSlider.centerYAnchor constraintEqualToAnchor:self.heightLabel.centerYAnchor].active = YES;
    [self.heightSlider.widthAnchor constraintEqualToConstant:230].active = YES;
    
    [self.contentView addSubview:self.adCountSlider];
    self.adCountSlider.translatesAutoresizingMaskIntoConstraints = NO;
    [self.adCountSlider.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-20].active = YES;
    [self.adCountSlider.centerYAnchor constraintEqualToAnchor:self.adCountLabel.centerYAnchor].active = YES;
    [self.adCountSlider.widthAnchor constraintEqualToConstant:230].active = YES;
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
    [UIView animateWithDuration:0.3 animations:^{
        _weakSelf.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _weakSelf.contentView.frame = CGRectMake(0, UIScreenHeight - View_Height, UIScreenWidth, View_Height);
    }];
}

- (void)removeView {
    __weak typeof(self) _weakSelf = self;
    _weakSelf.callBackBlock(self.widthSlider.value, self.heightSlider.value,self.adCountSlider.value,YES);
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

@end

