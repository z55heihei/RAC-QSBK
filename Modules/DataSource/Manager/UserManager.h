//
//  UserManager.h
//  RAC
//
//  Created by ZYW on 15/6/14.
//  Copyright (c) 2015年 zyw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserManager : NSObject

AS_SINGLETON(UserManager)

- (id)getValueWithKey:(NSString*)key;
- (void)saveValue:(id)value forKey:(NSString*)key;
- (void)saveCutomObject:(NSObject *)obj objKey:(NSString *)key;
- (void)removeCustomObject:(NSString *)key;
- (NSObject *)loadCustomObjectWithKey:(NSString *)key;

@end
