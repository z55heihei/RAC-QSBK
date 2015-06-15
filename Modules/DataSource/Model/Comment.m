//
//  comment.m
//  RAC
//
//  Created by zhangyw on 15/6/12.
//  Copyright (c) 2015年 zyw. All rights reserved.
//

#import "Comment.h"

@implementation Comment

- (instancetype)initWithComment:(NSString *)content
                      commentId:(NSString *)commentId
                       userName:(NSString *)userName
                           icon:(NSString *)icon
                            uid:(NSString *)uid
                          floor:(NSString *)floor
{
	self = [super init];
	if (self) {
		self.userName = userName;
		self.commentId = commentId;
		self.content = content;
		self.icon = icon;
		self.uid = uid;
        self.floor = floor;
	}
	
	return self;
}
@end
