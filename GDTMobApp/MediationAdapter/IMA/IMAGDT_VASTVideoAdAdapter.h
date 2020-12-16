//
//  IMAGDT_VASTVideoAdAdapter.h
//  GDTMobApp
//
//  Created by royqpwang on 2019/11/13.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDTUnifiedNativeAdNetworkAdapterProtocol.h"
#import "GDTUnifiedNativeAdDataObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface IMAGDT_VASTVideoAdAdapter : NSObject <GDTUnifiedNativeAdDataObjectAdapterProtocol, GDTMediaViewAdapterProtocol>

- (instancetype)initWithUnifiedNativeAdDataObject:(GDTUnifiedNativeAdDataObject *)dataObject;

@end

NS_ASSUME_NONNULL_END
