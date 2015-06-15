//
//  CommentCell.m
//  RAC
//
//  Created by zhangyw on 15/6/12.
//  Copyright (c) 2015年 zyw. All rights reserved.
//

#import "CommentCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CommentCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *floorLabel;

@end

@implementation CommentCell

- (void)awakeFromNib
{
	@weakify(self)
   [RACObserve(self, commetViewModel.commetUserIconURL) subscribeNext:^(NSURL *avatarURL) {
	   @strongify(self)
		[self.iconImageView sd_setImageWithURL:avatarURL placeholderImage:[UIImage imageNamed:@"thumb_avatar.png"]];
   }];
	
    RAC(_userNameLabel, text) = RACObserve(self,commetViewModel.comment.userName);
	RAC(_contentLabel, text) = RACObserve(self,commetViewModel.comment.content);
    RAC(_floorLabel,text) = RACObserve(self, commetViewModel.comment.floor);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
