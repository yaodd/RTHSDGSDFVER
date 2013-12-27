//
//  HeroSelectVIew.h
//  HeroSelectView
//
//  Created by 王智锐 on 12/19/13.
//  Copyright (c) 2013 王智锐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeroSelectView : UIView <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UILabel *selectedLabel;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)UIImageView *arrow;

-(void)setData:(NSMutableArray *)dataArray;

@end
