//
//  UITableViewCell+CPExtend.h
//  ziyingshopping
//
//  Created by 州龚 on 2020/1/9.
//  Copyright © 2020 rzx. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIcon     @"CPExtendCellPic"
#define kCellText    @"cellText"
#define kCellSubText @"cellSubText"
#define keyCellAlias   @"cellAlias"

@interface UITableViewCell (CPExtend)

@property (nonatomic, copy, class, readonly, nonnull) NSString *signUnique;

@end
