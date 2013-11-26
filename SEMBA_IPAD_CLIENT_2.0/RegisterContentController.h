//
//  RegisterContentController.h
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by 欧 展飞 on 13-11-2.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Dao.h"
#import "RegisterResultController.h"

@interface RegisterContentController : UIViewController<CLLocationManagerDelegate>

@property (nonatomic, retain) UIButton *historyBtn;

@property (nonatomic, strong) CLLocationManager *locateManager;

@property (nonatomic, strong) UIActivityIndicatorView *activity;

@property (nonatomic, strong) UILabel *hintText;

@property (nonatomic, strong) UIButton *registerBtn;

- (IBAction)checkBtnPressed:(id)sender;

- (IBAction)registerBtnPressed:(id)sender;

@end
