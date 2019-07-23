//
//  CPPickerView.h
//  test
//
//  Created by mac on 2019/5/13.
//  Copyright © 2019年 bo. All rights reserved.
//  地址选择器

#import <UIKit/UIKit.h>


#define kAddressCode @"code"
#define kAddressName @"name"
#define kAddressCitylist @"citylist"
#define kAddressArealist @"arealist"

NS_ASSUME_NONNULL_BEGIN

@class CPProvinceModel, CPCityModel, CPAreaModel;
typedef void(^DidChangeEnd)(CPProvinceModel *, CPCityModel *, CPAreaModel *);

@interface CPPickerView : UIView

@property (nonatomic, copy, nullable) DidChangeEnd changeEnd;
- (void)setDataSource:(nonnull NSArray *)source;

- (void)show;
- (void)showToView:(nullable UIView *)view;

@end


@interface CPProvinceModel : NSObject <NSCopying,NSMutableCopying>

/** 省对应的code或id */
@property (nonatomic, copy) NSString *code;
/** 省的名称 */
@property (nonatomic, copy) NSString *name;
/** 省的索引 */
@property (nonatomic, assign) NSInteger index;
/** 城市数组 */
@property (nonatomic, strong) NSArray *citylist;

@end


@interface CPCityModel : NSObject <NSCopying,NSMutableCopying>
/** 市对应的code或id */
@property (nonatomic, copy) NSString *code;
/** 市的名称 */
@property (nonatomic, copy) NSString *name;
/** 市的索引 */
@property (nonatomic, assign) NSInteger index;
/** 区数组 */
@property (nonatomic, strong) NSArray *arealist;

@end


@interface CPAreaModel : NSObject <NSCopying,NSMutableCopying>
/** 区对应的code或id */
@property (nonatomic, copy) NSString *code;
/** 区的名称 */
@property (nonatomic, copy) NSString *name;
/** 区的索引 */
@property (nonatomic, assign) NSInteger index;

@end

NS_ASSUME_NONNULL_END
