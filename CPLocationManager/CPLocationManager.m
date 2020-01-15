//
//  CPLocationManager.m
//  O
//
//  Created by 州龚 on 2019/12/4.
//  Copyright © 2019 clearlove. All rights reserved.
//

#import "CPLocationManager.h"

@interface CPLocationManager () {
    NSString *currentCity;//当前城市
    NSString *strlatitude;//经度
    NSString *strlongitude;//纬度
}

@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, strong) CLGeocoder *geocoder;

@property (nonatomic, assign) BOOL isRepeat;
@property (nonatomic, copy) CPClickButton getCtryBack;
@property (nonatomic, copy) CPClickButton locationUpdateEnd;

@end

@implementation CPLocationManager
static CPLocationManager *instance = nil;
+ (CPLocationManager *)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
        instance.geocoder = [[CLGeocoder alloc]init];
        instance.locationManager = [[CLLocationManager alloc]init];
        instance.locationManager.delegate = instance;
            //设置寻址精度
        instance.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        instance.locationManager.distanceFilter = kCLDistanceFilterNone;
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self shareManager];
}

- (instancetype)copyWithZone:(struct _NSZone *)zone {
    return instance;
}
- (void)getCurrentLocation:(CPClickButton)locationBack repeat:(BOOL)repeat {
        //判断定位功能是否打开
    if ([CLLocationManager locationServicesEnabled]) {
        // iOS8必须，这两行必须有一行执行，否则无法获取位置信息，和定位
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];
        self.isRepeat = repeat;
        if (repeat) {
            self.locationUpdateEnd = locationBack;
        } else {
            self.getCtryBack = locationBack;
        }
    } else {
            //设置提示提醒用户打开定位服务
        [App_Delegate.window.rootViewController showToastTitle:@"定位不可用，请在系统设置里打开位置服务后重试" delay:1.5];
    }
}
#pragma mark -定位-
// 位置更新
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (!self.isRepeat) {
        [self.locationManager stopUpdatingLocation];
    }
        //旧址
    CLLocation *currentLocation = [locations lastObject];
        //打印当前的经度与纬度
    NSLog(@"latitude == %f, longitude == %f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
    
        //反地理编码
    Code_Weakify(self)
    [self.geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        Code_Strongify(self)
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = [placemarks lastObject];
            if (!placeMark) {
                NSLog(@"获取当前位置失败");
            } else {
                if (self.isRepeat) {
                    if (self.locationUpdateEnd) {
                        self.locationUpdateEnd(placeMark, 1);
                    }
                } else {
                    self->currentCity = placeMark.locality;
                    if (self.getCtryBack) {
                        self.getCtryBack(self->currentCity, 1);
                    }
                }
            }
            
            /*看需求定义一个全局变量来接收赋值*/
//            NSLog(@"----%@",placeMark.country);//当前国家
//            NSLog(@"%@",self->currentCity);//当前的城市
             //            NSLog(@"%@",placeMark.subLocality);//当前的位置
             //            NSLog(@"%@",placeMark.thoroughfare);//当前街道
             //            NSLog(@"%@",placeMark.name);//具体地址
            
        }
    }];
}
//定位失败后调用此代理方法
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
        //设置提示提醒用户打开定位服务
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"允许定位提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
//    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [App_Delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

@end
