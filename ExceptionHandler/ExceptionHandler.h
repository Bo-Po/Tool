//
//  ExceptionHandler.h
//  test
//
//  Created by mac on 2019/6/13.
//  Copyright © 2019年 bo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExceptionHandler : NSObject {
    
    BOOL dismissed;
    
}

@end

void HandleException(NSException *exception);

void SignalHandler(int signal);


void InstallUncaughtExceptionHandler(void);

NS_ASSUME_NONNULL_END
