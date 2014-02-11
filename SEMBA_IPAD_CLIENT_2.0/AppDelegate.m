//
//  AppDelegate.m
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by yaodd on 13-10-28.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "AppDelegate.h"
#import "WelcomeViewController.h"
#import "Dao.h"
#import "MainPageViewController.h"
#import "MenuController.h"
#import "DDMenuController.h"
#import "SysbsModel.h"


@implementation AppDelegate
@synthesize window;
@synthesize hostController;
@synthesize downCache = _downCache;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //注册启用 push
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    
    
    // 监测网络情况
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    hostReach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    [hostReach startNotifier];
    
    // Override point for customization after application launch.
//    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    MainPageViewController *mainController = [[MainPageViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mainController];
    hostController = [[DDMenuController alloc] initWithRootViewController:navController];
    MenuController *menuController = [[MenuController alloc] init];
    hostController.leftViewController = menuController;
    //menuController.delegate = hostController.self;
    
    window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds]; // Main application window
    window.backgroundColor = [UIColor whiteColor];
    
    WelcomeViewController *rootViewController = [[WelcomeViewController alloc]init];
    window.rootViewController = rootViewController;
     /*
    UIViewController *controller = [[DetailViewController alloc]initWithNibName:@"DetailView" bundle:nil];
    self.window.rootViewController = controller;
*/
    Dao* dao = [Dao sharedDao];
    [window makeKeyAndVisible];
//    Dao *dao = [Dao sharedDao];
    SysbsModel *model = [SysbsModel getSysbsModel];
    
    ASIDownloadCache *cache = [[ASIDownloadCache alloc]init];
    
    self.downCache = cache;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
  //  [self.downCache setStoragePath:[documentDirectory stringByAppendingPathComponent:@"resource"]];
//    [self.downCache setStoragePath:[documentDirectory stringByAppendingPathComponent:@"resource"]];
    //[self.downCache setStoragePath:documentDirectory];
//    [self.downCache setDefaultCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
    

//    [self.downCache setStoragePath:[documentDirectory stringByAppendingPathComponent:@"resoure"]];
//[self.downloadCache setStoragePath:documentDirectory];
//    [self.downCache setDefaultCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) uncaughtExceptionHandler: (NSException *)exception{
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@",[exception callStackSymbols]);
}


//实现推送
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    NSLog(@"NSS %@",NSStringFromSelector(_cmd));
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    NSLog(@"NSS %@",NSStringFromSelector(_cmd));
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PushMsg" object:nil userInfo:userInfo];
    
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    NSString *stringToken = [[[[deviceToken description]
                               stringByReplacingOccurrencesOfString: @"<"
                               withString: @""]
                              stringByReplacingOccurrencesOfString: @">"
                              withString: @""]
                             stringByReplacingOccurrencesOfString: @" "
                             withString: @""];
    NSLog(@"stringToken: %@",stringToken);
}

//检测网络变化
- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if (status == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"出错啦！" message:@"网络无法连接。" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
    }
}


@end
