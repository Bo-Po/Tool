//
//  HttpURLRequest.m
//  TranslateDemoIOS
//
//  Created by NTTData on 16/3/28.
//  Copyright © 2016年 NTTData. All rights reserved.
//

#import "HttpURLRequest.h"

@implementation HttpURLRequest
{
    NSURLSessionDataTask *_dataTask;
}
- (void)requestGetWithURL:(NSString *)URLStr parameter:(NSDictionary *)para port:(NSString *)port callbackBlock:(Callback)callbackBlock {
    NSURL *url = [NSURL URLWithString:kServiceUrl(kServiceHost, port, URLStr)];
    // 创建一个请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    _dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.statusCode == 200) {
                NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                NSLog(@"dataDic = %@",dataDic);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error == nil) {
                        callbackBlock(dataDic, nil);
                    } else {
                        callbackBlock(nil, error);
                    }
                });
            } else {
                NSLog(@"statusCode  == %ld",(long)httpResponse.statusCode);
                dispatch_async(dispatch_get_main_queue(), ^{
                    callbackBlock(nil, error);
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                callbackBlock(nil, error);
            });
        }
    }];
    // 使用resume方法启动任务
    [_dataTask resume];
}

- (void)requestPostWithURL:(NSString *)URLStr isFileUpdata:(BOOL)isUpdata parameter:(NSDictionary *)para port:(NSString *)port callbackBlock:(Callback)callbackBlock {
    
    NSURL *url = [NSURL URLWithString: kServiceUrl(kServiceHost, port, URLStr)];
//    if ([port isEqualToString:kServicePort_8021] || [port isEqualToString:kServicePort_8011]) {
//        url = [NSURL URLWithString: kServiceUrl(@"http://172.16.4.25", port, URLStr)];
//    }
//    if ([URLStr hasPrefix:kApi_Get_Pay_Charge]) {
//        url = [NSURL URLWithString: kServiceUrl(@"http://172.16.4.25", port, URLStr)];
//    }
    NSLog(@"url == %@     para == %@",url, para);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: requestTimeout];
    [request setHTTPMethod:@"POST"];
    NSMutableData *postData = [[NSMutableData alloc]init];//请求体数据
    NSString *postStr;
    if (isUpdata) {
        NSString *boundary = @"wfWiEWrgEFA9A78512weF7sdhr";
        request.allHTTPHeaderFields = @{
                                        @"Content-Type":[NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary]
                                       };
//        [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@; charset=UTF-8",boundary] forHTTPHeaderField:@"Content-Type"];
        NSMutableData *postData = [[NSMutableData alloc]initWithCapacity:0];//请求体数据
        for (NSString *key in para) {
            //循环参数按照部分1、2、3那样循环构建每部分数据
            NSString *pair = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n",boundary, key];
            [postData appendData:[pair dataUsingEncoding:NSUTF8StringEncoding]];
            
            id value = [para objectForKey:key];
            if ([value isKindOfClass:[NSString class]]) {
                [postData appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
            }else if ([value isKindOfClass:[NSData class]]){
                [postData appendData:value];
            }else if ([value isKindOfClass:[NSArray class]]){
                NSData *valueData = [NSJSONSerialization dataWithJSONObject:value
                                                                   options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                     error:nil];
                
                [postData appendData:valueData];
            }
            [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            postStr = [[NSString alloc] initWithData:postData  encoding:NSUTF8StringEncoding];
            NSLog(@"postStr == %@",postStr);
        }
        //设置请求体
        NSString *last = [NSString stringWithFormat:@"--%@--\r\n",boundary];
        postStr =  [NSString stringWithFormat:@"%@%@",postStr,last];
        NSLog(@"postStr == %@",postStr);
//        NSData *lastData = [last dataUsingEncoding:NSUTF8StringEncoding];
//        [postData appendData:lastData];
        //[postData appendData:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
        postData = [NSMutableData dataWithData:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"postData == %@",postData);
    } else {
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:para
                                                           options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                             error:&error];
        postData = [NSMutableData dataWithData:jsonData];//请求体数据
    }
    if (![URLStr hasPrefix:kApi_Sendcode] && ![URLStr hasPrefix:kApi_Register] && ![URLStr isEqualToString:kApi_Login]) {
        
        [request setValue:[CPUtils getUuid] forHTTPHeaderField:@"UUID"];
    }
    [request setHTTPBody: postData];
    
    _dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.statusCode == 200) {
                NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                NSLog(@"url == %@     dataDic = %@",url ,dataDic);
                if ([dataDic[@"httpCode"] integerValue] == 401) {
                    [CPUtils setIsLogin:NO];
                    [CPUtils setUserInfo:[NSMutableDictionary dictionary]];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error == nil) {
                        callbackBlock(dataDic, nil);
                    } else {
                        callbackBlock(nil, error);
                    }
                });
            } else {
                NSLog(@"url == %@     para == %@   statusCode  == %ld",url, para ,(long)httpResponse.statusCode);
                error = [NSError errorWithDomain:@"httpResponse_error" code:httpResponse.statusCode userInfo:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    callbackBlock(nil, error);
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                callbackBlock(nil, error);
            });
        }
    }];
    // 使用resume方法启动任务
    [_dataTask resume];
}


- (void)requestPutWithURL:(NSString *)URLStr parameter:(NSDictionary *)para port:(NSString *)port callbackBlock:(Callback)callbackBlock {
    NSURL *url = [NSURL URLWithString: kServiceUrl(kServiceHost, port, URLStr)];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: requestTimeout];
    [request setHTTPMethod: @"PUT"];
    NSMutableData *postData = [[NSMutableData alloc]init];//请求体数据
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:para
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    postData = [NSMutableData dataWithData:jsonData];//请求体数据
    [request setHTTPBody: postData];
    
    _dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.statusCode == 200) {
                NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error == nil) {
                        callbackBlock(dataDic, nil);
                    } else {
                        callbackBlock(nil, error);
                    }
                });
            } else {
                NSLog(@"statusCode  == %ld",(long)httpResponse.statusCode);
                dispatch_async(dispatch_get_main_queue(), ^{
                    callbackBlock(nil, error);
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                callbackBlock(nil, error);
            });
        }
    }];
    // 使用resume方法启动任务
    [_dataTask resume];
}

- (void)requestDeleteWithURL:(NSString *)URLStr parameter:(NSDictionary *)para port:(NSString *)port callbackBlock:(Callback)callbackBlock {
    NSURL *url = [NSURL URLWithString: kServiceUrl(kServiceHost, port, URLStr)];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: requestTimeout];
    [request setHTTPMethod:@"DELETE"];
    NSMutableData *postData = [[NSMutableData alloc]init];//请求体数据
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    if (para) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:para
                                                           options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                             error:&error];
        postData = [NSMutableData dataWithData:jsonData];//请求体数据
        [request setHTTPBody: postData];
    }
    
    _dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.statusCode == 200) {
                NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                NSLog(@"dataDic = %@",dataDic);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error == nil) {
                        callbackBlock(dataDic, nil);
                    } else {
                        callbackBlock(nil, error);
                    }
                });
            } else {
                NSLog(@"statusCode  == %ld",(long)httpResponse.statusCode);
                dispatch_async(dispatch_get_main_queue(), ^{
                    callbackBlock(nil, error);
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                callbackBlock(nil, error);
            });
        }
    }];
    // 使用resume方法启动任务
    [_dataTask resume];
}
#define UploadImageBoundary @"KhTmLbOuNdArY0001"
- (void)requestUploadWithURL:(NSString *)URLStr parameter:(NSDictionary *)para image:(UIImage *)image port:(NSString *)port callbackBlock:(Callback)callbackBlock {
    
    NSData *imageData;
    NSString *imageFormat;
    NSString *imgType;
    if (UIImagePNGRepresentation(image) != nil) {
        imageFormat = @"Content-Type: image/png \r\n";
        imageData = UIImagePNGRepresentation(image);
        imgType = @"png";
    }else{
        imageFormat = @"Content-Type: image/jpeg \r\n";
        imageData = UIImageJPEGRepresentation(image, 1.0);
        imgType = @"jpg";
    }
    
    NSURL *url = [NSURL URLWithString: kServiceUrl(kServiceHost, port, URLStr)];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"text/html" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval:requestTimeout];
    [request setValue:[CPUtils getUuid] forHTTPHeaderField:@"UUID"];
    
    //设置请求实体
    NSMutableData *body = [NSMutableData data];
    NSMutableString *str = [NSMutableString string];
    
    [str appendFormat:@"--%@\r\n",UploadImageBoundary];
    
    /// 文件参数
    [body appendData:[self getDataWithString:[NSString stringWithFormat:@"--%@\r\n",UploadImageBoundary]]];
    NSString *disposition = [NSString stringWithFormat:@"Content-Disposition:form-data; name=\"%@\"; filename=\"%@.%@\"\r\n",@"fileimg", @"header", imgType];
    [str appendFormat:@"Content-Disposition:form-data; name=\"%@\"; filename=\"%@.%@\"\r\n",@"fileimg", @"header", imgType];
    [body appendData:[self getDataWithString:disposition]];
    [str appendString:imageFormat];
    [body appendData:[self getDataWithString:imageFormat]];
    [str appendFormat:@"\r\n"];
    [body appendData:[self getDataWithString:@"\r\n"]];
    [str appendFormat:@"图片"];
    [body appendData:imageData];
    [str appendFormat:@"\r\n"];
    [body appendData:[self getDataWithString:@"\r\n"]];
    
    //普通参数
    for (NSString *key in para) {
        [str appendFormat:@"--%@\r\n",UploadImageBoundary];
        [body appendData:[self getDataWithString:[NSString stringWithFormat:@"--%@\r\n",UploadImageBoundary]]];
        //上传参数需要key： （相应参数，在这里是_myModel.personID）
        NSString *dispositions = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n",key];
        [str appendString:dispositions];
        [body appendData:[self getDataWithString:dispositions ]];
        [str appendFormat:@"\r\n"];
        [body appendData:[self getDataWithString:@"\r\n"]];
        [str appendString:para[key]];
        [body appendData:[self getDataWithString:para[key]]];
        [str appendFormat:@"\r\n"];
        [body appendData:[self getDataWithString:@"\r\n"]];
    }
    
    //参数结束
    [str appendFormat:@"--%@--\r\n",UploadImageBoundary];
    [body appendData:[self getDataWithString:[NSString stringWithFormat:@"--%@--\r\n",UploadImageBoundary]]];
    
    NSLog(@"参数 str == %@",str);
    
    request.HTTPBody = body;
    //设置请求体长度
    NSInteger length = [body length];
    [request setValue:[NSString stringWithFormat:@"%ld",length] forHTTPHeaderField:@"Content-Length"];
    //设置 POST请求文件上传
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",UploadImageBoundary] forHTTPHeaderField:@"Content-Type"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSJSONSerialization *object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *dict = (NSDictionary *)object;
        NSLog(@"success=====%@ , dict === %@, error === %@",[dict objectForKey:@"success"], dict, error);
        if (error == nil) {
            if ([dict[@"httpCode"] integerValue] == 401) {
                [CPUtils setIsLogin:NO];
                [CPUtils setUserInfo:[NSMutableDictionary dictionary]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                callbackBlock(dict, nil);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                callbackBlock(nil, error);
            });
        }
    }];
    //开始任务
    [dataTask resume];
    
}

- (NSData *)getDataWithString:(NSString *)string{
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    return data;
    
}


- (NSString *)errorMsgFromErrorCode:(NSInteger)code {
    switch (code) {
        case 200:
            
            return @"请求成功";
        case 207:
            
            return @"频繁操作";
        case 303:
            
            return @"登录失败";
        case 400:
            
            return @"请求参数出错";
        case 401:
            
            return @"没有登录";
        case 403:
            
            return @"没有权限";
        case 404:
            
            return @"找不到页面";
        case 408:
            
            return @"请求超时";
        case 409:
            
            return @"发生冲突";
        case 410:
            
            return @"已被删除";
        case 423:
            
            return @"已被锁定";
        case 500:
            
            return @"服务器出错";
            
        default:
            return @"未知错误";
    }
}


/*
// 发送cmd到ac
+ (void)sendCmdToServiceWithPara:(ACMsg *)Para callbackBlock:(Callback)callbackBlock {
    
    ACServiceClient *serviceClient = [[ACServiceClient alloc] initWithHost:[ACloudLib getHost]
                                                                   service:@"petbot"
                                                                   version:1];
    
    [serviceClient sendToService:Para callback:^(ACMsg *responseObject, NSError *error) {
        
        [(AppDelegate *)[UIApplication sharedApplication].delegate appAlertDismiss];
        if (error) {
            //网络错误或其他,根据error.code作出不同提示和处理,此处一般为UDS云端问题,可到AbleCloud平台查看log日志
            callbackBlock(nil, error);
            return;
        }
        //发送成功并接受服务的响应消息
        if ([[responseObject getString:@"result"] isEqualToString:@"success"]) {
            callbackBlock(responseObject, nil);
        } else {
            callbackBlock(nil, nil);
            ACMsg *err = [responseObject get:@"error"];
            if ([err isErr]) {
                // ALERT_VOLUNTARILY([err getErrMsg]);
                NSLog(@"error is %@",[err getErrMsg]);
                return;
            }
            ALERT_VOLUNTARILY(@"服务器发生未知错误请稍后重试");
        }
    }];
}
// 匿名
+ (void)sendCmdToServiceWithAnonymousPara:(ACMsg *)Para callbackBlock:(Callback)callbackBlock {
                  
    [ACServiceClient sendToServiceWithoutSignWithSubDomain:subMajorDomain ServiceName:@"petbot" ServiceVersion:1 Req:Para Callback:^(ACMsg *responseMsg, NSError *error) {
        [(AppDelegate *)[UIApplication sharedApplication].delegate appAlertDismiss];
        if (error) {
            //网络错误或其他,根据error.code作出不同提示和处理,此处一般为UDS云端问题,可到AbleCloud平台查看log日志
            callbackBlock(nil, error);
            return;
        }
        //发送成功并接收服务的响应消息
    }];
}

- (NSString *)urlencode:(NSString*) data {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = [data UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}*/
@end
