//
//  QSBKMyCommentViewController.m
//  RAC
//
//  Created by zhangyw on 15/6/15.
//  Copyright (c) 2015年 zyw. All rights reserved.
//

#import "QSBKMyCommentViewController.h"

#import "strollLastestCell.h"
#import "QSBKDetailViewController.h"

@interface QSBKMyCommentViewController ()
@property (nonatomic,assign) NSInteger currentpage;
@property (nonatomic,strong) NSMutableArray *commentsArray;
@end

@implementation QSBKMyCommentViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	
	[self initConfigData];
}

- (void)initConfigData
{
	self.isRefreshHead = YES;
	self.isRefreshMore = YES;
	
	
	@weakify(self)
	self.headDataBlock =^{
		@strongify(self)
		[self getDefaultData];
	};
	
	self.moreDataBlock =^{
		@strongify(self)
		self.currentpage ++;
		[self getMoreData];
	};
	
	
	_currentpage = 1;
	[self getDefaultData];
	[self.slimeTableView registerNib:[UINib nibWithNibName:NSStringFromClass(strollLastestCell.class) bundle:nil]
			  forCellReuseIdentifier:NSStringFromClass(strollLastestCell.class)];
	

}
- (void)getDefaultData
{    @weakify(self)
	[RE_SINGLETON(DataGeterManager) getMyComments:1
									completeBlock:^(NSMutableArray *returnArray) {
										@strongify(self)
										self.commentsArray = returnArray;
										[self.slimeTableView reloadData];
										[self requestHeadStop];
									} errorBlock:^(NSError *error) {
										
									}];
}

- (void)getMoreData
{
	@weakify(self)
	[RE_SINGLETON(DataGeterManager) getMyComments:_currentpage
									completeBlock:^(NSMutableArray *returnArray) {
										@strongify(self)
										[self.commentsArray addObjectsFromArray:returnArray];
										[self.slimeTableView reloadData];
										[self requestFootStop];
									} errorBlock:^(NSError *error) {
										
									}];	
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 300;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _commentsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	strollLastestCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(strollLastestCell.class)];
	
	strollLlastestViewModel *viewModel = _commentsArray[[indexPath row]];
	cell.lastestViewModel = viewModel;
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
	strollLlastestViewModel *viewModel = _commentsArray[[indexPath row]];
	QSBKDetailViewController *detailViewController = [storyBoard instantiateViewControllerWithIdentifier: @"QSBKDetailViewController"];
	detailViewController.lastestViewModel = viewModel;
	[self.navigationController pushViewController:detailViewController animated:YES];
}


@end
