//
//  GSFilterCell.m
//  GSFilterViewdemo
//
//  Created by ygkj on 16/12/2.
//  Copyright © 2016年 ygkj. All rights reserved.

#import "GSFilterCell.h"
#import "DKFilterModel.h"
#import "GSMacros.h"
#import "ModelBtn.h"
#import "SelectBtn.h"

@interface GSFilterCell()
{
    
    NSInteger BtnlineNum;
    CGFloat Btnx;
    CGFloat totalHeight;
    
    CGFloat oneLineBtnWidtnLimit;
    CGFloat btnGap;
    CGFloat btnGapY;
    CGFloat BtnHeight;
    CGFloat minBtnLength;
    CGFloat maxBtnLength;
    
    NSMutableArray *rowHeigtharray;
}
@property (nonatomic,strong) NSMutableArray *buttons;
@property (nonatomic,strong) NSMutableArray *selectedbuttons;
@property (nonatomic,weak) DKFilterModel *filterData;

@property (nonatomic,strong) UIButton *selectingButton;


@end

@implementation GSFilterCell

- (instancetype)init{
    if (self = [super init]) {
        
        
        //颜色的设置
        self.buttonNormalColor = GS_NORMALTITLE_COLOR;   //未选中标题颜色
        self.buttonHighlightColor = GS_SELECTTITLE_COLOR; //选中标题颜色
        self.buttonNormalBorderColor =GS_NORMALBORDER_COLOR; //未选中边框颜色
        self.buttonSelectBorderColor = GS_SELECTBORDER_COLOR; //选中边框颜色
        self.buttonSelectBackGroundColor = GS_SELECTBACKGROUND_COLOR; //选中按钮的背景色
        self.buttonNormalBackGroundColor = GS_NORMALBACKGROUND_COLOR;//未选中按钮背景颜色
        
        rowHeigtharray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (instancetype)init:(DKFilterModel *) model Width:(CGFloat) width{
    if (self = [self init]) {
        _filterData = model;
        _maxViewWidth = width;
        _selectedbuttons = [[NSMutableArray alloc] initWithCapacity:5];
        _buttons = [[NSMutableArray alloc] initWithCapacity:_filterData.elements.count];
        
        UIView *subView = [UIView new]; // If there is no subview
        subView.tag = 444;              //it won't invoke layoutSubviews
        [self addSubview:subView];      //it will be removed after buttons initialization
        
    }
    return self;
}

- (void)initButtons{ 
    
    [_buttons removeAllObjects];
    
    totalHeight = 0;
    oneLineBtnWidtnLimit = SCREEN_WIDTH - 30;//每行btn占的最长长度，超出则换行
    btnGap = 10;//btn的x间距
    btnGapY = 13;
    BtnlineNum = 0;
    BtnHeight = 30;
    minBtnLength =  40;//每个btn的最小长度
    maxBtnLength = oneLineBtnWidtnLimit - btnGap*2;//每个btn的最大长度
    Btnx = 0;//每个btn的起始位置
    
    [_filterData.elements enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    
        Btnx += btnGap;

        CGFloat btnWidth = [self WidthWithString:obj fontSize:14 height:BtnHeight];
        btnWidth += 10;//让文字两端留出间距
        
        if(btnWidth<minBtnLength)
            btnWidth = minBtnLength;
        
        if(btnWidth>maxBtnLength)
            btnWidth = maxBtnLength;
        
        
        if(Btnx + btnWidth > oneLineBtnWidtnLimit)
        {
            BtnlineNum ++;//长度超出换到下一行
            Btnx = btnGap;
        }
        
        UIButton *button = [[UIButton alloc] init];
        
        //Y坐标
        CGFloat height = btnGapY+ (BtnlineNum*(BtnHeight+btnGapY));
        
        NSLog(@"Y坐标-------------%f",height);
        
        button.frame = CGRectMake(Btnx, height,
                               btnWidth,BtnHeight );
        
        button.layer.borderWidth = 1;
        button.layer.cornerRadius = 8;
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.titleLabel.minimumScaleFactor = 0.5;
        [button setTitle:obj forState:UIControlStateNormal];
        [button setTitleColor:self.buttonNormalColor forState:UIControlStateNormal];
        button.layer.borderColor = [self.buttonNormalBorderColor CGColor];
        button.selected = NO;
        button.tag = idx;
        button.titleLabel.font =[UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(buttonSelected:)
         forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [_buttons addObject:button];
        
        Btnx = button.frame.origin.x + button.frame.size.width + btnGap;
        
        totalHeight = height; 
        
    }];
    
}

#pragma mark - self tools
//根据字符串计算宽度
-(CGFloat)WidthWithString:(NSString*)string fontSize:(CGFloat)fontSize height:(CGFloat)height
{
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    return  [string boundingRectWithSize:CGSizeMake(0, height) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size.width;
}



- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    if (_buttons.count !=_filterData.elements.count) {
        
        [self initButtons];
        
        [[self viewWithTag:444] removeFromSuperview];
        
    }
    
    self.frame = CGRectMake(0, 0, _maxViewWidth, [self getEstimatedHeight]);
    
}

- (void)buttonSelected:(UIButton *)button{
    
    self.filterData.clickedButtonText = button.titleLabel.text;
    
    ModelBtn *model = [ModelBtn new];
    model.title = button.titleLabel.text;
//    model.tag = button.tag;
    [SelectBtn sharedManager].modelBtn = model;
    NSLog(@"%ld  %@",(long)[SelectBtn sharedManager].modelBtn.tag,[SelectBtn sharedManager].modelBtn.title);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GS_NOTIFICATION_BUTTON_CLICKED
                                                        object:self.filterData];
    
    if (self.filterData.type == DK_SELECTION_SINGLE) {
        if (button.selected) {
            [button setTitleColor:self.buttonNormalColor forState:UIControlStateNormal];
            button.layer.borderColor = [self.buttonNormalBorderColor CGColor];
            button.selected = NO;
            [button setBackgroundColor:self.buttonNormalBackGroundColor];

            [self.selectedbuttons removeObject:button];
        }else{
            for (UIButton *button in self.selectedbuttons) {
                [button setTitleColor:self.buttonNormalColor forState:UIControlStateNormal];
                button.layer.borderColor = [self.buttonNormalBorderColor CGColor];
                button.selected = NO;
                [button setBackgroundColor:self.buttonNormalBackGroundColor];

            }
            
            [self.selectedbuttons removeAllObjects];
            
            button.layer.borderColor = [self.buttonSelectBorderColor CGColor];
            [button setTitleColor:self.buttonHighlightColor forState:UIControlStateNormal];
            button.selected = YES;
            [button setBackgroundColor:self.buttonSelectBackGroundColor];
            [self.selectedbuttons addObject:button];
        }
        
    }else if(self.filterData.type == DK_SELECTION_MULTIPLE){
        if (button.selected) {
            [button setTitleColor:self.buttonNormalColor forState:UIControlStateNormal];
            button.layer.borderColor = [self.buttonNormalBorderColor CGColor];
            button.selected = NO;
            [button setBackgroundColor:self.buttonNormalBackGroundColor];

            [self.selectedbuttons removeObject:button];
        }else{
            button.layer.borderColor = [self.buttonSelectBorderColor CGColor];
            [button setTitleColor:self.buttonHighlightColor forState:UIControlStateNormal];
            button.selected = YES;
            [button setBackgroundColor:self.buttonSelectBackGroundColor];
            [self.selectedbuttons addObject:button];
        }
    }else if(self.filterData.type == DK_SELECTION_PICK){
        
        if (button.selected) {
            [button setTitleColor:self.buttonNormalColor forState:UIControlStateNormal];
            button.layer.borderColor = [self.buttonSelectBorderColor CGColor];
            button.selected = NO;
            [button setBackgroundColor:self.buttonNormalBackGroundColor];
            [button setTitle:GS_ADD forState:UIControlStateNormal];
            [self.selectedbuttons removeObject:button];
        }else{
            self.selectingButton = button;
            [[NSNotificationCenter defaultCenter] postNotificationName:GS_NOTIFICATION_PICKITEM
                                                                object:@(self.filterData.tag)];
        }
    }
}

-(CGFloat)getEstimatedHeight{
    
    return totalHeight + 45;

}

- (void)setSelectedChoice:(NSString *)choice{
    if(self.selectingButton){
        [self.selectingButton setTitle:choice forState:UIControlStateNormal];
        self.selectingButton.layer.borderColor = [self.buttonSelectBorderColor CGColor];
        [self.selectingButton setTitleColor:self.buttonHighlightColor forState:UIControlStateNormal];
        self.selectingButton.selected = YES;
        [self.selectedbuttons addObject:self.selectingButton];
    }
    self.selectingButton = nil;
}

- (NSArray *)getSelectedValues{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (UIButton *button in self.selectedbuttons) {
        [array addObject:button.titleLabel.text];
    }
    return array;
}

@end
