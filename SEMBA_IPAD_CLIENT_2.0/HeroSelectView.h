//
//  HeroSelectVIew.h
//  HeroSelectView
//
//  Created by 王智锐 on 12/19/13.
//  Copyright (c) 2013 王智锐. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HeroSelectDelegate <NSObject>
@optional
-(void)selectSomeItem:(int)index;
@end

@interface HeroSelectView : UIView <UITableViewDataSource,UITableViewDelegate>
@property id<HeroSelectDelegate> delegate;
@property (nonatomic,strong)UILabel *selectedLabel;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)UIImageView *arrow;

-(void)setData:(NSMutableArray *)dataArray;
- (void)deleteATeacherByIndex:(int)index;
@end
