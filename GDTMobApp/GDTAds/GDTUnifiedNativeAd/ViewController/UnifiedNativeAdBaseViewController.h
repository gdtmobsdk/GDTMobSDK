//
//  UnifiedNativeAdBaseViewController.h
//  GDTMobApp
//
//  Created by royqpwang on 2019/5/19.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDTUnifiedNativeAd.h"

NS_ASSUME_NONNULL_BEGIN

@interface UnifiedNativeAdBaseViewController : UIViewController

@property (nonatomic, copy) NSString *placementId;
@property (nonatomic, copy) NSString *appId;
@property (nonatomic, assign) NSInteger minVideoDuration;
@property (nonatomic, assign) NSInteger maxVideoDuration;
@property (nonatomic, strong) GDTVideoConfig *videoConfig;

@end

NS_ASSUME_NONNULL_END
