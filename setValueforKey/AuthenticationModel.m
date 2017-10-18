//
//  AuthenticationModel.m
//  setValueforKey
//
//  Created by APiX on 2017/10/17.
//  Copyright © 2017年 APiX. All rights reserved.
//

#import "AuthenticationModel.h"
#import <YYModel.h>

@implementation AuthenticationModel

+ (instancetype)sharedModel {
    static AuthenticationModel *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AuthenticationModel alloc] init];
    });
    return sharedInstance;
}

+ (NSArray *)getAllProperties {
    unsigned int outCount;
    
    objc_property_t *propertiesArray = class_copyPropertyList([self class], &outCount);
    NSMutableArray *resultArr = [NSMutableArray array];
    for (int i=0;i<outCount;i++) {
        objc_property_t property = propertiesArray[i];
        
        // 获取属性名
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        [resultArr addObject:propertyName];
    }
    
    return resultArr;
}

/** 解析用户的认证状态 */
+ (void)analysisAuthentication:(NSDictionary *)returnValue {
    AuthenticationModel *model = [self sharedModel];
    // step 1
    [model yy_modelSetWithJSON:returnValue[@"data"]];
    
    // step 2
    NSArray *reset_data = returnValue[@"reset_data"];
    NSArray *update_prompt = returnValue[@"update_prompt"];
    NSArray *propertyArray = [self getAllProperties];
    if (reset_data.count > 0) {
        [reset_data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dict = obj;
            [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([key isEqualToString:@"carrier"]) {
                    model.isp = NAAuthenticationStateOverdue;
                } else if ([key isEqualToString:@"identity"]) {
                    model.idcard = NAAuthenticationStateOverdue;
                } else if ([propertyArray containsObject:key]) {
                    id propertyValue = [[[NSNumberFormatter alloc] init] numberFromString:@"2"];
                    [model setValue:propertyValue forKey:key];
                }
            }];
        }];
    }
    // step 3
    if (update_prompt.count > 0) {
        [update_prompt enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dict = obj;
            for (NSString *key in dict.allKeys) {
                NSString *value = [NSString stringWithFormat:@"%@", [dict objectForKey:key]];
                
                id propertyValue = [[[NSNumberFormatter alloc] init] numberFromString:@"4"];
                if ([value integerValue] == 1)
                    propertyValue = [[[NSNumberFormatter alloc] init] numberFromString:@"3"];
                
                if ([key isEqualToString:@"carrier"]) {
                    [model setValue:propertyValue forKey:@"isp"];
                } else if ([key isEqualToString:@"identity"]) {
                    [model setValue:propertyValue forKey:@"idcard"];
                } else if ([propertyArray containsObject:key]) {
                    [model setValue:propertyValue forKey:key];
                }
            }
        }];
    }
}

@end
