//
//  NetWorkTools.h
//  02-RAC
//
//  Created by li on 15/12/6.
//  Copyright © 2015年 li. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <ReactiveCocoa.h>

typedef enum : NSUInteger {
    GET,
    POST
} RequestMethod;

@interface NetWorkTools : AFHTTPSessionManager

+ (instancetype)shareTools;

- (RACSignal *)request:(RequestMethod)method Url:(NSString *)urlString parameters:(id)parameters;

@end
