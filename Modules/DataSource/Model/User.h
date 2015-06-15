//
//  user.h
//  RAC
//
//  Created by zhangyw on 15/5/21.
//  Copyright (c) 2015年 zyw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic,copy) NSString *created_at;
@property (nonatomic,copy) NSString *role;
@property (nonatomic,copy) NSString *login;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *icon;

- (instancetype)initWithUid:(NSString *)uid
					   icon:(NSString *)icon
					  login:(NSString *)login
					   role:(NSString *)role
				 created_at:(NSString *)created_at;


@end
