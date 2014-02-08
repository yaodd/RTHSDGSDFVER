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
    int current_index ;
}

@end

@implementation EvaluateController
@synthesize selectView = _selectView;
@synthesize evaluateDataArray = _evaluateDataArray;
@synthesize scoreArray = _scoreArray;
@synthesize scrollView = _scrollView;
@synthesize suggestTextView = _suggestTextView;
@synthesize courseDescription = _courseDescription;
@synthesize courseAndTeacherName = _courseAndTeacherName;
@synthesize teacherHead = _teacherHead;
@synthesize classDateLabel = _classDateLabel;
@synthesize classNumLabel = _classNumLabel;

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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar_bg"] forBarMetrics:UIBarMetricsDefault];
    current_index = -1;
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    //_selectView = [[HeroSelectView alloc] initWithFrame:CGRectMake(411, 135, 196, 44)];
    //[_scrollView addSubview:_selectView];
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    [titleLabel setFont:[UIFont systemFontOfSize:19]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor redColor]];
    [titleLabel setText:@"评教"];
    self.navigationItem.titleView = titleLabel;

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
    _scrollView.delegate = self;
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
    
    _selectView = [[HeroSelectView alloc] initWithFrame:CGRectMake(411, 135, 240, 35)];
    [_selectView.layer setBorderColor:[UIColor colorWithWhite:215.0/255 alpha:1.0].CGColor];
    [_selectView.layer setBorderWidth:1.0];
    _selectView.delegate = self;
    
    [_scrollView addSubview:_selectView];
    
    _suggestTextView.layer.borderColor = [UIColor grayColor].CGColor;
    _suggestTextView.layer.borderWidth = 1.0f;
    _suggestTextView.layer.cornerRadius = 5.0f;
    
    [_upEvaluationButton addTarget:self action:@selector(upEvaluation:) forControlEvents:UIControlEventTouchUpInside];
    SysbsModel *model = [SysbsModel getSysbsModel];
    NSString *class_num = [NSString stringWithFormat:@"班级：黄埔%d期",model.user.class_num];
    _classNumLabel.text = class_num;
    NSThread *thread =[[NSThread alloc]initWithTarget:self selector:@selector(setData) object:nil];
    [thread start];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGRect scrollFrame = _scrollView.frame;
    scrollFrame.origin.y = 0 - 350;
    [UIView animateWithDuration:0.15
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             _scrollView.frame = scrollFrame;
                         } completion:^(BOOL finished) {
                             _scrollView.frame = scrollFrame;

    }];
    
    
    //    NSLog(@"show");
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_suggestTextView resignFirstResponder];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGRect scrollFrame = _scrollView.frame;
    scrollFrame.origin.y = 0;
    _scrollView.frame = scrollFrame;
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
    //[overlayView show:YES];

    int ret = [dao requestForEvaluationList:model.user.uid];
    if ( ret == 1){
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        NSArray *data = model.EvaluationList;
        int l = [data count];
                for ( int i = 0 ; i < l ; ++ i){
            EvaluationDataModel *onedata = (EvaluationDataModel *)[data objectAtIndex:i];
            NSString *oneString = [NSString stringWithFormat:@" %@ %@",onedata.courseName,onedata.teacherName];
            [arr  addObject:oneString];
        }
        if(l == 0){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"没有评教" message:@"当前没有评教" delegate:self cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alertView show];
        }
        [_selectView setData:arr];
    }else if( ret == 0 ){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"没有评教" message:@"当前没有评教" delegate:self cancelButtonTitle:@"好" otherButtonTitles: nil];
        [alertView show];
    }else if( ret == -1 ){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"服务器故障" message:@"当前没有评教" delegate:self cancelButtonTitle:@"好" otherButtonTitles: nil];
        [alertView show];
    }
    [self Dismiss];

    //_selectView setDataArray:;
}

-(void)Dismiss{
    [overlayView dismiss:YES];
    if(overlayView.superview != nil)
        [overlayView removeFromSuperview];
}

-(void)uploadEvaluation{
    overlayView = [[MRProgressOverlayView alloc]init];
    overlayView.mode = MRProgressOverlayViewModeIndeterminate;
    [self.view addSubview:overlayView];
    
    Dao *dao =[Dao sharedDao ];
    SysbsModel *model = [SysbsModel getSysbsModel];
    NSArray *arr = model.EvaluationList;
    EvaluationDataModel *onedata = [arr objectAtIndex:current_index];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"正在评教" message:@"正在发送网络请求请耐心等待，完成后将有提示。" delegate:self cancelButtonTitle:@"好" otherButtonTitles: nil];
    [alertView show];
    int rs = [dao requestForUpEvaluation:model.user.uid eid:onedata.eid one:[((ScorePoint*)[_scoreArray objectAtIndex:0]).selectedLabel.text intValue] two:[((ScorePoint*)[_scoreArray objectAtIndex:1]).selectedLabel.text intValue] three:[((ScorePoint*)[_scoreArray objectAtIndex:2]).selectedLabel.text intValue] four:[((ScorePoint*)[_scoreArray objectAtIndex:3]).selectedLabel.text intValue] five:[((ScorePoint*)[_scoreArray objectAtIndex:4]).selectedLabel.text intValue] six:[((ScorePoint*)[_scoreArray objectAtIndex:5]).selectedLabel.text intValue] seven:[((ScorePoint*)[_scoreArray objectAtIndex:6]).selectedLabel.text intValue] eight:[((ScorePoint*)[_scoreArray objectAtIndex:7]).selectedLabel.text intValue] nine:[((ScorePoint*)[_scoreArray objectAtIndex:8]).selectedLabel.text intValue] ten:[((ScorePoint*)[_scoreArray objectAtIndex:9]).selectedLabel.text intValue] suggestText:_suggestTextView.text];
    if(rs == 1){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"评教已经成功" message:@"评教已经成功返回可继续其他评教" delegate:self cancelButtonTitle:@"好" otherButtonTitles: nil];
        [alertView show];
                for (int i = 0 ; i <[_scoreArray count];++i){
            ScorePoint *point = [_scoreArray objectAtIndex:i];
            point.selectedLabel.text = @"10";
            _selectView.selectedLabel.text = @"无";
        }
        [self setData];

        _suggestTextView.text = @"";
    }else if(rs == -1){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"评教失败" message:@"服务器故障" delegate:self cancelButtonTitle:@"好" otherButtonTitles: nil];
        [alertView show];
    }else if(rs == -2){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"评教失败" message:@"你已经评教过了" delegate:self cancelButtonTitle:@"好" otherButtonTitles: nil];
        [alertView show];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"评教失败" message:@"网络或者服务器故障了" delegate:self cancelButtonTitle:@"好" otherButtonTitles: nil];
        [alertView show];

    }
    [overlayView dismiss:YES];
    if(overlayView.superview != nil)
        [overlayView removeFromSuperview];
    NSLog(@"uploadfinish %d" ,rs);
}

-(void)upEvaluation:(id)sender{
    [_suggestTextView resignFirstResponder];
    if(current_index < 0){
        NSLog(@"current_index < 0");
        return ;
    }
    //NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(uploadEvaluation) object:nil];
    //[thread start];
    [self uploadEvaluation];
}

-(void)selectSomeItem:(int)index{
    SysbsModel *model = [SysbsModel getSysbsModel];
    NSArray *arr = model.EvaluationList;
    EvaluationDataModel *onedata = [arr objectAtIndex:index];
    NSString *string = [NSString stringWithFormat:@"%@ %@",onedata.courseName,onedata.teacherName];
    _courseAndTeacherName.text = string;
    MyCourse *myCourse = model.myCourse;
    Course *course = [myCourse findCourse:onedata.cid];
    _courseDescription.text  = course.courseDescription;
    if([course.startTime length]>=10 && [course.endTime length]>=10){
        NSString *startdate = [course.startTime substringWithRange:NSMakeRange(5, 5)];
        NSString *enddate  = [course.endTime substringWithRange:NSMakeRange(5, 5)];
        NSString* showdate = [NSString stringWithFormat:@"%@到%@",startdate,enddate];
        _classDateLabel.text = showdate;
    }
    current_index = index;
}



@end
