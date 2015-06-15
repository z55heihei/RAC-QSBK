//
//  Common.m
//  RAC
//
//  Created by zhangyw on 15/5/25.
//  Copyright (c) 2015年 zyw. All rights reserved.
//

#import "Common.h"

@implementation Common

+ (CGSize)textSizeWithString:(NSString *)string
					withSize:(CGSize)size
					withFont:(UIFont *)font
{
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
	paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
	NSDictionary *attributes = @{NSFontAttributeName:font,
								 NSParagraphStyleAttributeName:paragraphStyle.copy};
	
	CGSize textSize =  [string  boundingRectWithSize:size
											 options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
										  attributes:attributes
											 context:nil].size;
	return textSize;
}

+ (BOOL)isValiateEmail:(NSString *)email
{
	NSString *emailPattern =
	@"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
	@"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
	@"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
	@"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
	@"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
	@"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
	@"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
	NSError *error = nil;
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:emailPattern options:NSRegularExpressionCaseInsensitive error:&error];
	NSTextCheckingResult *match = [regex firstMatchInString:email options:0 range:NSMakeRange(0, [email length])];
	return match != nil;
}

+ (BOOL)isValiateMobile:(NSString *)mobile
{
	NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
	NSPredicate *phonePre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
	return [phonePre evaluateWithObject:mobile];
}

@end
