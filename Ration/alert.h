//
//  alert.h
//  TianjinTrip
//
//  Created by mac on 2017/10/25.
//  Copyright © 2017年 Mac. All rights reserved.
//

#ifndef alert_h
#define alert_h



#define alertShow(aTitle, aMessage, btnTitle) UIAlertView *alert = [[UIAlertView alloc] initWithTitle:aTitle message:aMessage delegate:nil cancelButtonTitle:btnTitle otherButtonTitles:nil];\
    [alert show];


#define alert_title_msg(aTitle, aMessage) {alertShow(aTitle, aMessage, nil}
#define alert_title_btn(aTitle, btnTitle) {alertShow(aTitle, nil, btnTitle}
#define alert_msg_btn(aMessage, btnTitle) {alertShow(nil, aMessage, btnTitle}
#define alert_title(aTitle) {alertShow(aTitle, nil, nil)}
#define alert_msg(aMessage) {alertShow(nil, aMessage, nil)}


/// 自动消失
#define alert_after_show(aTitle, aMessage, duration) { alertShow(aTitle, aMessage, nil)\
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{\
    [alert dismissWithClickedButtonIndex:0 animated:YES];\
});\
}

#define alert_after_title_msg(aTitle, aMessage, duration) {alert_after_show(aTitle, aMessage, duration}
#define alert_after_title(aTitle, duration) {alert_after_show(aTitle, nil, duration)}
#define alert_after_msg(aMessage, duration) {alert_after_show(nil, aMessage, duration)}
#define alert_after_title_msg(aTitle, aMessage) {alert_after_show(aTitle, aMessage, defaultDuration}
#define alert_after_title(aTitle) {alert_after_show(aTitle, nil, defaultDuration)}
#define alert_after_msg(aMessage) {alert_after_show(nil, aMessage, defaultDuration)}


static CGFloat const defaultDuration = 1.5;

#endif /* alert_h */
