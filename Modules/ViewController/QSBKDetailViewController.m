//
//  QSBKDetailViewController.m
//  RAC
//
//  Created by zhangyw on 15/6/12.
//  Copyright (c) 2015年 zyw. All rights reserved.
//

#import "QSBKDetailViewController.h"
#import "strollLastestCell.h"
#import "CommentCell.h"
#import <ReactiveCocoa/RACDelegateProxy.h>
#import <objc/runtime.h>

@interface QSBKDetailViewController ()

@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (nonatomic,assign) NSInteger currentpage;
@property (nonatomic,assign) BOOL      keyboardVisible;
@property (nonatomic,strong) NSMutableArray *commentArray;
@end

@implementation QSBKDetailViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

	[self initConfigData];
}


- (void)initConfigData
{
	self.isRefreshMore = YES;
	self.currentpage = 1;
	self.slimeTableView.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].applicationFrame),
										   CGRectGetHeight([UIScreen mainScreen].applicationFrame)
										   - CGRectGetHeight(self.tabBarController.tabBar.frame)
										   - 40);
	@weakify(self)
	self.moreDataBlock =^{
		@strongify(self)
		self.currentpage ++;
		[self getMoreData];
	};

	[self getDefaultData];
	
	[self.slimeTableView registerNib:[UINib nibWithNibName:NSStringFromClass([CommentCell class]) bundle:nil]
			  forCellReuseIdentifier:NSStringFromClass([CommentCell class])];
	[self.slimeTableView registerNib:[UINib nibWithNibName:NSStringFromClass(strollLastestCell.class) bundle:nil]
			  forCellReuseIdentifier:NSStringFromClass(strollLastestCell.class)];
	
    
    RACSignal *validateCommentSignal = [self.commentTextField.rac_textSignal map:^id(NSString *commnet) {
        return @([commnet length] > 0);
    }];

	RACDelegateProxy *proxy = [[RACDelegateProxy alloc] initWithProtocol:@protocol(UITextFieldDelegate)];
	[[proxy rac_signalForSelector:@selector(textFieldShouldReturn:)] subscribeNext:^(RACTuple *args) {
		@strongify(self)
        UITextField *field  = [args first];
		[field resignFirstResponder];
        [[validateCommentSignal flattenMap:^RACStream *(id value) {
            @strongify(self)
            return [self commentSubmitSignal:self.lastestViewModel.lastest.qid
                                     comment:self.commentTextField.text];
        }]subscribeNext:^(NSString *success) {
            @strongify(self)
            BOOL isSuccess = [success integerValue] == 1;
            if (isSuccess) {
                [self getDefaultData];
            }
        }];
    }];
	self.commentTextField.delegate = (id<UITextFieldDelegate>)proxy;
	objc_setAssociatedObject(self.commentTextField, _cmd, proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIKeyboardWillShowNotification
                                                          object:nil]
     subscribeNext:^(NSNotification *notification) {
         [self didChangeKeyboardNotification:notification];
     }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification
                                                          object:nil] subscribeNext:^(NSNotification *notification) {
         [self didChangeKeyboardNotification:notification];
    }];
}

- (void)didChangeKeyboardNotification:(NSNotification *)notification
{
    BOOL up = notification.name == UIKeyboardWillShowNotification;
    
    _keyboardVisible = up;
    NSDictionary* userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationOptions animationCurve;
    CGRect keyboardEndFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    [UIView animateWithDuration:animationDuration
                          delay:0
                        options:animationCurve
                     animations:^{
                         if (_keyboardVisible) {
                             CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
                             self.commentView.frame = CGRectMake(self.commentView.frame.origin.x,
                                                                 self.view.frame.size.height
                                                                 - keyboardFrame.size.height
                                                                 - CGRectGetHeight(self.commentView.frame),
                                                                 CGRectGetWidth(self.commentView.frame),
                                                                 CGRectGetHeight(self.commentView.frame));
                             const UIEdgeInsets oldInset = self.slimeTableView.contentInset;
                             self.slimeTableView.contentInset = UIEdgeInsetsMake(oldInset.top, oldInset.left,  up ? keyboardFrame.size.height : 0, oldInset.right);
                             self.slimeTableView.scrollIndicatorInsets = self.slimeTableView.contentInset;
                         }else{
                             CGRect inputFrame = {0,CGRectGetHeight([UIScreen mainScreen].applicationFrame)
                                 - CGRectGetHeight(self.navigationController.navigationBar.frame) - 40,.size={CGRectGetWidth([UIScreen mainScreen].applicationFrame), 40}};
                             self.commentView.frame = inputFrame;
                         }
                     }
                     completion:nil];
}



- (RACSignal *)commentSubmitSignal:(NSString *)qid
                           comment:(NSString *)comment
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [RE_SINGLETON(DataGeterManager) postComment:qid
                                            comment:comment
                                      completeBlock:^{
                                          [subscriber sendNext:@(YES)];
                                          [subscriber sendCompleted];
                                      } errorBlock:^(NSError *error) {
                                          [subscriber sendNext:@(NO)];
                                          [subscriber sendCompleted];
                                      }];
        return nil;
    }];
}


- (void)getDefaultData
{
	[RE_SINGLETON(DataGeterManager) getComment:_currentpage
									 commentId:self.lastestViewModel.lastest.qid
								 completeBlcok:^(NSMutableArray *returnArray) {
                                     _commentTextField.text = @"";
									 self.commentArray = returnArray;
									 [self.slimeTableView reloadData];
									 [self requestFootStop];
								 } errorBlock:^(NSError *error) {
									 
								 }];
}

- (void)getMoreData
{
	[RE_SINGLETON(DataGeterManager) getComment:_currentpage
									 commentId:self.lastestViewModel.lastest.qid
								 completeBlcok:^(NSMutableArray *returnArray) {
									 [self.commentArray addObjectsFromArray:returnArray];
									 [self.slimeTableView reloadData];
									 [self requestFootStop];
								 } errorBlock:^(NSError *error) {
									 
								 }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return  [indexPath row] == 0 ? 300 : 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1 + [_commentArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger row = [indexPath row];
	if (row == 0) {
		strollLastestCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(strollLastestCell.class)];
		strollLlastestViewModel *viewModel = _lastestViewModel;
		cell.lastestViewModel = viewModel;
		return cell;
	}else{
		CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(CommentCell.class)];
		cell.commetViewModel = _commentArray[(row - 1)];
		return cell;
	}
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self.commentTextField resignFirstResponder];
}


@end
