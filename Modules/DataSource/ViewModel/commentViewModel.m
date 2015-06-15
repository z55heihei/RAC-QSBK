//
//  commentViewModel.m
//  RAC
//
//  Created by zhangyw on 15/6/12.
//  Copyright (c) 2015年 zyw. All rights reserved.
//

#import "commentViewModel.h"

@interface commentViewModel ()

@property (nonatomic,strong,readwrite) Comment *comment;
@property (nonatomic,strong,readwrite) NSURL *commetUserIconURL;
@end


@implementation commentViewModel

- (instancetype)initCommentModel:(Comment *)comment
{
	self = [super init];
	if (self) {
		self.comment = comment;
		self.commetUserIconURL = [NSURL URLWithString:[self avatarURL:comment.icon uid:comment.uid]];
	}
	return self;
}


- (NSString *)avatarURL:(NSString *)image
					uid:(NSString *)uid
{
	NSString *imageURL;
	if ([uid length] > 3) {
		NSString *prefixqid = [uid substringWithRange:NSMakeRange(0, 4)];
		imageURL = [NSString stringWithFormat:@"http://pic.qiushibaike.com/system/avtnew/%@/%@/medium/%@", prefixqid, uid, image];
	}
	return imageURL;
}


@end
