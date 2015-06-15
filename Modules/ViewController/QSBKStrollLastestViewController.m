//
//  QSBKStrollLastestViewController.m
//  RAC
//
//  Created by zhangyw on 15/5/21.
//  Copyright (c) 2015年 zyw. All rights reserved.
//

#import "QSBKStrollLastestViewController.h"
#import "QSBKDetailViewController.h"
#import "strollLastestCell.h"

@interface QSBKStrollLastestViewController ()

@property (nonatomic,assign) NSInteger currentpage;
@property (nonatomic,strong) NSMutableArray *strollLastestArray;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *creatpullBarButton;

@end

@implementation QSBKStrollLastestViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

	[self initConfigData];
}

- (void)initConfigData
{
	self.isRefreshHead = YES;
	self.isRefreshMore = YES;
	
	@weakify(self)
	self.headDataBlock = ^{
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
{
	[RE_SINGLETON(DataGeterManager) getQSBKStrollLastestData:1
											   completeBlock:^(NSMutableArray *returnArray) {
												   self.strollLastestArray = returnArray;
												   [self.slimeTableView reloadData];
												   [self requestHeadStop];
											   } errorBlock:^(NSError *error) {
												   
											   }];
}


- (void)getMoreData
{
	@weakify(self)
	[RE_SINGLETON(DataGeterManager) getQSBKStrollLastestData:_currentpage
											   completeBlock:^(NSMutableArray *returnArray) {
												    @strongify(self)
												   [self.strollLastestArray addObjectsFromArray:returnArray];
												   [self.slimeTableView reloadData];
												   [self requestFootStop];
											   } errorBlock:^(NSError *error) {
												   
											   }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	
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
    return _strollLastestArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	strollLastestCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(strollLastestCell.class)];

	strollLlastestViewModel *viewModel = _strollLastestArray[[indexPath row]];
	cell.lastestViewModel = viewModel;
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
	strollLlastestViewModel *viewModel = _strollLastestArray[[indexPath row]];
	QSBKDetailViewController *detailViewController = [storyBoard instantiateViewControllerWithIdentifier: @"QSBKDetailViewController"];
	detailViewController.lastestViewModel = viewModel;
	[self.navigationController pushViewController:detailViewController animated:YES];
}

@end
