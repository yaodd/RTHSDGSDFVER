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
#import "WebImgResourceContainer.h"
#import "ChoosePopView.h"

@interface CourseDetailViewController (){
    BOOL haveSelected;
    ChoosePopView *popUpView;
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
@synthesize requestImageQuque = _requestImageQuque;
@synthesize originalIndexArray = _originalIndexArray;
@synthesize originalOperationDic = _originalOperationDic;


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
    
    //底色
    [self.view setBackgroundColor:[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0]];
    
    //导航栏红色底线
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:199/255.0 green:56/255.0 blue:91/255.0 alpha:1.0];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar_bg"] forBarMetrics:UIBarMetricsDefault];
    
    self.title = @"课程详情";
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    [titleLabel setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:20.0]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor colorWithRed:199/255.0 green:56/255.0 blue:91/255.0 alpha:1.0]];
    [titleLabel setText:@"课程详情"];
    self.navigationItem.titleView = titleLabel;
    
    imageArray = [NSArray arrayWithObjects:@"lixinchun",@"lutaihong",@"maoyunshi", nil];
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    
    NSOperationQueue *tempQueue = [[NSOperationQueue alloc]init];
    _requestImageQuque = tempQueue;
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    self.originalIndexArray = array;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    self.originalOperationDic = dict;

    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 1024, 700)];
    _scrollView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_scrollView];
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(210, 28, 400, 60)];
    _titleLabel.text = @"测试课程标题";
    _titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:24.0];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor colorWithRed:199/255.0 green:56/255.0 blue:91/255.0 alpha:1.0];
    [_scrollView addSubview:_titleLabel];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(230, 78, 400, 20)];
    _nameLabel.text = @"授课老师:测试账号";
    _nameLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16.0];
    _nameLabel.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_nameLabel];
    
    _dateLabel = [[UILabel alloc]    initWithFrame:CGRectMake(230, 106, 400, 20)];
    _dateLabel.text = @"上课时间：测试时间";
    _dateLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16.0];
    _dateLabel.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_dateLabel];
    
    _peopleNumLabel = [[ UILabel alloc]  initWithFrame:CGRectMake(210, 138, 400, 60)];
    _peopleNumLabel.text = @"已选x人/限选y人";
    _peopleNumLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20.0];
    _peopleNumLabel.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_peopleNumLabel];
    
    //_imageView = []
    _selectButton = [[UIButton alloc] initWithFrame:CGRectMake(678, 76, 96, 38)];
    UIImage *buttonbg = [UIImage imageNamed:@"button_choose.png"];
    [_selectButton setBackgroundImage:buttonbg forState:UIControlStateNormal];
    [_selectButton setTitle:@"选课" forState:UIControlStateNormal];
    [_scrollView addSubview:_selectButton];
    
    _courseShortViewTitle = [[UILabel alloc]initWithFrame:CGRectMake(140, 200, 400, 26)];
    _courseShortViewTitle.text = @"课程简介";
    _courseShortViewTitle.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20.0];
    _courseShortViewTitle.textColor = [UIColor colorWithRed:199/255.0 green:56/255.0 blue:91/255.0 alpha:1.0];
    _courseShortViewTitle.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_courseShortViewTitle];
    
    _courseShortViewContent = [[UITextView alloc]initWithFrame:CGRectMake(120, 230, 720, 200)];
    _courseShortViewContent.text =@"测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容测试简介内容";
    _courseShortViewContent.userInteractionEnabled = NO;
    _courseShortViewContent.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14.0];
    _courseShortViewContent.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_courseShortViewContent];
    
    _teacherShortViewTitle = [[UILabel alloc]initWithFrame:
                              CGRectMake(140,
                                         _courseShortViewContent.frame.origin.y + _courseShortViewContent.frame.
                                         size.height + 20, 400, 26)];
    _teacherShortViewTitle.text = @"教师简介";
    _teacherShortViewTitle.font = [UIFont fontWithName:@"Heiti SC" size:20.0];
    _teacherShortViewTitle.textColor = [UIColor colorWithRed:199/255.0 green:56/255.0 blue:91/255.0 alpha:1.0];
    _teacherShortViewTitle.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_teacherShortViewTitle];
    
    _teacherShortViewContent = [[UITextView alloc]initWithFrame:CGRectMake(120, _teacherShortViewTitle.frame.origin.y + _teacherShortViewTitle.frame.size.height + 40, 720, 400)];
    _teacherShortViewContent.text = @"测试教师简介";
    _teacherShortViewContent.userInteractionEnabled = NO;
    _teacherShortViewContent.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14.0];
    _teacherShortViewContent.backgroundColor = [UIColor clearColor];
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
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 40, 120, 134)];
    [_scrollView addSubview:_imageView];
    //_imageView.image = [UIImage imageNamed:[imageArray objectAtIndex:index% 3]];
    
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.cornerRadius = 20;
    _imageView.image = [UIImage imageNamed:@"fengmian"];

    [self displayProductImage];
}

-(void)updateContent{
    _titleLabel.text = dataobj.courseTitle;
    
    //已选人数
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已选%d人/限选%d人",dataobj.nowChooseNum ,dataobj.maxChooseNum]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:199/255.0 green:56/255.0 blue:91/255.0 alpha:1.0] range:NSMakeRange(2, 1)];
    _peopleNumLabel.attributedText= str;
    
    NSString *teacher = [[NSString alloc] init];
    NSArray *tArr = (NSArray *)dataobj.teacherArr;
    int tlen = (int)[tArr count];
    NSLog(@"teacherLen-%d", tlen);
    if(tlen > 0){
        for(int i = 0; i < tlen; ++i){
            teacher = [teacher stringByAppendingString:[tArr objectAtIndex:i]];
        }
    }else {
        teacher = @"";
    }
    _nameLabel.text = teacher;
    
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
    UIImageView *contentImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"title"]];
    contentImage.frame = CGRectMake(120, _courseShortViewTitle.frame.origin.y, 8, 26) ;
    [_scrollView addSubview:contentImage];
    
    rect.size.height = [self heightForTextView:_courseShortViewContent WithText:_courseShortViewContent.text]+7;
    
    _courseShortViewContent.frame = rect;
    //NSLog(@"%f %f",rect.origin.y,rect.size.height);
    //更新教师简介高度。
    rect.origin.y = rect.origin.y + rect.size.height + 20;
    rect.size.height = 26;
    rect.origin.x = 140;
    _teacherShortViewTitle.frame = rect;
    UIImageView *teacherImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"title"]];
    teacherImage.frame = CGRectMake(120, rect.origin.y, 8, 26);
    [_scrollView addSubview:teacherImage];
    //NSLog(@"%f %f",rect.origin.y,rect.size.height);
    rect.origin.x = 120;
    rect.origin.y = rect.origin.y + 30 ;
    rect.size.height = [self heightForTextView:_teacherShortViewContent WithText:_teacherShortViewContent.text];
    _teacherShortViewContent.frame = rect;
    //NSLog(@"%f %f",rect.origin.y,rect.size.height);
    NSLog(@"contentx %f teachery %f",_courseShortViewTitle.frame.origin.x
          ,_teacherShortViewTitle.frame.origin.x);

    //更新Scrollview的高度
    rect = _scrollView.frame;
    CGRect courseShortTitleRect = _courseShortViewTitle.frame;
    rect.size.height = courseShortTitleRect.origin.y + 2 * courseShortTitleRect.size.height +
                       _courseShortViewContent.frame.size.height + _teacherShortViewContent.frame.size.height+40;
    _scrollView.contentSize = rect.size;
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
    popUpView = [[ChoosePopView alloc] initWithFrame:CGRectMake(300, 200, 402, 270)];
    [self.view addSubview:popUpView];
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tanchuang.png"]];
    image.frame = CGRectMake(0, 0, 402, 270);
    //[popUpView addSubview:image];
    
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
    UILabel *popUpTitle = [[UILabel alloc]initWithFrame:CGRectMake(150, 6, 100, 40)];
    popUpTitle.text  = @"确认选课";
    popUpTitle.textColor = [UIColor whiteColor];
    popUpTitle.backgroundColor = [UIColor clearColor];
    [popUpView addSubview:popUpTitle];
    
    UITextView *popUpContent = [[UITextView alloc]initWithFrame:CGRectMake(20, 60, 370, 100)];
    popUpContent.text = @"确认选取这门课程么？ 选课后将不能退课如需退课请联系教务老师。\n教务总监 周军霞老师：020-84112613；18666080259";
    popUpContent.font = [UIFont fontWithName:@"Heiti SC" size:15.0];
    popUpContent.backgroundColor = [UIColor clearColor];
    [popUpView addSubview:popUpContent];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(popUpView.frame.size.width/2 - 40, 160, 80, 40)];
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
    UILabel *popUpTitle = [[UILabel alloc]initWithFrame:CGRectMake(150, 6, 100, 40)];
    popUpTitle.text  = @"选课失败";
    popUpTitle.textColor = [UIColor whiteColor];
    popUpTitle.backgroundColor = [UIColor clearColor];
    [popUpView addSubview:popUpTitle];
    
    UITextView *popUpContent = [[UITextView alloc]initWithFrame:CGRectMake(20, 60, 370, 100)];
    popUpContent.text = @"您已经选了这门课了，不要重复选取谢谢！";
    popUpContent.font = [UIFont fontWithName:@"Heiti SC" size:15.0];
    popUpContent.backgroundColor = [UIColor clearColor];
    [popUpView addSubview:popUpContent];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(popUpView.frame.size.width/2 - 40, 160, 80, 40)];
    [button setTitle:@"我知道了" forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage imageNamed:@"button_choose.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(removePopUp) forControlEvents:UIControlEventTouchUpInside];
    [popUpView addSubview:button];

}

-(void)failBecauseOverNum{
    UILabel *popUpTitle = [[UILabel alloc]initWithFrame:CGRectMake(150, 6, 100, 40)];
    popUpTitle.text  = @"选课失败";
    popUpTitle.textColor = [UIColor whiteColor];
    popUpTitle.backgroundColor = [UIColor clearColor];
    [popUpView addSubview:popUpTitle];
    
    UITextView *popUpContent = [[UITextView alloc]initWithFrame:CGRectMake(20, 60, 370, 100)];
    popUpContent.text = @"很抱歉，限选人数已满。如需听课，请联系教务人员安排。\n教务总监 周军霞老师：020-84112613；18666080259";
    popUpContent.font = [UIFont fontWithName:@"Heiti SC" size:15.0];
    popUpContent.backgroundColor = [UIColor clearColor];
    [popUpView addSubview:popUpContent];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(popUpView.frame.size.width/2 - 40, 160, 80, 40)];
    [button setTitle:@"我知道了" forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage imageNamed:@"button_choose.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(removePopUp) forControlEvents:UIControlEventTouchUpInside];
    [popUpView addSubview:button];

}

-(void)successfulChoosePopUp{
    UILabel *popUpTitle = [[UILabel alloc]initWithFrame:CGRectMake(150, 6, 100, 40)];
    popUpTitle.text  = @"选课成功";
    popUpTitle.textColor = [UIColor whiteColor];
    popUpTitle.backgroundColor = [UIColor clearColor];
    [popUpView addSubview:popUpTitle];
    
    UITextView *popUpContent = [[UITextView alloc]initWithFrame:CGRectMake(20, 60, 370, 100)];
    popUpContent.text = @"选课成功！";
    popUpContent.font = [UIFont fontWithName:@"Heiti SC" size:15.0];
    popUpContent.backgroundColor = [UIColor clearColor];
    [popUpView addSubview:popUpContent];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(popUpView.frame.size.width/2 - 40, 160, 80, 40)];
    [button setTitle:@"我知道了" forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage imageNamed:@"button_choose.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(removePopUp) forControlEvents:UIControlEventTouchUpInside];
    [popUpView addSubview:button];

}


-(void)tuikePopUp{
    UILabel *popUpTitle = [[UILabel alloc]initWithFrame:CGRectMake(150, 6, 100, 40)];
    popUpTitle.text  = @"想要退课?";
    popUpTitle.textColor = [UIColor whiteColor];
    popUpTitle.backgroundColor = [UIColor clearColor];
    [popUpView addSubview:popUpTitle];
    
    UITextView *popUpContent = [[UITextView alloc]initWithFrame:CGRectMake(20, 60, 370, 100)];
    popUpContent.text = @"很抱歉，系统暂时不支持退课。如需退课请联系教务老师。教务总监 周军霞老师：020-84112613；18666080259";
    popUpContent.font = [UIFont fontWithName:@"Heiti SC" size:15.0];
    popUpContent.backgroundColor = [UIColor clearColor];
    [popUpView addSubview:popUpContent];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(popUpView.frame.size.width/2 - 40, 190, 80, 40)];
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

-(void)displayProductImage{
    //设置根ip地址
    NSLog(@"displayproduct");
    NSURL *url = [NSURL URLWithString:@"http://115.28.18.130/SEMBADEVELOP/img/head/"];
    int imageCount = 1;
    for (int i = 0 ; i < imageCount ; ++i) {
        
        if ([dataobj.coverUrl isEqualToString:@""] == NO){
            //获取网络图片。
            NSLog(@"from internet");
            NSURL *url = [NSURL URLWithString:dataobj.coverUrl];
            NSLog(@"%@",dataobj.coverUrl);
            [self displayImageByIndex:i ByImageURL:url];
        }else{
            //上默认图片
            continue;
            NSLog(@"默认图片");
        }
    }
}

-(void)displayImageByIndex:(NSInteger)index ByImageURL:(NSURL*)url{
    NSString *indexForString =[NSString stringWithFormat:@"%d",index];
    if([self.originalIndexArray containsObject:indexForString]){
        return;
    }
    
    UIImageView *imageView  = self.imageView;//=
    WebImgResourceContainer *imageOperation = [[WebImgResourceContainer alloc]init];
    
    imageOperation.resourceURL = url;
    imageOperation.hostObject = self;
    
    imageOperation.resourceDidReceive = @selector(imageDidReceive:);
    imageOperation.imageView = imageView;
    
    [_requestImageQuque addOperation:imageOperation];
    [self.originalOperationDic setObject:imageOperation forKey:indexForString];
}

-(void)imageDidReceive:(UIImageView*)imageView{
    if(imageView== nil || imageView.image ==nil){
        //
        return ;
    }
    NSLog(@"create new image");
    //imageView.frame = CGRectMake(0, 0, 300, 300);
    //[self.view addSubview:imageView];
    
}


@end
