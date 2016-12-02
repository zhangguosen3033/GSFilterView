//
//  SelectBtn.m
//  GSFilterViewdemo
//
//  Created by ygkj on 16/12/2.
//  Copyright © 2016年 ygkj. All rights reserved.

#import "SelectBtn.h"

@implementation SelectBtn

+(instancetype)sharedManager {
    static SelectBtn *share_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        share_manager = [[self alloc]init];
        share_manager.modelBtn = [ModelBtn new];
        
    });
    return share_manager;
}


@end
