//
//  GuideViewController.m
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by yaodd on 14-2-25.
//  Copyright (c) 2014年 yaodd. All rights reserved.
//

#import "GuideViewController.h"
#import "LoginViewController.h"

@interface GuideViewController ()

@property (strong, nonatomic) UIScrollView *guideScrollView;
@end


@implementation GuideViewController

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
    _guideScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    [_guideScrollView setShowsHorizontalScrollIndicator:NO];
    [_guideScrollView setShowsVerticalScrollIndicator:NO];
    [_guideScrollView setDelegate:self];
    [self.view addSubview:_guideScrollView];
    NSArray *imageNameArray = [NSArray arrayWithObjects:@"guide_01",@"guide_02",@"guide_03", nil];
    
    [_guideScrollView setContentSize:CGSizeMake(1024 * [imageNameArray count], 768)];
    [_guideScrollView setPagingEnabled:YES];
    for (int i = 0 ; i < [imageNameArray count]; i ++) {
        UIImage *image = [UIImage imageNamed:[imageNameArray objectAtIndex:i]];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(1024 * i, 0, 1024, 768)];
        [imageView setImage:image];
        [_guideScrollView addSubview:imageView];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelector)];
        if (i == 2) {
            [imageView setUserInteractionEnabled:YES];
            [imageView addGestureRecognizer:tapGesture];
        }
    }
}
- (void)tapSelector
{
    LoginViewController *loginViewController = [[LoginViewController alloc]init];
    [self presentViewController:loginViewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UIScrollViewDelegate mark
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x > 1024 * 2) {
        LoginViewController *loginViewController = [[LoginViewController alloc]init];
        [self presentViewController:loginViewController animated:YES completion:nil];
    }
}

@end
