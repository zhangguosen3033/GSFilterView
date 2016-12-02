//
//  GSFilterCell.h
//  GSFilterViewdemo
//
//  Created by ygkj on 16/12/2.
//  Copyright © 2016年 ygkj. All rights reserved.

#import <UIKit/UIKit.h>
@class DKFilterModel;

@interface GSFilterCell : UIView

@property (nonatomic,assign) NSInteger buttonWidth;
@property (nonatomic,assign) NSInteger buttonHeight;
@property (nonatomic,assign) NSInteger paddingHorizontal;
@property (nonatomic,assign) NSInteger paddingVertical;
@property (nonatomic,assign) NSInteger paddingBottom;
@property (nonatomic,assign) CGFloat maxViewWidth;
@property (nonatomic,strong) UIColor *buttonNormalColor;
@property (nonatomic,strong) UIColor *buttonTitleColor;
@property (nonatomic,strong) UIColor *buttonHighlightColor;
@property (nonatomic,strong) UIColor *buttonNormalBorderColor;
@property (nonatomic,strong) UIColor *buttonSelectBorderColor;

@property (nonatomic,strong) UIColor *buttonSelectBackGroundColor;
@property (nonatomic,strong) UIColor *buttonNormalBackGroundColor;


- (instancetype)init:(DKFilterModel *) model Width:(CGFloat) width;
- (CGFloat)getEstimatedHeight;
- (void)setSelectedChoice:(NSString *)choice;
- (NSArray *)getSelectedValues;
@end


