//
//  QSBKBaseViewController.m
//  RAC
//
//  Created by zhangyw on 15/5/21.
//  Copyright (c) 2015年 zyw. All rights reserved.
//

#import "QSBKBaseViewController.h"

@interface QSBKBaseViewController ()

@end

@implementation QSBKBaseViewController

- (void)setExtendedLayout
{
	self.edgesForExtendedLayout = UIRectEdgeNone;
	self.extendedLayoutIncludesOpaqueBars = NO;
	self.modalPresentationCapturesStatusBarAppearance = NO;
	self.automaticallyAdjustsScrollViewInsets = NO;
	self.extendedLayoutIncludesOpaqueBars = YES;
	self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
	return UIInterfaceOrientationPortrait;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
   [self setExtendedLayout];
	
	CGRect selfFrame = CGRectMake(0, 0,
								  CGRectGetWidth([UIScreen mainScreen].applicationFrame),
								  CGRectGetHeight([UIScreen mainScreen].applicationFrame)
								  - CGRectGetHeight(self.navigationController.navigationBar.frame)
								  - CGRectGetHeight(self.tabBarController.tabBar.frame));
	self.slimeTableView = [[slimeRefreshTableView alloc] initWithFrame:selfFrame
																 style:UITableViewStylePlain
														   headRefresh:NO
														   footRefresh:NO];
	self.slimeTableView.dataSource = self;
	self.slimeTableView.delegate = self;
	self.slimeTableView.showsVerticalScrollIndicator = NO;
	self.slimeTableView.showsHorizontalScrollIndicator = NO;
	self.slimeTableView.pullBackgroundColor = [UIColor whiteColor];
	self.slimeTableView.pullDelegate = (id<slimeRefreshPullDelegate>)self;
	self.slimeTableView.pullTextColor = [UIColor whiteColor];
	[self.view addSubview:self.slimeTableView];

	self.isOpenZoonAnimtion = YES;
	self.cellZoomInitialAlpha = [NSNumber numberWithFloat:1.0];
	self.cellZoomAnimationDuration = [NSNumber numberWithFloat:0.5];
	self.cellZoomXScaleFactor = [NSNumber numberWithFloat:0.9];
	self.cellZoomYScaleFactor = [NSNumber numberWithFloat:0.9];
	
	self.slimeTableView.backgroundView = nil;
	UIView *view = [[UIView alloc] init];
	view.backgroundColor = [UIColor clearColor];
	[self.slimeTableView setTableFooterView:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setIsRefreshHead:(BOOL)isRefreshHead
{
	_isRefreshHead = isRefreshHead;
	self.slimeTableView.isNeedRefreshHead = _isRefreshHead;
}

- (void)setIsRefreshMore:(BOOL)isRefreshMore
{
	_isRefreshMore = isRefreshMore;
	self.slimeTableView.isNeedRefreshMore = _isRefreshMore;
}

- (void)requestFootData
{
	if (_moreDataBlock) {
		_moreDataBlock();
	}
}

- (void)requestHeadData
{
	if (_headDataBlock) {
		_headDataBlock();
	}
}

@end
