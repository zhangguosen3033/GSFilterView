//
//  GSFilterView.h
//  GSFilterViewdemo
//
//  Created by ygkj on 16/12/2.
//  Copyright © 2016年 ygkj. All rights reserved.

#import <UIKit/UIKit.h>
#import "DKFilterSectionHeaderView.h"
#import "GSMacros.h"
#import "DKFilterModel.h"
@protocol DKFilterViewDelegate <NSObject>

@optional
- (NSInteger)getCustomSectionHeaderHeight;
- (DKFilterSectionHeaderView *)getCustomSectionHeader;
- (void)didClickAtModel:(DKFilterModel *)data;
@end

@interface GSFilterView : UIView
@property (nonatomic,strong) NSArray *filterModels;
@property (nonatomic,weak) id<DKFilterViewDelegate> delegate;
@property (nonatomic,strong) UITableView *tableView;
@end
