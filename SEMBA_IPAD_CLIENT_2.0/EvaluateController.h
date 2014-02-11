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

@interface EvaluateController : UIViewController<UIScrollViewDelegate,HeroSelectDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *teacherHead;
@property (strong, nonatomic) IBOutlet UILabel *courseAndTeacherName;
@property (strong, nonatomic) IBOutlet UITextView *courseDescription;
@property (nonatomic,strong)HeroSelectView *selectView;
//@property (nonatomic,strong)NSMutableArray *scoreArray;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *classDateLabel;
@property (nonatomic,strong)NSMutableArray *evaluateDataArray;
@property (strong, nonatomic) IBOutlet UITextView *suggestTextView;
@property (strong, nonatomic) IBOutlet UIButton *upEvaluationButton;
@property (strong, nonatomic) IBOutlet UILabel *classNumLabel;
@property (strong, nonatomic) UIView *scoreView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *scoreCollect;
@property (nonatomic, retain) NSMutableDictionary *scoreDict;

- (IBAction)scoreButtonAction:(id)sender;
@end
