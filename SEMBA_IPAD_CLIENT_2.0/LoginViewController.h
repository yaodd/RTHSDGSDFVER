//
//  LoginViewController.h
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by yaodd on 13-11-11.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>

#define isAutoDownloadKey   @"isAutoDownLoad"
#define isPushKey           @"isPush"
#define isAutoLoginKey      @"isAutoLogin"

#define isLoginOutKey       @"isLoginOutKey"

#define ACCOUNT_KEY         @"accountKey"
#define PASSWORD_KEY        @"passwordKey"

@interface LoginViewController : UIViewController <UITextFieldDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *accountTF;
@property (strong, nonatomic) IBOutlet UITextField *passwordTF;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)loginAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *loginView;
@property (strong, nonatomic) IBOutlet UIButton *autoLoginCheck;

@end
