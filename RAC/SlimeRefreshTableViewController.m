//
//  SlimeRefreshTableViewController.m
//  HomePage
//
//  Created by zhangyw on 15-1-9.
//  Copyright (c) 2015年 zyw. All rights reserved.
//

#import "SlimeRefreshTableViewController.h"

@interface SlimeRefreshTableViewController ()

@end

@implementation SlimeRefreshTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITableView *tableView = [self tableView2Refresh];
    self.tableView = tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableView *)tableView2Refresh
{
    return nil;
}

- (void)requestHeadData
{
    //do something
}

- (void)requestFootData
{
    //do something
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(slimeRefreshTableView *)pullTableView
{
    [self performSelector:@selector(requestHeadData)
               withObject:nil
               afterDelay:0.5f];
}

- (void)pullTableViewDidTriggerLoadMore:(slimeRefreshTableView *)pullTableView
{
    [self performSelector:@selector(requestFootData)
               withObject:nil
               afterDelay:0.5f];
}

- (void)requestHeadStop
{
    self.slimeTableView.pullTableIsRefreshing = NO;
}


- (void)requestFootStop
{
    self.slimeTableView.pullTableIsLoadingMore = NO;
}



@end
