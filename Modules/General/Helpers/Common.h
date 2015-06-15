//
//  Common.h
//  RAC
//
//  Created by zhangyw on 15/5/25.
//  Copyright (c) 2015年 zyw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject

+ (CGSize)textSizeWithString:(NSString *)string
					withSize:(CGSize)size
					withFont:(UIFont *)font;
+ (BOOL)isValiateEmail:(NSString *)email;
+ (BOOL)isValiateMobile:(NSString *)mobile;


@end
