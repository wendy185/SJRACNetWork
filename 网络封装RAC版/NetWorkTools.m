//
//  NetWorkTools.m
//  02-RAC
//
//  Created by li on 15/12/6.
//  Copyright © 2015年 li. All rights reserved.
//

#import "NetWorkTools.h"

@protocol NetworkToolsProxy <NSObject>

@optional
// 复制粘贴了 AFN 的内部方法
- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

@end

// 遵守协议，由 NetworkTools 实现 协议方法
// 但是，协议方法，AFN 已经实现好了
@interface NetWorkTools () <NetworkToolsProxy>

@end


@implementation NetWorkTools

+ (instancetype)shareTools{
    
    static NetWorkTools *tools;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tools = [[self alloc] initWithBaseURL:nil];
        tools.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    });
    return tools;
    
}

- (RACSignal *)request:(RequestMethod)method Url:(NSString *)urlString parameters:(id)parameters{
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        NSString *methodStr = method == GET ? @"GET" : @"POST";
        
        [[self dataTaskWithHTTPMethod:methodStr URLString:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            
            [subscriber sendNext:responseObject];
            
            [subscriber sendCompleted];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [subscriber sendError:error];
        }] resume];
        
        return nil;
    }];
 
}

@end
