//
//  CPInsetsTextField.h
//  XZOnLive
//
//  Created by 州龚 on 2019/10/16.
//  Copyright © 2019 clearlove. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CPInsetsTextField : UITextField

    /// 控制字体与控件边界的间距
@property (nonatomic) UIEdgeInsets textInsets;
@property (nonatomic, strong) UIColor *placeholderColor;

@end

NS_ASSUME_NONNULL_END
