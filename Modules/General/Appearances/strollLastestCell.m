//
//  strollLastestCell.m
//  RAC
//
//  Created by zhangyw on 15/5/21.
//  Copyright (c) 2015年 zyw. All rights reserved.
//

#import "strollLastestCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface strollLastestCell ()
{
	__weak IBOutlet UIImageView *thumbImageView;
	__weak IBOutlet UIImageView *avatarImageView;
	__weak IBOutlet UILabel     *nickNameLabel;
	__weak IBOutlet UILabel     *contentLabel;
	__weak IBOutlet UIButton    *pariseButton;
	__weak IBOutlet UIButton    *damageButton;
	__weak IBOutlet UIButton    *voteButton;
	__weak IBOutlet UIButton    *commentButton;
}

@end

@implementation strollLastestCell

- (void)awakeFromNib
{
    // Initialization code
	
	RAC(nickNameLabel,text) = RACObserve(self, lastestViewModel.lastest.user.login);
	RAC(contentLabel,text)  = RACObserve(self, lastestViewModel.lastest.content);
	
	[RACObserve(self, lastestViewModel.imageURL) subscribeNext:^(NSURL *imageURL) {
		[thumbImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"thumb_pic.png"]];
	}];
	
	[RACObserve(self, lastestViewModel.avatarURL) subscribeNext:^(NSURL *avatarURL) {
		[avatarImageView sd_setImageWithURL:avatarURL placeholderImage:[UIImage imageNamed:@"thumb_avatar.png"]];
	}];
	
	[RACObserve(self, lastestViewModel.lastest.vote.up) subscribeNext:^(NSString *up) {
		[pariseButton setTitle:up forState:UIControlStateNormal];
	}];
	
	[RACObserve(self, lastestViewModel.lastest.vote.down) subscribeNext:^(NSString *down) {
		[damageButton setTitle:down forState:UIControlStateNormal];
	}];
	
	[RACObserve(self, lastestViewModel.lastest.comments_count) subscribeNext:^(NSString *comments_count) {
		[commentButton setTitle:comments_count forState:UIControlStateNormal];
	}];
	
	[RACObserve(self, lastestViewModel.markState) subscribeNext:^(NSString *state) {
		voteButton.selected = [state integerValue] == 1;
	}];
}


- (void)layoutSubviews
{
	[super layoutSubviews];
  	pariseButton.rac_command = self.lastestViewModel.pariseCommand;
	damageButton.rac_command = self.lastestViewModel.damageCommand;
	voteButton.rac_command   = self.lastestViewModel.markCommand;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
