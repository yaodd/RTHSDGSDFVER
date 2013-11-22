//
//  LeftCell.m
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by 欧 展飞 on 13-11-12.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "LeftCell.h"

@implementation LeftCell
@synthesize month;
@synthesize monthBg;
@synthesize name;
@synthesize teacher;
@synthesize date;
@synthesize place;
@synthesize time;
@synthesize contentBg;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UIColor *titleColor = [UIColor colorWithRed:199/255.0 green:56/255.0 blue:91/255.0 alpha:1.0];
        UIColor *textColor = [UIColor colorWithRed:192/255.0 green:178/255.0 blue:181/255.0 alpha:1.0];
        
        self.backgroundColor = [UIColor clearColor];
        
        monthBg = [[UIImageView alloc] initWithFrame:CGRectMake(425, 25, 103, 103)];
        monthBg.image = [UIImage imageNamed:@"course_month"];
        monthBg.backgroundColor = [UIColor clearColor];
        [self addSubview:monthBg];
        
        contentBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 426, 171)];
        contentBg.image = [UIImage imageNamed:@"course_couyrse"];
        contentBg.backgroundColor = [UIColor clearColor];
        [self addSubview:contentBg];
        
        month = [[UILabel alloc] initWithFrame:CGRectMake(425, 45, 103, 50)];
        month.backgroundColor = [UIColor clearColor];
        month.font = [UIFont fontWithName:@"Heiti SC" size:30.0];
        month.textColor = [UIColor whiteColor];
        month.text = @"aaa";
        month.textAlignment = NSTextAlignmentCenter;
        [self addSubview:month];
        
        name = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, 200, 40)];
        name.text = @"aaaa";
        name.backgroundColor = [UIColor clearColor];
        name.font = [UIFont fontWithName:@"Heiti SC" size:30];
        name.textColor = titleColor;
        [self addSubview:name];
        
        teacher = [[UILabel alloc] initWithFrame:CGRectMake(name.frame.origin.x + name.frame.size.width, 35, 150, 20)];
        teacher.text = @"bbbbbb";
        teacher.backgroundColor = [UIColor clearColor];
        teacher.font = [UIFont fontWithName:@"Heiti SC" size:18];
        teacher.textColor = textColor;
        [self addSubview:teacher];
        
        date = [[UILabel alloc] initWithFrame:CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height + 15, 300, 20)];
        date.text = @"cccccccccc";
        date.backgroundColor = [UIColor clearColor];
        date.font = [UIFont fontWithName:@"Heiti SC" size:18];
        date.textColor = textColor;
        [self addSubview:date];
        
        place = [[UILabel alloc] initWithFrame:CGRectMake(name.frame.origin.x, date.frame.origin.y + date.frame.size.height + 15, 300, 20)];
        place.text = @"dddddddd";
        place.backgroundColor = [UIColor clearColor];
        place.font = [UIFont fontWithName:@"Heiti SC" size:18];
        place.textColor = textColor;
        [self addSubview:place];
        
        time = [[UILabel alloc] initWithFrame:CGRectMake(name.frame.origin.x, place.frame.origin.y + place.frame.size.height + 15, 300, 20)];
        time.backgroundColor = [UIColor clearColor];
        time.font = [UIFont fontWithName:@"Heiti SC" size:18];
        time.text = @"eeeeeeeeeee";
        time.textColor = textColor;
        [self addSubview:time];
    }
    return self;
}

- (void)setData:(CellData *)data
{
    self.month.text = data.month;
    self.name.text = data.name;
    self.teacher.text = data.teacher;
    self.date.text = data.date;
    self.place.text = data.place;
    self.time.text = data.time;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
