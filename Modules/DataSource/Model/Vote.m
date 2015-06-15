//
//  vote.m
//  RAC
//
//  Created by zhangyw on 15/5/21.
//  Copyright (c) 2015年 zyw. All rights reserved.
//

#import "Vote.h"

@implementation Vote

- (instancetype)initWithDown:(NSString *)down
						  up:(NSString *)up
{
	self = [super init];
	if (self) {
		_down = down;
		_up = up;
	}
	return self;
}

@end
