//
//  GDTSplashZoomOutView+GDTDraggable.m
//  GDTMobApp
//
//  Created by nimomeng on 2020/11/18.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "GDTSplashZoomOutView+GDTDraggable.h"

@implementation GDTSplashZoomOutView (GDTDraggable)
- (void)supportDrag
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    
    CGPoint offset = [pan translationInView:self];
    [pan setTranslation:CGPointZero inView:self];
    
    // 确定ZoomOutView的位置
    CGFloat targetX = CGRectGetMidX(self.frame) + offset.x;
    CGFloat targetY = CGRectGetMidY(self.frame) + offset.y;
    CGFloat margin = 12;
    CGFloat widthLimitation = CGRectGetWidth(self.frame) + margin;
    CGFloat heightLimitation = CGRectGetHeight(self.frame) + margin;
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
        {
            // ZoomOutView随手指拖动变化位置
            self.center = CGPointMake(targetX, targetY);
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            BOOL needAnimation;
            // 处理拖动到边界的情况
            if (targetX < widthLimitation / 2) {
                targetX = widthLimitation / 2;
                needAnimation = YES;
            }
            
            if (targetX > [UIScreen mainScreen].bounds.size.width - widthLimitation / 2) {
                targetX = [UIScreen mainScreen].bounds.size.width - widthLimitation / 2;
                needAnimation = YES;
            }
            
            if (targetY < heightLimitation / 2) {
                targetY = heightLimitation / 2;
                needAnimation = YES;
            }
            
            if (targetY > [UIScreen mainScreen].bounds.size.height - heightLimitation / 2) {
                targetY = [UIScreen mainScreen].bounds.size.height - heightLimitation / 2;
                needAnimation = YES;
            }
            // 给一个bounds的动画
            if (needAnimation) {
                [UIView animateWithDuration:0.3 animations:^{
                    self.center = CGPointMake(targetX, targetY);
                }];
            }
        }
        default:
            break;
    }
}

@end
