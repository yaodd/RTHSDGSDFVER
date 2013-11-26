//
//  SendEmailController.m
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by 欧 展飞 on 13-11-26.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "SendEmailController.h"
#import "ModifyPSWController.h"
#define TEXT_SIZE  18.0f

@interface SendEmailController ()

@end

@implementation SendEmailController
@synthesize email;
@synthesize send;

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
    
    UIFont *textFont = [UIFont systemFontOfSize:TEXT_SIZE];
    UIColor *textColor = [UIColor colorWithRed:105.0 / 255 green:105.0 / 255 blue:105.0 / 255 alpha:1.0];
    
    UILabel *pleaseEnter = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 600, 40)];
    pleaseEnter.text = @"请输入您的电子邮箱";
    pleaseEnter.textColor = textColor;
    pleaseEnter.font = textFont;
    pleaseEnter.backgroundColor = [UIColor clearColor];
    pleaseEnter.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:pleaseEnter];
    
    email = [[UITextField alloc] initWithFrame:CGRectMake(pleaseEnter.frame.origin.x,
                                                          pleaseEnter.frame.origin.y + pleaseEnter.frame.size.height + 10,
                                                          400, 50)];
    email.placeholder = @"hahahaha@gmail.com";
    email.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:email];
    
    UILabel *hint = [[UILabel alloc] initWithFrame:CGRectMake(email.frame.origin.x,
                                                              email.frame.origin.y + email.frame.size.height + 20,
                                                              600, 100)];
    hint.lineBreakMode = NSLineBreakByCharWrapping;
    hint.numberOfLines = 0;
    hint.text = @"我们将发送验证码到您的邮箱，请注意差收";
    hint.font = textFont;
    hint.textColor = textColor;
    hint.textAlignment = NSTextAlignmentLeft;
    hint.backgroundColor = [UIColor clearColor];
    [self.view addSubview:hint];
    
    send = [[UIButton alloc] initWithFrame:CGRectMake(100, 400, 150, 50)];
    send.backgroundColor = [UIColor clearColor];
    [send setBackgroundImage:[UIImage imageNamed:@"setting_button"] forState:UIControlStateNormal];
    send.titleLabel.text = @"发送";
    send.titleLabel.textColor = [UIColor whiteColor];
    send.titleLabel.textAlignment = NSTextAlignmentCenter;
    [send addTarget:self action:@selector(sendPressed:) forControlEvents:UIControlEventTouchUpInside];
    send.titleLabel.font = textFont;
    [self.view addSubview:send];
}

- (IBAction)sendPressed:(id)sender
{
    ModifyPSWController *modifyController = [[ModifyPSWController alloc] init];
    [self.navigationController pushViewController:modifyController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
