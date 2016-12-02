
//
//  GSMacros.h
//  GSFilterViewdemo
//
//  Created by ygkj on 16/12/2.
//  Copyright © 2016年 ygkj. All rights reserved.
//

#ifndef GSMacros_h
#define GSMacros_h

#define RGBCOLOR(_R_, _G_, _B_) [UIColor colorWithRed:(_R_)/255.0 green: (_G_)/255.0 blue: (_B_)/255.0 alpha: 1.0]
#define stringIsEmpty(str) !(str&&str.length)
#define GS_ADD @"+"

#define GS_NORMAL_COLOR RGBCOLOR(189,189,189)//默认的button外面的圈的颜色
#define GS_HL_COLOR RGBCOLOR(104,105,106)//示例点击标题的颜色

#define GS_NOTIFICATION_PICKITEM @"GSNotificationPickItem"
#define GS_NOTIFICATION_BUTTON_CLICKED @"GSFilterButtonClicked"

#define GS_DEFAULT_TITLE_COLOR RGBCOLOR(23,23,23)   //上部标题的颜色

#define GS_SELECTBORDER_COLOR RGBCOLOR(252,61,7)//选中边框颜色
#define GS_NORMALBORDER_COLOR RGBCOLOR(233,234,235)//未选中边框颜色

#define GS_NORMALTITLE_COLOR RGBCOLOR(104,105,106)//未选中标题颜色
#define GS_SELECTTITLE_COLOR RGBCOLOR(255,255,255)//选中标题颜色

#define GS_SELECTBACKGROUND_COLOR RGBCOLOR(252,61,7)//选中按钮背景颜色
#define GS_NORMALBACKGROUND_COLOR RGBCOLOR(255,255,255)//选中按钮背景颜色

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define GS_IMAGINARUYLINE_COLOR RGBCOLOR(109,110,111)//虚线宽度

#define MYRGBCOLOR(_R_, _G_, _B_) [UIColor colorWithRed:(_R_)/255.0 green: (_G_)/255.0 blue: (_B_)/255.0 alpha: 1.0]

#endif /* GSMacros_h */
