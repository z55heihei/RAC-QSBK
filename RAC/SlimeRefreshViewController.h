//
//  SlimeRefreshViewController.h
//  SnapWine
//
//  Created by ZYW on 14/7/5.
//  Copyright (c) 2014年 zyw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "slimeRefreshTableView.h"

@interface SlimeRefreshViewController : UIViewController <slimeRefreshPullDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) slimeRefreshTableView *slimeTableView;

@property (strong, nonatomic) NSNumber *cellZoomXScaleFactor;
@property (strong, nonatomic) NSNumber *cellZoomYScaleFactor;
@property (strong, nonatomic) NSNumber *cellZoomXOffset;
@property (strong, nonatomic) NSNumber *cellZoomYOffset;
@property (strong, nonatomic) NSNumber *cellZoomInitialAlpha;
@property (strong, nonatomic) NSNumber *cellZoomAnimationDuration;
@property (assign, nonatomic) BOOL     isOpenZoonAnimtion;

-(void)resetViewedCells;

- (void)requestHeadData;
- (void)requestFootData;

- (void)requestHeadStop;
- (void)requestFootStop;

@end
