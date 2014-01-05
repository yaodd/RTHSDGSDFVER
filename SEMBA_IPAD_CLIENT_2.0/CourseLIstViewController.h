//
//  CourseLIstViewController.h
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by 王智锐 on 12/31/13.
//  Copyright (c) 2013 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseLIstViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIScrollView *alreadyChoose;
@property (strong, nonatomic) IBOutlet UITextView *alreadyChooseTextView;

@end
