//
//  BaseModel.m
//  TianjinTrip
//
//  Created by Mac on 2017/10/24.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>

@implementation BaseModel

- (NSDictionary *)dictionary {
    unsigned int propertyCount = 0;
    
    ///通过运行时获取当前类的属性
    objc_property_t *propertys = class_copyPropertyList([self class], &propertyCount);
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for (NSUInteger i = 0; i < propertyCount; i++) {
        // 获取属性名称
        const char *propertyName = property_getName(propertys[i]);
        NSString *name = [NSString stringWithUTF8String:propertyName];
        id val = [self valueForKey:name];
        if ([val isKindOfClass:[BaseModel class]]) {
            val = [val dictionary];
        } else {
            if ([val isKindOfClass:[NSArray class]]) {
                if (((NSArray *)val).count != 0) {
                    NSMutableArray *objs = [[NSMutableArray alloc] init];
                    for (id subVal in (NSArray *)val) {
                        if ([subVal isKindOfClass:[BaseModel class]]) {
                            NSDictionary *dict = [subVal dictionary];
                            [objs addObject:dict];
                        }
                    }
                    val = [NSArray arrayWithArray:objs];
                } else {
                    val = nil;
                }
            }
        }
        if (val) {
            [dic setValue:val forKey:name];
        }
    }
    return [[NSDictionary alloc] initWithDictionary:dic];
}

+ (instancetype)objcetWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if(self) {
        unsigned int propertyCount = 0;
        ///通过运行时获取当前类的属性
        objc_property_t *propertys = class_copyPropertyList([self class], &propertyCount);
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        NSDictionary *propertyDic = [self propertyFormKey];
        for (NSUInteger i = 0; i < propertyCount; i++) {
            // 获取属性名称
            const char *propertyName = property_getName(propertys[i]);
            NSString *name = [NSString stringWithUTF8String:propertyName];
            const char *propertyAttr = property_getAttributes(propertys[i]);
            NSString *attr = [NSString stringWithUTF8String:propertyAttr];
            NSArray *arr = [attr componentsSeparatedByString:@"\""];
            Class cla;
            NSString *className;
            if (arr && arr.count>1) {
                cla = NSClassFromString(arr[1]);
                className = arr[1];
            }
            if (kIsShowLog) {
                NSLog(@"Attributes   ==  %@", attr);
                NSLog(@"class  ==  %@    superClass   ==  %@   [self class] == %@", NSStringFromClass(cla), NSStringFromClass(class_getSuperclass(cla)),NSStringFromClass([self class]));
            }
            if ([cla isSubclassOfClass:[BaseModel class]]) {
                NSDictionary *val;
                if (propertyDic[name]) {
                    val = [dictionary valueForKey:propertyDic[name]];
                } else {
                    val = [dictionary valueForKey:name];
                }
                BaseModel *obj = [cla objcetWithDictionary:val];
                [dic setValue:obj forKey:name];
            } else {
                NSArray *array = [className componentsSeparatedByString:@"<"];
                Class subCla;
                NSString *pro;
                if (array && array.count>0) {
                    cla = NSClassFromString(array[0]);
                    if (kIsShowLog) {
                        NSLog(@"cla == %@",array[0]);
                    }
                    if (array.count>1) {
                        pro = array[1];
                        pro = [pro substringToIndex:pro.length-1];
                        if (kIsShowLog) {
                            NSLog(@"por == %@",pro);
                        }
                        subCla = NSClassFromString(pro);
                    }
                }
                if ([cla isSubclassOfClass:[NSArray class]]) {
                    NSArray *val;
                    if (propertyDic[name]) {
                        val = [dictionary valueForKey:propertyDic[name]];
                    } else {
                        val = [dictionary valueForKey:name];
                    }
                    NSMutableArray *objs = @[].mutableCopy;
                    if ([subCla isSubclassOfClass:[BaseModel class]]) {
                        for (NSDictionary *dict in val) {
                            BaseModel *obj = [subCla objcetWithDictionary:dict];
                            [objs addObject:obj];
                        }
                        val = [NSArray arrayWithArray:objs];
                    }
                    [dic setValue:val forKey:name];
                } else {
                    if (propertyDic[name]) {
                        [dic setValue:[dictionary valueForKey:propertyDic[name]] forKey:name];
                    } else {
                        [dic setValue:[dictionary valueForKey:name] forKey:name];
                    }
                }
            }
        }
        [self setValuesForKeysWithDictionary:dic];
    }
    
    return self;
}

- (NSDictionary *)propertyFormKey {
    return [NSDictionary dictionary];
}

- (NSArray<CPProperty *> *)getPropertyList {
    unsigned int propertyCount = 0;
    ///通过运行时获取当前类的属性
    objc_property_t *propertys = class_copyPropertyList([self class], &propertyCount);
    NSMutableArray *ptys = @[].mutableCopy;
    for (NSUInteger i = 0; i < propertyCount; i++) {
        CPProperty *pty = [[CPProperty alloc] init];
        // 获取属性名称
        const char *propertyName = property_getName(propertys[i]);
        NSString *name = [NSString stringWithUTF8String:propertyName];
        pty.name = name;
        const char *propertyAttr = property_getAttributes(propertys[i]);
        NSString *attr = [NSString stringWithUTF8String:propertyAttr];
        // T@"NSString",C,N,V_string 、T^d,N,V_cateList 、T@"CPModel",&,N,V_model 、T@"NSArray",N,V_arr
        pty.type = attr;
        if (kIsShowLog) {
            NSLog(@"pty.name   ==  %@       pty.type   ==  %@", pty.name, pty.type);
        }
        pty.isLayIn = [pty.type containsString:@"@\""];
        
        [ptys addObject:pty];
        
    }
    //释放
    free(propertys);
    
    return ptys;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    for (CPProperty *pty in [self getPropertyList]) {
        if ([self valueForKey:pty.name]) {
            [aCoder encodeObject:[self valueForKey:pty.name] forKey:pty.name];
        }
    }
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        for (CPProperty *pty in [self getPropertyList]) {
            [self setValue:[aDecoder decodeObjectForKey:pty.name] forKey:pty.name];
        }
    }
    return self;
}

// 重写debugDescription, 而不是description （为了在控制台打印出实例的各个属性值）
- (NSString *)description {
    //判断是否时NSArray 或者NSDictionary NSNumber 如果是的话直接返回 debugDescription
    if ([self isKindOfClass:[NSArray class]] || [self isKindOfClass:[NSDictionary class]] || [self isKindOfClass:[NSString class]] || [self isKindOfClass:[NSNumber class]]) {
        return [super description];
    }
    //声明一个字典
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    //得到当前class的所有属性
    NSArray *ptys = [self getPropertyList];
    //循环并用KVC得到每个属性的值
    for (int i = 0; i<ptys.count; i++) {
        NSString *name = ((CPProperty *)ptys[i]).name;
        id value = [self valueForKey:name]?:@"nil";//默认值为nil字符串
        [dictionary setObject:value forKey:name];//装载到字典里
    }
    return [NSString stringWithFormat:@"<%@: %p -- %@>",[self class],self,dictionary];
}

// 存储到本地UserDefaults
+ (void)setModel:(id)obj forKey:(NSString *)key {
    if ([obj respondsToSelector:@selector(encodeWithCoder:)]) {
        NSData * encodeObject = [NSKeyedArchiver archivedDataWithRootObject:obj];
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:encodeObject forKey:key];
        [defaults synchronize];
        return;
    }
    NSLog(@"对象存入失败！对象必须实现NSCoding 协议的 encodeWithCoder:方法");
}
+ (id)modelForKey:(NSString *)key {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSData * encodeObject = [defaults objectForKey:key];
    if (encodeObject == nil) {
        return nil;
    }
    id obj = [NSKeyedUnarchiver unarchiveObjectWithData:encodeObject];
    return obj;
    
}

@end


@implementation CPProperty

@end
