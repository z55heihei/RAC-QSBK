//
//  strollLlastestViewModel.m
//  RAC
//
//  Created by zhangyw on 15/5/21.
//  Copyright (c) 2015年 zyw. All rights reserved.
//

#import "strollLlastestViewModel.h"

@interface strollLlastestViewModel ()

@property (nonatomic,strong,readwrite) strollLastest *lastest;
@property (nonatomic,strong,readwrite) NSURL    *imageURL;
@property (nonatomic,strong,readwrite) NSURL    *avatarURL;

@end

@implementation strollLlastestViewModel

- (instancetype)initWithLastestModel:(strollLastest *)lastest
{
	self = [super init];
	if (self) {
		self.lastest = lastest;
		self.imageURL = [NSURL URLWithString:[self imageURL:lastest.image qid:lastest.qid]];
		self.avatarURL = [NSURL URLWithString:[self avatarURL:lastest.user.icon uid:lastest.user.uid]];
	}
	return self;
}

- (NSString *)imageURL:(NSString *)image
				   qid:(NSString *)qid
{
	NSString *prefixqid = [qid substringWithRange:NSMakeRange(0, 5)];
	NSString *imageURL = [NSString stringWithFormat:@"http://pic.qiushibaike.com/system/pictures/%@/%@/medium/%@", prefixqid, qid, image];
	return imageURL;
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

- (RACCommand *)markCommand
{
	if (!_markCommand) {
		_markCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
			RACSignal *markSignal = [self markSignal:self.lastest.qid];
			RACSignal *unMarkSignal = [self unMarkSignal:self.lastest.qid];
			RACSignal *resultSignal = [self.markState integerValue] == 0 ? markSignal : unMarkSignal;
			RAC(self,markState) = resultSignal;
			return resultSignal;
		}];
	}
	return _markCommand;
}

- (RACCommand *)pariseCommand
{
	if (!_pariseCommand) {
		_pariseCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
			RACSignal *pariseSignal = [self voteSignal:self.lastest.qid];
			[pariseSignal subscribeNext:^(id x) {
				self.lastest.vote.up = [NSString stringWithFormat:@"%d",[self.lastest.vote.up integerValue] + 1];
			}];
			return pariseSignal;
		}];
	}
	return _pariseCommand;
}

- (RACCommand *)damageCommand
{
	if (!_damageCommand) {
		_damageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
			RACSignal *damageSignal = [self voteSignal:self.lastest.qid];
			[damageSignal subscribeNext:^(id x) {
				self.lastest.vote.down = [NSString stringWithFormat:@"%d",[self.lastest.vote.down integerValue] - 1];
			}];
			return damageSignal;
		}];
	}
	return _damageCommand;
}


- (RACSignal *)markSignal:(NSString *)qid
{
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		[RE_SINGLETON(DataGeterManager) postMark:qid
								   completeBlock:^{
			[subscriber sendNext:@"1"];
			[subscriber sendCompleted];
		} errorBlock:^(NSError *error) {
			[subscriber sendNext:@"0"];
			[subscriber sendCompleted];
		}];
		return nil;
	}];
}

- (RACSignal *)unMarkSignal:(NSString *)qid
{
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		[RE_SINGLETON(DataGeterManager)postUnMark:qid
									completeBlock:^{
			[subscriber sendNext:@"0"];
			[subscriber sendCompleted];
		} errorBlock:^(NSError *error) {
			[subscriber sendNext:@"0"];
			[subscriber sendCompleted];
		}];
		
		return nil;
	}];
}

- (RACSignal *)voteSignal:(NSString *)qid
{
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		[RE_SINGLETON(DataGeterManager) postVote:qid
									 completeBlock:^(NSInteger parise) {
										 [subscriber sendNext:@(parise)];
										 [subscriber sendCompleted];
									 } errorBlock:^(NSError *error) {
										 
									 }];
		return nil;
	}];
}

@end
