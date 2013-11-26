//
//  RegisterResultController.m
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by 欧 展飞 on 13-11-27.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "RegisterResultController.h"
#define kSuccess 0
#define kFailTime 1
#define kFailWifi 2
#define kFailPlace 3

@interface RegisterResultController ()

@end

@implementation RegisterResultController
@synthesize tryAgain;
@synthesize resultText;

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
	// Do any additional setup after loading the view.
    
    resultText = [[UILabel alloc] init];
    resultText.frame = CGRectMake(10, 50, 200, 50);
    resultText.font = [UIFont fontWithName:@"Heiti SC" size:20.0];
    resultText.textColor = [UIColor blackColor];
    resultText.textAlignment = NSTextAlignmentLeft;
    resultText.lineBreakMode = NSLineBreakByCharWrapping;
    resultText.numberOfLines = 0;
    resultText.backgroundColor = [UIColor clearColor];
    [self.view addSubview:resultText];
    
    tryAgain = [[UIButton alloc] init];
    [tryAgain setTitle:@"再试一次" forState:UIControlStateNormal];
    [tryAgain setTintColor:[UIColor whiteColor]];
    [tryAgain setBackgroundImage:[UIImage imageNamed:@"setting_button" ] forState:UIControlStateNormal];
    tryAgain.frame = CGRectMake(50, 200, 100, 50);
    [self.view addSubview:tryAgain];
}

- (void)startRegister:(int)returnValue
{
    switch (returnValue) {
        case 0:
            resultText.text = @"签到成功";
            [tryAgain setHidden:YES];
            break;
            
        case 1:
            resultText.text = @"签到失败，已经过了签到时间";
            [tryAgain setHidden:NO];
            break;
            
        case 2:
            resultText.text = @"签到失败，请检查网络";
            [tryAgain setHidden:NO];
            break;
            
        case 3:
            resultText.text = @"签到失败，您还没到上课地点";
            [tryAgain setHidden:NO];
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
