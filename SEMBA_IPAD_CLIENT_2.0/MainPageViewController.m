//
//  MainPageViewController.m
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by yaodd on 13-10-28.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "MainPageViewController.h"
#import "SearchViewController.h"
#import "CourseItem.h"
#import "UITapGestureRecognizer+category.h"
#import "CoursewareViewController.h"
#import "Dao.h"
#import "MyCourse.h"
#import "Course.h"
#import "SysbsModel.h"
#import "User.h"
#import "DownloadModel.h"

#define START_X 18
#define START_Y 24
#define MAIN_VIEW_WIDTH     988
#define MAIN_VIEW_HEIGHT    308
#define MAIN_VIEW_IMAGE_WIDTH   590
#define MAIN_VIEW_INFO_WIDTH    398
#define SPACE_OUT           26
#define SPACE_IN            13
#define COURSE_ITEM_LENGTH  238
@interface MainPageViewController ()

@end

@implementation MainPageViewController
@synthesize scrollView;
@synthesize mainImageView;
@synthesize courseImageView;
@synthesize courseLabel;
@synthesize classRoomLabel;
@synthesize teachLabel;
@synthesize dateLabel;
@synthesize courseButton;
@synthesize courseArray;

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
    [self.view setBackgroundColor:[UIColor colorWithRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:1.0]];
    courseArray = [[NSArray alloc]init];
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(loadDataSelector:) object:nil];
    [thread start];
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar_bg"] forBarMetrics:UIBarMetricsDefault];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    [titleLabel setFont:[UIFont systemFontOfSize:19]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor redColor]];
    [titleLabel setText:@"课程"];
    self.navigationItem.titleView = titleLabel;

    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStyleBordered target:self action:@selector(searchButtonAction:)];
    self.navigationItem.rightBarButtonItem = searchButton;
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768 - 64)];
    [scrollView setBackgroundColor:[UIColor clearColor]];//课程页背景
    
    [self.view addSubview:scrollView];
    
    UIView *mainView = [[UIView alloc]initWithFrame:CGRectMake(START_X, START_Y, MAIN_VIEW_WIDTH, MAIN_VIEW_HEIGHT)];
    [mainView setBackgroundColor:[UIColor clearColor]];
    [mainView.layer setCornerRadius:20.0f];
    
    [self.scrollView addSubview:mainView];
    
    mainImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MAIN_VIEW_IMAGE_WIDTH, MAIN_VIEW_HEIGHT)];
    [mainImageView setBackgroundColor:[UIColor yellowColor]];
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:mainImageView.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerTopLeft) cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc]init];
    maskLayer1.frame = mainImageView.bounds;
    maskLayer1.path = maskPath1.CGPath;
    mainImageView.layer.mask = maskLayer1;
    [mainView addSubview:mainImageView];
    
    courseImageView = [[UIImageView alloc]initWithFrame:CGRectMake(MAIN_VIEW_IMAGE_WIDTH, 0, MAIN_VIEW_INFO_WIDTH, MAIN_VIEW_HEIGHT)];
    [courseImageView setBackgroundColor:[UIColor colorWithRed:254.0/255 green:254.0/255 blue:254.0/255 alpha:1.0]];
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:courseImageView.bounds byRoundingCorners:(UIRectCornerBottomRight | UIRectCornerTopRight) cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc]init];
    maskLayer2.frame = courseImageView.bounds;
    maskLayer2.path = maskPath2.CGPath;
    courseImageView.layer.mask = maskLayer2;
    [mainView addSubview:courseImageView];
    
    CGFloat labelStartX = 41.0f;
    CGFloat labelTopY   = 71.0f;
    
    
    courseLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelStartX, labelTopY, 200, 40)];
    UIColor *redColor = [UIColor colorWithRed:198.0/255 green:56.0/255 blue:91.0/255 alpha:1.0];
    [courseLabel setText:@"战略管理"];
    UIFont *font = [UIFont systemFontOfSize:36];
    [courseLabel setFont:font];
    [courseLabel setBackgroundColor:[UIColor clearColor]];
    [courseLabel setTextColor:redColor];
    [courseLabel setTextAlignment:NSTextAlignmentLeft];
    [self.courseImageView addSubview:courseLabel];
    
    teachLabel = [[UILabel alloc]initWithFrame:CGRectMake(courseImageView.frame.size.width - 41 - 200, labelTopY + 13, 200, 20)];
    [teachLabel setText:@"李飞教授"];
    [teachLabel setFont:[UIFont systemFontOfSize:18]];
    [teachLabel setTextAlignment:NSTextAlignmentRight];
    [teachLabel setTextColor:redColor];
    [self.courseImageView addSubview:teachLabel];
    
    labelTopY += (40 + 19);
    classRoomLabel= [[UILabel alloc]initWithFrame:CGRectMake(labelStartX, labelTopY, 200, 20)];
    [classRoomLabel setText:@"善衡堂M101"];
    [classRoomLabel setFont:[UIFont systemFontOfSize:18]];
    [classRoomLabel setTextColor:redColor];
    [classRoomLabel setTextAlignment:NSTextAlignmentLeft];
    [self.courseImageView addSubview:classRoomLabel];
    
    dateLabel= [[UILabel alloc]initWithFrame:CGRectMake(courseImageView.frame.size.width - 41 - 300, labelTopY, 300, 20)];
    [dateLabel setText:@"9月1日----10月1日"];
    [dateLabel setFont:[UIFont systemFontOfSize:18]];
    [dateLabel setTextAlignment:NSTextAlignmentRight];
    [dateLabel setTextColor:redColor];
    [self.courseImageView addSubview:dateLabel];
    
    labelTopY += (20 + 22);
    UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelStartX, labelTopY, courseImageView.frame.size.width - (labelStartX * 2),70)];
    [infoLabel setText:@"速度速度速度放松放松方式方法是对方未按时大范围阿斯顿发违法斯蒂芬阿瑟发文阿斯顿发违法瑟尔"];
    [infoLabel setNumberOfLines:0];
//    [infoLabel setTextAlignment:NSTextAlignmentLeft];
    [infoLabel setBackgroundColor:[UIColor clearColor]];
    [infoLabel setTextColor:[UIColor colorWithRed:127.0/255 green:118.0/255 blue:120.0/255 alpha:1.0]];
    [infoLabel setFont:[UIFont systemFontOfSize:12]];
    [self.courseImageView addSubview:infoLabel];
    
    courseButton = [[UIButton alloc]initWithFrame:CGRectMake(labelStartX + 61, 238, 160, 54)];
    [courseButton setBackgroundImage:[UIImage imageNamed:@"button_see_all"] forState:UIControlStateNormal];
    [courseButton setTintColor:[UIColor whiteColor]];
    [courseButton setTitle:@"查看相关课件" forState:UIControlStateNormal];
    [self.courseImageView addSubview:courseButton];
    
	// Do any additional setup after loading the view.
}

- (void)searchButtonAction:(UIBarButtonItem *)button{
    SearchViewController *searchViewController = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchViewController animated:YES];
}

- (void)loadDataSelector:(NSThread *)thread{
    Dao *dao = [Dao sharedDao];
    SysbsModel *sysbsModel = [SysbsModel getSysbsModel];
    User *user = sysbsModel.user;
    int myCourseRequest = [dao requestForMyCourse:user.uid];
    
    if (myCourseRequest == 1) {
        NSLog(@"myCourse success！");
        MyCourse *myCourse = sysbsModel.myCourse;
        courseArray = [myCourse getMyCourse];
        [self performSelectorOnMainThread:@selector(initCourse) withObject:nil waitUntilDone:YES];
        for (int i = 0; i < [courseArray count]; i ++) {
            Course *course = [courseArray objectAtIndex:i];
            [dao requestForFileList:course.cid];
        }
    } else if (myCourseRequest == 0) {
        NSLog(@"网络连接失败！");
    } else if (myCourseRequest == -1){
        NSLog(@"服务器出错！");
    }
    [self performSelectorOnMainThread:@selector(downloadAll) withObject:nil waitUntilDone:YES];
    
}
- (void)downloadAll{
    NSLog(@"donwloadAll");
    DownloadModel *downloadModel = [DownloadModel getDownloadModel];
    SysbsModel *sysbsModel = [SysbsModel getSysbsModel];
    MyCourse *myCourse = sysbsModel.myCourse;
    [downloadModel setMyCourse:myCourse];
    [downloadModel downloadAll];
}

- (void)initCourse{
    int courseNumber = [courseArray count];

    int rowNum = (courseNumber % 4 == 0) ? (courseNumber / 4) : (courseNumber / 4 + 1);
    [self.scrollView setContentSize:CGSizeMake(1024, START_Y + MAIN_VIEW_HEIGHT + SPACE_OUT + rowNum * (COURSE_ITEM_LENGTH + SPACE_IN))];
    for (int i = 0;  i < courseNumber; i ++) {
        Course *course = [courseArray objectAtIndex:i];
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:course.courseName,@"courseName",course.teacherName,@"teachName",@"2013/11/11",@"date", nil];
        CourseItem *courseItem = [[CourseItem alloc]initWithFrame:CGRectMake(START_X + (i % 4) * (COURSE_ITEM_LENGTH + SPACE_IN),START_Y + MAIN_VIEW_HEIGHT + SPACE_OUT + (i / 4) * (COURSE_ITEM_LENGTH + SPACE_IN), COURSE_ITEM_LENGTH, COURSE_ITEM_LENGTH) :dict];
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpToCourseware:)];
        NSDictionary *myDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:course.cid],@"tag", nil];
        [singleTapGesture setMyDict:myDict];
        [courseItem addGestureRecognizer:singleTapGesture];
        [self.scrollView addSubview:courseItem];
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//跳转到课件页面
- (void)jumpToCourseware:(id)sender
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *)sender;
    NSDictionary *myDict = gesture.myDict;
    int index = [(NSNumber *)[myDict objectForKey:@"tag"] integerValue];
    
    CoursewareViewController *coursewareViewController = [[CoursewareViewController alloc]init];
    coursewareViewController.courseFolderName = [NSString stringWithFormat:@"%d",index];
    [self.navigationController pushViewController:coursewareViewController animated:YES];
}

- (void)menuAction:(id)sender
{
    
}

@end
