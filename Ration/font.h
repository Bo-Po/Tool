//
//  font.h
//  TianjinTrip
//
//  Created by mac on 2017/11/14.
//  Copyright © 2017年 Mac. All rights reserved.
//

#ifndef font_h
#define font_h

#define Font_System(a) [UIFont systemFontOfSize:a]
#define Font_System_Bold(a) [UIFont boldSystemFontOfSize:a]
#define Font(a) Font_System(a*.48)
#define Font_Bold(a) Font_System_Bold(a*.48)

// nav title
#define kFont_nav_title Font_Bold(34.)
#define kFont_secondary_title Font_Bold(30.)

#define kFont_30 Font(30.)
#define kFont_Bold_30 Font_Bold(30.)


#define kFont_24 Font(24.)
#define kFont_26 Font(26.)
#define kFont_30 Font(30.)
#define kFont_68 Font(68.)
#define kFont_72 Font(72.)
#define kFont_80 Font(80.)

#define kFont_Bold_24 Font_Bold(24.)
#define kFont_Bold_26 Font_Bold(26.)
#define kFont_Bold_30 Font_Bold(30.)
#define kFont_Bold_68 Font_Bold(68.)
#define kFont_Bold_72 Font_Bold(72.)
#define kFont_Bold_80 Font_Bold(80.)


#define kFont_System_13 Font_System(13.)
#define kFont_System_15 Font_System(15.)

#define kFont_System_Bold_13 Font_System_Bold(13.)
#define kFont_System_Bold_15 Font_System_Bold(15.)

#endif /* font_h */
