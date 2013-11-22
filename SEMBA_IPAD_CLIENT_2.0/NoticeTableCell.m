//
//  NoticeTableCell.m
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by 欧 展飞 on 13-10-31.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "NoticeTableCell.h"
#define kLineFrame CGRectMake(0, 0, 756, 6)
#define kTitleFrame CGRectMake(15, 15, 700, 60)
#define kDateFrame CGRectMake(15, 30, 100, 10)
#define kContentFrame CGRectMake(10, 50, 700, 16)
#define kRotateButtonFrame CGRectMake(700, 35, 20, 20)

@implementation NoticeTableCell
@synthesize topLine;
@synthesize title;
@synthesize content;
@synthesize date;
@synthesize indexPath;
@synthesize rotateBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    NSLog(@"A Cell has initlized");
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        topLine = [[UIImageView alloc] init];
        topLine.frame = kLineFrame;
        topLine.image = [UIImage imageNamed:@"news center-colourful thick line"];
        [self addSubview:topLine];
        
        title = [[UILabel alloc] init];
        title.frame = kTitleFrame;
        title.font =[UIFont fontWithName:@"Helti SC" size:24.0];
        title.textColor =[UIColor colorWithRed:195/255 green:65/255 blue:102/255 alpha:1.0];
        title.backgroundColor = [UIColor clearColor];
        [self addSubview:title];
        
        date = [[UILabel alloc] init];
        date.frame = kDateFrame;
        date.font = [UIFont fontWithName:@"Helti SC" size:12.0];
        date.textColor = [UIColor colorWithRed:135/255.0 green:132/255.0 blue:134/255.0 alpha:1.0];
        date.backgroundColor = [UIColor clearColor];
        [self addSubview:date];
        
        content = [[UILabel alloc] init];
        content.frame = kContentFrame;
        content.font = [UIFont fontWithName:@"Helti SC" size:15.0];
        content.textColor = [UIColor colorWithRed:135/255.0 green:132/255.0 blue:134/255.0 alpha:1.0];
        content.lineBreakMode = NSLineBreakByCharWrapping;
        content.numberOfLines = 0;
        content.adjustsFontSizeToFitWidth = NO;
        content.lineBreakMode = NSLineBreakByTruncatingTail;
        content.backgroundColor = [UIColor clearColor];
        [self addSubview:content];
        
        rotateBtn = [[UIButton alloc] init];
        rotateBtn.frame = kRotateButtonFrame;
        [rotateBtn setImage:[UIImage imageNamed:@"setting_back.png"] forState:UIControlStateNormal];
        [rotateBtn setBackgroundColor:[UIColor blackColor]];
        [self addSubview:rotateBtn];
    }
    return self;
}

#pragma mark - behavior

- (void)rotateExpandBtnToExpanded
{
    [UIView beginAnimations:@"rotateDisclosureButt" context:nil];
    [UIView setAnimationDuration:0.3];
    rotateBtn.transform = CGAffineTransformMakeRotation(M_PI*1.0);
    [UIView commitAnimations];
}

- (void)rotateExpandBtnToCollapsed
{
    [UIView beginAnimations:@"rotateDisclosureButt" context:nil];
    [UIView setAnimationDuration:0.3];
    rotateBtn.transform = CGAffineTransformMakeRotation(M_PI*2.0);
    [UIView commitAnimations];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}

@end

