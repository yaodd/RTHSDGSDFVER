//
//  NoteToolDrawerBar.m
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by yaodd on 13-11-8.
//  Copyright (c) 2013年 yaodd. All rights reserved.
//

#import "NoteToolDrawerBar.h"

#define BUTTON_X    0.0f
#define BUTTON_Y    52.0f
#define BUTTON_WIDTH_SMALL    97.0f
#define BUTTON_HEIGHT_SMALL   73.0f
#define BUTTON_WIDTH_LARGE    156.0f
#define BUTTON_HEIGHT_LARGE   88.0f
#define BUTTON_SPACE    10.0f


@implementation NoteToolDrawerBar
@synthesize isOpen;
@synthesize parentView;
@synthesize closePoint;
@synthesize openPoint;
@synthesize parentRect;
@synthesize arrowIV;
@synthesize buttonArray;
@synthesize imageNameNArray;
@synthesize imageNameHArray;

- (id)initWithFrame:(CGRect)frame parentView:(UIView *)parentview
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //初始化抽屉
        self.parentView = parentview;
        parentRect = parentView.frame;
        parentRect.size.width = parentView.frame.size.height;
        parentRect.size.height = parentView.frame.size.width;
        
        UIImageView *background = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ppt_toolbox_bg"]];
        [background setFrame:CGRectMake(0, 0, background.frame.size.width, background.frame.size.height)];
        [self addSubview:background];
        
        UIView *touchView = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width - 40, 0, 40, frame.size.height)];
        [touchView setBackgroundColor:[UIColor clearColor]];

        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        [touchView addGestureRecognizer:panRecognizer];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
        [touchView addGestureRecognizer:tapRecognizer];
        
        [self addSubview:touchView];
        
        arrowIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, frame.size.height / 2 - 20, 40, 40)];
        [arrowIV setBackgroundColor:[UIColor blueColor]];
        [touchView addSubview:arrowIV];
        
        closePoint = CGPointMake(0 - 30, parentRect.size.height / 2);
        openPoint = CGPointMake(frame.size.width / 2, parentRect.size.height / 2);
        self.center = closePoint;
        
        [self initButton];
        
    }
    return self;
}

- (void)initButton{
    imageNameNArray = [[NSMutableArray alloc]initWithObjects:@"ppt_toolbox_colorpicker_bg",@"ppt_toolbox_pencil",@"ppt_toolbox_brush",@"ppt_toolbox_eraser",@"ppt_toolbox_camera",@"ppt_toolbox_recorder", nil];
    imageNameHArray = [[NSMutableArray alloc]initWithObjects:@"ppt_toolbox_colorpicker_bg_active",@"ppt_toolbox_pencil_active",@"ppt_toolbox_brush_active",@"ppt_toolbox_eraser_active",@"ppt_toolbox_camera_active",@"ppt_toolbox_recorder_active", nil];    CGFloat topButtonY = BUTTON_Y;
    buttonArray = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < 6; i ++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(BUTTON_X, topButtonY, BUTTON_WIDTH_SMALL, BUTTON_HEIGHT_SMALL)];
//        [button setBackgroundColor:[UIColor grayColor]];
        UIImage *image = [UIImage imageNamed:[imageNameNArray objectAtIndex:i]];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setTag:i + 1];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttonArray addObject:button];
        [self addSubview:button];
        topButtonY += (BUTTON_HEIGHT_SMALL + BUTTON_SPACE);
    }
}

- (void)buttonAction:(UIButton *)button
{
    [self closeAllButtonExcept:button.tag];
    if (button.selected) {
        [self animationOfButtonClose:button];
    } else{
        [self animationOfButtonOpen:button];
    }
    button.selected = !button.selected;
    
    [self.delegate tappedInNoteToolDrawerBar:self toolAction:button];
}
- (void)closeAllButton{
    for (int i = 0 ; i < [buttonArray count]; i ++) {
        UIButton *otherButton = [buttonArray objectAtIndex:i];
        if (otherButton.selected) {
            [self animationOfButtonClose:otherButton];
            otherButton.selected = NO;
        }
    }
}
- (void)closeAllButtonExcept:(int)index{
    for (int i = 0 ; i < [buttonArray count]; i ++) {
        UIButton *otherButton = [buttonArray objectAtIndex:i];
        if (otherButton.selected && otherButton.tag != index) {
            [self animationOfButtonClose:otherButton];
            otherButton.selected = NO;
        }
    }
}


- (void)animationOfButtonOpen:(UIButton *)button{
    int index = button.tag - 1;
    if (button.tag == 1) {
        return;
    }
    CGRect rect = button.frame;
    rect.origin.y -= 8;
    rect.origin.x = 0;
    rect.size.width += 59;
    rect.size.height += 16;

    [UIView animateWithDuration:0.5 animations:^{
        button.frame = rect;
        
    } completion:^(BOOL finish){
        [button setBackgroundImage:[UIImage imageNamed:[imageNameHArray objectAtIndex:index]] forState:UIControlStateNormal];
    }];
}
- (void)animationOfButtonClose:(UIButton *)button{
    int index = button.tag - 1;
    if (button.tag == 1) {
        return;
    }
    CGRect rect = button.frame;
    rect.origin.y += 8;
    rect.origin.x = 0;
    rect.size.height -= 16;
    rect.size.width -= 59;
    [UIView animateWithDuration:0.3 animations:^{
        button.frame = rect;
    } completion:^(BOOL finish){
        [button setBackgroundImage:[UIImage imageNamed:[imageNameNArray objectAtIndex:index]] forState:UIControlStateNormal];
    }];
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer{
    CGPoint translation = [recognizer translationInView:parentView];
    if (self.center.x + translation.x < closePoint.x) {
        self.center = closePoint;
    }else if(self.center.x + translation.x > openPoint.x)
    {
        self.center = openPoint;
    }else{
        self.center = CGPointMake(self.center.x + translation.x, self.center.y);
    }
    [recognizer setTranslation:CGPointMake(0, 0) inView:parentView];
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.75 delay:0.15 options:UIViewAnimationOptionCurveEaseOut animations:^{
            if (self.center.x < openPoint.x * 1/2) {
                self.center = closePoint;
                [self transformArrow:NO];
            }else
            {
                self.center = openPoint;
                [self transformArrow:YES];
            }
            
        } completion:^(BOOL finish){
            if (!isOpen) {
                
                NSLog(@"open");
            } else{
//                [self.delegate drawerClose:self];
                NSLog(@"close");
            }
        }];
        
    }
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer{
    [self openOrCloseToolBar];
}
- (void)openOrCloseToolBar{
    [UIView animateWithDuration:0.75 delay:0.15 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        if (isOpen) {
            self.center = closePoint;
            [self transformArrow:NO];
        }else
        {
            self.center = openPoint;
            [self transformArrow:YES];
        }
    } completion:^(BOOL finish){
        
    }];
}

- (void)transformArrow:(BOOL)openOrClose{
    
    if (openOrClose) {
        [self.delegate drawerOpen:self];
    } else{
        [self.delegate drawerClose:self];
    }
    [UIView animateWithDuration:0.3 delay:0.35 options:UIViewAnimationOptionCurveEaseOut animations:^{
        if (openOrClose == YES){
            
            arrowIV.transform = CGAffineTransformMakeRotation(M_PI);
        }else
        {
            
            arrowIV.transform = CGAffineTransformMakeRotation(0);
        }
    } completion:^(BOOL finish){
        self.isOpen = openOrClose;
    }];
    
}

- (void)hideNoteToolDrawerBar{
    if (self.hidden == NO)
	{
        NSLog(@"hide");
		[UIView animateWithDuration:0.25 delay:0.0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^(void)
         {
             self.alpha = 0.0f;
         }
                         completion:^(BOOL finished)
         {
             self.hidden = YES;
         }
         ];
	}
    
}

- (void)showNoteToolDrawerBar{
    if (self.hidden == YES)
	{
        NSLog(@"show");
		[UIView animateWithDuration:0.25 delay:0.0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^(void)
         {
             self.hidden = NO;
             self.alpha = 1.0f;
         }
                         completion:NULL
         ];
	}
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
