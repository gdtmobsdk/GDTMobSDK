//
//  GDTBaseAdNetworkAdapterProtocol.h
//  GDTMobApp
//
//  Created by royqpwang on 2019/7/25.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GDTBaseAdNetworkAdapterProtocol <NSObject>

+ (NSString *)adapterVersion;

- (instancetype)initWithAdNetworkConnector:(id)connector
                                     posId:(NSString *)posId
                                    extStr:(NSString *)extStr;
@optional

- (NSInteger)eCPM;
- (NSInteger)priority;
- (NSString *)eCPMLevel;
- (void)cancelLoad;
- (NSInteger)mediationPrice;
- (BOOL)isContractAd;

@end

