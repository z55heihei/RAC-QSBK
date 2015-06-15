//
//  QSBKLoginViewController.m
//  RAC
//
//  Created by zhangyw on 15/5/25.
//  Copyright (c) 2015年 zyw. All rights reserved.
//

#import "QSBKLoginViewController.h"
#import <ReactiveCocoa/RACDelegateProxy.h>
#import <objc/runtime.h>

@interface QSBKLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField     *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField     *passWordTextField;
@property (weak, nonatomic) IBOutlet UIButton        *loginButton;
@property (weak, nonatomic) IBOutlet UIButton        *qqLoginButton;
@property (weak, nonatomic) IBOutlet UIButton        *sinaLoginButton;
@property (weak, nonatomic) IBOutlet UIButton        *weixinLogin;

@end

@implementation QSBKLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	RACSignal *validateUserNameSignal = [self.userNameTextField.rac_textSignal map:^id(NSString *userName) {
		return @([self validateUserName:userName]);
	}];
	
	RACSignal *validatePassWordSignal = [self.passWordTextField.rac_textSignal map:^id(NSString *passWord) {
		return @([self validatePassWord:passWord]);
	}];
	
	RAC(self.loginButton,enabled) = [RACSignal combineLatest:@[validateUserNameSignal,validatePassWordSignal] reduce:^id(NSNumber *isUserNameValidate,NSNumber *isPassWordValidate){
		return @([isUserNameValidate boolValue] && [isPassWordValidate boolValue]);
	}];
	
	
	RACDelegateProxy *proxy = [[RACDelegateProxy alloc] initWithProtocol:@protocol(UITextFieldDelegate)];
	[[proxy rac_signalForSelector:@selector(textFieldShouldReturn:)] subscribeNext:^(RACTuple *args) {
		UITextField *field  = [args first];
		[field resignFirstResponder];
	}];
	self.userNameTextField.delegate = (id<UITextFieldDelegate>)proxy;
	objc_setAssociatedObject(self.userNameTextField, _cmd, proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	
	self.passWordTextField.delegate = (id<UITextFieldDelegate>)proxy;
	objc_setAssociatedObject(self.passWordTextField, _cmd, proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	
	[[[[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	   doNext:^(id x) {
		
	}]flattenMap:^RACStream *(id value) {
		return [self signInSignal];
	}]subscribeNext:^(NSNumber *success) {
		if ([success boolValue]) {
			[self.navigationController popToRootViewControllerAnimated:YES];
		}
	}];
	
	[[[self.qqLoginButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	  flattenMap:^RACStream *(id value) {
		return [self authorLoginSignal:@"z55heihei"];
	}]subscribeNext:^(NSNumber *success) {
		if ([success boolValue]) {
			[self.navigationController popToRootViewControllerAnimated:YES];
		}
	}];
	
	[[[self.sinaLoginButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	  flattenMap:^RACStream *(id value) {
		  return [self authorLoginSignal:@"z55heihei"];
	  }]subscribeNext:^(NSNumber *success) {
		  if ([success boolValue]) {
			  [self.navigationController popToRootViewControllerAnimated:YES];
		  }
	  }];
	
	[[[self.weixinLogin rac_signalForControlEvents:UIControlEventTouchUpInside]
	  flattenMap:^RACStream *(id value) {
		  return [self authorLoginSignal:@"z55heihei"];
	  }]subscribeNext:^(NSNumber *success) {
		  if ([success boolValue]) {
			  [self.navigationController popToRootViewControllerAnimated:YES];
		  }
	  }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)validateUserName:(NSString *)userName
{
	return userName.length > 0;
}

- (BOOL)validatePassWord:(NSString *)passWord
{
	return passWord.length >= 6;
}

- (RACSignal *)signInSignal
{
	@weakify(self)
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
	 @strongify(self)
	[RE_SINGLETON(DataGeterManager) postLogin:self.userNameTextField.text
									 password:self.passWordTextField.text
								completeBlock:^(BOOL isSuccess) {
									[subscriber sendNext:@(isSuccess)];
									[subscriber sendCompleted];
								} errorBlock:^(NSError *error) {
									
								}];
		return nil;
	}];
}

- (RACSignal *)authorLoginSignal:(NSString *)nick
{
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		[RE_SINGLETON(DataGeterManager) registerNickName:nick
										   completeBlock:^(BOOL isSuccess) {
											   [subscriber sendNext:@(isSuccess)];
											   [subscriber sendCompleted];
										   } errorBlock:^(NSError *error) {
											   
										   }];
		return nil;
	}];
}

@end
