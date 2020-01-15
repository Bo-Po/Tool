//
//  CPLocationManager.h
//  O
//
//  Created by 州龚 on 2019/12/4.
//  Copyright © 2019 clearlove. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CPLocationManager : NSObject <CLLocationManagerDelegate>

@property (class, readonly, strong) CPLocationManager *shareManager;
@property (nonatomic, strong) CLPlacemark *placemark;

- (void)getCurrentLocation:(CPClickButton)locationBack repeat:(BOOL)repeat;

@end

NS_ASSUME_NONNULL_END
