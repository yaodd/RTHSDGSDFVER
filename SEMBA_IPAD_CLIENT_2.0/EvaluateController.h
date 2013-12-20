//
//  EvalutateController.h
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by 欧 展飞 on 13-10-30.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeroSelectView.h"
#import "MRProgressOverlayView.h"

@interface EvaluateController : UIViewController<UIScrollViewDelegate>

@property (nonatomic,strong)HeroSelectView *selectView;
@property (nonatomic,strong)NSMutableArray *scoreArray;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong)NSMutableArray *evaluateDataArray;
@property (strong, nonatomic) IBOutlet UITextView *suggestTextView;

@end
