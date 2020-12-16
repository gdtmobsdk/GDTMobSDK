//
//  GDTAdViewController.m
//  GDTMobApp
//
//  Created by royqpwang on 2019/3/26.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "GDTAdViewController.h"
#import <AdSupport/ASIdentifierManager.h>
#import <objc/runtime.h>

@interface GDTAdViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation GDTAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.demoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    }
    cell.textLabel.text = self.demoArray[indexPath.row][0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id item = self.demoArray[indexPath.row][1];
    if ([item isKindOfClass:[NSString class]]) {
        UIViewController *vc = [[NSClassFromString(item) alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        NSString *idfaCopyedMsg = [NSString stringWithFormat:@"%@\n 已经复制到你的粘贴板",idfa];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:idfaCopyedMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        // sync idfa to pasteboard
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = idfa;
        [alert show];
    }
}

#pragma mark - property getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.accessibilityIdentifier = @"tableView_id";
    }
    return _tableView;
}

@end
