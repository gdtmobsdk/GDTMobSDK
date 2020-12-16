//
//  UnifiedNativePortraitCollectionViewCell.m
//  GDTMobApp
//
//  Created by royqpwang on 2019/5/16.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "UnifiedNativePortraitCollectionViewCell.h"
#import "GDTLogoView.h"


@interface UnifiedNativePortraitCollectionViewCell()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation UnifiedNativePortraitCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    self.backgroundColor = [UIColor blueColor];
    [self addSubview:self.imageView];
}

- (void)setupWithUnifiedNativeAdDataObject:(GDTUnifiedNativeAdDataObject *)nativeAdDataObject
{
    NSURL *imageURL = [NSURL URLWithString:nativeAdDataObject.imageUrl];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = [UIImage imageWithData:imageData];
        });
    });
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.imageView.image = nil;
}

#pragma mark - property getter
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView.translatesAutoresizingMaskIntoConstraints = YES;
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.accessibilityIdentifier = @"imageView_id";
    }
    return _imageView;
}


@end
