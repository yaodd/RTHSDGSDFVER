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
#import "LoginViewController.h"

#define START_X 18
#define START_Y 24
#define MAIN_VIEW_WIDTH     988
#define MAIN_VIEW_HEIGHT    308
#define MAIN_VIEW_IMAGE_WIDTH   590
#define MAIN_VIEW_INFO_WIDTH    398
#define SPACE_OUT           26
#define SPACE_IN            13
#define COURSE_ITEM_LENGTH  238

#define HISTORY_PLIST_KEY   @"history_plist_key"
@interface MainPageViewController (){
    UILabel *infoLabel;
}

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
    [self getCatchFromFile];

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
    //妈蛋这命名。。。
    [mainImageView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"image01"]]];
    
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
    
    //[courseLabel setText:@"战略管理"];
    UIFont *font = [UIFont systemFontOfSize:36];
    [courseLabel setFont:font];
    [courseLabel setBackgroundColor:[UIColor clearColor]];
    [courseLabel setTextColor:redColor];
    [courseLabel setTextAlignment:NSTextAlignmentLeft];
    [self.courseImageView addSubview:courseLabel];
    
    teachLabel = [[UILabel alloc]initWithFrame:CGRectMake(courseImageView.frame.size.width - 41 - 200, labelTopY + 13, 200, 20)];
    
    //[teachLabel setText:@"李飞教授"];
    [teachLabel setFont:[UIFont systemFontOfSize:18]];
    [teachLabel setTextAlignment:NSTextAlignmentRight];
    [teachLabel setTextColor:redColor];
    [self.courseImageView addSubview:teachLabel];
    
    labelTopY += (40 + 19);
    classRoomLabel= [[UILabel alloc]initWithFrame:CGRectMake(labelStartX, labelTopY, 200, 20)];
        //[classRoomLabel setText:@"善衡堂M101"];
    [classRoomLabel setFont:[UIFont systemFontOfSize:18]];
    [classRoomLabel setTextColor:redColor];
    [classRoomLabel setTextAlignment:NSTextAlignmentLeft];
    [self.courseImageView addSubview:classRoomLabel];
    
    dateLabel= [[UILabel alloc]initWithFrame:CGRectMake(courseImageView.frame.size.width - 41 - 300, labelTopY, 300, 20)];
        [dateLabel setFont:[UIFont systemFontOfSize:18]];
    [dateLabel setTextAlignment:NSTextAlignmentRight];
    [dateLabel setTextColor:redColor];
    [self.courseImageView addSubview:dateLabel];
    
    labelTopY += (20 + 22);
    infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelStartX, labelTopY, courseImageView.frame.size.width - (labelStartX * 2),70)];
    //[infoLabel setText:@"速度速度速度放松放松方式方法是对方未按时大范围阿斯顿发违法斯蒂芬阿瑟发文阿斯顿发违法瑟尔"];
    [infoLabel setNumberOfLines:0];
    //......
//    [infoLabel setTextAlignment:NSTextAlignmentLeft];
    [infoLabel setBackgroundColor:[UIColor clearColor]];
    [infoLabel setTextColor:[UIColor colorWithRed:127.0/255 green:118.0/255 blue:120.0/255 alpha:1.0]];
    [infoLabel setFont:[UIFont systemFontOfSize:12]];
    [self.courseImageView addSubview:infoLabel];
    
    courseButton = [[UIButton alloc]initWithFrame:CGRectMake(labelStartX + 61, 238, 160, 54)];
    [courseButton setBackgroundImage:[UIImage imageNamed:@"button_see_all"] forState:UIControlStateNormal];
    [courseButton setTintColor:[UIColor whiteColor]];
//    SysbsModel *sysbsModel = [SysbsModel getSysbsModel];
//    MyCourse *myCourse = sysbsModel.myCourse;
    //UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpToCourseware:)];
   //妈蛋又硬编码。。。
    //NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:2],@"cid", nil];
    //[tapGesture setMyDict:dict];
    //[courseButton addGestureRecognizer:tapGesture];
    [courseButton setTitle:@"查看相关课件" forState:UIControlStateNormal];
    //[self.courseImageView addSubview:courseButton];
    
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
    NSLog(@"user id %d",user.uid);
    int myCourseRequest = [dao requestForMyCourse:user.uid];
    
    if (myCourseRequest == 1) {
        NSLog(@"myCourse success！");
        
    } else if (myCourseRequest == 0) {
        NSLog(@"网络连接失败！");
    } else if (myCourseRequest == -1){
        NSLog(@"服务器出错！");
    }
    MyCourse *myCourse = sysbsModel.myCourse;
    courseArray = [myCourse getMyCourse];
    for (int i = 0; i < [courseArray count]; i ++) {
        Course *course = [courseArray objectAtIndex:i];
        [dao requestForFileList:course.cid];
    }
    NSLog(@"mycoursenum%d",[courseArray count]);
    [self performSelectorOnMainThread:@selector(initCourse) withObject:nil waitUntilDone:YES];
//    [self performSelectorOnMainThread:@selector(downloadAll) withObject:nil waitUntilDone:YES];
    
}
- (void)downloadAll{
    DownloadModel *downloadModel = [DownloadModel getDownloadModel];
    SysbsModel *sysbsModel = [SysbsModel getSysbsModel];
    MyCourse *myCourse = sysbsModel.myCourse;
    [downloadModel setMyCourse:myCourse];

    NSUserDefaults *userDefaults  = [NSUserDefaults standardUserDefaults];
    BOOL isAutoDownload = [(NSNumber *)[userDefaults objectForKey:isAutoDownloadKey] boolValue];
    if (!isAutoDownload) {
        return;
    }
    NSLog(@"donwloadAll");
    [downloadModel downloadAll];
}

- (void)initCourse{
    int courseNumber = [courseArray count];

    NSLog(@"courseNumber %d",courseNumber);
    int rowNum = (courseNumber % 4 == 0) ? (courseNumber / 4) : (courseNumber / 4 + 1);
    [self.scrollView setContentSize:CGSizeMake(1024, START_Y + MAIN_VIEW_HEIGHT + SPACE_OUT + rowNum * (COURSE_ITEM_LENGTH + SPACE_IN))];
    //你真强。。。
    NSArray *array = [NSArray arrayWithObjects:@"lixinchun",@"lutaihong",@"maoyunshi", nil];
    UITapGestureRecognizer * singleTapGesture;
    for (int i = 0;  i < courseNumber; i ++) {
        Course *course = [courseArray objectAtIndex:i];
        //妈蛋 。。arr 你妹啊。。死数据还这样写。。。真是给跪了。。
        UIImage *image = [UIImage imageNamed:[array objectAtIndex:(i%3)]];
        //妈蛋加死数据也不是你这样加的啊我草。。
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:course.courseName,@"courseName",course.startTime,@"date",image,@"courseImage",course.teacherName,@"teachName", nil];
        
        CourseItem *courseItem = [[CourseItem alloc]initWithFrame:CGRectMake(START_X + (i % 4) * (COURSE_ITEM_LENGTH + SPACE_IN),START_Y + MAIN_VIEW_HEIGHT + SPACE_OUT + (i / 4) * (COURSE_ITEM_LENGTH + SPACE_IN), COURSE_ITEM_LENGTH, COURSE_ITEM_LENGTH) :dict];
        singleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpToCourseware:)];
        NSDictionary *myDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:course.cid],@"tag", nil];
        [singleTapGesture setMyDict:myDict];
        [courseItem addGestureRecognizer:singleTapGesture];
        [self.scrollView addSubview:courseItem];
    }
    UITapGestureRecognizer *TapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpToCourseware:)];
    if([courseArray count]>0){
        Course *course = [courseArray objectAtIndex:0];
        [TapGesture setMyDict:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:course.cid],@"tag", nil]];
        courseImageView.userInteractionEnabled = YES;
        [courseImageView addGestureRecognizer:TapGesture];
        courseButton.userInteractionEnabled = YES;
        [courseButton addGestureRecognizer:TapGesture];
    }
    NSLog(@"image frame %f %f %f %f ",courseImageView.frame.origin.x,courseImageView.frame.origin.y,courseImageView.frame.size.width,courseImageView.frame.size.height);
    NSLog(@"fucking frame %f %f %f %f ",courseButton.frame.origin.x,courseButton.frame.origin.y,courseButton.frame.size.width,courseButton.frame.size.height);
        //手贱。
    [courseImageView addSubview:courseButton];
    //[courseButton addGestureRecognizer:singleTapGesture];
    [self saveCatchToFile];
    [self downloadAll];
    
    //取出最新的课程。
    SysbsModel *model = [SysbsModel getSysbsModel];
    MyCourse *mycourse = model.myCourse;
    
    Course *course;
    if([mycourse.courseArr count] > 0)
        course = [mycourse.courseArr objectAtIndex:0];
    if([course.startTime length] >= 10 && [course.endTime length]>=10){
        NSString *startdate = [course.startTime substringWithRange:NSMakeRange(5, 5)];
        NSString *enddate = [course.endTime substringWithRange:NSMakeRange(5, 5)];
        NSString *showdate = [NSString stringWithFormat:@"%@到%@",startdate,enddate];
        [dateLabel setText:showdate];
    }
    [infoLabel setText:course.courseDescription];
    [courseLabel setText:course.courseName];
    [classRoomLabel setText:course.location];
    [courseButton addTarget:self action:@selector(jumpToCourseware:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)jumpToNewestCourseware:(id)sender{
    NSLog(@"妈蛋");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//跳转到课件页面
- (void)jumpToCourseware:(id)sender
{
    
    NSLog(@"tiaozhuandaokejian");
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *)sender;
    NSDictionary *myDict = gesture.myDict;
    int index = [(NSNumber *)[myDict objectForKey:@"tag"] integerValue];
    
    CoursewareViewController *coursewareViewController = [[CoursewareViewController alloc]init];
    coursewareViewController.courseFolderName = [NSString stringWithFormat:@"%d",index];
    [self.navigationController pushViewController:coursewareViewController animated:YES];
}
//保存历史信息到本地
- (void)saveCatchToFile{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    //    NSString *filePath = [self.noteDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",document.pageNumber]];
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",HISTORY_PLIST_KEY]];
    SysbsModel *sysbsModel = [SysbsModel getSysbsModel];
    User *user = sysbsModel.user;
    
    NSDictionary *userDict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:user.uid],@"uid",user.username,@"userName",user.company,@"company",user.rank,@"rank",user.headImg,@"handImg",user.cellNum,@"cellNum", nil];
//    NSMutableDictionary *userDict = [[NSMutableDictionary alloc]init];
//    [userDict setObject:[NSNumber numberWithInt:user.uid] forKey:@"uid"];
//    [userDict setObject:user.username forKey:@"userName"];
//    [userDict setObject:user.company forKey:@"company"];
//    [userDict setObject:user.rank forKey:@"rank"];
//    [userDict setObject:user.headImg forKey:@"headImg"];
//    [userDict setObject:user.cellNum forKey:@"cellNum"];
    
    
    NSMutableArray *courseArr = [[NSMutableArray alloc]init];
    MyCourse *myCourse = sysbsModel.myCourse;
    NSMutableArray *courseArrTemp = [myCourse courseArr];
    for (int i = 0 ; i < courseArrTemp.count; i ++) {
        Course *course = [courseArrTemp objectAtIndex:i];
        
        NSMutableArray *fileArr = [[NSMutableArray alloc]init];
        for (int k = 0; k < course.fileArr.count; k ++) {
            File *file = [course.fileArr objectAtIndex:k];
//            NSLog(@"i %d cid %d",i,[file cid]);
            NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:file.cid],@"cid",file.fileName,@"fileName",file.filePath,@"filePath",file.date,@"date", nil];
//            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
//            [dict setObject:[NSNumber numberWithInt:file.cid] forKey:@"cid"];
//            [dict setObject:file.fileName forKey:@"fileName"];
//            [dict setObject:file.filePath forKey:@"filePath"];
//            [dict setObject:file.date forKey:@"date"];
            [fileArr addObject:dict];
        }
        
        NSMutableArray *bookArr = [[NSMutableArray alloc]init];
        for (int k = 0; k < course.recommendBook.count; k ++) {
            RecommendBook *book = [course.recommendBook objectAtIndex:k];
            NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:book.bookName,@"bookName",book.author,@"author",book.publisher,@"publisher",book.description,@"description", nil];
//            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
//            [dict setObject:book.bookName forKey:@"bookName"];
//            [dict setObject:book.author forKey:@"author"];
//            [dict setObject:book.publisher forKey:@"publisher"];
//            [dict setObject:book.description forKey:@"description"];
            [bookArr addObject:dict];
        }
        
        
        NSDictionary *courseDict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:course.cid],@"cid",course.courseName,@"courseName",fileArr,@"fileArr",bookArr,@"bookArr",course.timeArr,@"timeArr",course.courseDescription,@"courseDescription",course.teacherName,@"teacherName", nil];
//        NSMutableDictionary *courseDict = [[NSMutableDictionary alloc]init];
//        [courseDict setObject:[NSNumber numberWithInt:course.cid] forKey:@"cid"];
//        [courseDict setObject:course.courseName forKey:@"courseName"];
//        [courseDict setObject:fileArr forKey:@"fileArr"];
//        [courseDict setObject:bookArr forKey:@"bookArr"];
//        [courseDict setObject:course.timeArr forKey:@"timeArr"];
//        [courseDict setObject:course.description forKey:@"courseDescription"];
//        [courseDict setObject:course.teacherName forKey:@"teacherName"];
        [courseArr addObject:courseDict];
    }
    NSDictionary *myCourseDict = [[NSDictionary alloc]initWithObjectsAndKeys:courseArr,@"courseArr", nil];
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:userDict,@"user",myCourseDict,@"myCourse", nil];
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
//    [dict setObject:userDict forKey:@"user"];
//    [dict setObject:myCourseDict forKey:@"myCourse"];
    
    NSFileManager* fm = [NSFileManager defaultManager];
    [fm createFileAtPath:filePath contents:nil attributes:nil];
    [dict writeToFile:filePath atomically:YES];
    NSLog(@"%@",filePath);
}
//从本地获取历史信息
- (void)getCatchFromFile{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    //    NSString *filePath = [self.noteDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",document.pageNumber]];
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",HISTORY_PLIST_KEY]];
    
    SysbsModel *sysbsModel = [SysbsModel getSysbsModel];
    
    NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSLog(@"out");
    if (dict == nil) {
        NSLog(@"in");
        return;
    }
    NSLog(@"dictInfo %@",dict);
    NSDictionary *userDict = [dict objectForKey:@"user"];
//    User *user = sysbsModel.user;
        User *user = [[User alloc]init];
//    if (user.uid == 0) {
       /* user.username = [userDict objectForKey:@"userName"];
        user.uid = [(NSNumber *)[userDict objectForKey:@"uid"] intValue];
        user.company = [userDict objectForKey:@"company"];
        user.rank = [userDict objectForKey:@"rank"];
        user.headImg = [userDict objectForKey:@"headImg"];
//    }
    sysbsModel.user = user;*/
    //NSLog(@"user %@ %d %@",sysbsModel.user.username,sysbsModel.user.uid,sysbsModel.user.company);
    NSDictionary *myCourseDict = [dict objectForKey:@"myCourse"];
    NSMutableArray *courseArrTemp = [myCourseDict objectForKey:@"courseArr"];
    NSMutableArray *courseArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < courseArrTemp.count; i ++) {
        Course *course = [[Course alloc]init];
        NSDictionary *courseDict = [courseArrTemp objectAtIndex:i];
        course.courseName = [courseDict objectForKey:@"courseName"];
        course.courseDescription = [courseDict objectForKey:@"courseDescription"];
        course.cid = [(NSNumber *)[courseDict objectForKey:@"cid"] intValue];
        NSMutableArray *fileArrTemp = [courseDict objectForKey:@"fileArr"];
        NSMutableArray *fileArr = [[NSMutableArray alloc]init];
        for (int k = 0; k < fileArrTemp.count;  k ++) {
            File *file = [[File alloc]init];
            NSDictionary *fileDict = [fileArrTemp objectAtIndex:k];
            file.filePath = [fileDict objectForKey:@"filePath"];
            file.fileName = [fileDict objectForKey:@"fileName"];
            file.cid = [(NSNumber *)[fileDict objectForKey:@"cid"] intValue];
            file.date = [fileDict objectForKey:@"date"];
            [fileArr addObject:file];
        }
        NSMutableArray *bookArrTemp = [courseDict objectForKey:@"bookArr"];
        NSMutableArray *bookArr = [[NSMutableArray alloc]init];
        for (int k = 0; k <  bookArrTemp.count; k ++) {
            RecommendBook *book = [[RecommendBook alloc]init];
            NSDictionary *bookDict = [bookArrTemp objectAtIndex:k];
            book.bookName = [bookDict objectForKey:@"bookName"];
            book.description = [bookDict objectForKey:@"description"];
            book.author = [bookDict objectForKey:@"author"];
            book.publisher = [bookDict objectForKey:@"publisher"];
            [bookArr addObject:book];
        }
        NSMutableArray *timeArr = [courseDict objectForKey:@"timeArr"];
        course.timeArr = timeArr;
        course.fileArr = fileArr;
        course.recommendBook = bookArr;
        [courseArr addObject:course];
    }
    MyCourse *myCourse = [[MyCourse alloc]init];
    [myCourse setCourses:courseArr];
    sysbsModel.myCourse = myCourse;
    //NSLog(@"getCatch %d %d %d",[courseArr count],[myCourse.courseArr count],[[sysbsModel.myCourse courseArr] count]);
    SysbsModel *model = [SysbsModel getSysbsModel];
    NSLog(@"userid!%d",model.user.uid);
}


@end
