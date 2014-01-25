//
//  WebImgResourceContainer.m
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by 王智锐 on 1/24/14.
//  Copyright (c) 2014 yaodd. All rights reserved.
//

#import "WebImgResourceContainer.h"

@implementation WebImgResourceContainer

@synthesize resourceURL = _resourceURL;
@synthesize hostObject = _hostObject;
@synthesize resourceDidReceive = _resourceDidReceive;
@synthesize appDelegate = _appDelegate;
@synthesize httpRequest = _httpRequest;
@synthesize imageView = _imageView;

-(id)init{
    if(self == [super init]){
        self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    }
    return self;
}

-(void)main{
    if(self.hostObject == Nil)
        return;
    
    if (self.resourceURL == nil){
        [self resourceDidReceive];
        return;
    }
    NSLog(@"main invoke");
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:self.resourceURL];
    self.httpRequest = request;
    
    [self.httpRequest setDownloadCache:self.appDelegate.downCache];
    [self.httpRequest setDelegate:self];
    NSLog(@"before start");
    [self.httpRequest setDidStartSelector:@selector(didStartHttpRequest:)];
    NSLog(@"before finish");
    [self.httpRequest setDidFinishSelector:@selector(didFinishHttpRequest:)];
    NSLog(@"before failed");
    [self.httpRequest setDidFailSelector:@selector(didFailedHttpRequest:)];
    [self.httpRequest startAsynchronous];
    NSLog(@"start asynchronous");
}

-(void)didStartHttpRequest:(ASIHTTPRequest *)request{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSLog(@"start");
}

-(void)didFinishHttpRequest:(ASIHTTPRequest *)request{
    [[UIApplication sharedApplication ]setNetworkActivityIndicatorVisible:NO];
    if( [request responseStatusCode ] == 200 || [request responseStatusCode ] == 304){
        if([request didUseCachedResponse]){
            NSLog(@"资源请求：%@来自缓存====",self.resourceURL);
            
        }else{
            NSLog(@"不来自缓存");
        }
        [self resourceDidReceive:[request responseData]];
    }else{
        [self resourceDidReceive:nil];
    }
    NSLog(@"finish");
}

-(void)didFailedHttpRequest:(ASIHTTPRequest *)request{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self resourceDidReceive:nil];
}

-(void)cancelResourceGet{
    [self.httpRequest cancel];
}

-(void)resourceDidReceive:(NSData *)resource{
    NSLog(@"resourceReceive");
    if([self.hostObject respondsToSelector:_resourceDidReceive]){
        if(resource != nil && self.imageView != nil) {
            self.imageView.image = [UIImage imageWithData:resource];
        }
        [self.hostObject performSelectorOnMainThread:_resourceDidReceive withObject:_imageView waitUntilDone:NO];
    }
}

@end
