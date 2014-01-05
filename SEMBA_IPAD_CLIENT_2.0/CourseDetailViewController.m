//
//  CourseDetailViewController.m
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by 王智锐 on 12/31/13.
//  Copyright (c) 2013 yaodd. All rights reserved.
//

#import "CourseDetailViewController.h"
#import "Dao.h"
#import "SysbsModel.h"
#import "SingleChooseCourseDataObject.h"
#import "MRProgressOverlayView.h"

@interface CourseDetailViewController (){
    BOOL haveSelected;
    UIView *popUpView;
    SingleChooseCourseDataObject *dataobj;
    MRProgressOverlayView *overlayView;
    NSArray *imageArray;
    int index ;
}

@end

@implementation CourseDetailViewController

@synthesize nameLabel = _nameLabel;
@synthesize titleLabel = _titleLabel;
@synthesize dateLabel = _dateLabel;
@synthesize peopleNumLabel = _peopleNumLabel;
@synthesize imageView = _imageView;
@synthesize selectButton = _selectButton;
@synthesize courseShortViewContent = _courseShortViewContent;
@synthesize courseShortViewTitle = _courseShortViewTitle;
@synthesize teacherShortViewContent = _teacherShortViewContent;
@synthesize teacherShortViewTitle = _teacherShortViewTitle;
@synthesize scrollView = _scrollView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil courseid:(int)course_index{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        SysbsModel *model = [SysbsModel getSysbsModel];
        dataobj = [model.chooseCourseListResult.arr objectAtIndex:course_index];
        index = course_index;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    imageArray = [NSArray arrayWithObjects:@"lixinchun",@"lutaihong",@"maoyunshi", nil];
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    [self.view addSubview:_scrollView];
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(210, 28, 400, 60  )];
    _titleLabel.text = @"测试课程标题";
    [_scrollView addSubview:_titleLabel];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(226, 78, 400, 20)];
    _nameLabel.text = @"授课老师:测试账号";
    [_scrollView addSubview:_nameLabel];
    
    _dateLabel = [[UILabel alloc]    initWithFrame:CGRectMake(228, 106, 400, 20)];
    _dateLabel.text = @"上课时间：测试时间";
    [_scrollView addSubview:_dateLabel];
    
    _peopleNumLabel = [[ UILabel alloc]  initWithFrame:CGRectMake(210, 138, 400, 60)];
    _peopleNumLabel.text = @"已选x人/限选y人";
    [_scrollView addSubview:_peopleNumLabel];
    
    //_imageView = []
    _selectButton = [[UIButton alloc] initWithFrame:CGRectMake(678, 76, 96, 38)];
    UIImage *buttonbg = [UIImage imageNamed:@"button_choose.png"];
    [_selectButton setBackgroundImage:buttonbg forState:UIControlStateNormal];
    [_selectButton setTitle:@"选课" forState:UIControlStateNormal];
    [_scrollView addSubview:_selectButton];
    
    _courseShortViewTitle = [[UILabel alloc]initWithFrame:CGRectMake(150, 200, 400, 26)];
    _courseShortViewTitle.text = @"课程简介";
    [_scrollView addSubview:_courseShortViewTitle];
    
    _courseShortViewContent = [[UITextView alloc]initWithFrame:CGRectMake(120, 250, 720, 200)];
    _courseShortViewContent.text =@"测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容";
    _courseShortViewContent.userInteractionEnabled = NO;
    [_scrollView addSubview:_courseShortViewContent];
    
    _teacherShortViewTitle = [[UILabel alloc]initWithFrame:
                              CGRectMake(150, _courseShortViewContent.frame.origin.y + _courseShortViewContent.frame.size.height + 40, 100, 26)];
    _teacherShortViewTitle.text = @"教师简介";
    [_scrollView addSubview:_teacherShortViewTitle];
    
    _teacherShortViewContent = [[UITextView alloc]initWithFrame:CGRectMake(120, _teacherShortViewTitle.frame.origin.y + _teacherShortViewTitle.frame.size.height + 20, 720, 400)];
    _teacherShortViewContent.text = @"测试教师简介";
    _teacherShortViewContent.userInteractionEnabled = NO;
    [_scrollView addSubview:_teacherShortViewContent];
    
    UIImage *timelogo = [UIImage imageNamed:@"time.png"];
    UIImageView *timelogoView = [[UIImageView alloc]initWithImage:timelogo];
    timelogoView.frame = CGRectMake(210, 106, 18, 18);
    [_scrollView addSubview:timelogoView];
    
    UIImage *peoplelogo = [UIImage imageNamed:@"user.png"];
    UIImageView *peoplelogoView = [[UIImageView alloc]initWithImage:peoplelogo];
    peoplelogoView.frame = CGRectMake(210, 78, 16, 18);
    [_scrollView addSubview:peoplelogoView];
    [self updateContent];
    [self updateContentSize];
	// Do any additional setup after loading the view.
    [_selectButton addTarget:self action:@selector(chooseButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 20, 120, 134)];
    [_scrollView addSubview:_imageView];
    _imageView.image = [UIImage imageNamed:[imageArray objectAtIndex:index% 3]];
}

-(void)updateContent{
    _titleLabel.text = dataobj.courseTitle;
    _peopleNumLabel.text = [NSString stringWithFormat:@"已选%d人/限选%d人",dataobj.nowChooseNum ,dataobj.maxChooseNum];
    //_nameLabel.text
    _courseShortViewContent.text = dataobj.contentShortView;
    
    NSString *startdate = [dataobj.startdate substringWithRange:NSMakeRange(5, 5)];
    NSString *enddate = [dataobj.enddate substringWithRange:NSMakeRange(5, 5)];
    _dateLabel.text = [NSString stringWithFormat:@"%@到%@",startdate,enddate];
    haveSelected = dataobj.haveselected;
    
    if(haveSelected == YES){
        [_selectButton setBackgroundImage:[UIImage imageNamed:@"button_choose.png"] forState:UIControlStateNormal];
        [_selectButton setTitle:@"退课" forState:UIControlStateNormal];
    }else{
        [_selectButton setTitle:@"选课" forState:UIControlStateNormal];
        [_selectButton setBackgroundImage:[UIImage imageNamed:@"button_chosen.png"] forState:UIControlStateNormal];
    }
}

-(void)updateContentSize{
    CGRect rect = _courseShortViewContent.frame;
    UIImageView *contentImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"title.png"]];
    contentImage.frame = CGRectMake(120, _courseShortViewTitle.frame.origin.y, 8, 26) ;
    [_scrollView addSubview:contentImage];
    
    rect.size.height = [self heightForTextView:_courseShortViewContent WithText:_courseShortViewContent.text];
    
    _courseShortViewContent.frame = rect;
    //NSLog(@"%f %f",rect.origin.y,rect.size.height);
    //更新教师简介高度。
    rect.origin.y = rect.origin.y + rect.size.height ;
    rect.size.height = 40;
    rect.origin.x = 150;
    _teacherShortViewTitle.frame = rect;
    UIImageView *teacherImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"title.png"]];
    teacherImage.frame = CGRectMake(120, rect.origin.y, 8, 26);
    [_scrollView addSubview:teacherImage];
    //NSLog(@"%f %f",rect.origin.y,rect.size.height);
    rect.origin.x = 120;
    rect.origin.y = rect.origin.y + rect.size.height  ;
    rect.size.height = [self heightForTextView:_teacherShortViewContent WithText:_teacherShortViewContent.text];
    _teacherShortViewContent.frame = rect;
    //NSLog(@"%f %f",rect.origin.y,rect.size.height);
    NSLog(@"contentx %f teachery %f",_courseShortViewTitle.frame.origin.x
          ,_teacherShortViewTitle.frame.origin.x);
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)chooseButtonPressed:(id)sender{
    if(!haveSelected){
        [self popUpAView:1];
    }else{
        [self popUpAView:5];
    }
}

-(void)upChooseCourse{
    overlayView = [[MRProgressOverlayView alloc] init];
    overlayView.mode = MRProgressOverlayViewModeIndeterminate;
    [self.view addSubview:overlayView];
    [overlayView show:YES];

    //包在线程里进行。
    Dao *dao = [Dao sharedDao];
    SysbsModel *model = [SysbsModel getSysbsModel];
    User *user = model.user;
    
    int ret = [dao requestForChooseCourse:dataobj.cid userid:user.uid];
    if(ret == 1){
        //成功
        [self popUpAView:3];
    }else if(ret == -2){
        //人数超出。
        [self popUpAView:2];
    }else if(ret == -3){
        //已经选过
        [self popUpAView:4];
    }else{
        
    }
    [overlayView dismiss:YES];
}

-(void)popUpAView:(int)type{
    if(popUpView != nil)return;
    popUpView = [[UIView alloc] initWithFrame:CGRectMake(300, 260, 422, 270)];
    [self.view addSubview:popUpView];
    //[popUpView setBackgroundColor:[UIColor yellowColor]  ];
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tanchuang.png"]];
    image.frame = CGRectMake(0, 0, 422, 270);
    [popUpView addSubview:image];
    
    switch (type) {
        case 1://确认选课
            [self confirmXuanKe];
            break;
        case 2://选课失败（超出人数）
            [self failBecauseOverNum];
            break;
        case 3://选课成功 ()
            [self successfulChoosePopUp];
            break;
        case 4://选课失败（已经选过）
            [self alreadyChoose];
            break;
        case 5://退课
            [self tuikePopUp];
            break;
        default:
            break;
    }
    [self.view addSubview:popUpView];
}

-(void)confirmXuanKe{
    UILabel *popUpTitle = [[UILabel alloc]initWithFrame:CGRectMake(150, 10, 100, 40)];
    popUpTitle.text  = @"确认选课";
    [popUpView addSubview:popUpTitle];
    
    UITextView *popUpContent = [[UITextView alloc]initWithFrame:CGRectMake(20, 60, 400, 100)];
    popUpContent.text = @"确认选取这门课程么？ 选课后将不能退课如需退课请联系教务老师。\n教务总监 周军霞老师：020-84112613；18666080259";
    [popUpView addSubview:popUpContent];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(86, 160, 80, 40)];
    [button setTitle:@"我再看看" forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage imageNamed:@"button_choose.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(removePopUp) forControlEvents:UIControlEventTouchUpInside];
    [popUpView addSubview:button];
    
    UIButton *confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(196, 160, 80, 40)];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton addTarget:self  action:@selector(upChooseCourse) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"button_chosen.png"] forState:UIControlStateNormal];
    [popUpView addSubview:confirmButton];
}

-(void)alreadyChoose{
    UILabel *popUpTitle = [[UILabel alloc]initWithFrame:CGRectMake(150, 10, 100, 40)];
    popUpTitle.text  = @"选课失败";
    [popUpView addSubview:popUpTitle];
    
    UITextView *popUpContent = [[UITextView alloc]initWithFrame:CGRectMake(20, 60, 400, 100)];
    popUpContent.text = @"您已经选了这门课了，不要重复选取谢谢！";
    [popUpView addSubview:popUpContent];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(200, 160, 80, 40)];
    [button setTitle:@"我知道了" forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage imageNamed:@"button_choose.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(removePopUp) forControlEvents:UIControlEventTouchUpInside];
    [popUpView addSubview:button];

}

-(void)failBecauseOverNum{
    UILabel *popUpTitle = [[UILabel alloc]initWithFrame:CGRectMake(150, 10, 100, 40)];
    popUpTitle.text  = @"选课失败";
    [popUpView addSubview:popUpTitle];
    
    UITextView *popUpContent = [[UITextView alloc]initWithFrame:CGRectMake(20, 60, 400, 100)];
    popUpContent.text = @"很抱歉，限选人数已满。如需听课，请联系教务人员安排。\n教务总监 周军霞老师：020-84112613；18666080259";
    [popUpView addSubview:popUpContent];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(200, 160, 80, 40)];
    [button setTitle:@"我知道了" forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage imageNamed:@"button_choose.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(removePopUp) forControlEvents:UIControlEventTouchUpInside];
    [popUpView addSubview:button];

}

-(void)successfulChoosePopUp{
    UILabel *popUpTitle = [[UILabel alloc]initWithFrame:CGRectMake(150, 10, 100, 40)];
    popUpTitle.text  = @"选课成功";
    [popUpView addSubview:popUpTitle];
    
    UITextView *popUpContent = [[UITextView alloc]initWithFrame:CGRectMake(20, 60, 400, 100)];
    popUpContent.text = @"选课成功！";
    [popUpView addSubview:popUpContent];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(200, 160, 80, 40)];
    [button setTitle:@"我知道了" forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage imageNamed:@"button_choose.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(removePopUp) forControlEvents:UIControlEventTouchUpInside];
    [popUpView addSubview:button];

}


-(void)tuikePopUp{
    UILabel *popUpTitle = [[UILabel alloc]initWithFrame:CGRectMake(150, 10, 100, 40)];
    popUpTitle.text  = @"想要退课?";
    [popUpView addSubview:popUpTitle];
    
    UITextView *popUpContent = [[UITextView alloc]initWithFrame:CGRectMake(20, 60, 400, 100)];
    popUpContent.text = @"很抱歉，系统暂时不支持退课。如需退课请联系教务老师。教务总监 周军霞老师：020-84112613；18666080259";
    [popUpView addSubview:popUpContent];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(200, 160, 80, 40)];
    [button setTitle:@"我知道了" forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage imageNamed:@"button_choose.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(removePopUp) forControlEvents:UIControlEventTouchUpInside];
    [popUpView addSubview:button];

}

-(void)removePopUp{
    if (popUpView.superview != Nil){
        [popUpView removeFromSuperview];
    }
    popUpView = nil;
}

-(float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    float fPadding = 16.0; // 8.0px x 2
    CGSize constraint = CGSizeMake(textView.contentSize.width - fPadding, CGFLOAT_MAX);
    
    CGSize size = [strText sizeWithFont: textView.font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    float fHeight = size.height + 16.0;
    
    return fHeight;
}

@end
