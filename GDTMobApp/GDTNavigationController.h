//
//  GDTNavigationController.h
//  GDTMobApp
//
//  Created by GaoChao on 13-12-31.
//  Copyright (c) 2013年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDTNavigationController : UINavigationController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
- (BOOL)shouldAutorotate;
- (NSUInteger)supportedInterfaceOrientations;

@end
