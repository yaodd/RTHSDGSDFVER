//
//  AppDelegate.h
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by yaodd on 13-10-28.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIDownloadCache.h"

@class DDMenuController;
@class Reachability;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    Reachability  *hostReach;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) DDMenuController *hostController;
@property (nonatomic,strong)ASIDownloadCache *downCache;

- (void) uncaughtExceptionHandler: (NSException *)exception;
@end
