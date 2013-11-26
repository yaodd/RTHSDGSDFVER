//
//  ForgetPSWView.h
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by 欧 展飞 on 13-11-26.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendEmailController.h"

@interface ForgetPSWView : UIView
@property (nonatomic, retain)UIViewController *outViewController;

-(id)initWithDefault:(UIViewController *)controler;

- (void)showModifyPSWView;

- (void)hideModifyPSWView;

@end
