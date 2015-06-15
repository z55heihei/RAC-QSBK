//
//  strollLastest.h
//  RAC
//
//  Created by zhangyw on 15/5/21.
//  Copyright (c) 2015年 zyw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Vote.h"

@interface strollLastest : NSObject

@property (nonatomic,copy) NSString *qid;
@property (nonatomic,copy) NSString *image;
@property (nonatomic,copy) NSString *published_at;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *comments_count;

@property (nonatomic,copy) User *user;
@property (nonatomic,copy) Vote *vote;

- (instancetype)initWithQid:(NSString *)qid
					  image:(NSString *)image
			   published_at:(NSString *)published_at
					content:(NSString *)content
			 comments_count:(NSString *)comments_count
					   user:(User *)user
					   vote:(Vote *)vote;


@end
