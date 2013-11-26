//
//  ForgetPSWView.m
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by 欧 展飞 on 13-11-26.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "ForgetPSWView.h"
#define SCREENWIDTH 1024
#define SCREENHEIGHT 768
#define SETUPWIDTH 405
#define SETUPHEIGHT 499
#define kDurationOfAnimation 2.0f

@implementation ForgetPSWView
@synthesize outViewController;

-(id)initWithDefault:controler{
    NSLog(@"hero");
    outViewController = controler;
    return [self initWithFrame:CGRectMake(SCREENWIDTH/2-SETUPWIDTH/2, SETUPHEIGHT / 2 + 100, SETUPWIDTH, SETUPHEIGHT)];
}

-(void)slideIn{
    CGRect startRect = CGRectMake(SCREENWIDTH/2-SETUPWIDTH/2, -SETUPHEIGHT, SETUPWIDTH, SETUPHEIGHT);
    CGRect endRect =   CGRectMake(SCREENWIDTH/2-SETUPWIDTH/2, SCREENHEIGHT/2-SETUPHEIGHT/2, SETUPWIDTH, SETUPHEIGHT);
    //SetUpView *view = [[SetUpView alloc] initWithDefault];
    self.frame = startRect;
    self.alpha = 1.0f;
    [UIView animateWithDuration:kDurationOfAnimation delay:0.0f
                        options:    UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         self.frame = endRect;
                     } completion:^(BOOL finished) {
                     }];
    NSLog(@"finish");
    NSLog(@"%f",self.frame.origin.y);
}

- (void)hideModifyPSWView{
    CGRect rect = self.frame;
    rect.origin.y += 200;
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = rect;
        self.alpha = 0.0f;
    } completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}

- (void)showModifyPSWView{
    [outViewController.view addSubview:self];
    CGRect rect = self.frame;
    rect.origin.y -= 200;
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = rect;
        self.alpha = 1.0f;
    } completion:^(BOOL finished){
        
    }];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UIColor *bgColor = [UIColor whiteColor];
        [self setBackgroundColor:bgColor];
        self.layer.cornerRadius = 20;
        
        SendEmailController *rootViewController = [[SendEmailController alloc] init];
        [rootViewController.view setFrame:CGRectMake(0, 0, SETUPWIDTH, SETUPHEIGHT)];
        rootViewController.title = @"重置密码";
        
        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:rootViewController];
        [navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"setting_nav_bar"] forBarMetrics:UIBarMetricsDefault];
        [navigationController.view setFrame:CGRectMake(0, 0, SETUPWIDTH, SETUPHEIGHT)];
        
        [self addSubview:navigationController.view];
        [outViewController addChildViewController:navigationController];

    }
    return self;
}


@end
