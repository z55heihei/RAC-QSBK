//
//  commentViewModel.h
//  RAC
//
//  Created by zhangyw on 15/6/12.
//  Copyright (c) 2015年 zyw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Comment.h"

@interface commentViewModel : NSObject

@property (nonatomic,strong,readonly) Comment *comment;
@property (nonatomic,strong,readonly) NSURL *commetUserIconURL;

- (instancetype)initCommentModel:(Comment *)comment;

@end
