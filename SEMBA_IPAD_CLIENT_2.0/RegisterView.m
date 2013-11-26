//
//  RegisterView.m
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by 欧 展飞 on 13-11-27.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "RegisterView.h"
#import "RegisterContentController.h"
#import "RegisterHistoryController.h"
#define SCREENWIDTH 1024
#define SCREENHEIGHT 768
#define VIEWWIDTH 405
#define VIEWHEIGHT 499
#define kDurationOfAnimation 0.5f
#define kBackgroundColor [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0]

@implementation RegisterView

@synthesize outViewController;

- (id)initWithDefault:(UIViewController *)controller
{
    NSLog(@"RegisterView init");
    outViewController = controller;
    return [self initWithFrame:CGRectMake(SCREENWIDTH/2 - VIEWWIDTH/2, VIEWHEIGHT/2 + 100, VIEWWIDTH, VIEWHEIGHT)];
}

- (void)slideIn{

    CGRect startRect = CGRectMake(SCREENWIDTH/2-VIEWWIDTH/2, -VIEWHEIGHT, VIEWWIDTH, VIEWHEIGHT);
    CGRect endRect = CGRectMake(SCREENWIDTH/2-VIEWWIDTH/2, SCREENHEIGHT/2-VIEWHEIGHT/2, VIEWWIDTH, VIEWHEIGHT);
    //SetUpView *view = [[SetUpView alloc] initWithDefault];
    self.frame = startRect;
    self.alpha = 1.0f;
    [UIView animateWithDuration:2.0f delay:0.0f
                        options:    UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         self.frame = endRect;
                     } completion:^(BOOL finished) {
                     }];
    NSLog(@"finish");
}

- (void)showRegisterView
{
    [outViewController.view addSubview:self];
    CGRect rect = self.frame;
    rect.origin.y -= 200;
    [UIView animateWithDuration:kDurationOfAnimation animations:^{
        self.frame = rect;
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideRegisterView
{
    CGRect rect = self.frame;
    rect.origin.y += 200;
    [UIView animateWithDuration:kDurationOfAnimation animations:^{
        self.frame = rect;
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setBackgroundColor:kBackgroundColor];
        self.layer.cornerRadius = 20.0f;
        
        RegisterContentController *rootController = [[RegisterContentController alloc] init];
        rootController.title = @"签到";
        rootController.view.frame = CGRectMake(0, 0, VIEWWIDTH, VIEWHEIGHT);
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootController];
        navController.view.frame = CGRectMake(0, 0, VIEWWIDTH, VIEWHEIGHT);
        
        [outViewController addChildViewController:navController];
        [self addSubview:navController.view];
        
    }
    return self;
}


@end
