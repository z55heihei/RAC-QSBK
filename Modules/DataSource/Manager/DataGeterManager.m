//
//  DataGeterManager.m
//  bugTrack
//
//  Created by zhangyw on 14-12-22.
//  Copyright (c) 2014年 zyw. All rights reserved.
//

#import "DataGeterManager.h"

@implementation DataGeterManager

DEF_SINGLETON(DataGeterManager)

- (void)getQSBKStrollLastestData:(NSInteger)page
				   completeBlock:(void (^)(NSMutableArray *returnArray))completeblock
					  errorBlock:(void (^)(NSError *error))errorblock
{
	[RE_SINGLETON(DataPosterManager) postData:nil
								   httpMethod:GET
									   server:QSBK_ARRICLE_API(@"latest", page)
								completeBlock:^(NSDictionary *returnDict) {
									NSMutableArray *returnArray = [NSMutableArray array];
									NSArray *lastestArray = returnDict[@"items"];
									[lastestArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
										NSDictionary *userDict = obj[@"user"];
										NSDictionary *voteDict = obj[@"votes"];
										if (![userDict isEqual:[NSNull null]] && ![voteDict isEqual:[NSNull null]]) {
											User *user = [[User alloc] initWithUid:[NSString stringWithFormat:@"%@",userDict[@"id"]]
																		icon:[NSString stringWithFormat:@"%@",userDict[@"icon"]]
																			 login:[NSString stringWithFormat:@"%@",userDict[@"login"]]
																		role:[NSString stringWithFormat:@"%@",userDict[@"role"]]
																		created_at:[NSString stringWithFormat:@"%@",userDict[@"created_at"]]];
											Vote *vote = [[Vote alloc] initWithDown:[NSString stringWithFormat:@"%@",voteDict[@"down"]]
																				 up:[NSString stringWithFormat:@"%@",voteDict[@"up"]]];
											NSDictionary *lastestDict = obj;
											strollLastest *lastest = [[strollLastest alloc] initWithQid:[NSString stringWithFormat:@"%@",lastestDict[@"id"]]
																								  image:[NSString stringWithFormat:@"%@",lastestDict[@"image"]]
																						   published_at:[NSString stringWithFormat:@"%@",lastestDict[@"published_at"]]
																								content:[NSString stringWithFormat:@"%@",lastestDict[@"content"]]
																						 comments_count:[NSString stringWithFormat:@"%@",lastestDict[@"comments_count"]]
																								   user:user
																								   vote:vote];
											
											strollLlastestViewModel *lastViewModel = [[strollLlastestViewModel alloc] initWithLastestModel:lastest];
											[returnArray addObject:lastViewModel];
										}
									}];
									if (completeblock) {
										completeblock(returnArray);
									}
								} errorBlock:^(NSError *error) {
									if (errorblock) {
										errorblock(error);
									}
								}];

}


- (void)postLogin:(NSString *)userName
		 password:(NSString *)password
	completeBlock:(void(^)(BOOL isSuccess))completeblock
	   errorBlock:(void (^)(NSError *error))errorblock
{
	NSMutableDictionary *paramDictory = [@{@"login":userName,@"pass":password}mutableCopy];
   [RE_SINGLETON(DataPosterManager) postData:paramDictory
								  httpMethod:POST
									  server:QSBK_LOGIN_API
							   completeBlock:^(NSDictionary *returnDict) {
                                   if ([returnDict[@"err"] integerValue] == 0) {
                                       User *user = [[User alloc] initWithUid:[NSString stringWithFormat:@"%@",returnDict[@"user"][@"id"]]
                                                                         icon:[NSString stringWithFormat:@"%@",returnDict[@"user"][@"icon"]]
                                                                        login:[NSString stringWithFormat:@"%@",returnDict[@"user"][@"login"]]
                                                                         role:[NSString stringWithFormat:@"%@",returnDict[@"user"][@"role"]]
                                                                   created_at:[NSString stringWithFormat:@"%@",returnDict[@"user"][@"created_at"]]];
                                       [RE_SINGLETON(UserManager) saveCutomObject:user objKey:@"user"];
                                       completeblock(YES);
                                   }
							   } errorBlock:^(NSError *error) {
								   NSLog(@"%@",error);
							   }];
}

- (void)registerNickName:(NSString *)nick
           completeBlock:(void(^)(BOOL isSuccess))completeblock
              errorBlock:(void(^)(NSError *error))error
{
    [RE_SINGLETON(DataPosterManager) postData:nil
                                   httpMethod:GET
                                       server:QSBK_REGISTER_API(nick)
                                completeBlock:^(NSDictionary *returnDict) {
                                    if ([returnDict[@"err"] integerValue] == 0) {
                                        completeblock(YES);
                                    }
                                } errorBlock:^(NSError *error) {
                                    NSLog(@"%@",error);
                                }];
}


- (void)postVote:(NSString *)voteId
	 completeBlock:(void(^)(NSInteger parise))completeblock
		errorBlock:(void (^)(NSError *error))errorblock
{
	NSMutableDictionary *paramDictory = [@{@"session":@"",
										 @"type": @"up",
										 @"target": voteId,
										 @"action": @1}mutableCopy];
	NSMutableDictionary *param = [@{@"votes":paramDictory}mutableCopy];

	[RE_SINGLETON(DataPosterManager) postData:param
								   httpMethod:POST
									   server:QSBK_VOTE_API
								completeBlock:^(NSDictionary *returnDict) {
									completeblock(1);
								} errorBlock:^(NSError *error) {
									errorblock(error);
								}];
}

- (void)postMark:(NSString *)markId
   completeBlock:(void(^)())completeblock
	  errorBlock:(void (^)(NSError *error))errorblock
{
   [RE_SINGLETON(DataPosterManager)postData:nil
								 httpMethod:POST
									 server:QSBK_MARK_API(markId)
							  completeBlock:^(NSDictionary *returnDict) {
								  completeblock();
							  } errorBlock:^(NSError *error) {
								  
							  }];
}

- (void)postUnMark:(NSString *)markId
	 completeBlock:(void(^)())completeblock
		errorBlock:(void (^)(NSError *error))errorblock
{
	[RE_SINGLETON(DataPosterManager)postData:nil
								  httpMethod:POST
									  server:QSBK_UNMARK_API(markId)
							   completeBlock:^(NSDictionary *returnDict) {
								   completeblock();
							   } errorBlock:^(NSError *error) {
								   
							   }];
}

- (void)getMyMark:(NSInteger)page
	completeBlock:(void(^)(NSMutableArray *returnArray))completeblock
		erorBlock:(void (^)(NSError *error))errorblock
{
	[RE_SINGLETON(DataPosterManager) postData:nil
								   httpMethod:GET
									   server:QSBK_MYMARK_API(page, 10)
								completeBlock:^(NSDictionary *returnDict) {
									NSMutableArray *returnArray = [NSMutableArray array];
									NSArray *lastestArray = returnDict[@"items"];
									[lastestArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
										NSDictionary *userDict = obj[@"user"];
										NSDictionary *voteDict = obj[@"votes"];
										if (![userDict isEqual:[NSNull null]] && ![voteDict isEqual:[NSNull null]]) {
											User *user = [[User alloc] initWithUid:[NSString stringWithFormat:@"%@",userDict[@"id"]]
																			  icon:[NSString stringWithFormat:@"%@",userDict[@"icon"]]
																			 login:[NSString stringWithFormat:@"%@",userDict[@"login"]]
																			  role:[NSString stringWithFormat:@"%@",userDict[@"role"]]
																		created_at:[NSString stringWithFormat:@"%@",userDict[@"created_at"]]];
											Vote *vote = [[Vote alloc] initWithDown:[NSString stringWithFormat:@"%@",voteDict[@"down"]]
																				 up:[NSString stringWithFormat:@"%@",voteDict[@"up"]]];
											NSDictionary *lastestDict = obj;
											strollLastest *lastest = [[strollLastest alloc] initWithQid:[NSString stringWithFormat:@"%@",lastestDict[@"id"]]
																								  image:[NSString stringWithFormat:@"%@",lastestDict[@"image"]]
																						   published_at:[NSString stringWithFormat:@"%@",lastestDict[@"published_at"]]
																								content:[NSString stringWithFormat:@"%@",lastestDict[@"content"]]
																						 comments_count:[NSString stringWithFormat:@"%@",lastestDict[@"comments_count"]]
																								   user:user
																								   vote:vote];

											strollLlastestViewModel *lastViewModel = [[strollLlastestViewModel alloc] initWithLastestModel:lastest];
											lastViewModel.markState = @"1";
											[returnArray addObject:lastViewModel];
										}
									}];
									if (completeblock) {
										completeblock(returnArray);
									}
								} errorBlock:^(NSError *error) {
									
								}];
}

- (void)getComment:(NSInteger)page
		 commentId:(NSString *)commentId
	 completeBlcok:(void(^)(NSMutableArray *returnArray))completeblock
		errorBlock:(void(^)(NSError *error))errorblock
{
	[RE_SINGLETON(DataPosterManager) postData:nil
								   httpMethod:GET
									   server:QSBK_COMMENT_API(commentId,10, page)
								completeBlock:^(NSDictionary *returnDict) {
									NSMutableArray *returnArray = [NSMutableArray array];
									NSArray *commentArray = returnDict[@"items"];
									[commentArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {										
										Comment *comment = [[Comment alloc] initWithComment:obj[@"content"]
																				  commentId:obj[@"id"]
																				   userName:obj[@"user"][@"login"]
																					   icon:obj[@"user"][@"icon"]
																						uid:obj[@"user"][@"id"]
                                                                                      floor:[NSString stringWithFormat:@"%@",obj[@"floor"]]];
										commentViewModel *commentviewmodel = [[commentViewModel alloc] initCommentModel:comment];
										[returnArray addObject:commentviewmodel];
									}];
									if(completeblock){
									   completeblock(returnArray);
									}
								}errorBlock:^(NSError *error) {
									if (errorblock) {
										errorblock(error);
									}
								}];
}

/*!
 *  评论
 *
 *  @param commentId     帖子id
 */
- (void)postComment:(NSString *)commentId
			comment:(NSString *)comment
	  completeBlock:(void(^)())completeblock
		 errorBlock:(void(^)(NSError *error))errorblock
{
	NSMutableDictionary *param = [@{@"content":comment,@"anonymous":@"1"}mutableCopy];
	[RE_SINGLETON(DataPosterManager) postData:param
								   httpMethod:POST
									   server:QSBK_CREAT_COMMENT_API(commentId)
								completeBlock:^(NSDictionary *returnDict) {
									if(completeblock){
										completeblock();
									}
								}errorBlock:^(NSError *error) {
									if (errorblock) {
										errorblock(error);
									}
								}];
}

/*!
 *  我发表的
 *
 *  @param page          页码
 */
- (void)getMyArticles:(NSInteger)page
		completeBlock:(void(^)(NSMutableArray *returnArray))completeblock
		   errorBlock:(void(^)(NSError *error))errorblock
{
	[RE_SINGLETON(DataPosterManager) postData:nil
								   httpMethod:GET
									   server:QSBK_MINE_ARTICLES(page, 10)
								completeBlock:^(NSDictionary *returnDict) {
									NSMutableArray *returnArray = [NSMutableArray array];
									NSArray *lastestArray = returnDict[@"items"];
									[lastestArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
										NSDictionary *userDict = obj[@"user"];
										NSDictionary *voteDict = obj[@"votes"];
										if (![userDict isEqual:[NSNull null]] && ![voteDict isEqual:[NSNull null]]) {
											User *user = [[User alloc] initWithUid:[NSString stringWithFormat:@"%@",userDict[@"id"]]
																			  icon:[NSString stringWithFormat:@"%@",userDict[@"icon"]]
																			 login:[NSString stringWithFormat:@"%@",userDict[@"login"]]
																			  role:[NSString stringWithFormat:@"%@",userDict[@"role"]]
																		created_at:[NSString stringWithFormat:@"%@",userDict[@"created_at"]]];
											Vote *vote = [[Vote alloc] initWithDown:[NSString stringWithFormat:@"%@",voteDict[@"down"]]
																				 up:[NSString stringWithFormat:@"%@",voteDict[@"up"]]];
											NSDictionary *lastestDict = obj;
											strollLastest *lastest = [[strollLastest alloc] initWithQid:[NSString stringWithFormat:@"%@",lastestDict[@"id"]]
																								  image:[NSString stringWithFormat:@"%@",lastestDict[@"image"]]
																						   published_at:[NSString stringWithFormat:@"%@",lastestDict[@"published_at"]]
																								content:[NSString stringWithFormat:@"%@",lastestDict[@"content"]]
																						 comments_count:[NSString stringWithFormat:@"%@",lastestDict[@"comments_count"]]
																								   user:user
																								   vote:vote];
											
											strollLlastestViewModel *lastViewModel = [[strollLlastestViewModel alloc] initWithLastestModel:lastest];
											lastViewModel.markState = @"1";
											[returnArray addObject:lastViewModel];
										}
									}];
									if (completeblock) {
										completeblock(returnArray);
									}
								}errorBlock:^(NSError *error) {
									if (errorblock) {
										errorblock(error);
									}
								}];
}

/*!
 *  我的评论
 *
 *  @param page          页码
 */
- (void)getMyComments:(NSInteger)page
		completeBlock:(void(^)(NSMutableArray *returnArray))completeblock
		   errorBlock:(void(^)(NSError *error))errorblock
{
	[RE_SINGLETON(DataPosterManager) postData:nil
								   httpMethod:GET
									   server:QSBK_MINE_COMMENTS(page, 10)
								completeBlock:^(NSDictionary *returnDict) {
									NSMutableArray *returnArray = [NSMutableArray array];
									NSArray *lastestArray = returnDict[@"items"];
									[lastestArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
										NSDictionary *userDict = obj[@"user"];
										NSDictionary *voteDict = obj[@"votes"];
										if (![userDict isEqual:[NSNull null]] && ![voteDict isEqual:[NSNull null]]) {
											User *user = [[User alloc] initWithUid:[NSString stringWithFormat:@"%@",userDict[@"id"]]
																			  icon:[NSString stringWithFormat:@"%@",userDict[@"icon"]]
																			 login:[NSString stringWithFormat:@"%@",userDict[@"login"]]
																			  role:[NSString stringWithFormat:@"%@",userDict[@"role"]]
																		created_at:[NSString stringWithFormat:@"%@",userDict[@"created_at"]]];
											Vote *vote = [[Vote alloc] initWithDown:[NSString stringWithFormat:@"%@",voteDict[@"down"]]
																				 up:[NSString stringWithFormat:@"%@",voteDict[@"up"]]];
											NSDictionary *lastestDict = obj;
											strollLastest *lastest = [[strollLastest alloc] initWithQid:[NSString stringWithFormat:@"%@",lastestDict[@"id"]]
																								  image:[NSString stringWithFormat:@"%@",lastestDict[@"image"]]
																						   published_at:[NSString stringWithFormat:@"%@",lastestDict[@"published_at"]]
																								content:[NSString stringWithFormat:@"%@",lastestDict[@"content"]]
																						 comments_count:[NSString stringWithFormat:@"%@",lastestDict[@"comments_count"]]
																								   user:user
																								   vote:vote];
											
											strollLlastestViewModel *lastViewModel = [[strollLlastestViewModel alloc] initWithLastestModel:lastest];
											lastViewModel.markState = @"1";
											[returnArray addObject:lastViewModel];
										}
									}];
									if (completeblock) {
										completeblock(returnArray);
									}
								}errorBlock:^(NSError *error) {
									if (errorblock) {
										errorblock(error);
									}
								}];
}

/*!
 *  反馈
 *
 *  @param content       内容
 *  @param contact       联系人
 */
- (void)postMyFeedBack:(NSString *)content
			   contact:(NSString *)contact
		 completeBlock:(void(^)(BOOL isSuccess))completeblock
			errorBlock:(void(^)(NSError *error))errorblock
{
	NSMutableDictionary *param = [@{@"content":content,
									@"contact":contact,
									@"source":@"",
									@"device":@"",
									@"userid":@"1686395"}mutableCopy];
	[RE_SINGLETON(DataPosterManager) postData:param
								   httpMethod:POST
									   server:QSBK_MINE_FEEDBACK
								completeBlock:^(NSDictionary *returnDict) {
									if (completeblock) {
										completeblock(YES);
									}
								}errorBlock:^(NSError *error) {
									if (errorblock) {
										errorblock(error);
									}
								}];
}

@end
