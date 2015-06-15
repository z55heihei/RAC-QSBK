//
//  settingViewModel.m
//  RAC
//
//  Created by ZYW on 15/6/14.
//  Copyright (c) 2015年 zyw. All rights reserved.
//

#import "settingViewModel.h"

@interface settingViewModel ()

@property (nonatomic,strong,readwrite) NSURL    *avatarURL;
@property (nonatomic,strong,readwrite) NSString *userName;

@end

@implementation settingViewModel

- (instancetype)initWithUser:(User *)user
{
    self = [super init];
    if (self) {
        self.avatarURL = [NSURL URLWithString:[self avatarURL:user.icon uid:user.uid]];
        self.userName = user.login;
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
