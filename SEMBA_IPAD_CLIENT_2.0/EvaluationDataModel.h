//
//  EvaluationDataModel.h
//  SEMBA_IPAD_CLIENT_2.0
//
//  Created by 王智锐 on 12/23/13.
//  Copyright (c) 2013 yaodd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EvaluationDataModel : NSObject

@property (nonatomic) int eid;
@property (nonatomic) int tid;
@property (nonatomic) int cid;
@property (nonatomic,strong) NSString *teacherName;
@property (nonatomic,strong) NSString *courseName;
@end
