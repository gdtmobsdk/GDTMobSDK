//
//  UnifiedNativePortraitCollectionViewCell.h
//  GDTMobApp
//
//  Created by royqpwang on 2019/5/16.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDTUnifiedNativeAdView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UnifiedNativePortraitCollectionViewCell : UICollectionViewCell

- (void)setupWithUnifiedNativeAdDataObject:(GDTUnifiedNativeAdDataObject *)nativeAdDataObject;

@end

NS_ASSUME_NONNULL_END
