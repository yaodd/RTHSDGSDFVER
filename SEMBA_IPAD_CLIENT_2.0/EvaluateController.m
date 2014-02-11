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
    NSArray *numArr;
    NSArray *commentArr;
    int isEnableComment;        //0表示不可评教，1表示可评教
}

@end

@implementation EvaluateController
@synthesize selectView = _selectView;
@synthesize evaluateDataArray = _evaluateDataArray;
//@synthesize scoreArray = _scoreArray;
@synthesize scrollView = _scrollView;
@synthesize suggestTextView = _suggestTextView;
@synthesize courseDescription = _courseDescription;
@synthesize courseAndTeacherName = _courseAndTeacherName;
@synthesize teacherHead = _teacherHead;
@synthesize classDateLabel = _classDateLabel;
@synthesize classNumLabel = _classNumLabel;
@synthesize scoreView;
@synthesize scoreCollect;
@synthesize scoreDict;

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
    
    _teacherHead.layer.masksToBounds = YES;
    _teacherHead.layer.cornerRadius = 55.5;
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    [titleLabel setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:20.0]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor colorWithRed:199/255.0 green:56/255.0 blue:91/255.0 alpha:1.0]];
    [titleLabel setText:@"评教"];
    self.navigationItem.titleView = titleLabel;

    /*
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
    */
    
    _scrollView.delegate = self;
    
    _selectView = [[HeroSelectView alloc] initWithFrame:CGRectMake(411, 135, 240, 35)];
    [_selectView.layer setBorderColor:[UIColor colorWithWhite:215.0/255 alpha:1.0].CGColor];
    [_selectView.layer setBorderWidth:1.0];
    //因为暂时没有评教，点击无反应
    _selectView.userInteractionEnabled = NO;
    _selectView.delegate = self;
    
    [_scrollView addSubview:_selectView];
    
    _suggestTextView.layer.borderColor = [UIColor grayColor].CGColor;
    _suggestTextView.layer.borderWidth = 1.0f;
    _suggestTextView.layer.cornerRadius = 5.0f;
    
    [_upEvaluationButton addTarget:self action:@selector(upEvaluation:) forControlEvents:UIControlEventTouchUpInside];
    SysbsModel *model = [SysbsModel getSysbsModel];
    NSString *class_num = [NSString stringWithFormat:@"班级：黄埔%d期",model.user.class_num];
    _classNumLabel.text = class_num;
    
    Reachability *r = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if([r currentReachabilityStatus] == NotReachable){
            // 没有网络连接
            NSLog(@"no connection");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"网络出错" message:@"当前没有网络，无法评教" delegate:self cancelButtonTitle:@"好" otherButtonTitles: nil];
        [alertView show];
    }else {

            NSThread *thread =[[NSThread alloc]initWithTarget:self selector:@selector(setData) object:nil];
            [thread start];
    }
    

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    commentArr =[[NSArray alloc]initWithObjects:@"one",@"two",@"three",@"four",@"five",@"six",@"seven",@"eight",@"nine",@"ten", nil];
    numArr = [[NSArray alloc]initWithObjects:@"assess_10",@"assess_9",@"assess_8",@"assess_7",@"assess_6",@"assess_5",@"assess_4",@"assess_3",@"assess_2",@"assess_1", nil];
    NSNumber *tenNum = [NSNumber numberWithInt:10];
    scoreDict = [[NSMutableDictionary alloc]init];
    NSLog(@"scoreCollectcount:%d", [scoreCollect count]);
    for (int i = 0 ; i < 10; i ++) {
        [scoreDict setObject:tenNum forKey:[commentArr objectAtIndex:i]];
        UIButton *button = [scoreCollect objectAtIndex:i];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"评分"] forState:UIControlStateNormal];
    }
    [scoreDict setObject:@"" forKey:@"comment"];
    [scoreDict setObject:@"" forKey:@"teach"];
    scoreView = [[UIView alloc]init];
    scoreView.alpha = 0;
    UIColor *viewBG = [UIColor colorWithPatternImage:[UIImage imageNamed:@"assess_dropdown_bg"]];
    [scoreView setBackgroundColor:viewBG];
    for (int i = 0; i < 5; i ++) {
        for (int k = 0 ; k < 2; k ++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(k * 60 + 27, i * 39 + 20, 23, 19);
            [button setBackgroundImage:[UIImage imageNamed:[numArr objectAtIndex:i * 2 + k]] forState:UIControlStateNormal];
            [button setTag:i * 2 + k + 1];
            [button setTitle:[NSString stringWithFormat:@"%d",11-(i * 2 + k + 1) ] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(numButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [scoreView addSubview:button];
            
        }
    }

    [self.view addSubview:scoreView];
}

- (void)numButtonAction:(id)sender
{
    
    UIButton *button = (UIButton *)sender;
    int tag = button.tag;
    //UIImage *image = [UIImage imageNamed:[numArr objectAtIndex:tag - 1]];
    //    UIButton *scoreButton = [scoreButtonCol objectAtIndex:nowButtonIndex - 1];
    UIButton *scoreButton = [[UIButton alloc]init];
    for (int i = 0; i < scoreCollect.count; i ++) {
        NSLog(@"=====");
        NSLog(@"[scoreCollect objectAtIndex:i]).tag::%d--current_index::%d",((UIButton *)[scoreCollect objectAtIndex:i]).tag, current_index);
        if (((UIButton *)[scoreCollect objectAtIndex:i]).tag == current_index)
        {
            scoreButton = (UIButton *)[scoreCollect objectAtIndex:i];
            break;
        }
    }
    NSNumber *scoreNum = [NSNumber numberWithInt:11 - tag];
    NSLog(@"bbbb");
    NSString *scoreKey = [commentArr objectAtIndex:scoreButton.tag - 1];
    NSLog(@"aaaa");
    [scoreDict setObject:scoreNum forKey:scoreKey];
    
    
    //    [scoreButton setImage:image forState:UIControlStateNormal];
    [scoreButton setTitle:[NSString stringWithFormat:@"%d",11 - tag] forState:UIControlStateNormal];
    [scoreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self scoreViewDisappear:scoreView :sender];
}

- (IBAction)scoreButtonAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSLog(@"%f %f %f %f",scoreView.frame.origin.x,scoreView.frame.origin.y,scoreView.frame.size.width,scoreView.frame.size.height);
    current_index = button.tag;
    //    NSLog(@"inini");
    if (scoreView.alpha == 1) {
        [self scoreViewDisappear:scoreView :sender];
        
    }
    
    {
        
        CGRect rect = button.frame;
        CGFloat offset = [_scrollView contentOffset].y;
        NSLog(@"offset %f",offset);
        rect.origin.y -= offset;
        
        rect.origin.x -=  77;
        rect.origin.y += rect.size.height + 20;
        rect.size.height = 209;
        rect.size.width = 139;
        scoreView.frame = rect;
        //        [scoreView setBackgroundColor:[UIColor redColor]];
        [self scoreViewAppear:scoreView :sender];
    }
}

- (void) scoreViewAppear:(UIView *)view : (id)sender
{
    NSLog(@"app");
    [UIView beginAnimations:@"scoreViewAppear" context:nil];
    [UIView setAnimationDuration:0.3];
    CGRect anRect = view.frame;
    anRect.origin.y -= 20;
    view.alpha = 1;
    view.frame = anRect;
    [UIView commitAnimations];
    
}

- (void) scoreViewDisappear:(UIView *)view : (id)sender
{
    NSLog(@"disa");
    [UIView beginAnimations:@"scoreViewDisappear" context:nil];
    [UIView setAnimationDuration:0.3];
    CGRect anRect = view.frame;
    anRect.origin.y += 20;
    view.alpha = 0;
    view.frame = anRect;
    [UIView commitAnimations];

}


- (void)keyboardWillShow:(NSNotification *)notification {
   // CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
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
    //NSLog(@"滚动视图开始滚动，它只调用一次");
    if (scoreView.alpha != 0) {
        [self scoreViewDisappear:scoreView :nil];
    }
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
        isEnableComment = 1;
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        NSArray *data = model.EvaluationList;
        int l = [data count];
                for ( int i = 0 ; i < l ; ++ i){
            EvaluationDataModel *onedata = (EvaluationDataModel *)[data objectAtIndex:i];
            NSString *oneString = [NSString stringWithFormat:@" %@ %@",onedata.courseName,onedata.teacherName];
            [arr  addObject:oneString];
        }
        if(l == 0){
            isEnableComment = 0;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"没有评教" message:@"当前没有评教" delegate:self cancelButtonTitle:@"好" otherButtonTitles: nil];
            [alertView show];
        }
        [_selectView setData:arr];
    }else if( ret == 0 ){
        isEnableComment = 0;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"没有评教" message:@"当前没有评教" delegate:self cancelButtonTitle:@"好" otherButtonTitles: nil];
        [alertView show];
    }else if( ret == -1 ){
        isEnableComment = 0;
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
    int rs = [dao requestForUpEvaluation:model.user.uid eid:onedata.eid
                                     one:((UIButton *)[scoreCollect objectAtIndex:0]).titleLabel.text.intValue
                                     two:((UIButton *)[scoreCollect objectAtIndex:1]).titleLabel.text.intValue
                                   three:((UIButton *)[scoreCollect objectAtIndex:2]).titleLabel.text.intValue
                                    four:((UIButton *)[scoreCollect objectAtIndex:3]).titleLabel.text.intValue
                                    five:((UIButton *)[scoreCollect objectAtIndex:4]).titleLabel.text.intValue
                                     six:((UIButton *)[scoreCollect objectAtIndex:5]).titleLabel.text.intValue
                                   seven:((UIButton *)[scoreCollect objectAtIndex:6]).titleLabel.text.intValue
                                   eight:((UIButton *)[scoreCollect objectAtIndex:7]).titleLabel.text.intValue
                                    nine:((UIButton *)[scoreCollect objectAtIndex:8]).titleLabel.text.intValue
                                     ten:((UIButton *)[scoreCollect objectAtIndex:9]).titleLabel.text.intValue
                             suggestText:_suggestTextView.text];
    if(rs == 1){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"评教已经成功" message:@"评教已经成功返回可继续其他评教" delegate:self cancelButtonTitle:@"好" otherButtonTitles: nil];
        [alertView show];
               //评教完成一次后，还原评教之前的内容
                for (int i = 0 ; i <[scoreCollect count];++i){
            //ScorePoint *point = [_scoreArray objectAtIndex:i];
           // point.selectedLabel.text = @"10";
                    UIButton *btn = (UIButton *)[scoreCollect objectAtIndex:i];
                    btn.titleLabel.text = @"评分";
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
    //暂时没有评教
    if(isEnableComment == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"没有评教" message:@"当前没有评教" delegate:self cancelButtonTitle:@"好" otherButtonTitles: nil];
        [alertView show];
    }
    else {
    //如果恢复评教功能
        for(int i = 0; i < [scoreCollect count]; ++i){
            if([((UIButton *)[scoreCollect objectAtIndex:i]).titleLabel.text isEqualToString:@"评分"]){
                NSLog(@"没有全部评分！");
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"评教失败" message:@"请完成全部评分" delegate:self cancelButtonTitle:@"好" otherButtonTitles: nil];
                [alertView show];
                return ;
            }
        }
    
    //NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(uploadEvaluation) object:nil];
    //[thread start];
    [self uploadEvaluation];
    }
    
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
