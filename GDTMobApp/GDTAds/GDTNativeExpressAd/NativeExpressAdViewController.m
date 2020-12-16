//
//  NativeExpressAdViewController.m
//  GDTMobApp
//
//  Created by michaelxing on 2017/4/17.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "NativeExpressAdViewController.h"
#import "GDTNativeExpressAd.h"
#import "GDTNativeExpressAdView.h"
#import "GDTAppDelegate.h"
#import "NativeExpressAdConfigView.h"

@interface NativeExpressAdViewController ()<GDTNativeExpressAdDelegete,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *expressAdViews;

@property (nonatomic, strong) GDTNativeExpressAd *nativeExpressAd;

@property (weak, nonatomic) IBOutlet UITextField *placementIdTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic)  float widthSliderValue;
@property (assign, nonatomic)  float heightSliderValue;
@property (assign, nonatomic)  float adCountSliderValue;

//切换广告样式
@property (nonatomic, strong) UIAlertController *advStyleAlertController;

@property (nonatomic, strong) UIButton *changAdvStyleButton;

@end

@implementation NativeExpressAdViewController

static NSString *ABOVEPH_BLOWTEXT_STR = @"5030722621265924";

static NSString *ABOVETEXT_BLOW_PH_STR = @"8010090333885456";

static NSString *LEFTPH_RIHGTTEXT_STR = @"1080793303881448";

static NSString *LEFTTEXT_RIGHTPH_STR = @"9050097313684512";

static NSString *TWOPH_AND_TEXT_STR = @"5070297373087567";

static NSString *WIDTHPHOTO_STR = @"5070791337820394";

static NSString *HEIGHTPHOTO_STR = @"6090492353182599";

static NSString *THREE_SMALLPH_STR = @"9050492343889611";

static NSString *ABOVETEXT_SURFACE_BLOWPH_STR = @"9010495393982624";

static NSString *ABOVEPH_BLOWTEXT_SURFACE_STR = @"6020493353488605";

static NSString *TEXTSURFACE_ONEPHOTO_STR = @"3030690323789618";

static NSString *HEIGHTERPHOTO_STR = @"6060290383380659";

static NSInteger ADVTYPE_COUNT = 12;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"nativeexpresscell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"splitnativeexpresscell"];
    
    [self initVideoConfig];
    [self refreshButton:nil];
}

- (IBAction)selectADVStyle:(id)sender {
    self.advStyleAlertController = [UIAlertController alertControllerWithTitle:@"请选择需要的广告样式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *advTypeTextArray = @[@"上图下文(图片尺寸1280×720)",
                                  @"上文下图(图片尺寸1280×720)",
                                  @"左图右文(图片尺寸1200×800)",
                                  @"左文右图(图片尺寸1200×800)",
                                  @"双图双文(大图尺寸1280×720)",
                                  @"纯图片(图片尺寸1280×720)",
                                  @"纯图片(图片尺寸800×1200)",
                                  @"三小图(图片尺寸228×150)",
                                  @"文字浮层(上文下图1280×720)",
                                  @"文字浮层(上图下文1280×720)",
                                  @"文字浮层(单图1280×720)",
                                  @"纯图片(图片尺寸1080×1920或800×1200)"];
    
    NSArray *advTypePosIDArray = @[ABOVEPH_BLOWTEXT_STR,
                                    ABOVETEXT_BLOW_PH_STR,
                                    LEFTPH_RIHGTTEXT_STR,
                                    LEFTTEXT_RIGHTPH_STR,
                                    TWOPH_AND_TEXT_STR,
                                    WIDTHPHOTO_STR,
                                    HEIGHTPHOTO_STR,
                                    THREE_SMALLPH_STR,
                                    ABOVETEXT_SURFACE_BLOWPH_STR,
                                    ABOVEPH_BLOWTEXT_SURFACE_STR,
                                    TEXTSURFACE_ONEPHOTO_STR,
                                    HEIGHTERPHOTO_STR];
    
    for (NSInteger i = 0; i < ADVTYPE_COUNT; i++) {
        UIAlertAction *advTypeAction = [UIAlertAction actionWithTitle:advTypeTextArray[i]
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
            self.placementIdTextField.placeholder = advTypePosIDArray[i];
            [self refreshViewWithNewPosID];
        }];
        [self.advStyleAlertController addAction:advTypeAction];
    }
    [self presentViewController:self.advStyleAlertController
                       animated:YES
                     completion:^{
        [self clickBackToMainView];
    }];
}

- (void)clickBackToMainView {
    NSArray *arrayViews = [UIApplication sharedApplication].keyWindow.subviews;
    UIView *backToMainView = [[UIView alloc] init];
    for (int i = 1; i < arrayViews.count; i++) {
        NSString *viewNameStr = [NSString stringWithFormat:@"%s",object_getClassName(arrayViews[i])];
        if ([viewNameStr isEqualToString:@"UITransitionView"]) {
            backToMainView = [arrayViews[i] subviews][0];
            break;
        }
    }
//    UIView *backToMainView = [arrayViews.lastObject subviews][0];
    backToMainView.userInteractionEnabled = YES;
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTap)];
    [backToMainView addGestureRecognizer:backTap];
}

- (void)backTap {
    [self.advStyleAlertController dismissViewControllerAnimated:YES completion:nil];
}

- (void)refreshViewWithNewPosID {
    NSString *placementId = self.placementIdTextField.text.length > 0? self.placementIdTextField.text: self.placementIdTextField.placeholder;
    self.nativeExpressAd = [[GDTNativeExpressAd alloc] initWithPlacementId:placementId
                                                                    adSize:CGSizeMake(self.widthSliderValue, self.heightSliderValue)];
    self.nativeExpressAd.delegate = self;
    [self.nativeExpressAd loadAd:(NSInteger)self.adCountSliderValue];
}


- (IBAction)refreshButton:(id)sender {
    NSString *placementId = self.placementIdTextField.text.length > 0? self.placementIdTextField.text: self.placementIdTextField.placeholder;
    self.nativeExpressAd = [[GDTNativeExpressAd alloc] initWithPlacementId:placementId
                                                                    adSize:CGSizeMake(self.widthSliderValue, self.heightSliderValue)];
    self.nativeExpressAd.delegate = self;
    [self.nativeExpressAd loadAd:(NSInteger)self.adCountSliderValue];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)initVideoConfig
{
    self.widthSliderValue = [UIScreen mainScreen].bounds.size.width;
    self.heightSliderValue = 50;
    self.adCountSliderValue = 3;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更多视频配置" style:UIBarButtonItemStylePlain target:self action:@selector(jumpToAnotherView)];
}

- (void)jumpToAnotherView{
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    NativeExpressAdConfigView *theNativeExpressAdConfigView = [[NativeExpressAdConfigView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    __weak typeof(self) _weakSelf = self;
    theNativeExpressAdConfigView.widthSlider.value = self.widthSliderValue;
    theNativeExpressAdConfigView.heightSlider.value = self.heightSliderValue;
    theNativeExpressAdConfigView.adCountSlider.value = self.adCountSliderValue;
    theNativeExpressAdConfigView.callBackBlock = ^(float widthSliderValue,float heightSliderValue,float adCountSliderValue,BOOL navigationRightButtonIsenabled){
        [self.navigationItem.rightBarButtonItem setEnabled:navigationRightButtonIsenabled];
        _weakSelf.widthSliderValue = widthSliderValue;
        _weakSelf.heightSliderValue = heightSliderValue;
        _weakSelf.adCountSliderValue = adCountSliderValue;
    };
    [theNativeExpressAdConfigView showInView:self.view];
}

#pragma mark - GDTNativeExpressAdDelegete
/**
 * 拉取广告成功的回调
 */
- (void)nativeExpressAdSuccessToLoad:(GDTNativeExpressAd *)nativeExpressAd views:(NSArray<__kindof GDTNativeExpressAdView *> *)views
{
    NSLog(@"%s",__FUNCTION__);
    self.expressAdViews = [NSMutableArray arrayWithArray:views];
    if (self.expressAdViews.count) {
        [self.expressAdViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GDTNativeExpressAdView *expressView = (GDTNativeExpressAdView *)obj;
            expressView.controller = self;
            [expressView render];
            NSLog(@"eCPM:%ld eCPMLevel:%@", [expressView eCPM], [expressView eCPMLevel]);
        }];
    }
    [self.tableView reloadData];
}

/**
 * 拉取广告失败的回调
 */
- (void)nativeExpressAdRenderFail:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 * 拉取原生模板广告失败
 */
- (void)nativeExpressAdFailToLoad:(GDTNativeExpressAd *)nativeExpressAd error:(NSError *)error
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"Express Ad Load Fail : %@",error);
}

- (void)nativeExpressAdViewRenderSuccess:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
    [self.tableView reloadData];
}

- (void)nativeExpressAdViewClicked:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)nativeExpressAdViewClosed:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
    [self.expressAdViews removeObject:nativeExpressAdView];
    [self.tableView reloadData];
}

- (void)nativeExpressAdViewExposure:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)nativeExpressAdViewWillPresentScreen:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)nativeExpressAdViewDidPresentScreen:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)nativeExpressAdViewWillDismissScreen:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)nativeExpressAdViewDidDismissScreen:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"%s",__FUNCTION__);
}

/**
 * 详解:当点击应用下载或者广告调用系统程序打开时调用
 */
- (void)nativeExpressAdViewApplicationWillEnterBackground:(GDTNativeExpressAdView *)nativeExpressAdView
{
    NSLog(@"--------%s-------",__FUNCTION__);
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        UIView *view = [self.expressAdViews objectAtIndex:indexPath.row / 2];
        return view.bounds.size.height;
    }
    else {
        return 44;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.expressAdViews.count * 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.row % 2 == 0) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"nativeexpresscell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *subView = (UIView *)[cell.contentView viewWithTag:1000];
        if ([subView superview]) {
            [subView removeFromSuperview];
        }
        UIView *view = [self.expressAdViews objectAtIndex:indexPath.row / 2];
        view.tag = 1000;
        [cell.contentView addSubview:view];
        cell.accessibilityIdentifier = @"nativeTemp_even_ad";
    } else {
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"splitnativeexpresscell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor grayColor];
        cell.accessibilityIdentifier = @"nativeTemp_odd_ad";
    }
    return cell;
}

@end
