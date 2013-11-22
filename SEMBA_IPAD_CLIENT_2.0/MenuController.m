//
//  MenuController.m
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by 欧 展飞 on 13-10-29.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "MenuController.h"
#import "DDMenuController.h"
#import "AppDelegate.h"
#import "EvaluateController.h"
#import "ScheduleController.h"
#import "MainPageViewController.h"
#import "NoticeController.h"
#import "RegisterController.h"
#import "RegisterContentController.h"
#import "SetUpView.h"
#define menuWidth 238


@interface MenuController ()
{
    NSMutableArray *titleArray;
    NSInteger *currentRow;
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        titleArray = [[NSMutableArray alloc] initWithObjects:@"课程中心", @"课件", @"评教", @"课程表", @"通知中心", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    hostController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).hostController;
    
    currentRow = 0;
    
    float originY = 19.5;
    
    //Background Image
    CGRect backgroundFrame = CGRectMake(0, originY, menuWidth, self.view.frame.size.width - originY);
    backgroundImg = [[UIImageView alloc] init];
    backgroundImg.frame = backgroundFrame;
    [self.view addSubview:backgroundImg];
    
    //headImg
    CGRect headFrame = CGRectMake(53.5, 50, 134, 144);
    headImg = [[UIImageView alloc] init];
    headImg.frame = headFrame;
    headImg.backgroundColor = [UIColor blackColor];
    [self.view addSubview:headImg];
    
    //UserNameLabel
    CGRect nameFrame = CGRectMake(0, 200, menuWidth, 35);
    nameLabel = [[UILabel alloc] init];
    nameLabel.frame = nameFrame;
    nameLabel.text = @"李开花";
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont fontWithName:@"Helti SC" size:24.0f];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nameLabel];
    
    //Menu TableView
    CGRect listFrame = CGRectMake(0, 233.5, menuWidth, 210);
    list = [[UITableView alloc] init];
    list.frame = listFrame;
    [list setSectionIndexColor:[UIColor clearColor]];
    [list setSeparatorColor:[UIColor clearColor]];
    list.backgroundColor = [UIColor clearColor];
    list.delegate = self;
    list.dataSource = self;
    
    [list setScrollEnabled:NO];
    [self.view addSubview:list];
    
    //RegisterButton
    CGRect registerFrame = CGRectMake(54, listFrame.origin.y + listFrame.size.height + 63.5, 104, 96);
    registerBtn = [[UIButton alloc] init];
    registerBtn.frame = registerFrame;
    registerBtn.backgroundColor = [UIColor clearColor];
    [registerBtn addTarget:self action:@selector(registerBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    //RegisterLabel
    CGRect registerLabelFrame = CGRectMake(0, registerFrame.origin.y + registerFrame.size.height + 10, menuWidth, 40);
    registerLabel = [[UILabel alloc] init];
    registerLabel.frame = registerLabelFrame;
    registerLabel.text = @"签到";
    registerLabel.textColor = [UIColor whiteColor];
    registerLabel.backgroundColor = [UIColor clearColor];
    registerLabel.font = [UIFont fontWithName:@"Helti SC" size:18.0f];
    registerLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:registerLabel];
    
    //Help Button
    CGRect helpFrame = CGRectMake(0, 0, 0, 0);
    helpBtn = [[UIButton alloc] init];
    helpBtn.frame = helpFrame;
    helpBtn.backgroundColor = [UIColor blackColor];
    //[self.view addSubview:helpBtn];
    
    //setting Button
    CGRect settingFrame = CGRectMake(200, listFrame.origin.y + listFrame.size.height + 270, 26, 26);
    settingBtn = [[UIButton alloc] init];
    settingBtn.frame = settingFrame;
    settingBtn.backgroundColor = [UIColor clearColor];
    [settingBtn addTarget:self action:@selector(showSetupWindow) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingBtn];
    
    [self setImageAndBackground];

    noticeController = [[NoticeController alloc] init];
    noticeController.view.frame = CGRectMake(menuWidth, 0, 1024-menuWidth, 768);

    [noticeController.view setAlpha:0];
    [noticeController.view setHidden:YES];

    [hostController addChildViewController:noticeController];
    [hostController.view addSubview:noticeController.view];

    
    //Declare the setting view and background view
    blurView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    [blurView setBackgroundColor:[UIColor blackColor]];
    [blurView setAlpha:0.0f];
    [blurView setHidden:YES];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelector:)];
    [blurView addGestureRecognizer:tapGesture];
    [hostController.view addSubview:blurView];

    setupView = [[SetUpView alloc]initWithDefault:hostController];
    setupView.delegate = self;
    setupView.alpha = 0.0f;
    [hostController.view addSubview:setupView];
    
    
}

- (void)dealloc{
    self.delegate = nil;
}

- (void)showSetupWindow{
    [hostController.tap setEnabled:NO];
    [self showBlur];
    [setupView showSetupView];
}

- (void)tapSelector:(UITapGestureRecognizer *)gesture{
    [setupView hideSetupView];
    [self hideBlur];
    [hostController.tap setEnabled:YES];
}

- (void)showBlur{
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
- (void)setImageAndBackground
{
    [backgroundImg setImage:[UIImage imageNamed:@"news center-menu.png"]];
    
    [headImg setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"news center-circle on the menu.png"]]];
    
    [registerBtn setImage:[UIImage imageNamed:@"news center-sign.png"] forState:UIControlStateNormal];
    
    [settingBtn setImage:[UIImage imageNamed:@"news center-setting.png"] forState:UIControlStateNormal];
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
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"A cell for row %d", indexPath.row);
    static NSString *contentIdentifier = @"Cell";
    
    MenuCell *cell =[list dequeueReusableCellWithIdentifier:contentIdentifier];
    
    if(cell == nil){
        cell = [[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contentIdentifier];
    }
    
    cell.textLabel.text = [titleArray objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor whiteColor];
    
    
    if(indexPath.row == 0){
        cell.topLine.frame = CGRectMake(0, 0, menuWidth, 2);
        cell.belowLine.frame = CGRectMake(0, 40.5, menuWidth, 2);
        cell.topLine.backgroundColor = [UIColor whiteColor];
        cell.belowLine.backgroundColor = [UIColor whiteColor];
        
        cell.icon.frame = CGRectMake(23, 5, 35, 31);
        cell.icon.image = [UIImage imageNamed:@"news center-study"];
        
        cell.textLabel.font = [UIFont fontWithName:@"Helti SC" size:18.0];
        
    }else if(indexPath.row == 1){
        
        cell.icon.frame = CGRectMake(65, 5, 35, 31);
        cell.icon.image = [UIImage imageNamed:@"news center-note.png"];
        
        cell.textLabel.font = [UIFont fontWithName:@"Helti SC" size:15.0];
        
        cell.backgroundImg.frame = cell.frame;
        cell.backgroundImg.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
        
    }else if(indexPath.row == 2){
        
        cell.icon.frame = CGRectMake(65, 5, 35, 31);
        cell.icon.image = [UIImage imageNamed:@"news center-pen.png"];
        
        cell.textLabel.font = [UIFont fontWithName:@"Helti SC" size:15.0];
        
        cell.backgroundImg.frame = cell.frame;
        cell.backgroundImg.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
        
    }else if(indexPath.row == 3){
        
        cell.icon.frame = CGRectMake(62, 5, 28, 27);
        cell.icon.image = [UIImage imageNamed:@"news center-calender.png"];
        
        cell.textLabel.font = [UIFont fontWithName:@"Helti SC" size:15.0];
        
        cell.backgroundImg.frame = cell.frame;
        cell.backgroundImg.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
        
    }else if(indexPath.row == 4){
        cell.topLine.frame = CGRectMake(0, 0, menuWidth, 2);
        cell.belowLine.frame = CGRectMake(0, 40.5, menuWidth, 2);
        cell.topLine.backgroundColor = [UIColor whiteColor];
        cell.belowLine.backgroundColor = [UIColor whiteColor];
        
        cell.icon.frame = CGRectMake(23, 5, 35, 31);
        cell.icon.image = [UIImage imageNamed:@"news center-calender.png"];
        
        cell.textLabel.font = [UIFont fontWithName:@"Helti SC" size:15.0];
        
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 42.5;
    }
    if(indexPath.row == 4){
        return 42.5;
    }
    return 41;
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //hostController.rootViewController.view.userInteractionEnabled = YES;
    
    if(currentRow == (NSInteger *)indexPath.row){
        [list deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    if(indexPath.row == 1 || indexPath.row == 0){
        MainPageViewController *controller = [[MainPageViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        controller.title = [titleArray objectAtIndex:indexPath.row];
        [hostController setRootController:navController animated:YES];
        
        if(noticeController.view.isHidden == NO){
            noticeController.view.alpha = 0.0;
            [noticeController.view setHidden:YES];
        }

    }else if(indexPath.row == 2){

        EvaluateController *controller = [[EvaluateController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        controller.title = [titleArray objectAtIndex:indexPath.row];
        [hostController setRootController:navController animated:YES];
        
        if(noticeController.view.isHidden == NO){
            noticeController.view.alpha = 0.0;
            [noticeController.view setHidden:YES];
        }
        
    }else if(indexPath.row == 3){
        ScheduleController *controller = [[ScheduleController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        controller.title = [titleArray objectAtIndex:indexPath.row];
        [hostController setRootController:navController animated:YES];
        

        if(noticeController.view.isHidden == NO){
            noticeController.view.alpha = 0.0;
            [noticeController.view setHidden:YES];
        }
    }else if(indexPath.row == 4){
        [hostController.rootViewController.view setHidden:YES];

        
            [hostController.tap setEnabled:NO];
            [noticeController.view setHidden:NO];
        
            [noticeController.view setFrame:CGRectMake(1024, 0, noticeController.view.frame.size.width, noticeController.view.frame.size.height)];
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                noticeController.view.alpha = 1.0;
                noticeController.view.frame = CGRectMake(250, 0, noticeController.view.frame.size.width, noticeController.view.frame.size.height);
            } completion:^(BOOL finished) {
                [noticeController.view setUserInteractionEnabled:YES];
                [self.view bringSubviewToFront:noticeController.view];
            }];
        


    }
    
    currentRow = (NSInteger*)indexPath.row;
    [list deselectRowAtIndexPath:indexPath animated:YES];
}



@end