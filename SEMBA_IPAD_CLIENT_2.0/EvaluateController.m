//
//  EvalutateController.m
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by 欧 展飞 on 13-10-30.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "EvaluateController.h"
#import "ScorePoint.h"
#import "Dao.h"
#import "SysbsModel.h"

@interface EvaluateController (){
    MRProgressOverlayView *overlayView;
}

@end

@implementation EvaluateController
@synthesize selectView = _selectView;
@synthesize evaluateDataArray = _evaluateDataArray;
@synthesize scoreArray = _scoreArray;
@synthesize scrollView = _scrollView;
@synthesize suggestTextView = _suggestTextView;

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
    
    _selectView = [[HeroSelectView alloc] initWithFrame:CGRectMake(411, 135, 196, 44)];
    [_scrollView addSubview:_selectView];
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:@"10",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2",@"1", nil];
    ScorePoint *point1 = [[ScorePoint alloc ]initWithFrame:CGRectMake(897, 402, 32, 32)];
    [point1 setDataArray:array];
    ScorePoint *point2 = [[ScorePoint alloc ]initWithFrame:CGRectMake(897, 452, 32, 32)];
    [point2 setDataArray:array];
    ScorePoint *point3 = [[ScorePoint alloc ]initWithFrame:CGRectMake(897, 502, 32, 32)];
    [point3 setDataArray:array];
    ScorePoint *point4 = [[ScorePoint alloc ]initWithFrame:CGRectMake(897, 552, 32, 32)];
    [point4 setDataArray:array];
    ScorePoint *point5 = [[ScorePoint alloc ]initWithFrame:CGRectMake(897, 602, 32, 32)];
    [point5 setDataArray:array];
    ScorePoint *point6 = [[ScorePoint alloc ]initWithFrame:CGRectMake(897, 652, 32, 32)];
    [point6 setDataArray:array];
        ScorePoint *point7 = [[ScorePoint alloc ]initWithFrame:CGRectMake(897, 702, 32, 32)];
    [point7 setDataArray:array];
    ScorePoint *point8 = [[ScorePoint alloc ]initWithFrame:CGRectMake(897, 752, 32, 32)];
    [point8 setDataArray:array];
    ScorePoint *point9 = [[ScorePoint alloc ]initWithFrame:CGRectMake(897, 802, 32, 32)];
    [point9 setDataArray:array];
    ScorePoint *point10 = [[ScorePoint alloc ]initWithFrame:CGRectMake(897, 852, 32, 32)];
    [point10 setDataArray:array];
    [_scrollView addSubview:point10];
    [_scrollView addSubview:point9];
    [_scrollView addSubview:point8];
    [_scrollView addSubview:point7];
    [_scrollView addSubview:point6];
    [_scrollView addSubview:point5];
    [_scrollView addSubview:point4];
    [_scrollView addSubview:point3];
    [_scrollView addSubview:point2];
    [_scrollView addSubview:point1];

    _scoreArray = [[NSMutableArray alloc]init];
    [_scoreArray addObject:point1];
    [_scoreArray addObject:point2];
    [_scoreArray addObject:point3];
    [_scoreArray addObject:point4];
    [_scoreArray addObject:point5];
    [_scoreArray addObject:point6];
    [_scoreArray addObject:point7];
    [_scoreArray addObject:point8];
    [_scoreArray addObject:point9];
    [_scoreArray addObject:point10];
    
    _suggestTextView.layer.borderColor = [UIColor grayColor].CGColor;
    _suggestTextView.layer.borderWidth = 1.0f;
    _suggestTextView.layer.cornerRadius = 5.0f;
    NSThread *thread =[[NSThread alloc]initWithTarget:self selector:@selector(setData) object:nil];
    [thread start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setData{
    Dao *dao = [Dao sharedDao];
    
    SysbsModel *model = [SysbsModel getSysbsModel];
    overlayView = [[MRProgressOverlayView alloc]init];
    overlayView.mode = MRProgressOverlayViewModeIndeterminate;
    [self.view addSubview:overlayView];
    [overlayView show:YES];

    int ret = [dao requestForEvaluationList:model.user.uid];
    if ( ret == 1){
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        NSArray *data = model.EvaluationList;
        int l = [data count];
        for ( int i = 0 ; i < l ; ++ i){
            EvaluationDataModel *onedata = (EvaluationDataModel *)[data objectAtIndex:i];
            NSString *oneString = [NSString stringWithFormat:@"%@  %@",onedata.courseName,onedata.teacherName];
            [arr  addObject:oneString];
        }
        [_selectView setDataArray:arr];
    }else if( ret == 0 ){
    
    }else if( ret == -1 ){
        
    }
    NSLog(@"evadismiss");
    [self Dismiss];

    //_selectView setDataArray:;
}

-(void)Dismiss{
    [overlayView dismiss:YES];
}



@end
