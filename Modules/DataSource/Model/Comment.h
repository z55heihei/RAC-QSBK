//
//  Comment.h
//  RAC
//
//  Created by zhangyw on 15/6/12.
//  Copyright (c) 2015年 zyw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject

@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *commentId;
@property (nonatomic,copy) NSString *floor;
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *uid;

- (instancetype)initWithComment:(NSString *)content
					  commentId:(NSString *)commentId
					   userName:(NSString *)userName
						   icon:(NSString *)icon
                            uid:(NSString *)uid
                          floor:(NSString *)floor;

@end
