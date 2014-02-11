//
//  SingleCourseCell.m
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by 王智锐 on 1/3/14.
//  Copyright (c) 2014 yaodd. All rights reserved.
//

#import "SingleCourseCell.h"

@implementation SingleCourseCell

@synthesize nameLabel = _nameLabel;
@synthesize titleLabel = _titleLabel;
@synthesize dateLabel = _dateLabel;
@synthesize peopleNumLabel = _peopleNumLabel;
@synthesize contentTextView = _contentTextView;
@synthesize imageView = _imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //标注图给得太烂。。自己发挥想象力好了。。
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 48, 140, 20)];
        _nameLabel.text = @"";
        _nameLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16.0];
        [self addSubview:_nameLabel];
        _dateLabel = [[UILabel alloc]  initWithFrame:CGRectMake(355, 48, 140, 20)];
        _dateLabel.text = @"测试时间";
        _dateLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16.0];
        [self addSubview:_dateLabel];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(146, 5, 400, 40)];
        _titleLabel.text = @"测试课程题目";
        _titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:24];
        _titleLabel.textColor = [UIColor colorWithRed:199/255.0 green:56/255.0 blue:91/255.0 alpha:1.0];
        [self addSubview:_titleLabel];
        
        _peopleNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(580, 65, 200, 20)];
        _peopleNumLabel.text = @"已选x人/限选y人";
        _peopleNumLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20];
        [self addSubview:_peopleNumLabel];
        
        _contentTextView = [[UITextView alloc]   initWithFrame:CGRectMake(146, 70, 400, 65)];
        _contentTextView.text = @"测试课程简介";
        _contentTextView.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14.0];
        [self addSubview:_contentTextView];
        
        UIImage *timelogo = [UIImage imageNamed:@"time.png"];
        UIImageView *timelogoView = [[UIImageView alloc]initWithImage:timelogo];
        timelogoView.frame = CGRectMake(332, 48, 18, 18);
        [self addSubview:timelogoView];
        
        UIImage *peoplelogo = [UIImage imageNamed:@"user.png"];
        UIImageView *peoplelogoView = [[UIImageView alloc]initWithImage:peoplelogo];
        peoplelogoView.frame = CGRectMake(146, 48, 16, 18);
        [self addSubview:peoplelogoView];
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _contentTextView.userInteractionEnabled = NO;
        
        _imageView = [[UIImageView alloc]   initWithFrame:CGRectMake(20, 5, 106, 126)];
        [self addSubview:_imageView];
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = 20;

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
