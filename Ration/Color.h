//
//  Color.h
//  TianjinTrip
//
//  Created by Mac on 2017/10/19.
//  Copyright © 2017年 Mac. All rights reserved.
//

#ifndef Color_h
#define Color_h


#define kColor_main_alpha(a) [UIColor colorWithWhite:1 alpha:a]
#define kColor_main kColor_main_alpha(1.)
#define kColor_alert_btn_title kColor_Map_Line // [UIColor colorWithRed:234./255 green:53./255 blue:45./255 alpha:1]

#define Color_Hex_alpha(color, a) [UIColor colorWithHexString:color alpha:a]
#define Color_Hex(color) [UIColor colorWithHexString:color]

#define kColor_nav_title Color_Hex(@"0x4b4b4b")
#define kColor_btn_gary_title Color_Hex(@"0x878686") // 出租车
#define kColor_btn_blark_title Color_Hex(@"0x876666")

#define kColor_btn_send_back Color_Hex(@"0x434343") // 呼叫背景
#define kColor_wait_text Color_Hex(@"0x727272") // 等待字体颜色
#define kColor_wait_time_text Color_Hex(@"0x46C184") // 等待时间字体颜色

#define kColor_Line Color_Hex(@"0xc7c7c7")


#define kColor_Map_Line Color_Hex(@"0x46C184")

#define kColor_2a Color_Hex(@"0x2a2a2a")
#define kColor_4b Color_Hex(@"0x4b4b4b")
#define kColor_c7 Color_Hex(@"0xcfcfcf")

#endif /* Color_h */
