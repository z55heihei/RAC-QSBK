//
//  DataGeterManager.h
//  bugTrack
//
//  Created by zhangyw on 14-12-22.
//  Copyright (c) 2014年 zyw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataPosterManager.h"
#import "strollLastest.h"
#import "strollLlastestViewModel.h"
#import "commentViewModel.h"
#import "UserManager.h"

@interface DataGeterManager : NSObject

AS_SINGLETON(DataGeterManager)

/*!
 *  获取最新列表
 *
 *  @param page          页码
 */
- (void)getQSBKStrollLastestData:(NSInteger)page
				   completeBlock:(void (^)(NSMutableArray *returnArray))completeblock
					  errorBlock:(void (^)(NSError *error))errorblock;

/*!
 *  登录
 *
 *  @param userName      用户名
 *  @param password      密码
 */
- (void)postLogin:(NSString *)userName
		 password:(NSString *)password
	completeBlock:(void(^)(BOOL isSuccess))completeblock
	   errorBlock:(void(^)(NSError *error))errorblock;


/*!
 * 注册
 *
 *  @param nick      昵称
 */
- (void)registerNickName:(NSString *)nick
           completeBlock:(void(^)(BOOL isSuccess))completeblock
              errorBlock:(void(^)(NSError *error))error;

/*!
 *  投票
 *
 *  @param voteId        投票id
 */
- (void)postVote:(NSString *)voteId
   completeBlock:(void(^)(NSInteger parise))completeblock
	  errorBlock:(void (^)(NSError *error))errorblock;

/*!
 *  收藏
 *
 *  @param voteId        收藏id
 */
- (void)postMark:(NSString *)markId
   completeBlock:(void(^)())completeblock
	  errorBlock:(void (^)(NSError *error))errorblock;

/*!
 *  取消收藏
 *
 *  @param voteId        取消收藏id
 */
- (void)postUnMark:(NSString *)markId
	 completeBlock:(void(^)())completeblock
		errorBlock:(void (^)(NSError *error))errorblock;

/*!
 *  获取收藏列表
 *
 *  @param page          页码
 */
- (void)getMyMark:(NSInteger)page
	completeBlock:(void(^)(NSMutableArray *returnArray))completeblock
		erorBlock:(void (^)(NSError *error))errorblock;

/*!
 *  获取评论列表
 *
 *  @param page          页码
 *  @param commentId     帖子id
 */
- (void)getComment:(NSInteger)page
		 commentId:(NSString *)commentId
	 completeBlcok:(void(^)(NSMutableArray *returnArray))completeblock
		errorBlock:(void(^)(NSError *error))errorblock;

/*!
 *  评论
 *
 *  @param commentId     帖子id
 *  @param comment       评论内容
 */
- (void)postComment:(NSString *)commentId
			comment:(NSString *)comment
	  completeBlock:(void(^)())completeblock
		 errorBlock:(void(^)(NSError *error))errorblock;

/*!
 *  我发表的
 *
 *  @param page          页码
 */
- (void)getMyArticles:(NSInteger)page
		completeBlock:(void(^)(NSMutableArray *returnArray))completeblock
		   errorBlock:(void(^)(NSError *error))errorblock;

/*!
 *  我的评论
 *
 *  @param page          页码
 */
- (void)getMyComments:(NSInteger)page
		completeBlock:(void(^)(NSMutableArray *returnArray))completeblock
		   errorBlock:(void(^)(NSError *error))errorblock;

/*!
 *  反馈
 *
 *  @param content       内容
 *  @param contact       联系人
 */
- (void)postMyFeedBack:(NSString *)content
			   contact:(NSString *)contact
		 completeBlock:(void(^)(BOOL isSuccess))completeblock
			errorBlock:(void(^)(NSError *error))errorblock;


@end
