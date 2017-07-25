//
//  FontAndColorMacros.h
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/18.
//  Copyright © 2017年 徐阳. All rights reserved.
//

//字体大小和颜色配置

#ifndef FontAndColorMacros_h
#define FontAndColorMacros_h

#pragma mark -  颜色区
/** rgb颜色转换（16进制->10进制）*/
#define COLOR_WITH_HEX(rgbValue ,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

/** 带有RGBA的颜色设置 */
#define COLOR_WITH_RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

/** 透明色 */
#define CLEAR_COLOR [UIColor clearColor]

/** 常用颜色 */
#define WHITE_COLOR [UIColor whiteColor]
#define BLACK_COLOR [UIColor blackColor]
#define RED_COLOR [UIColor redColor]
#define BLUE_COLOR [UIColor blueColor]
#define GREEN_COLOR [UIColor greenColor]
#define GRAY_COLOR [UIColor grayColor]
#define ORANGE_COLOR [UIColor orangeColor]
#define PURPLE_COLOR [UIColor purpleColor]

/** 设置页面的背景颜色 */
#define SETTING_BACKGROUND_COLOR COLOR_WITH_HEX(0xf5f5f5, 1)

/** 未连接时的背景颜色 */
#define DISCONNECT_BACKGROUND_COLOR COLOR_WITH_RGBA(46.0, 52.0, 62.0, 1)
/** 连接时的背景颜色 */
#define CONNECT_BACKGROUND_COLOR COLOR_WITH_RGBA(36.0, 154.0, 184.0, 1)

/** 未连接时的刻度盘颜色 */
#define DISCONNECT_DIAL_COLOR COLOR_WITH_RGBA(61.0, 66.0, 67.0, 1)
/** 连接时的刻度盘颜色 */
#define CONNECT_DIAL_COLOR COLOR_WITH_RGBA(124.0, 204.0, 218.0, 1)

/** navigationBar 的颜色 */
#define NAVIGATION_BAR_COLOR COLOR_WITH_HEX(0x2196f3, 1)

/** tableView 线的颜色 */
#define TABLEVIEW_LINE_COLOR COLOR_WITH_HEX(0xcccccc,1)

/** 按钮的绿色 */
//#define kButtonGreenColor COLOR_WITH_HEX(0x18db30,1)

/** 底部通知栏的颜色 */
#define STATE_BAR_BACKGROUND_COLOR COLOR_WITH_HEX(0xf5f5f5,1)

//绿色主题
#define CNavBgColor  [UIColor colorWithHexString:@"00acc1"]
#define CNavBgFontColor  [UIColor colorWithHexString:@"ffffff"]

//默认页面背景色
#define CViewBgColor [UIColor colorWithHexString:@"fcfcfc"]

//分割线颜色
#define CLineColor [UIColor colorWithHexString:@"ededed"]

//次级字色
#define CFontColor1 [UIColor colorWithHexString:@"1f1f1f"]

//再次级字色
#define CFontColor2 [UIColor colorWithHexString:@"5c5c5c"]

/** 文字的颜色 --> 0.87 */
#define TEXT_BLACK_COLOR_LEVEL4 COLOR_WITH_HEX(0x000000,0.87)
/** 文字的颜色 --> 0.54 */
#define TEXT_BLACK_COLOR_LEVEL3 COLOR_WITH_HEX(0x000000,0.54)
/** 文字的颜色 --> 0.38 */
#define TEXT_BLACK_COLOR_LEVEL2 COLOR_WITH_HEX(0x000000,0.38)
/** 文字的颜色 --> 0.15 */
#define TEXT_BLACK_COLOR_LEVEL1 COLOR_WITH_HEX(0x000000,0.15)
/** 文字的颜色 --> 0.05 */
#define TEXT_BLACK_COLOR_LEVEL0 COLOR_WITH_HEX(0x000000,0.05)

/** 文字的颜色 --> 0.87 */
#define TEXT_WHITE_COLOR_LEVEL4 COLOR_WITH_HEX(0xffffff,0.87)
/** 文字的颜色 --> 0.54 */
#define TEXT_WHITE_COLOR_LEVEL3 COLOR_WITH_HEX(0xffffff,0.54)
/** 文字的颜色 --> 0.38 */
#define TEXT_WHITE_COLOR_LEVEL2 COLOR_WITH_HEX(0xffffff,0.38)
/** 文字的颜色 --> 0.15 */
#define TEXT_WHITE_COLOR_LEVEL1 COLOR_WITH_HEX(0xffffff,0.15)
/** 文字的颜色 --> 0.05 */
#define TEXT_WHITE_COLOR_LEVEL0 COLOR_WITH_HEX(0xffffff,0.05)


#pragma mark -  字体区


#define FFont1 [UIFont systemFontOfSize:12.0f]

#endif /* FontAndColorMacros_h */
