//
//  RegisterResultController.m
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by 欧 展飞 on 13-11-27.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "RegisterResultController.h"
#define kSuccess 0
#define kFailOverTime 1
#define kFailNotTime 5
#define kFailWifi 2
#define kFailPlace 3
#define kFailDate 4

@interface RegisterResultController ()

@end

@implementation RegisterResultController
{
    NSString *result;
}
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
    resultText.textColor = [UIColor whiteColor];
    resultText.textAlignment = NSTextAlignmentLeft;
    resultText.lineBreakMode = NSLineBreakByCharWrapping;
    resultText.numberOfLines = 0;
    resultText.backgroundColor = [UIColor blackColor];
    resultText.text = result;
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
    NSLog(@"register return value:%d", returnValue);
    switch (returnValue) {
        case kSuccess:
            NSLog(@"签到成功");
            result = @"签到成功";
            [tryAgain setHidden:YES];
            break;
            
        case kFailOverTime:
            NSLog(@"已经过了亲到时间");
            result = @"签到失败，已经过了签到时间";
            [tryAgain setHidden:NO];
            break;
            
        case kFailWifi:
            NSLog(@"网络出错");
            result = @"签到失败，请检查网络";
            [tryAgain setHidden:NO];
            break;
            
        case kFailPlace:
            NSLog(@"没到上课地点");
            result = @"签到失败，您还没到上课地点";
            [tryAgain setHidden:NO];
            break;
            
        case kFailNotTime:
            NSLog(@"还没到上课时间");
            result = @"签到失败，还没到签到时间";
            [tryAgain setHidden:NO];
            break;
            
        case kFailDate:
            NSLog(@"不是上课日期");
            result = @"签到失败，今天不用上课";
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
