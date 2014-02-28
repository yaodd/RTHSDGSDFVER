//
//  MenuController.m
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by 欧 展飞 on 13-10-29.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "MenuController.h"
#import "AppDelegate.h"
#import "EvaluateController.h"
#import "ScheduleController.h"
#import "MainPageViewController.h"
#import "NoticeController.h"
#import "RegisterController.h"
#import "RegisterContentController.h"
#import "CourseDetailViewController.h"
#import "CourseLIstViewController.h"
#import "Dao.h"
#import "SysbsModel.h"
#import "WebImgResourceContainer.h"

#define menuWidth 238


@interface MenuController ()
{
    NSMutableArray *titleArray;
    int currentRow;
}

@end

@implementation MenuController
@synthesize headImg;
@synthesize list;
@synthesize registerBtn;
@synthesize helpBtn;
@synthesize nameLabel;
@synthesize settingBtn;
@synthesize registerLabel;
@synthesize backgroundImg;
@synthesize hostController;
@synthesize noticeView;
@synthesize blurView;
@synthesize setupView;
@synthesize noticeController;
@synthesize registerView;
@synthesize requestImageQuque = _requestImageQuque;
@synthesize originalIndexArray = _originalIndexArray;
@synthesize originalOperationDic = _originalOperationDic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        titleArray = [[NSMutableArray alloc] initWithObjects:@"课程中心", @"课件", @"评教", @"课程表",@"选课", @"通知中心", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    hostController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).hostController;
    hostController.delegate = self;
    
    NSOperationQueue *tempQueue = [[NSOperationQueue alloc]init];
    _requestImageQuque = tempQueue;
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    self.originalIndexArray = array;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    self.originalOperationDic = dict;

    //NSLog(@"MenuView did load");
    currentRow = 0;
    
    float originY = 20;
    
    //Background Color
    [self.view setBackgroundColor:[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0]];
    
    //Background Image
    CGRect backgroundFrame = CGRectMake(0, originY, menuWidth+5, 748);
    backgroundImg = [[UIImageView alloc] init];
    backgroundImg.frame = backgroundFrame;
    [backgroundImg setImage:[UIImage imageNamed:@"background_drawer"]];
    [self.view addSubview:backgroundImg];
    
    //headImg
    CGRect headFrame = CGRectMake(53.5, 50, 134, 144);
    headImg = [[UIImageView alloc] init];
    headImg.frame = headFrame;
    headImg.backgroundColor = [UIColor blackColor];
    [headImg setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"news center-circle on the menu"]]];
    headImg.layer.masksToBounds = YES;
    headImg.layer.cornerRadius = 10;
    
    [self.view addSubview:headImg];
    SysbsModel *model = [SysbsModel getSysbsModel];
    //UserNameLabel
    CGRect nameFrame = CGRectMake(0, 210, menuWidth, 35);
    nameLabel = [[UILabel alloc] init];
    nameLabel.frame = nameFrame;
    nameLabel.text = model.user.username;
    //nameLabel.text = @"李开花";
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont fontWithName:@"Heiti SC" size:24.0f];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nameLabel];
    
    //Menu TableView
    CGRect listFrame = CGRectMake(0, 255, menuWidth, 252);
    list = [[UITableView alloc] init];
    list.frame = listFrame;
    [list setSectionIndexColor:[UIColor clearColor]];
    [list setSeparatorColor:[UIColor clearColor]];
    list.backgroundColor = [UIColor clearColor];
    list.delegate = self;
    list.dataSource = self;
    
    [list setScrollEnabled:NO];
    [self.view addSubview:list];
    
    /*签到的按钮作废
    //RegisterButton
    CGRect registerFrame = CGRectMake(54, listFrame.origin.y + listFrame.size.height + 63.5, 104, 96);
    registerBtn = [[UIButton alloc] init];
    registerBtn.frame = registerFrame;
    registerBtn.backgroundColor = [UIColor clearColor];
    [registerBtn addTarget:self action:@selector(showRegisterView) forControlEvents:UIControlEventTouchUpInside];
    [registerBtn setImage:[UIImage imageNamed:@"news center-sign"] forState:UIControlStateNormal];
    [self.view addSubview:registerBtn];
    */
    
    //RegisterLabel
    /*签到的label作废
    CGRect registerLabelFrame = CGRectMake(0, registerFrame.origin.y + registerFrame.size.height + 10, menuWidth-20, 40);
    registerLabel = [[UILabel alloc] init];
    registerLabel.frame = registerLabelFrame;
    registerLabel.text = @"签到";
    registerLabel.textColor = [UIColor whiteColor];
    registerLabel.backgroundColor = [UIColor clearColor];
    registerLabel.font = [UIFont fontWithName:@"Heiti SC" size:18.0f];
    registerLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:registerLabel];
    */
    
    //Help Button
    CGRect helpFrame = CGRectMake(0, 0, 0, 0);
    helpBtn = [[UIButton alloc] init];
    helpBtn.frame = helpFrame;
    helpBtn.backgroundColor = [UIColor blackColor];
    //[self.view addSubview:helpBtn];
    
    //setting Button
    UIImageView *settingImg = [[UIImageView alloc] initWithFrame:CGRectMake(200, listFrame.origin.y + listFrame.size.height + 228, 26, 26)];
    settingImg.image = [UIImage imageNamed:@"news center-setting"];
    settingImg.backgroundColor = [UIColor clearColor];
    [self.view addSubview:settingImg];
    CGRect settingFrame = CGRectMake(188, listFrame.origin.y + listFrame.size.height + 226, 50, 50);
    settingBtn = [[UIButton alloc] init];
    settingBtn.frame = settingFrame;
    settingBtn.backgroundColor = [UIColor clearColor];
    [settingBtn addTarget:self action:@selector(showSetupWindow) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingBtn];
    
    noticeController = [[NoticeController alloc] init];
    noticeController.view.frame = CGRectMake(menuWidth, 0, 1024-menuWidth, 768);

    [noticeController.view setAlpha:0];
    [noticeController.view setHidden:YES];

    [hostController addChildViewController:noticeController];
    [hostController.view addSubview:noticeController.view];

    
    //The background view when pop a view
    blurView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    [blurView setBackgroundColor:[UIColor blackColor]];
    [blurView setAlpha:0.0f];
    [blurView setHidden:YES];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelector:)];
    [blurView addGestureRecognizer:tapGesture];

    setupView = [[SetUpView alloc]initWithDefault:hostController];
    setupView.delegate = self;
    setupView.alpha = 0.0f;
    
    registerView = [[RegisterView alloc] initWithDefault:hostController];
    registerView.alpha = 0.0f;
    [self displayProductImage];
}

- (void)dealloc{
    self.delegate = nil;
}

//Methods about showing and hiding the setting view
- (void)showSetupWindow{
    
    [hostController.tap setEnabled:NO];
    [self showBlur];
    [setupView showSetupView];
}

- (void)tapSelector:(UITapGestureRecognizer *)gesture{
    if(setupView.alpha == 1.0f){
        [setupView hideSetupView];
    }else if (registerView.alpha == 1.0f){
        [registerView hideRegisterView];
    }
    [self hideBlur];
    [hostController.tap setEnabled:YES];
}

- (void)showBlur{
    [hostController.view addSubview:blurView];
    [blurView setHidden:NO];
    [UIView animateWithDuration:0.5f animations:^{
        [blurView setAlpha:0.5f];
    } completion:^(BOOL finished){
        
    }];
}
- (void)hideBlur{
    [UIView animateWithDuration:0.5f animations:^{
        [blurView setAlpha:0.0f];
    } completion:^(BOOL finished){
        [blurView setHidden:YES];
        [blurView removeFromSuperview];
    }];
}
#pragma SetUpViewDelegate mark
- (void)closeSetUpView{
    [setupView hideSetupView];
    [self hideBlur];
    [hostController.tap setEnabled:YES];
}

- (void)logoutAccount{
    [setupView hideSetupView];
    [self hideBlur];
    [hostController.tap setEnabled:YES];
    [hostController dismissViewControllerAnimated:YES completion:nil];
}

//Methods about showing and hiding register view
- (void)showRegisterView
{
    [hostController.tap setEnabled:NO];
    [self showBlur];
    [registerView showRegisterView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)registerBtnPressed:(id)sender
{
    RegisterController *popController = [RegisterController sharedRegisterController];
    
    //[popController presentWithContentController:contentController animated:YES];

    
    [self presentViewController:popController animated:YES completion:nil];
}

#pragma Mark - tableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
    //return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"Cell for section:%d row:%d",[indexPath section],[indexPath row]);
    NSString *contentIdentifier = [NSString stringWithFormat:@"Cell%d%d",[indexPath section],[indexPath row]]; //以indexPath来唯一确定cell,不使用完全重用机制
    
    MenuCell *cell =[list dequeueReusableCellWithIdentifier:contentIdentifier];
    
    if(cell == nil){
        cell = [[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contentIdentifier];
    }
    
    
    cell.title.text = [titleArray objectAtIndex:indexPath.row];
    
    //NSLog(@"currentRow:%d", currentRow);
    if(indexPath.row == 0){
        
        cell.topLine.frame = CGRectMake(0, 0, menuWidth, 1);
        cell.belowLine.frame = CGRectMake(0, 43, menuWidth, 1);
        cell.topLine.backgroundColor = [UIColor whiteColor];
        cell.belowLine.backgroundColor = [UIColor whiteColor];
        
        cell.icon.frame = CGRectMake(23, 5, 35, 31);
        cell.backgroundImg.frame = CGRectMake(0, 0, menuWidth, 44);
        cell.title.font = [UIFont fontWithName:@"Heiti SC" size:18];
        cell.title.frame = CGRectMake(0, 0, menuWidth, 41);
        cell.title.textAlignment = NSTextAlignmentCenter;
        
        if(currentRow == 0){
            
            cell.icon.image = [UIImage imageNamed:@"course_pressed"];
            cell.backgroundImg.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
            cell.title.textColor = [UIColor colorWithRed:212/255.0 green:74/255.0 blue:108/255.0 alpha:1.0];
            
        }else{

            cell.icon.image = [UIImage imageNamed:@"course_normal"];
            cell.backgroundImg.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
            cell.title.textColor = [UIColor whiteColor];
        }
    }else if(indexPath.row == 1){
        
        cell.icon.frame = CGRectMake(65, 5, 35, 31);
        cell.title.font = [UIFont fontWithName:@"Heiti SC" size:15.0];
        cell.backgroundImg.frame = CGRectMake(0, 0, menuWidth, 41.5);
        cell.title.frame = CGRectMake(110, 0, menuWidth - 120, 41);
        
        if(currentRow == 1){
            
            cell.icon.image = [UIImage imageNamed:@"ppt_pressed"];
            cell.backgroundImg.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
            cell.title.textColor = [UIColor colorWithRed:212/255.0 green:74/255.0 blue:108/255.0 alpha:1.0];
        }else {
            
            cell.icon.image = [UIImage imageNamed:@"ppt_normal"];
            cell.backgroundImg.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
            cell.title.textColor = [UIColor whiteColor];
        }
        
        
    }else if(indexPath.row == 2){
        
        cell.icon.frame = CGRectMake(65, 5, 35, 31);
        cell.title.font = [UIFont fontWithName:@"Heiti SC" size:15.0];
        cell.backgroundImg.frame = CGRectMake(0, 0, menuWidth, 41.5);
        cell.title.frame = CGRectMake(110, 0, menuWidth - 120, 41);
        
        if(currentRow == 2){
            
            cell.icon.image = [UIImage imageNamed:@"pingjiao_pressed"];
            cell.backgroundImg.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
            cell.title.textColor = [UIColor colorWithRed:212/255.0 green:74/255.0 blue:108/255.0 alpha:1.0];
        }else {

            cell.icon.image = [UIImage imageNamed:@"pingjiao_normal"];
            cell.backgroundImg.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
            cell.title.textColor = [UIColor whiteColor];
        }
        
    }else if(indexPath.row == 3){
        
        cell.icon.frame = CGRectMake(62, 5, 28, 27);
        cell.title.font = [UIFont fontWithName:@"Heiti SC" size:15.0];
        cell.backgroundImg.frame = CGRectMake(0, 0, menuWidth, 41.5);
        cell.title.frame = CGRectMake(110, 0, menuWidth - 120, 41);
        
        if(currentRow == 3){
            
            cell.icon.image = [UIImage imageNamed:@"schedule_pressed"];
            cell.backgroundImg.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
            //NSLog(@"row3's bgImg frame:%f--%f", cell.backgroundImg.frame.origin.x, cell.backgroundImg.frame.origin.y);
            cell.title.textColor = [UIColor colorWithRed:212/255.0 green:74/255.0 blue:108/255.0 alpha:1.0];
        }else {
            
            cell.icon.image = [UIImage imageNamed:@"schedule_normal"];
            cell.backgroundImg.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
            cell.title.textColor = [UIColor whiteColor];
        }
        
    }else if(indexPath.row == 4){
        
        cell.icon.frame = CGRectMake(62, 5, 28, 27);
        cell.title.font = [UIFont fontWithName:@"Heiti SC" size:15.0];
        cell.backgroundImg.frame = CGRectMake(0, 0, menuWidth, 41.5);
        cell.title.frame = CGRectMake(110, 0, menuWidth - 120, 41);
        
        if(currentRow == 4){
            
            cell.icon.image = [UIImage imageNamed:@"xuanke_pressed"];
            cell.backgroundImg.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
            //NSLog(@"row3's bgImg frame:%f--%f", cell.backgroundImg.frame.origin.x, cell.backgroundImg.frame.origin.y);
            cell.title.textColor = [UIColor colorWithRed:212/255.0 green:74/255.0 blue:108/255.0 alpha:1.0];
        }else {
            
            cell.icon.image = [UIImage imageNamed:@"xuanke_normal"];
            cell.backgroundImg.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
            cell.title.textColor = [UIColor whiteColor];
        }

    
    }else if(indexPath.row == 5){
    
        cell.topLine.frame = CGRectMake(0, 0, menuWidth, 1);
        cell.belowLine.frame = CGRectMake(0, 42, menuWidth, 1);
        cell.topLine.backgroundColor = [UIColor whiteColor];
        cell.belowLine.backgroundColor = [UIColor whiteColor];
        
        cell.icon.frame = CGRectMake(23, 5, 35, 31);
        cell.backgroundImg.frame = CGRectMake(0, 0, menuWidth, 44);
        cell.title.font = [UIFont fontWithName:@"Heiti SC" size:18.0];
        cell.title.frame = CGRectMake(0, 0, menuWidth, 41);
        cell.title.textAlignment = NSTextAlignmentCenter;
        
        if(currentRow == 5){
            
            cell.icon.image = [UIImage imageNamed:@"news_pressed"];
            cell.backgroundImg.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
            cell.title.textColor = [UIColor colorWithRed:212/255.0 green:74/255.0 blue:108/255.0 alpha:1.0];
            
        }else{
            
            cell.icon.image = [UIImage imageNamed:@"news_normal"];
            cell.backgroundImg.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
            cell.title.textColor = [UIColor whiteColor];
        }
        
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0 || indexPath.row == 5){
        return 44;
    }

    return 41;
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(currentRow == indexPath.row){
        //[list deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    if(indexPath.row == 1 || indexPath.row == 0){
        //implement the views' translate
        MainPageViewController *controller = [[MainPageViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        controller.title = [titleArray objectAtIndex:indexPath.row];
        [hostController setRootController:navController animated:YES];
        
        if(noticeController.view.isHidden == NO){
            noticeController.view.alpha = 0.0;
            [noticeController.view setHidden:YES];
        }

    }else if(indexPath.row == 2){
        //implement the views' translate
        EvaluateController *controller = //[[EvaluateController alloc] init ];
        [[EvaluateController alloc] initWithNibName:@"EvaluatePage" bundle:nil];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        controller.title = [titleArray objectAtIndex:indexPath.row];
        [hostController setRootController:navController animated:YES];

        if(noticeController.view.isHidden == NO){
            noticeController.view.alpha = 0.0;
            [noticeController.view setHidden:YES];
        }
        
    }else if(indexPath.row == 3){
        //implement the views' translate
        ScheduleController *controller = [[ScheduleController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        [hostController setRootController:navController animated:YES];
        

        if(noticeController.view.isHidden == NO){
            noticeController.view.alpha = 0.0;
            [noticeController.view setHidden:YES];
        }

        
    }else if(indexPath.row == 4){//
        //jump to xuanke page.
        
        //test dao.
        Dao *dao = [Dao sharedDao];
        SysbsModel * model = [SysbsModel getSysbsModel];
        [dao requestForChooseCourseList:model.user.class_num userid:model.user.uid];
        CourseLIstViewController *controller = [[CourseLIstViewController alloc]initWithNibName:@"CourseList" bundle:nil];
        
        //CourseDetailViewController *cotroller = [[CourseDetailViewController alloc]init];
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:controller];
        [hostController setRootController:navController animated:YES];
        if(noticeController.view.isHidden == NO){
            noticeController.view.alpha = 0.0;
            [noticeController.view setHidden:YES];
        }

    }else if(indexPath.row == 5){
        //加载数据
        [noticeController setData];
        //implement the views' translate
        [hostController.rootViewController.view setHidden:YES];
        
        [hostController.tap setEnabled:NO];
        [noticeController.view setHidden:NO];
        
        [noticeController.view setFrame:CGRectMake(1024, 0, noticeController.view.frame.size.width,noticeController.view.frame.size.height)];
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            noticeController.view.alpha = 1.0;
            noticeController.view.frame = CGRectMake(menuWidth, 0, noticeController.view.frame.size.width,noticeController.view.frame.size.height);
        } completion:^(BOOL finished) {
            [noticeController.view setUserInteractionEnabled:YES];
            [self.view bringSubviewToFront:noticeController.view];
            [hostController showLeftController:NO];
        }];

        
    }
    
    currentRow = indexPath.row;
    [self.list reloadData];
    //[list deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma Mark - DDMenuController Delegate
- (BOOL)isPresentNoticeView
{
    if(currentRow == 5)
        return YES;
    return NO;
}

-(void)displayProductImage{
    //设置根ip地址
    NSLog(@"displayproduct");
    NSURL *url = [NSURL URLWithString:@"http://115.28.18.130/SEMBADEVELOP/img/head/"];
    int imageCount = 1;
    for (int i = 0 ; i < imageCount ; ++i) {
        User *user = [SysbsModel getSysbsModel].user;
        if ([user.headImgUrl isEqualToString:@""] == NO){
            //获取网络图片。
            NSLog(@"from internet");
            NSURL *url = [NSURL URLWithString:user.headImgUrl];
            NSLog(@"%@",user.headImgUrl);
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
    UIImageView *imageView = headImg;
    //[courseItem addSubview:imageView];
    //courseItem.courseImg;
    //imageView.tag = index;
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