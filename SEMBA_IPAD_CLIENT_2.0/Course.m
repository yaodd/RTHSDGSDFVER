//
//  Course.m
//  ;
//
//  Created by 王智锐 on 13-9-18.
//  Copyright (c) 2013年 王智锐. All rights reserved.
//

#import "Course.h"

@implementation Course

@synthesize courseName,courseDescription,teacher,fileArr,cid;
@synthesize startTime = _startTime;
@synthesize endTime = _endTime;
+(id)alloc{
    return [super alloc];
}

-(id)init{
    if(self = [super init]){
        cid = 0;
        fileArr = [[NSMutableArray alloc] init];
        courseName = @"";
        courseDescription = @"";
        _startTime = @"";
        _endTime = @"";
        _location = @"";
        return self;
    }
    return nil;
}


@end
