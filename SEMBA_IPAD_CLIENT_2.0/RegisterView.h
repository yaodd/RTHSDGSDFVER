//
//  RegisterView.h
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by 欧 展飞 on 13-11-27.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterView : UIView
@property (nonatomic, strong) UIViewController *outViewController;

- (id)initWithDefault:(UIViewController *)controller;

- (void)showRegisterView;

- (void)hideRegisterView;

@end
