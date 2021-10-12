//
//  APPConfig.m
//  DaoyitongCode
//
//  Created by chenjg on 2018/9/6.
//  Copyright © 2018年 爱康国宾. All rights reserved.
//

#import "APPConfig.h"
#import "LookingFriend-Swift.h"

@implementation APPConfig

+ (NSDictionary *)mj_objectClassInArray {
    return @{
      @"hostArray":@"RequestHostModel"
    };
}

+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });

    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"];
        NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        self = [self mj_setKeyValues:dictionary];
        if (self.debugMode) {
            NSString* hostString = [[DCDataManager shared].fileManager getJsonWithFileName:@"host-environment"];
            if (hostString.length) {
                self.hostString = hostString;
            }
            
            NSString *isSecretSwitch = [[DCDataManager shared].fileManager getJsonWithFileName:@"isSecretAPI"];
            if (isSecretSwitch.length) {
                self.isSecretAPI = [isSecretSwitch isEqualToString:@"0"] ? NO : YES;
            }
        }
    }
    return self;
}

- (RequestHostModel *)host {
    if (!_host) {
        _host = [RequestHostModel mj_objectWithKeyValues:self.environments[self.hostString]];
        
    }
    return _host;
}



@end


@implementation RequestHostModel


@end
