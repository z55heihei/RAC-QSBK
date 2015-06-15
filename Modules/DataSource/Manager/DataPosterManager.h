//
//  DataPosterManager.h
//  RAC
//
//  Created by zhangyw on 14-12-22.
//  Copyright (c) 2014年 zyw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>

typedef enum HttpMethod:NSUInteger{
     GET,
     POST
}HttpMethod;

typedef void(^getDataPosterCompleteBlock)(NSDictionary *returnDict);
typedef void(^getDataPosterErrorBlock)(NSError *error);

@interface DataPosterManager : AFHTTPRequestOperationManager

AS_SINGLETON(DataPosterManager)


- (void)postData:(NSMutableDictionary *)params
      httpMethod:(HttpMethod)method
          server:(NSString *)server
   completeBlock:(getDataPosterCompleteBlock)completeblock
      errorBlock:(getDataPosterErrorBlock)errorblock;

@end
