//
//  AboutUsViewController.m
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by yaodd on 14-2-25.
//  Copyright (c) 2014年 yaodd. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

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
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIImage *image = [UIImage imageNamed:@"logo"];
    UIImageView *logo = [[UIImageView alloc]initWithImage:image];
    [logo setFrame:CGRectMake(63, 160, image.size.width * 3 / 4, image.size.height * 3 / 4)];
    [self.view addSubview:logo];
    
    UILabel *compCN = [[UILabel alloc]initWithFrame:CGRectMake(65, 430, 300, 30)];
    [compCN setBackgroundColor:[UIColor clearColor]];
    [compCN setText:@"广州哲信软件科技有限公司 版权所有"];
    [compCN setFont:[UIFont systemFontOfSize:17]];
    [compCN setTextColor:[UIColor colorWithWhite:177.0 / 255 alpha:1]];
    UILabel *compEN = [[UILabel alloc]initWithFrame:CGRectMake(60, 450, 400, 30)];
    [compEN setBackgroundColor:[UIColor clearColor]];
    [compEN setText:@"Copyright  @ Guangzhou Jitsun Software Tech Co.ltd"];
    [compEN setFont:[UIFont systemFontOfSize:12]];
    [compEN setTextColor:[UIColor colorWithWhite:177.0 / 255 alpha:1]];
    [self.view addSubview:compCN];
    [self.view addSubview:compEN];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
