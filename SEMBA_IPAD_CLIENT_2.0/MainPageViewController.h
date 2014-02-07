//
//  MainPageViewController.h
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by yaodd on 13-10-28.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainPageViewController : UIViewController

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIImageView *mainImageView;
@property (nonatomic, retain) UIImageView *courseImageView;
@property (nonatomic, retain) UILabel *courseLabel;
@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) UILabel *teachLabel;
@property (nonatomic, retain) UILabel *classRoomLabel;
@property (nonatomic, retain) UIButton *courseButton;
@property (nonatomic, retain) NSArray *courseArray;
//获取图片的线程类。
@property (nonatomic,retain)NSOperationQueue *requestImageQuque;
//存放获取资源
@property(nonatomic,strong)NSMutableArray *originalIndexArray;
@property(nonatomic,strong)NSMutableDictionary *originalOperationDic;


-(void)displayProductImage;

-(void)displayImageByIndex:(NSInteger)index ByImageURL:(NSURL*)url;

-(void)imageDidReceive:(UIImageView*)imageView;


@end
