//
//  NoticeTableView.m
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by 欧 展飞 on 13-10-31.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "NoticeTableView.h"
#import "NoticeTableCell.h"

#define originalHeight 133.0f
//#define newHeight 75.0f
#define isOpen @"didOpen"
#define kTitleKey @"title"
#define kContentKey @"content"
#define kDateKey @"date"

@interface NoticeTableView()
{
    UILabel *emptyLabel;
}
@end
@implementation NoticeTableView
{
    NSMutableDictionary *dicClicked;
    NSMutableDictionary *titles;
    NSMutableDictionary *titleNames;
    CGRect expandRect;
    int cellCount;
    
    int flag;
}

@synthesize dataArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        cellCount = 5;
        
        dicClicked = [NSMutableDictionary dictionaryWithCapacity:3];
        titleNames = [[NSMutableDictionary alloc]initWithCapacity:cellCount];
        titles = [[NSMutableDictionary alloc] initWithCapacity:cellCount];
        
        self.delegate = self;
        self.dataSource = self;
        
        flag = 0;
        
        [self setShowsVerticalScrollIndicator:NO];
        [self setSeparatorColor:[UIColor clearColor]];
        
        emptyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, 800, 40)];
        [emptyLabel setTextColor:[UIColor grayColor]];
        [emptyLabel setText:@"暂时还没有通知噢，先去看看课件吧！"];
        [emptyLabel setFont:[UIFont systemFontOfSize:15]];
        [emptyLabel setHidden:YES];
        [self addSubview:emptyLabel];
    }
    return self;
}



//set the presented content of tableView
- (void)setTableViewData:(NSMutableArray *)data
{
    self.dataArray = data;
    if ([dataArray count] == 0) {
        [emptyLabel setHidden:NO];
    } else{
        [emptyLabel setHidden:YES];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    NSLog(@"numberOfSections:%d", self.dataArray.count);
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"cell For row %d at section %d", indexPath.row, indexPath.section);
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell"]; //以indexPath来唯一确定cell,不使用完全重用机制
    
    NoticeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[NoticeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        flag++;
    }
    
    DataItem *item = [dataArray objectAtIndex:indexPath.section];
    
    cell.indexPath = indexPath;
    
    cell.name.text = item.title;
    
    cell.date.text = item.date;
    
    cell.content.text  = item.content;
    
    if ([[dicClicked objectForKey:[NSString stringWithFormat:@"%d", indexPath.section]] isEqualToString: isOpen])
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:cell.content.font, NSFontAttributeName,cell.content.textColor, NSForegroundColorAttributeName, nil];
        
        CGSize size = CGSizeMake(700, 2000);
        
        expandRect = [cell.content.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        
        cell.content.frame = CGRectMake(cell.content.frame.origin.x,
                                        cell.content.frame.origin.y,
                                        cell.content.frame.size.width,
                                        expandRect.size.height);
        
        cell.expand.frame = CGRectMake(cell.expand.frame.origin.x,
                                       100,
                                       cell.expand.frame.size.width,
                                       cell.expand.frame.size.height);
        cell.expand.text = @"展开";
        cell.rotateBtn.frame = CGRectMake(cell.expand.frame.origin.x + cell.expand.frame.size.width,
                                          cell.expand.frame.origin.y,
                                          cell.rotateBtn.frame.size.width,
                                          cell.rotateBtn.frame.size.height);
        
        [UIView animateWithDuration:0.5 animations:^(void){
            
            cell.expand.frame = CGRectMake(cell.expand.frame.origin.x,
                                           expandRect.size.height + 90,
                                           cell.expand.frame.size.width,
                                           cell.expand.frame.size.height);
            cell.expand.text = @"收起";
            cell.rotateBtn.frame = CGRectMake(cell.expand.frame.origin.x + cell.expand.frame.size.width,
                                              cell.expand.frame.origin.y,
                                              cell.rotateBtn.frame.size.width,
                                              cell.rotateBtn.frame.size.height);
            
        }];
        
        [cell rotateExpandBtnToExpanded];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 723, cell.content.frame.size.height + 120) byRoundingCorners:(UIRectCornerBottomRight | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(20.0, 20.0)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        //maskLayer.path=maskPath.CGPath;
        maskLayer.frame = CGRectMake(0, 0, 723, 123);
        maskLayer.path = maskPath.CGPath;
        cell.layer.mask = maskLayer;
        
        
    }else{
        
        cell.content.frame = CGRectMake(cell.content.frame.origin.x,
                                        cell.content.frame.origin.y,
                                        cell.content.frame.size.width,
                                        16);
        
        if(dataArray.count < flag){
            
            cell.expand.frame = CGRectMake(cell.expand.frame.origin.x,
                                           expandRect.size.height + 90,
                                           cell.expand.frame.size.width,
                                           cell.expand.frame.size.height);
            cell.expand.text = @"收起";
            cell.rotateBtn.frame = CGRectMake(cell.expand.frame.origin.x + cell.expand.frame.size.width,
                                              cell.expand.frame.origin.y,
                                              cell.rotateBtn.frame.size.width,
                                              cell.rotateBtn.frame.size.height);
        }
        [UIView animateWithDuration:0.5 animations:^(void){
            
            cell.expand.frame = CGRectMake(cell.expand.frame.origin.x,
                                           100,
                                           cell.expand.frame.size.width,
                                           cell.expand.frame.size.height);
            cell.expand.text = @"展开";
            cell.rotateBtn.frame = CGRectMake(cell.expand.frame.origin.x + cell.expand.frame.size.width,
                                              cell.expand.frame.origin.y,
                                              cell.rotateBtn.frame.size.width,
                                              cell.rotateBtn.frame.size.height);
        }];
        
        [cell rotateExpandBtnToCollapsed];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 723, 130) byRoundingCorners:(UIRectCornerBottomRight | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(20.0, 20.0)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        //maskLayer.path=maskPath.CGPath;
        maskLayer.frame = CGRectMake(0, 0, 723, 123);
        maskLayer.path = maskPath.CGPath;
        cell.layer.mask = maskLayer;
    }
    
    cell.bottomLine.frame = CGRectMake(cell.bottomLine.frame.origin.x,
                                       cell.expand.frame.origin.y + 25,
                                       cell.bottomLine.frame.size.width,
                                       cell.bottomLine.frame.size.height);
    
    return cell;
}

- (void)reloadData
{
    [super reloadData];
    flag = 0;
}

//Section的标题栏高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

/*
 -(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
 {
 
 }
 */
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Row %d at Section %d was selected",indexPath.row, indexPath.section);
    
    NoticeTableCell *targetCell = (NoticeTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (targetCell.frame.size.height == originalHeight){
        
        [dicClicked setObject:isOpen forKey:[NSString stringWithFormat:@"%d", indexPath.section]];
        
    }
    else{
        
        [dicClicked removeObjectForKey:[NSString stringWithFormat:@"%d", indexPath.section]];
        
    }
    
    [self reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Height for row %d at section %d.", indexPath.row, indexPath.section);
    
    
    DataItem *item = [dataArray objectAtIndex:indexPath.section];
    
    NSString *content = item.content;
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Heiti SC" size:15.0], NSFontAttributeName,[UIColor colorWithRed:135/255.0 green:132/255.0 blue:134/255.0 alpha:1.0], NSForegroundColorAttributeName, nil];
    
    CGSize size = CGSizeMake(700, 2000);
    
    expandRect = [content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    
    if ([[dicClicked objectForKey:[NSString stringWithFormat:@"%d", indexPath.section]] isEqualToString: isOpen]){
        
        return expandRect.size.height + 120;
    }
    else{
        return originalHeight;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    sectionView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    return sectionView;
}

@end
