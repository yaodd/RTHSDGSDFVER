//
//  SingleChooseCourseDataObject.h
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by 王智锐 on 1/2/14.
//  Copyright (c) 2014 yaodd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleChooseCourseDataObject : NSObject

@property BOOL haveselected;//yes 代表已选，反之未选。
@property int cid;
@property (nonatomic,strong)NSArray *teacherArr;
@property (nonatomic,strong)NSString *courseTitle;
//@property (nonatomic,strong)NSString *courseContent;
@property (nonatomic,strong)NSString *startdate;
@property (nonatomic,strong)NSString *enddate;
@property (nonatomic,strong)NSString *contentShortView;
@property (nonatomic,strong)NSString *teacherShortView;
@property int nowChooseNum;
@property int maxChooseNum;

@end
