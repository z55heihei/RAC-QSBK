//
//  strollLlastestViewModel.h
//  RAC
//
//  Created by zhangyw on 15/5/21.
//  Copyright (c) 2015年 zyw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/RACCommand.h>

@interface strollLlastestViewModel : NSObject

@property (nonatomic,strong,readonly) strollLastest *lastest;
@property (nonatomic,strong,readonly) NSURL *imageURL;
@property (nonatomic,strong,readonly) NSURL *avatarURL;

@property (nonatomic,strong) NSString *markState;

@property (nonatomic,strong) RACCommand *pariseCommand;
@property (nonatomic,strong) RACCommand *damageCommand;
@property (nonatomic,strong) RACCommand *markCommand;

- (instancetype)initWithLastestModel:(strollLastest *)lastest;


@end
