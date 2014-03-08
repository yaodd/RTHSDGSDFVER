//
//  ChoosePopView.m
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by 欧 展飞 on 14-3-6.
//  Copyright (c) 2014年 yaodd. All rights reserved.
//

#import "ChoosePopView.h"
#define VIEWWIDTH 402
#define VIEWHEIGHT 270

@implementation ChoosePopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *bar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, VIEWWIDTH, 44)];
        bar.image = [UIImage imageNamed:@"setting_nav_bar"];
        [self addSubview:bar];
        
        self.layer.cornerRadius = 20.0f;
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
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
