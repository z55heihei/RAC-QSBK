//
//  QSBKMineViewController.m
//  RAC
//
//  Created by zhangyw on 15/6/12.
//  Copyright (c) 2015年 zyw. All rights reserved.
//

#import "QSBKMineViewController.h"

#import "QSBKMyArticlesViewController.h"
#import "QSBKMyCommentViewController.h"
#import "QSBKMyMarkViewController.h"

@interface QSBKMineViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (assign,nonatomic) NSUInteger currentIndex;

@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIView *container;

@end

@implementation QSBKMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.currentIndex = 0;
	
	self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
	[self.pageViewController setDataSource:self];
	[self.pageViewController setDelegate:self];
	[self.pageViewController setViewControllers:@[[self viewAtIndex:_currentIndex] ] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
	[self addChildViewController:self.pageViewController];
	[self.pageViewController didMoveToParentViewController:self];
	[self.view addSubview:self.pageViewController.view];

	[self.segmentControl setSelectedSegmentIndex:0];
	@weakify(self)
	[[self.segmentControl rac_signalForControlEvents:UIControlEventValueChanged]subscribeNext:^(UISegmentedControl *segmentControl) {
		@strongify(self)
		NSInteger direction;
		if (self.segmentControl.selectedSegmentIndex > self.currentIndex) {
			direction = UIPageViewControllerNavigationDirectionForward;
		} else if (self.segmentControl.selectedSegmentIndex < self.currentIndex) {
			direction = UIPageViewControllerNavigationDirectionReverse;
		} else {
			return;
		}
		self.currentIndex = self.segmentControl.selectedSegmentIndex;
		[self.pageViewController setViewControllers:@[ [self viewAtIndex:self.currentIndex] ] direction:direction animated:YES completion:nil];
	}];
}

- (void)viewDidLayoutSubviews
{
	self.pageViewController.view.frame = self.container.frame;
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
	NSUInteger index = [self indexAtView:viewController];
	if (index == 0) {
		return nil;
	}
	index--;
	return [self viewAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
	NSUInteger index = [self indexAtView:viewController];
	index++;
	if (index == 3) {
		return nil;
	}
	return [self viewAtIndex:index];
}


- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
	UIViewController *currentView = [[pageViewController viewControllers] objectAtIndex:0];
	_currentIndex = [self indexAtView:currentView];
	self.segmentControl.selectedSegmentIndex = _currentIndex;
}


- (UIViewController *)viewAtIndex:(NSUInteger)index
{
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
	UIViewController *view;
	if (index == 0) {
		view = [storyboard instantiateViewControllerWithIdentifier:@"QSBKMyArticlesViewController"];
	} else if (index == 1) {
		view = [storyboard instantiateViewControllerWithIdentifier:@"QSBKMyCommentViewController"];
	} else if (index == 2) {
		view = [storyboard instantiateViewControllerWithIdentifier:@"QSBKMyMarkViewController"];
	}else {
		view = nil;
	}
	return view;
}

- (NSUInteger)indexAtView:(UIViewController *)view
{
	NSUInteger index;
	if ([view isKindOfClass:[QSBKMyArticlesViewController class]]) {
		index = 0;
	} else if ([view isKindOfClass:[QSBKMyCommentViewController class]]) {
		index = 1;
	} else if ([view isKindOfClass:[QSBKMyMarkViewController class]]) {
		index = 2;
	}
	return index;
}





@end
