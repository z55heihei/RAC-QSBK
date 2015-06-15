//
//  QSBKSettingViewController.m
//  RAC
//
//  Created by ZYW on 15/6/14.
//  Copyright (c) 2015年 zyw. All rights reserved.
//

#import "QSBKSettingViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "settingViewModel.h"

@interface QSBKSettingViewController ()

@property (nonatomic,strong) settingViewModel *settingModel;
@property (weak, nonatomic) IBOutlet UIImageView *avaImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation QSBKSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    RAC(_userNameLabel,text) = RACObserve(self, settingModel.userName);
    [RACObserve(self, settingModel.avatarURL) subscribeNext:^(NSURL *avaImageURL) {
        [_avaImageView sd_setImageWithURL:avaImageURL placeholderImage:[UIImage imageNamed:@"thumb_avatar.png"]];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    User *user = (User*)[RE_SINGLETON(UserManager) loadCustomObjectWithKey:@"user"];
    self.settingModel = [[settingViewModel alloc] initWithUser:user];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
