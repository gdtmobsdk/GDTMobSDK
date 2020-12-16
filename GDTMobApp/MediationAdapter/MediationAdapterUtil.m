//
//  MediationAdapterUtil.m
//  GDTMobApp
//
//  Created by royqpwang on 2019/7/18.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "MediationAdapterUtil.h"

@implementation MediationAdapterUtil

+ (NSMutableDictionary *)getURLParams:(NSString *)url
{
    if (url.length == 0) {
        return nil;
    }
    NSArray * pairs = [url componentsSeparatedByString:@"&"];
    NSMutableDictionary * kvPairs = [NSMutableDictionary dictionary];
    for (NSString * pair in pairs) {
        NSArray * bits = [pair componentsSeparatedByString:@"="];
        NSString * key = [[bits objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString * value = [[bits objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [kvPairs setObject:value forKey:key];
    }
    return kvPairs;
}

@end
