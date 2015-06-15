//
//  QSBKFeedBackViewController.m
//  RAC
//
//  Created by zhangyw on 15/6/15.
//  Copyright (c) 2015年 zyw. All rights reserved.
//

#import "QSBKFeedBackViewController.h"

@interface QSBKFeedBackViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sumbitBarButton;
@property (weak, nonatomic) IBOutlet UITextField *contactTextField;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;

@end

@implementation QSBKFeedBackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	@weakify(self)
	self.sumbitBarButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
			[RE_SINGLETON(DataGeterManager)postMyFeedBack:self.contentTextField.text
												  contact:self.contactTextField.text
											completeBlock:^(BOOL isSuccess) {
												if (isSuccess) {
													[self.navigationController popViewControllerAnimated:YES];
												}
											} errorBlock:^(NSError *error) {
												[self.navigationController popViewControllerAnimated:YES];
											}];
			return nil;
		}];
	}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
