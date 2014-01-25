//
//  Course.h
//  testJson
//
//  Created by 王智锐 on 13-9-18.
//  Copyright (c) 2013年 王智锐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Course : NSObject{
    
    
}
@property int cid;
@property (strong,nonatomic)NSString *courseName;
@property (strong,nonatomic)NSString *courseDescription;
//@property (strong,nonatomic)NSString *teacherName;
@property (strong,nonatomic)NSMutableArray *fileArr;
@property (strong,nonatomic)NSString *startTime;
@property (strong,nonatomic)NSString *endTime;
@property (strong,nonatomic)NSString *location;
@property (nonatomic,strong)NSMutableArray *teacher;
@property (nonatomic,strong)NSString *coverUrl;


+(id)alloc;
-(id)init;


@end
