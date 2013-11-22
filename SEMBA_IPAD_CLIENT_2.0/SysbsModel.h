//
//  SysbsModel.h
//  SYSBS_EMBA_IPAD_CLIENT
//
//  Created by 王智锐 on 11/11/13.
//  Copyright (c) 2013 yaodd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Course.h"
#import "File.h"
#import "RecommendBook.h"
#import "MyCourse.h"

@class SysbsModel;

@interface SysbsModel : NSObject

@property (nonatomic,strong)User *user;
@property (nonatomic,strong)MyCourse *myCourse;

+(SysbsModel*)getSysbsModel;
-(User*)getUser;
-(void)setUser:(User*)tempUser;
-(MyCourse*)getMyCourse;
-(void)setCourses:(MyCourse*)tempMyCourse;

@end

