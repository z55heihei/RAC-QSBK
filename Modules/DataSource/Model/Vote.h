//
//  vote.h
//  RAC
//
//  Created by zhangyw on 15/5/21.
//  Copyright (c) 2015年 zyw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Vote : NSObject

@property (nonatomic,copy) NSString *down;
@property (nonatomic,copy) NSString *up;

- (instancetype)initWithDown:(NSString *)down
						  up:(NSString *)up;


@end
