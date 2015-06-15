//
//  QSBKBaseViewController.h
//  RAC
//
//  Created by zhangyw on 15/5/21.
//  Copyright (c) 2015年 zyw. All rights reserved.
//

#import "SlimeRefreshViewController.h"

typedef void(^RequestRefreshHeadDataBlock)(void);
typedef void(^RequestRefreshMoreDataBlock)(void);

@interface QSBKBaseViewController : SlimeRefreshViewController

@property (nonatomic) BOOL isRefreshHead;
@property (nonatomic) BOOL isRefreshMore;

@property (nonatomic,strong) RequestRefreshHeadDataBlock headDataBlock;
@property (nonatomic,strong) RequestRefreshMoreDataBlock moreDataBlock;


@end
