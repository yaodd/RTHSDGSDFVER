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
    NSLog(@"MenuView did load");
    currentRow = 0;
    
    float originY = 20;
    
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
    [self.view addSubview:headImg];
    
    //UserNameLabel
    CGRect nameFrame = CGRectMake(0, 210, menuWidth, 35);
    nameLabel = [[UILabel alloc] init];
    nameLabel.frame = nameFrame;
    nameLabel.text = @"李开花";
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont fontWithName:@"Heiti SC" size:24.0f];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nameLabel];
    
    //Menu TableView
    CGRect listFrame = CGRectMake(0, 255, menuWidth, 210);
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
    [registerBtn setImage:[UIImage imageNamed:@"news center-sign"] forState:UIControlStateNormal];
    [self.view addSubview:registerBtn];
    
    //RegisterLabel
    CGRect registerLabelFrame = CGRectMake(0, registerFrame.origin.y + registerFrame.size.height + 10, menuWidth-20, 40);
    registerLabel = [[UILabel alloc] init];
    registerLabel.frame = registerLabelFrame;
    registerLabel.text = @"签到";
    registerLabel.textColor = [UIColor whiteColor];
    registerLabel.backgroundColor = [UIColor clearColor];
    registerLabel.font = [UIFont fontWithName:@"Heiti SC" size:18.0f];
    registerLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:registerLabel];
    
    //Help Button
    CGRect helpFrame = CGRectMake(0, 0, 0, 0);
    helpBtn = [[UIButton alloc] init];
    helpBtn.frame = helpFrame;
    helpBtn.backgroundColor = [UIColor blackColor];
    //[self.view addSubview:helpBtn];
    
    //setting Button
    UIImageView *settingImg = [[UIImageView alloc] initWithFrame:CGRectMake(200, listFrame.origin.y + listFrame.size.height + 270, 26, 26)];
    settingImg.image = [UIImage imageNamed:@"news center-setting"];
    settingImg.backgroundColor = [UIColor clearColor];
    [self.view addSubview:settingImg];
    CGRect settingFrame = CGRectMake(188, listFrame.origin.y + listFrame.size.height + 268, 50, 50);
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

    
    //Declare the setting view and background view
    blurView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    [blurView setBackgroundColor:[UIColor blackColor]];
    [blurView setAlpha:0.0f];
    [blurView setHidden:YES];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelector:)];
    [blurView addGestureRecognizer:tapGesture];
//    [hostController.view addSubview:blurView];

    setupView = [[SetUpView alloc]initWithDefault:hostController];
    setupView.delegate = self;
    setupView.alpha = 0.0f;
}

- (void)dealloc{
    self.delegate = nil;
}

- (void)showSetupWindow{
//    [self.view bringSubviewToFront:setupView];
//    [hostController.view addSubview:setupView];
    [hostController.tap setEnabled:NO];
    [self showBlur];
    [setupView showSetupView];
}

- (void)tapSelector:(UITapGestureRecognizer *)gesture{
    [setupView hideSetupView];
    [self hideBlur];
    [hostController.tap setEnabled:YES];
//    [setupView removeFromSuperview];
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
    NSLog(@"Cell for section:%d row:%d",[indexPath section],[indexPath row]);
    NSString *contentIdentifier = [NSString stringWithFormat:@"Cell%d%d",[indexPath section],[indexPath row]]; //以indexPath来唯一确定cell,不使用完全重用机制
    
    MenuCell *cell =[list dequeueReusableCellWithIdentifier:contentIdentifier];
    
    if(cell == nil){
        cell = [[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contentIdentifier];
    }
    
    
    cell.title.text = [titleArray objectAtIndex:indexPath.row];
    
    NSLog(@"currentRow:%d", currentRow);
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

            cell.icon.image = [UIImage imageNamed:@"news center-study"];
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
            
            cell.icon.image = [UIImage imageNamed:@"news center-note"];
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
            
            cell.icon.image = [UIImage imageNamed:@"news center-pen"];
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
            NSLog(@"row3's bgImg frame:%f--%f", cell.backgroundImg.frame.origin.x, cell.backgroundImg.frame.origin.y);
            cell.title.textColor = [UIColor colorWithRed:212/255.0 green:74/255.0 blue:108/255.0 alpha:1.0];
        }else {
            
            cell.icon.image = [UIImage imageNamed:@"news center-calender"];
            cell.backgroundImg.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
            cell.title.textColor = [UIColor whiteColor];
        }
        
    }else if(indexPath.row == 4){
    
        cell.topLine.frame = CGRectMake(0, 0, menuWidth, 1);
        cell.belowLine.frame = CGRectMake(0, 42, menuWidth, 1);
        cell.topLine.backgroundColor = [UIColor whiteColor];
        cell.belowLine.backgroundColor = [UIColor whiteColor];
        
        cell.icon.frame = CGRectMake(23, 5, 35, 31);
        cell.backgroundImg.frame = CGRectMake(0, 0, menuWidth, 44);
        cell.title.font = [UIFont fontWithName:@"Heiti SC" size:18.0];
        cell.title.frame = CGRectMake(0, 0, menuWidth, 41);
        cell.title.textAlignment = NSTextAlignmentCenter;
        
        if(currentRow == 4){
            
            cell.icon.image = [UIImage imageNamed:@"news center-mail"];
            cell.backgroundImg.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
            cell.title.textColor = [UIColor colorWithRed:212/255.0 green:74/255.0 blue:108/255.0 alpha:1.0];
            
        }else{
            
            cell.icon.image = [UIImage imageNamed:@"news center-calender"];
            cell.backgroundImg.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
            cell.title.textColor = [UIColor whiteColor];
        }
        
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0 || indexPath.row == 4){
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
        EvaluateController *controller = [[EvaluateController alloc] init];
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

        
    }else if(indexPath.row == 4){
        //implement the views' translate
        [hostController.rootViewController.view setHidden:YES];
        
        [hostController.tap setEnabled:NO];
        [noticeController.view setHidden:NO];
        
        [noticeController.view setFrame:CGRectMake(1024, 0, noticeController.view.frame.size.width,noticeController.view.frame.size.height)];
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            noticeController.view.alpha = 1.0;
            noticeController.view.frame = CGRectMake(menuWidth, 0, noticeController.view.frame.size.width,noticeController.view.frame.size.height);
        } completion:^(BOOL finished) {
            [noticeController.view setUserInteractionEnabled:YES];
            [self.view bringSubviewToFront:noticeController.view];
        }];

        
    }
    
    currentRow = indexPath.row;
    [self.list reloadData];
    //[list deselectRowAtIndexPath:indexPath animated:YES];
}



@end