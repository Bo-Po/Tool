//
//  CALayer+Frame.h
//  ziyingshopping
//
//  Created by 州龚 on 2020/1/9.
//  Copyright © 2020 rzx. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (Frame)

@property (assign, nonatomic) CGFloat    cp_top;
@property (assign, nonatomic) CGFloat    cp_bottom;
@property (assign, nonatomic) CGFloat    cp_left;
@property (assign, nonatomic) CGFloat    cp_right;

@property (assign, nonatomic) CGFloat    cp_x;
@property (assign, nonatomic) CGFloat    cp_y;
@property (assign, nonatomic) CGPoint    cp_origin;

@property (assign, nonatomic) CGFloat    cp_width;
@property (assign, nonatomic) CGFloat    cp_height;
@property (assign, nonatomic) CGSize     cp_size;

@end

NS_ASSUME_NONNULL_END
