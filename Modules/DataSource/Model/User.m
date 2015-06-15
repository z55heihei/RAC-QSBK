//
//  user.m
//  RAC
//
//  Created by zhangyw on 15/5/21.
//  Copyright (c) 2015年 zyw. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithUid:(NSString *)uid
					   icon:(NSString *)icon
					  login:(NSString *)login
					   role:(NSString *)role
				 created_at:(NSString *)created_at
{
	self = [super init];
	if (self) {
		_uid = uid;
		_icon = icon;
		_login = login;
		_role = role;
		_created_at = created_at;
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.uid forKey:@"uid"];
    [encoder encodeObject:self.icon forKey:@"icon"];
    [encoder encodeObject:self.login forKey:@"login"];
    [encoder encodeObject:self.role forKey:@"role"];
    [encoder encodeObject:self.created_at forKey:@"created_at"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    if (self) {
        self.uid = [decoder decodeObjectForKey:@"uid"];
        self.icon = [decoder decodeObjectForKey:@"icon"];
        self.login = [decoder decodeObjectForKey:@"login"];
        self.role = [decoder decodeObjectForKey:@"role"];
        self.created_at = [decoder decodeObjectForKey:@"created_at"];
    }
    return self;
}



@end
