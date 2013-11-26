//
//  MenuController.h
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by 欧 展飞 on 13-10-29.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuCell.h"
#import "SetUpView.h"
#import "RegisterView.h"
#import "DDMenuController.h"

@class NoticeController;

@protocol menuControllerDelegate;

@interface MenuController : UIViewController<UITableViewDataSource, UITableViewDelegate,SetUpViewDelegate, DDMenuControllerDelegate>

@property (nonatomic, retain) UIImageView *backgroundImg;
@property (nonatomic, retain) UIImageView *headImg;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UITableView *list;
@property (nonatomic, retain) UIButton *registerBtn;
@property (nonatomic, retain) UIButton *helpBtn;
@property (nonatomic, retain) UIButton *settingBtn;
@property (nonatomic, retain) UILabel *registerLabel;
@property (nonatomic, retain) DDMenuController *hostController;
@property (nonatomic, retain) UIView *noticeView;
@property (nonatomic, assign) id <menuControllerDelegate> delegate;
@property (nonatomic, retain) UIView *blurView;
@property (nonatomic, retain) SetUpView *setupView;
@property (nonatomic, retain) NoticeController *noticeController;
@property (nonatomic, retain) RegisterView *registerView;

- (IBAction)registerBtnPressed:(id)sender;

@end

@protocol menuControllerDelegate

- (void)disableTap;

@end
