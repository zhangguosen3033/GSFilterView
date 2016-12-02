//
//  SelectBtn.h
//  GSFilterViewdemo
//
//  Created by ygkj on 16/12/2.
//  Copyright © 2016年 ygkj. All rights reserved.

#import <Foundation/Foundation.h>
#import "ModelBtn.h"

@interface SelectBtn : NSObject


@property(nonatomic,strong) ModelBtn *modelBtn;

+(instancetype)sharedManager;

@end
