//
//  QSBKResigterViewController.m
//  RAC
//
//  Created by zhangyw on 15/5/25.
//  Copyright (c) 2015年 zyw. All rights reserved.
//

#import "QSBKResigterViewController.h"
#import <ReactiveCocoa/RACDelegateProxy.h>
#import <objc/runtime.h>
#import "Common.h"

@interface QSBKResigterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassWordTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *registerDoneBarButton;

@end

@implementation QSBKResigterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	

	RACSignal *passwordSignal =[self passwordVaildSignal:self.passWordTextField] ;
	[passwordSignal subscribeNext:^(id x) {
		NSLog(@"密码至少6位数");
	}];
	
	RACSignal *confirmSignal = [self passwordVaildSignal:self.confirmPassWordTextField];
	[confirmSignal subscribeNext:^(id x) {
		NSLog(@"密码至少6位数");
	}];
	
	RACSignal *passwordEqualSignal = [self passwordEuqalSignal:self.passWordTextField
											  confirmTextFeild:self.confirmPassWordTextField];
	[passwordEqualSignal subscribeNext:^(NSNumber *confirmPassWord) {
		if (![confirmPassWord boolValue]) {
			NSLog(@"密码不相同");
		}
	}];

	
	RAC(self.registerDoneBarButton,enabled) = [RACSignal combineLatest:@[self.emailTextField.rac_textSignal,
																		 self.userNameTextField.rac_textSignal,
																		 passwordSignal,
																		 confirmSignal,
																		 passwordEqualSignal]
																reduce:^id(NSString *email,
																		   NSString *username,
																		   NSNumber *passwordvaild,
																		   NSNumber *confirmpasswordvaild,
																		   NSNumber *passwordEqual){
																	return @([email length] > 0
																		   && [username length] > 0
																	       && [passwordvaild integerValue] == 1
																		   && [confirmpasswordvaild integerValue] == 1
																	       && [passwordEqual integerValue] == 1);
																}];

	@weakify(self)
	[[[self textFeildDelegateProxy:self.emailTextField] rac_signalForSelector:@selector(textFieldShouldReturn:)] subscribeNext:^(RACTuple *args) {
		@strongify(self)
		if (![Common isValiateEmail:self.emailTextField.text]) {
			NSLog(@"请输入有效的邮箱地址");
		}
	}];
	
	[self textFeildDelegateProxy:self.emailTextField];
	[self textFeildDelegateProxy:self.userNameTextField];
	[self textFeildDelegateProxy:self.passWordTextField];
	[self textFeildDelegateProxy:self.confirmPassWordTextField];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (RACDelegateProxy *)textFeildDelegateProxy:(UITextField *)delegateTextField
{
	RACDelegateProxy *proxy = [[RACDelegateProxy alloc] initWithProtocol:@protocol(UITextFieldDelegate)];

	[[proxy rac_signalForSelector:@selector(textFieldShouldReturn:)] subscribeNext:^(RACTuple *args) {
		UITextField *field  = [args first];
		[field resignFirstResponder];
	}];
	
	delegateTextField.delegate = (id<UITextFieldDelegate>)proxy;
	objc_setAssociatedObject(delegateTextField, _cmd, proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	
	return proxy;
}

- (RACSignal *)passwordVaildSignal:(UITextField *)textFeild
{
	RACSignal *validPasswordSignal = [textFeild.rac_textSignal  map:^id(NSString *text) {
		return @([textFeild.text length] >= 6);
	}];
	return validPasswordSignal;
}

- (RACSignal *)passwordEuqalSignal:(UITextField *)passwordTextFeild
				  confirmTextFeild:(UITextField *)confirmTextFeild
{
	RACSignal *confirmPassWordSignal = [RACSignal combineLatest:@[passwordTextFeild.rac_textSignal,
																  confirmTextFeild.rac_textSignal]
														 reduce:^id(NSString *passwordText,NSString *confirmText){
															 return @([passwordText isEqualToString:confirmText]);
														 }];
	return confirmPassWordSignal;
}


@end
