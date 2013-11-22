//
//  MenuCell.m
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by 欧 展飞 on 13-10-30.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell
@synthesize title;
@synthesize belowLine;
@synthesize topLine;
@synthesize icon;
@synthesize backgroundImg;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        title = [[UILabel alloc] init];
        belowLine = [[UIImageView alloc] init];
        topLine = [[UIImageView alloc] init];
        icon = [[UIImageView alloc] init];
        backgroundImg = [[UIImageView alloc] init];
        
        
        [self addSubview:backgroundImg];
        [self addSubview:title];
        [self addSubview:belowLine];
        [self addSubview:topLine];
        [self addSubview:icon];
        
             
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
