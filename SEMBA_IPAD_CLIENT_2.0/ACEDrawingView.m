/*
 * ACEDrawingView: https://github.com/acerbetti/ACEDrawingView
 *
 * Copyright (c) 2013 Stefano Acerbetti
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "ACEDrawingView.h"
#import "ACEDrawingTools.h"

#import <QuartzCore/QuartzCore.h>

#define kDefaultLineColor       [UIColor blackColor]
#define kDefaultLineWidth       10.0f
#define kDefaultLineAlpha       1.0f
#define WAITING_TIME 0.001f
// experimental code
#define PARTIAL_REDRAW          0

@interface ACEDrawingView () {
    CGPoint currentPoint;
    CGPoint previousPoint1;
    CGPoint previousPoint2;
    
    BOOL firstTouch;
}

@property (nonatomic, strong) NSMutableArray *pathArray;
@property (nonatomic, strong) NSMutableArray *bufferArray;
@property (nonatomic, strong) id<ACEDrawingTool> currentTool;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, retain) UIImage *testImage;



@end

#pragma mark -

@implementation ACEDrawingView
//@synthesize undoImageArr;
//@synthesize redoImageArr;
@synthesize testImage;
@synthesize thread;


- (id)initWithFrame:(CGRect)frame
{
//    NSLog(@"frame");
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame :(UIImage *)image{
    
    if (self = [super initWithFrame:frame]){
        
        [self configure];
        self.image = image;
        self.testImage = [UIImage imageNamed:@"faderKey.png"];
        //将原来有的image加到需要存的数组里，作为上次画的image
        if (image != nil) {
//            [undoImageArr addObject:image];
        }
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
//    NSLog(@"coder");
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)configure
{
//    NSLog(@"configure");
    // init the private arrays
    firstTouch= YES;
//    thread = [[NSThread alloc]initWithTarget:self selector:@selector(waiting:) object:nil];
    self.pathArray = [NSMutableArray array];
    self.bufferArray = [NSMutableArray array];
    
//    self.undoImageArr = [[NSMutableArray alloc]init];
//    self.redoImageArr = [[NSMutableArray alloc]init];
    
    // set the default values for the public properties
    self.lineColor = kDefaultLineColor;
    self.lineWidth = kDefaultLineWidth;
    self.lineAlpha = kDefaultLineAlpha;
    
    // set the transparent background
    self.backgroundColor = [UIColor clearColor];
    
}


#pragma mark - Drawing
//划线调用这里
- (void)drawRect:(CGRect)rect
{
//    NSLog(@"drawRect");
    
#if PARTIAL_REDRAW
//    NSLog(@"drawRect1");
    // TODO: draw only the updated part of the image
    
    
    [self drawPath];
#else
//    NSLog(@"drawRect2");
    //这里是画当前的image，更新画布
    
    [self.image drawInRect:self.bounds];
    
    [self.currentTool draw];
    
#endif
}





- (void)updateCacheImage:(BOOL)redraw
{
//    NSLog(@"update");
    // init a context
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
//    [self.image drawAtPoint:CGPointZero];
    
    //undo和redo调用这里
    if (redraw) {
        // erase the previous image
//        self.image = nil;
        
        // I need to redraw all the lines
        //undo和redo不仅要重画线条，还要重画背景，防止原本保存的背景被清掉
//        if ([undoImageArr count] > 0) {
//            UIImage *currentImage = [undoImageArr objectAtIndex:[undoImageArr count] - 1];
//            [currentImage drawAtPoint:CGPointZero];
//        }
       
        for (id<ACEDrawingTool> tool in self.pathArray) {
            [tool draw];
        }
        
    } else {//画完线调用这里
        // set the draw point
        [self.image drawAtPoint:CGPointZero];
        [self.currentTool draw];
        
        
//        [undoImageArr addObject:UIGraphicsGetImageFromCurrentImageContext()];
        
    }
    
    
    // store the image
    
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
}

- (id<ACEDrawingTool>)toolWithCurrentSettings
{
    switch (self.drawTool) {
        case ACEDrawingToolTypePen:
        {
            return ACE_AUTORELEASE([ACEDrawingPenTool new]);
        }
            
        case ACEDrawingToolTypeLine:
        {
            return ACE_AUTORELEASE([ACEDrawingLineTool new]);
        }
            
        case ACEDrawingToolTypeRectagleStroke:
        {
            ACEDrawingRectangleTool *tool = ACE_AUTORELEASE([ACEDrawingRectangleTool new]);
            tool.fill = NO;
            return tool;
        }
            
        case ACEDrawingToolTypeRectagleFill:
        {
            ACEDrawingRectangleTool *tool = ACE_AUTORELEASE([ACEDrawingRectangleTool new]);
            tool.fill = YES;
            return tool;
        }
            
        case ACEDrawingToolTypeEllipseStroke:
        {
            ACEDrawingEllipseTool *tool = ACE_AUTORELEASE([ACEDrawingEllipseTool new]);
            tool.fill = NO;
            return tool;
        }
            
        case ACEDrawingToolTypeEllipseFill:
        {
            ACEDrawingEllipseTool *tool = ACE_AUTORELEASE([ACEDrawingEllipseTool new]);
            tool.fill = YES;
            return tool;
        }
            
        case ACEDrawingToolTypeEraser:
        {
            return ACE_AUTORELEASE([ACEDrawingEraserTool new]);
        }
    }
}


#pragma mark - Touch Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // init the bezier path
    
    self.currentTool = [self toolWithCurrentSettings];
    self.currentTool.lineWidth = self.lineWidth;
    self.currentTool.lineColor = self.lineColor;
    self.currentTool.lineAlpha = self.lineAlpha;
    [self.pathArray addObject:self.currentTool];
    
    // add the first touch
    UITouch *touch = [touches anyObject];
    
    previousPoint1 = [touch previousLocationInView:self];
    currentPoint = [touch locationInView:self];
    
    [self.currentTool setInitialPoint:currentPoint];
    
    // call the delegate
    if ([self.delegate respondsToSelector:@selector(drawingView:willBeginDrawUsingTool:)]) {
        [self.delegate drawingView:self willBeginDrawUsingTool:self.currentTool];
    }
    [self.delegate intoDrawState:self];
    
    if (!self.thread.isCancelled && !firstTouch) {
        [self.thread cancel];
        NSLog(@"cancel");
    }
    firstTouch = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // save all the touches in the path
    UITouch *touch = [touches anyObject];
    
    previousPoint2 = previousPoint1;
    previousPoint1 = [touch previousLocationInView:self];
    currentPoint = [touch locationInView:self];
    
    if ([self.currentTool isKindOfClass:[ACEDrawingPenTool class]]) {
        CGRect bounds = [(ACEDrawingPenTool*)self.currentTool addPathPreviousPreviousPoint:previousPoint2 withPreviousPoint:previousPoint1 withCurrentPoint:currentPoint];
        
        CGRect drawBox = bounds;
        drawBox.origin.x -= self.lineWidth * 2.0;
        drawBox.origin.y -= self.lineWidth * 2.0;
        drawBox.size.width += self.lineWidth * 4.0;
        drawBox.size.height += self.lineWidth * 4.0;
        
        [self setNeedsDisplayInRect:drawBox];
        
    }
    else {
        
        [self.currentTool moveFromPoint:previousPoint1 toPoint:currentPoint];
        [self setNeedsDisplay];
        
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // make sure a point is recorded
    [self touchesMoved:touches withEvent:event];
    
    // update the image
    [self updateCacheImage:NO];
    
    // clear the current tool
    self.currentTool = nil;
    
    // clear the redo queue
    [self.bufferArray removeAllObjects];
    
    // call the delegate
    if ([self.delegate respondsToSelector:@selector(drawingView:didEndDrawUsingTool:)]) {
        [self.delegate drawingView:self didEndDrawUsingTool:self.currentTool];
    }
    if ([thread isExecuting]) {
        [thread cancel];
        [NSThread exit];
    }
    thread = [[NSThread alloc]initWithTarget:self selector:@selector(waiting:) object:nil];
    [thread start];
    NSLog(@"start");
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // make sure a point is recorded
    [self touchesEnded:touches withEvent:event];
    [self.delegate cancelDrawState:self];
}

- (void)waiting:(NSThread *)thread
{
    for (int i = 0; i < 1000; i ++) {
        [NSThread sleepForTimeInterval:WAITING_TIME];
        if ([[NSThread currentThread] isCancelled])
            return;
    }
    [self performSelectorOnMainThread:@selector(threadFinish) withObject:nil waitUntilDone:YES];
    NSLog(@"no stop");
    
}
- (void)threadFinish
{
    [self.delegate cancelDrawState:self];
}


#pragma mark - Actions

- (void)clear
{
    [self.bufferArray removeAllObjects];
    [self.pathArray removeAllObjects];
//    [self.undoImageArr removeAllObjects];
//    [self.redoImageArr removeAllObjects];
    [self updateCacheImage:YES];
    [self setNeedsDisplay];
}


#pragma mark - Undo / Redo

- (NSUInteger)undoSteps
{
    return self.bufferArray.count;
}

- (BOOL)canUndo
{
    return self.pathArray.count > 0;
}

- (void)undoLatestStep
{
    if ([self canUndo]) {
        
//        UIImage *image = [self.undoImageArr lastObject];
//        [self.redoImageArr addObject:image];
//        if ([undoImageArr count] > 0) {
//            [self.undoImageArr removeLastObject];
//        }
        
        
        id<ACEDrawingTool>tool = [self.pathArray lastObject];
        [self.bufferArray addObject:tool];
        [self.pathArray removeLastObject];
        [self updateCacheImage:YES];
        [self setNeedsDisplay];
    }
}

- (BOOL)canRedo
{
    return self.bufferArray.count > 0;
}

- (void)redoLatestStep
{
    if ([self canRedo]) {
        
//        UIImage *image = [self.redoImageArr lastObject];
//        [self.undoImageArr addObject:image];
//        if ([redoImageArr count] > 0) {
//            [self.redoImageArr removeLastObject];
//        }
        
        
        id<ACEDrawingTool>tool = [self.bufferArray lastObject];
        [self.pathArray addObject:tool];
        [self.bufferArray removeLastObject];
        [self updateCacheImage:YES];
        [self setNeedsDisplay];
    }
}

#if !ACE_HAS_ARC

- (void)dealloc
{
    self.pathArray = nil;
    self.bufferArray = nil;
    self.currentTool = nil;
    self.image = nil;
    
    
    [super dealloc];
}

#endif

@end
