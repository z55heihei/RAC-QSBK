//
//  AppMacro.h
//  RAC
//
//  Created by ZYW on 14/7/4.
//  Copyright (c) 2014年 zyw. All rights reserved.
//

#ifndef RAC_AppMacro_h
#define RAC_AppMacro_h

#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
+ (__class *)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}

#undef  RE_SINGLETON
#define RE_SINGLETON(__class) [__class sharedInstance]
#endif

#define RGBA(r, g, b, a) [UIColor colorWithRed:(r) / 255.0 \
green:(g) / 255.0 \
blue:(b) / 255.0 \
alpha:(a)]

#define RGB(r, g, b) RGBA((r), (g), (b), 255)

#define RGBA0X(rgba) RGBA((rgb & 0xff000000) >> 24, \
(rgb & 0x00ff0000) >> 16, \
(rgb & 0x0000ff00) >> 8, \
(rgb & 0x000000ff) >> 0)

#define RGB0X(rgb) RGBA0X((rgb << 8) + 0xff)

#define API_DEFALUT_COUNT 10
#define QSBK_ARRICLE_API(method,page) [NSString stringWithFormat:@"http://m2.qiushibaike.com/article/list/%@?count=%d&page=%d",method,API_DEFALUT_COUNT,page]

#define QSBK_LOGIN_API  @"http://m2.qiushibaike.com/user/signin"

#define QSBK_VOTE_API @"http://vote.qiushibaike.com/vote_queue"

#define QSBK_MARK_API(id) [NSString stringWithFormat:@"http://m2.qiushibaike.com/collect/%@", id]

#define QSBK_UNMARK_API(id) [NSString stringWithFormat:@"http://m2.qiushibaike.com/collect/%@/del", id]

#define QSBK_MYMARK_API(page, count)  [NSString stringWithFormat:@"http://m2.qiushibaike.com/collect/list?page=%d&count=%d", page, count]

#define QSBK_COMMENT_API(id,count,page) [NSString stringWithFormat:@"http://m2.qiushibaike.com/article/%@/comments?count=%d&page=%d", id, count, page]

#define QSBK_CREAT_COMMENT_API(id)  [NSString stringWithFormat:@"http://m2.qiushibaike.com/article/%@/comment/create", id]

#define QSBK_REGISTER_API(nick) [NSString stringWithFormat:@"http://m2.qiushibaike.com/user/v3/signup?login=%@",nick]

#define QSBK_MINE_ARTICLES(page,count) [NSString stringWithFormat:@"http://m2.qiushibaike.com/user/my/articles?page=%d&count=%d", page, count]

#define QSBK_MINE_COMMENTS(page,count) [NSString stringWithFormat:@"http://m2.qiushibaike.com/user/my/participate?page=%d&count=%d", page, count]

#define QSBK_MINE_FEEDBACK @"http://m2.qiushibaike.com/feedback"









