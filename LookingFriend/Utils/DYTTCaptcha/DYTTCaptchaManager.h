//
//  DYTTCaptchaManager.h
//
//
//  Created by 曲超 on 2020/12/11.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void(^AuthCompleteBlock)(NSDictionary * _Nullable dictionary);

NS_ASSUME_NONNULL_BEGIN

@interface DYTTCaptchaManager : NSObject

+(instancetype)shareInstance;

-(void)showTCaptchaInView:(UIView *)view
                    block:(AuthCompleteBlock)block;

@end

NS_ASSUME_NONNULL_END
