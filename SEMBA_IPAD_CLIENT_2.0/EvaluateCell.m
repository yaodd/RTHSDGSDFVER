//
//  EvaluateCell.m
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by 王智锐 on 12/19/13.
//  Copyright (c) 2013 yaodd. All rights reserved.
//

#import "EvaluateCell.h"

@implementation EvaluateCell

@synthesize  label = _label;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:_label];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
