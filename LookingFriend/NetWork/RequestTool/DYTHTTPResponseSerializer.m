//
//  DYTURLResponseSerialization.m
//  DaoyitongCode
//
//  Created by maoge on 2018/11/27.
//  Copyright © 2018 爱康国宾. All rights reserved.
//

#import "DYTHTTPResponseSerializer.h"
#import "DES3Util.h"

@implementation DYTHTTPResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *  _Nullable *)error{
    NSError* newError = nil;
    [super responseObjectForResponse:response data:data error:&newError];
    if (newError && newError.code == 3840) {
        NSString *newString = [DES3Util decryptHex:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
        return [super responseObjectForResponse:response data:[newString dataUsingEncoding:NSUTF8StringEncoding] error:error];
    }
    return [super responseObjectForResponse:response data:data error:error];
}

@end
