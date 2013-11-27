//
//  myCourseBtn.m
//  SYSBS_EMBA_IPAD_CLIENT_2.0
//
//  Created by 欧 展飞 on 13-10-21.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "CourseItem.h"

#define START_X     12.0f
#define START_Y     15.0f
#define TEACH_LABEL_WIDTH   100
#define INFO_VIEW_Y     169
#define INFO_VIEW_HEIGHT    69

@implementation CourseItem
@synthesize courseImg;
@synthesize nameLabel;
@synthesize dateLabel;
@synthesize resumeLabel;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame :(NSMutableDictionary *)courseDict{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self.layer setCornerRadius:20.0f];
        NSString *date = [courseDict objectForKey:@"date"];
        NSString *courseName = [courseDict objectForKey:@"courseName"];
        NSString *teachName = [courseDict objectForKey:@"teachName"];
//        NSLog(@"1 %@ 2 %@ 3 %@",courseName,date,teachName);
        UIImage *courseImage = [courseDict objectForKey:@"courseImage"];
//        UIImage *courseImage = [UIImage imageNamed:@"lixinchun"];
//        self.backgroundColor = [UIColor grayColor];
        [self setBackgroundColor:[UIColor colorWithPatternImage:courseImage]];
        
//        courseImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//        [courseImg setImage:courseImage];
//        [courseImg.layer setCornerRadius:20.0f];
//        [self addSubview:courseImg];
        
        UIView *infoView = [[UIView alloc]initWithFrame:CGRectMake(0, INFO_VIEW_Y, self.frame.size.width, INFO_VIEW_HEIGHT)];
        [infoView setBackgroundColor:[UIColor colorWithRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:1.0]];
        [infoView setAlpha:0.6];
        [self addSubview:infoView];

        CGFloat topY = START_Y;
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(START_X, topY + INFO_VIEW_Y, 200, 30)];
        nameLabel.text = courseName;
        nameLabel.textColor = [UIColor colorWithRed:198.0/255 green:56.0/255 blue:91.0/255 alpha:1.0];
        nameLabel.font = [UIFont fontWithName:@"Heiti SC" size:27.0];
        nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
        nameLabel.numberOfLines = 0;
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:nameLabel];
        topY += (30);
        resumeLabel = [[UILabel alloc] initWithFrame:CGRectMake(START_X, topY + INFO_VIEW_Y, 70, 15)];
        resumeLabel.text = teachName;
        resumeLabel.textColor = [UIColor colorWithRed:56.0/255 green:16.0/255 blue:33.0/255 alpha:1.0];
        resumeLabel.font = [UIFont fontWithName:@"Heiti SC" size:12.0];
        resumeLabel.lineBreakMode = NSLineBreakByCharWrapping;
        resumeLabel.numberOfLines = 0;
        [resumeLabel setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:resumeLabel];
        
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - (START_X * 2) - 200, topY + INFO_VIEW_Y, 200, 15)];
        dateLabel.text = date;
        dateLabel.textColor = [UIColor colorWithRed:56.0/255 green:16.0/255 blue:33.0/255 alpha:1.0];
        dateLabel.font = [UIFont fontWithName:@"Heiti SC" size:12.0];
        dateLabel.lineBreakMode = NSLineBreakByCharWrapping;
        dateLabel.numberOfLines = 0;
        [dateLabel setTextAlignment:NSTextAlignmentRight];
        [self addSubview:dateLabel];
        
        
        
    }
    return self;

}

- (void)jumpToDetail:(id)sender
{
    NSLog(@"jumpToDetail");
    
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
