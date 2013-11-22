//
//  NoticeTableCell.m
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by 欧 展飞 on 13-10-31.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "NoticeTableCell.h"
#define kLineFrame CGRectMake(0, 0, 720, 6)
#define kTitleFrame CGRectMake(16, 18, 550, 35)
#define kDateFrame CGRectMake(16, 53, 300, 16)
#define kContentFrame CGRectMake(16, 78, 700, 16)
#define kRotateButtonFrame CGRectMake(620, 100, 20, 20)
#define kExpandLabelFrame CGRectMake(650, 75, 40, 20)

@implementation NoticeTableCell
@synthesize topLine;
@synthesize name;
@synthesize content;
@synthesize date;
@synthesize indexPath;
@synthesize rotateBtn;
@synthesize expand;
@synthesize bottomLine;
@synthesize rightLine;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    NSLog(@"A Cell has initlized");
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:254/255.0 green:254/255.0 blue:254/255.0 alpha:1.0];
        
        topLine = [[UIImageView alloc] init];
        topLine.frame = kLineFrame;
        topLine.image = [UIImage imageNamed:@"line_news"];
        [self addSubview:topLine];
        
        bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 118, 720, 5)];
        bottomLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:bottomLine];
        
        rightLine = [[UIImageView alloc] initWithFrame:CGRectMake(718, 0, 5, 700)];
        rightLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:rightLine];
        //部分圆角
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 723, 123) byRoundingCorners:(UIRectCornerBottomRight | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(20.0, 20.0)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        //maskLayer.path=maskPath.CGPath;
        maskLayer.frame = CGRectMake(0, 0, 723, 123);
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
        
        name = [[UILabel alloc] init];
        name.frame = kTitleFrame;
        name.font =[UIFont fontWithName:@"Heiti SC" size:24.0];
        name.textColor =[UIColor colorWithRed:165/255.0 green:95/255.0 blue:102/255.0 alpha:1.0];
        name.backgroundColor = [UIColor clearColor];
        [self addSubview:name];
        
        date = [[UILabel alloc] init];
        date.frame = kDateFrame;
        date.font = [UIFont fontWithName:@"Heiti SC" size:12.0];
        date.textColor = [UIColor colorWithRed:160/255.0 green:156/255.0 blue:158/255.0 alpha:1.0];
        date.backgroundColor = [UIColor clearColor];
        [self addSubview:date];
        
        content = [[UILabel alloc] init];
        content.frame = kContentFrame;
        content.font = [UIFont fontWithName:@"Heiti SC" size:15.0];
        content.textColor = [UIColor colorWithRed:135/255.0 green:132/255.0 blue:134/255.0 alpha:1.0];
        content.lineBreakMode = NSLineBreakByCharWrapping;
        content.numberOfLines = 0;
        content.adjustsFontSizeToFitWidth = NO;
        content.lineBreakMode = NSLineBreakByTruncatingTail;
        content.backgroundColor = [UIColor clearColor];
        [self addSubview:content];
        
        expand = [[UILabel alloc] init];
        expand.frame = kExpandLabelFrame;
        expand.font = [UIFont fontWithName:@"Heiti SC" size:15.0];
        expand.text = @"展开";
        expand.textColor = [UIColor colorWithRed:212/255.0 green:74/255.0 blue:108/255.0 alpha:1.0];
        expand.backgroundColor = [UIColor clearColor];
        [self addSubview:expand];
        
        rotateBtn = [[UIButton alloc] init];
        rotateBtn.frame = kRotateButtonFrame;
        [rotateBtn setImage:[UIImage imageNamed:@"news center-next mail"] forState:UIControlStateNormal];
        [rotateBtn setBackgroundColor:[UIColor clearColor]];
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

