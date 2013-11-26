//
//  RegisterResultController.h
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by 欧 展飞 on 13-11-27.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterResultController : UIViewController

@property (nonatomic, strong) UILabel *resultText;

@property (nonatomic, strong) UIButton *tryAgain;

- (void)startRegister:(int)returnValue;

@end
