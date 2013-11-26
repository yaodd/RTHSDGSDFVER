//
//  SendEmailController.h
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by 欧 展飞 on 13-11-26.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendEmailController : UIViewController

@property (nonatomic, strong) UITextField *email;

@property (nonatomic, strong) UIButton *send;

- (IBAction)sendPressed:(id)sender;

@end
