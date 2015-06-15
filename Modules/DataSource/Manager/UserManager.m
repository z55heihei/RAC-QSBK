//
//  UserManager.m
//  RAC
//
//  Created by ZYW on 15/6/14.
//  Copyright (c) 2015年 zyw. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager

DEF_SINGLETON(UserManager)

- (void)saveValue:(id)value forKey:(NSString*)key
{
    NSUserDefaults*defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

- (id)getValueWithKey:(NSString*)key
{
    NSUserDefaults* deafaults = [NSUserDefaults standardUserDefaults];
    id value = [deafaults objectForKey:key];
    return value;
}

- (void)saveCutomObject:(NSObject *)obj objKey:(NSString *)key
{
    NSData *myEncoderObject = [NSKeyedArchiver archivedDataWithRootObject:obj];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:myEncoderObject forKey:key];
}


- (NSObject *)loadCustomObjectWithKey:(NSString *)key
{
    NSUserDefaults *defauts = [NSUserDefaults standardUserDefaults];
    NSData *myEncoderObject = [defauts objectForKey:key];
    if (myEncoderObject) {
        NSObject *obj = [NSKeyedUnarchiver unarchiveObjectWithData:myEncoderObject];
        return obj;
    }
    return nil;
}

- (void)removeCustomObject:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
