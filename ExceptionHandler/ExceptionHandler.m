//
//  ExceptionHandler.m
//  test
//
//  Created by mac on 2019/6/13.
//  Copyright © 2019年 bo. All rights reserved.
//

#import "ExceptionHandler.h"

#include <libkern/OSAtomic.h>

#include <execinfo.h>



NSString * const ExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";

NSString * const ExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";

NSString * const ExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";

static NSUncaughtExceptionHandler *previousUncaughtExceptionHandler = NULL;


volatile int32_t UncaughtExceptionCount = 0;

const int32_t UncaughtExceptionMaximum = 10;



const NSInteger ExceptionHandlerSkipAddressCount = 4;

const NSInteger ExceptionHandlerReportAddressCount = 5;



@implementation ExceptionHandler



+ (NSArray *)backtrace

{
    
    void  * callstack[128];
    
        
    
    int frames = backtrace(callstack, 128);
    
         char **strs = backtrace_symbols(callstack, frames);
    
     
    
    int i;
    
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    
    for (
         
         i = ExceptionHandlerSkipAddressCount;
         
         i < ExceptionHandlerSkipAddressCount +
         
         ExceptionHandlerReportAddressCount;
         
         i++)
        
    {
        
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
        
    }
    
    free(strs);
    
     
    
    return backtrace;
    
}

- (void)validateAndSaveCriticalApplicationData:(NSException *)exception {
    NSLog(@"1111111111111111111111");
//    dispatch_async(dispatch_get_main_queue(), ^{
//        UIAlertView *alert = [[UIAlertView alloc]
//                              initWithTitle:@"异常"
//                              message:[NSString stringWithFormat:@"You can try to continue but the application may be unstable.\n\nDebug details follow:\n%@\n%@",[exception reason], [[exception userInfo] objectForKey:ExceptionHandlerAddressesKey]]
//                              delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发送", nil];
//        [alert show];
//    });
    
//    @throw exception;
    
    UIAlertController *alertviewVC = [UIAlertController alertControllerWithTitle:@"异常" message:[NSString stringWithFormat:@"You can try to continue but the application may be unstable.\n\nDebug details follow:\n%@\n%@",[exception reason], [[exception userInfo] objectForKey:ExceptionHandlerAddressesKey]] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *defult = [UIAlertAction actionWithTitle:@"发送" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }];
    [alertviewVC addAction:cancel];
    [alertviewVC addAction:defult];
    [App_Window.rootViewController presentViewController:alertviewVC animated:YES completion:nil];
    // 调用之前崩溃的回调函数
    if (previousUncaughtExceptionHandler) {
        previousUncaughtExceptionHandler(exception);
    }
}

- (void)handleException:(NSException *)exception {
    
    [self validateAndSaveCriticalApplicationData:exception];
    
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
    
    while (!dismissed)

    {

        for (NSString *mode in (__bridge NSArray *)allModes)

        {

            CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);

        }

    }
    
    CFRelease(allModes);
    
    
    
    NSSetUncaughtExceptionHandler(NULL);

    signal(SIGABRT, SIG_DFL);

    signal(SIGILL, SIG_DFL);

    signal(SIGSEGV, SIG_DFL);

    signal(SIGFPE, SIG_DFL);

    signal(SIGBUS, SIG_DFL);

    signal(SIGPIPE, SIG_DFL);
    
    if ([[exception name] isEqual:ExceptionHandlerSignalExceptionName])

    {

        kill(getpid(), [[[exception userInfo] objectForKey:ExceptionHandlerSignalKey] intValue]);

    }

    else

    {

        [exception raise];

    }
    
}



@end



void HandleException(NSException *exception) {
    
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum)
        
    {
        
        return;
        
    }
    
    NSArray *callStack = [ExceptionHandler backtrace];
    
    NSMutableDictionary *userInfo =
    
    [NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
    
    [userInfo
     
     setObject:callStack
     
     forKey:ExceptionHandlerAddressesKey];
    
    [[[ExceptionHandler alloc] init]
     
     performSelectorOnMainThread:@selector(handleException:)
     
     withObject:
     
     [NSException
      
      exceptionWithName:[exception name]
      
      reason:[exception reason]
      
      userInfo:userInfo]
     
     waitUntilDone:YES];
    
}



void SignalHandler(int signal) {
    
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    
    if (exceptionCount > UncaughtExceptionMaximum)
        
    {
        
        return;
        
    }
    
    NSMutableDictionary *userInfo =
    
    [NSMutableDictionary
     
     dictionaryWithObject:[NSNumber numberWithInt:signal]
     
     forKey:ExceptionHandlerSignalKey];
    
    
    
    NSArray *callStack = [ExceptionHandler backtrace];
    
    [userInfo
     
     setObject:callStack
     
     forKey:ExceptionHandlerAddressesKey];
    
    [[[ExceptionHandler alloc] init]
     
     performSelectorOnMainThread:@selector(handleException:)
     
     withObject:
     
     [NSException
      
      exceptionWithName:ExceptionHandlerSignalExceptionName
      
      reason:
      
      [NSString stringWithFormat:
       
       NSLocalizedString(@"Signal %d was raised.", nil),
       
       signal]
      
      userInfo:
      
      [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:ExceptionHandlerSignalKey]]
     
     waitUntilDone:YES];
    
}



void InstallUncaughtExceptionHandler(void) {
    
    previousUncaughtExceptionHandler = NSGetUncaughtExceptionHandler();
    NSSetUncaughtExceptionHandler(&HandleException);
    
    signal(SIGABRT, SignalHandler);
    
    signal(SIGILL, SignalHandler);
    
    signal(SIGSEGV, SignalHandler);
    
    signal(SIGFPE, SignalHandler);
    
    signal(SIGBUS, SignalHandler);
    
    signal(SIGPIPE, SignalHandler);
    
}
