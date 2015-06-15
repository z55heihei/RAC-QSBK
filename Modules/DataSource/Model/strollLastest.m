//
//  strollLastest.m
//  RAC
//
//  Created by zhangyw on 15/5/21.
//  Copyright (c) 2015年 zyw. All rights reserved.
//

#import "strollLastest.h"

@implementation strollLastest

- (instancetype)initWithQid:(NSString *)qid
					  image:(NSString *)image
			   published_at:(NSString *)published_at
					content:(NSString *)content
			 comments_count:(NSString *)comments_count
					   user:(User *)user
					   vote:(Vote *)vote
{
	self = [super init];
	if (self) {
		_qid = qid;
		_image = image;
		_published_at = published_at;
		_content = content;
		_comments_count = comments_count;
		_user = user;
		_vote = vote;
	}
	return self;
}



@end
