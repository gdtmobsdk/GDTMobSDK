//
//  GDTNavigationController.m
//  GDTMobApp
//
//  Created by GaoChao on 13-12-31.
//  Copyright (c) 2013年 Tencent. All rights reserved.
//

#import "GDTNavigationController.h"

@interface GDTNavigationController ()

@end

@implementation GDTNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return [(UIViewController *)[[self viewControllers] lastObject] shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [[[self viewControllers] lastObject] preferredInterfaceOrientationForPresentation];
}

@end
