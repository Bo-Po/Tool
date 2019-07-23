//
//  BaseModel.h
//  TianjinTrip
//
//  Created by Mac on 2017/10/24.
//  实现实例的基础model，所有model尽量都继承BaseModel
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef kIsShowLog
#define kIsShowLog NO
#endif

@class CPProperty;
@interface BaseModel : NSObject<NSCoding>

/// 实例与字典互转
+ (instancetype)objcetWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionary;

/// 属性与key的对照关系
- (NSDictionary *)propertyFormKey;

/// 获取实例的所有属性
- (NSArray<CPProperty *> *)getPropertyList;

/// 存储到本地UserDefaults
+(void)setModel:(id)obj forKey:(NSString *)key;
+(id)modelForKey:(NSString *)key;

@end

// 属性的实例
@interface CPProperty : NSObject

@property (nonatomic, copy) NSString *name; // 属性名
@property (nonatomic, copy) NSString *type; // 属性类型
@property (nonatomic, assign) BOOL isLayIn; // 是否可以直接存储

@end
