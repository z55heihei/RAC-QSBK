//
//  slimeRefreshTableView.h
//  simleRefresh
//
//  Created by ZYW on 14/7/5.
//  Copyright (c) 2014年 ZYW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadMoreTableFooterView.h"
#import "SRRefreshView.h"
#import "MessageInterceptor.h"


@class slimeRefreshTableView;

@protocol slimeRefreshPullDelegate <NSObject>
- (void)pullTableViewDidTriggerRefresh:(slimeRefreshTableView *)pullTableView;
- (void)pullTableViewDidTriggerLoadMore:(slimeRefreshTableView *)pullTableView;
@end


@interface slimeRefreshTableView : UITableView<SRRefreshDelegate,LoadMoreTableFooterDelegate>
{
    SRRefreshView *slimeView;
    LoadMoreTableFooterView *loadMoreView;
    
    UIEdgeInsets realContentInsets;
    MessageInterceptor *delegateInterceptor;
}

@property (nonatomic, strong) UIImage *pullArrowImage;
@property (nonatomic, strong) UIColor *pullBackgroundColor;
@property (nonatomic, strong) UIColor *pullTextColor;

@property (nonatomic, assign) BOOL isNeedRefreshHead;
@property (nonatomic, assign) BOOL isNeedRefreshMore;

@property (nonatomic, assign) BOOL pullTableIsRefreshing;
@property (nonatomic, assign) BOOL pullTableIsLoadingMore;
@property (nonatomic, assign) CGFloat footHspaceHeight;

@property (nonatomic, assign) id<slimeRefreshPullDelegate>pullDelegate;

- (id)initWithFrame:(CGRect)frame
              style:(UITableViewStyle)style
        headRefresh:(BOOL)head
        footRefresh:(BOOL)foot;

@end
