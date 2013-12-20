//
//  ScheduleController.m
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by 欧 展飞 on 13-10-30.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "ScheduleController.h"
#import "RightCell.h"
#import "LeftCell.h"
#import "CellData.h"
#include "SysbsModel.h"
#include "MyCourse.h"
#include "Course.h"

#define kCellSize CGSizeMake(600, 171)
#define kDistanceOfCells 135.0f
#define kOriginXOfRightCells 450.0f
#define kOriginYofTopCell 50.0f
#define kYearLabelSize CGSizeMake(200, 100)

@interface ScheduleController ()

@end

@implementation ScheduleController
{
    float originY;
    int cellCount;
}

@synthesize scrollView = _scrollView;
@synthesize dataArray = _dataArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0]];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:199/255.0 green:56/255.0 blue:91/255.0 alpha:1.0];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar_bg"] forBarMetrics:UIBarMetricsDefault];
    
    UIImageView *title = [[UIImageView alloc] initWithFrame:CGRectMake(470, 30, 71, 21)];
    title.image = [UIImage imageNamed:@"schedule"];
    [self.navigationController.view addSubview:title];
    
    UIImageView *centerLine = [[UIImageView alloc] initWithFrame:CGRectMake(500, 0, 7, 700)];
    centerLine.image = [UIImage imageNamed:@"course_line"];
    [self.view addSubview:centerLine];
    
    cellCount = 10;

    SysbsModel *model = [SysbsModel getSysbsModel];
    _dataArray = [[model getCourses] getMyCourse];
    cellCount = [_dataArray count];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,
                                                                self.view.frame.size.height,
                                                                self.view.frame.size.width)];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_scrollView];
    
    originY = kOriginYofTopCell - kDistanceOfCells;
    for(int i = 0; i < cellCount; ++i){
        
        originY += kDistanceOfCells;
        Course *course = ((Course*)[_dataArray objectAtIndex:i]);
        CellData* celldata = [[CellData alloc] init];
        celldata.date = course.startTime;
        celldata.name = course.courseName;
        celldata.month = @"11月";
        celldata.place = course.location;
        celldata.time = @"时间： 9：00AM-12：00AM";
        celldata.teacher = @"李非";
        //Add a label of year to view
        if(0){//目前永远不会执行。
            UILabel *year = [[UILabel alloc] initWithFrame:CGRectMake(410 , originY, kYearLabelSize.width, kYearLabelSize.height)];
            year.textColor = [UIColor colorWithRed:228/255.0 green:64/255.0 blue:91/255.0 alpha:1.0];
            year.font = [UIFont fontWithName:@"Heiti SC" size:30.0];
            year.text = @"aaa";
            [self.scrollView addSubview:year];
            originY += year.frame.size.height + 50;
        }
        
        if(i % 2 == 0){
            
            RightCell *cell1 = [[RightCell alloc] initWithFrame:CGRectMake(kOriginXOfRightCells, originY, kCellSize.width, kCellSize.height)];
            [self.scrollView addSubview:cell1];
            [cell1 setData:celldata];
            
        }else {
            
            LeftCell *cell2 = [[LeftCell alloc] initWithFrame:CGRectMake(26, originY, kCellSize.width, kCellSize.height)];
            [self.scrollView addSubview:cell2];
            [cell2 setData:celldata];
        }
    }
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, (cellCount + 1) * kDistanceOfCells + kOriginYofTopCell)];
    
    
    
    //NSLog(@"dataArray count %d ",[array count]);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
