//
//  ScorePoint.h
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by 王智锐 on 12/19/13.
//  Copyright (c) 2013 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScorePoint : UIView <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UILabel *selectedLabel;
@property (nonatomic,strong)NSMutableArray *dataArray;

@end
