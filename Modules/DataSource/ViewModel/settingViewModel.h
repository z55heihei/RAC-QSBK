//
//  settingViewModel.h
//  RAC
//
//  Created by ZYW on 15/6/14.
//  Copyright (c) 2015年 zyw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface settingViewModel : NSObject

@property (nonatomic,strong,readonly) NSURL *avatarURL;
@property (nonatomic,strong,readonly) NSString *userName;

- (instancetype)initWithUser:(User *)user;

@end
