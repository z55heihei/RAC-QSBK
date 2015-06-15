//
//  SlimeRefreshTableViewController.h
//  HomePage
//
//  Created by zhangyw on 15-1-9.
//  Copyright (c) 2015年 zyw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "slimeRefreshTableView.h"


@interface SlimeRefreshTableViewController : UITableViewController

@property (nonatomic,strong) slimeRefreshTableView *slimeTableView;

- (UITableView *)tableView2Refresh;

- (void)requestHeadData;
- (void)requestFootData;

- (void)requestHeadStop;
- (void)requestFootStop;

@end
