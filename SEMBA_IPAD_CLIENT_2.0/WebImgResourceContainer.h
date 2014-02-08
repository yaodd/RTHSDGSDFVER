//
//  WebImgResourceContainer.h
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by 王智锐 on 1/24/14.
//  Copyright (c) 2014 yaodd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "AppDelegate.h"

@interface WebImgResourceContainer : NSOperation

@property (nonatomic,strong)NSURL *resourceURL;
@property (nonatomic,strong)NSObject *hostObject;
@property (nonatomic,assign)SEL resourceDidReceive;
@property (nonatomic,assign)AppDelegate *appDelegate;
@property (nonatomic,strong)ASIHTTPRequest *httpRequest;
@property (nonatomic,strong)UIImageView *imageView;

-(void)didStartHttpRequest:(ASIHTTPRequest *)request;
-(void)didFinishHttpRequest:(ASIHTTPRequest *)request;
-(void)didFailedHttpRequest:(ASIHTTPRequest *)request;

-(void)cancelResourceGet;

-(void)resourceDidReceive:(NSData*)resource;

@end
