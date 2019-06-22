//
//  CHBaseEntity.m
//
//  Created by lichanghong on 4/17/19.
//  Copyright © 2019 lichanghong. All rights reserved.
//

#import "CHBaseEntity.h"
#import "YYModel.h"
#import <objc/runtime.h>
#import <objc/message.h>


@interface CHBaseEntity()

@end

@implementation CHBaseEntity

- (void)dealloc {
    NSLog(@"dealloc ------ %@", NSStringFromClass([self class]));
}
#pragma mark - alloc init
- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue
{
    id entity = [self.class yy_modelWithDictionary:dictionaryValue];
    return entity;
}

+ (NSMutableArray *)arrayOfModelsWithDictionaries:(NSArray *)dictionaries
{
    id entity = [NSArray yy_modelArrayWithClass:self.class json:dictionaries];
    return entity;
}

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionaryValue
{
    return [self yy_modelWithDictionary:dictionaryValue];
}
+ (instancetype)modelWithJSON:(id)json
{
    return [self yy_modelWithJSON:json];
}

- (NSString *)toJSONString
{
   return [self yy_modelToJSONString];
}
- (id)toJSONObject
{
    return [self yy_modelToJSONObject];
}

#pragma mark yymodel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return nil;
 }

+ (CHMapperType)mapperType
{
    return CHMapperTypeUnderscoreCaseToCamelCase;
}

+ (NSDictionary<NSString *,id> *)customPropertyMapper
{
    return nil;
}

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    if (![self.class isMemberOfClass:CHBaseEntity.class]) { //不是基类
        NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
        YYClassInfo *classInfo = [YYClassInfo classInfoWithClass:self];
        NSDictionary *dic = [self customPropertyMapper];
        if (dic) {
            NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:classInfo.propertyInfos];
            [mdic removeObjectsForKeys:dic.allKeys];
            if ([self mapperType] == CHMapperTypeUnderscoreCaseToCamelCase) {
                for (NSString *key in mdic.allKeys) {
                    if (!key) continue;
                   NSString *value = underscoreCaseKeyWithCamelCaseKey(key);
                    if (value) {
                        [newDic setObject:value forKey:key];
                    }
                }
            }
            else
            {
                for (NSString *key in mdic.allKeys) {
                    if (!key) continue;
                    NSString *value = key;
                    if (value) {
                        [newDic setObject:value forKey:key];
                    }
                }
            }
            if (dic && dic.count > 0) {
                [newDic addEntriesFromDictionary:dic];
            }
        }
        
        return newDic;
    }
    return nil;
}

/**
 * 驼峰转下划线
 * userName -> user_name
 */
static NSString * underscoreCaseKeyWithCamelCaseKey(NSString * camelCaseKey) {
    NSMutableString* result = [NSMutableString stringWithString:camelCaseKey];
    NSRange upperCharRange = [result rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]];
    
    //handle upper case chars
    while ( upperCharRange.location!=NSNotFound) {
        
        NSString* lowerChar = [[result substringWithRange:upperCharRange] lowercaseString];
        [result replaceCharactersInRange:upperCharRange
                              withString:[NSString stringWithFormat:@"_%@", lowerChar]];
        upperCharRange = [result rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]];
    }
    
    //handle numbers
    NSRange digitsRange = [result rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
    while ( digitsRange.location!=NSNotFound) {
        
        NSRange digitsRangeEnd = [result rangeOfString:@"\\D" options:NSRegularExpressionSearch range:NSMakeRange(digitsRange.location, result.length-digitsRange.location)];
        if (digitsRangeEnd.location == NSNotFound) {
            //spands till the end of the key name
            digitsRangeEnd = NSMakeRange(result.length, 1);
        }
        
        NSRange replaceRange = NSMakeRange(digitsRange.location, digitsRangeEnd.location - digitsRange.location);
        NSString* digits = [result substringWithRange:replaceRange];
        
        [result replaceCharactersInRange:replaceRange withString:[NSString stringWithFormat:@"_%@", digits]];
        digitsRange = [result rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet] options:kNilOptions range:NSMakeRange(digitsRangeEnd.location+1, result.length-digitsRangeEnd.location-1)];
    }
    return result;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList([self class], &outCount);
    
    for (unsigned int i = 0; i < outCount; ++i) {
        Ivar ivar = ivars[i];
        
        // 获取成员变量名
        const void *name = ivar_getName(ivar);
        NSString *ivarName = [NSString stringWithUTF8String:name];
        // 去掉成员变量的下划线
        ivarName = [ivarName substringFromIndex:1];
        
        // 获取getter方法
        SEL getter = NSSelectorFromString(ivarName);
        if ([self respondsToSelector:getter]) {
            const void *typeEncoding = ivar_getTypeEncoding(ivar);
            NSString *type = [NSString stringWithUTF8String:typeEncoding];
            
            // const void *
            if ([type isEqualToString:@"r^v"]) {
                const char *value = ((const void *(*)(id, SEL))(void *)objc_msgSend)((id)self, getter);
                NSString *utf8Value = [NSString stringWithUTF8String:value];
                [aCoder encodeObject:utf8Value forKey:ivarName];
                continue;
            }
            // int
            else if ([type isEqualToString:@"i"]) {
                int value = ((int (*)(id, SEL))(void *)objc_msgSend)((id)self, getter);
                [aCoder encodeObject:@(value) forKey:ivarName];
                continue;
            }
            // float
            else if ([type isEqualToString:@"f"]) {
                float value = ((float (*)(id, SEL))(void *)objc_msgSend)((id)self, getter);
                [aCoder encodeObject:@(value) forKey:ivarName];
                continue;
            }
            
            id value = ((id (*)(id, SEL))(void *)objc_msgSend)((id)self, getter);
            if (value != nil && [value respondsToSelector:@selector(encodeWithCoder:)]) {
                [aCoder encodeObject:value forKey:ivarName];
            }
        }
    }
    
    free(ivars);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList([self class], &outCount);
        
        for (unsigned int i = 0; i < outCount; ++i) {
            Ivar ivar = ivars[i];
            
            // 获取成员变量名
            const void *name = ivar_getName(ivar);
            NSString *ivarName = [NSString stringWithUTF8String:name];
            // 去掉成员变量的下划线
            ivarName = [ivarName substringFromIndex:1];
            // 生成setter格式
            NSString *setterName = ivarName;
            // 那么一定是字母开头
            if (![setterName hasPrefix:@"_"]) {
                NSString *firstLetter = [NSString stringWithFormat:@"%c", [setterName characterAtIndex:0]];
                setterName = [setterName substringFromIndex:1];
                setterName = [NSString stringWithFormat:@"%@%@", firstLetter.uppercaseString, setterName];
            }
            setterName = [NSString stringWithFormat:@"set%@:", setterName];
            // 获取getter方法
            SEL setter = NSSelectorFromString(setterName);
            if ([self respondsToSelector:setter]) {
                const void *typeEncoding = ivar_getTypeEncoding(ivar);
                NSString *type = [NSString stringWithUTF8String:typeEncoding];
                // const void *
                if ([type isEqualToString:@"r^v"]) {
                    NSString *value = [aDecoder decodeObjectForKey:ivarName];
                    if (value) {
                        ((void (*)(id, SEL, const void *))objc_msgSend)(self, setter, value.UTF8String);
                    }
                    
                    continue;
                }
                // int
                else if ([type isEqualToString:@"i"]) {
                    NSNumber *value = [aDecoder decodeObjectForKey:ivarName];
                    if (value != nil) {
                        ((void (*)(id, SEL, int))objc_msgSend)(self, setter, [value intValue]);
                    }
                    continue;
                } else if ([type isEqualToString:@"f"]) {
                    NSNumber *value = [aDecoder decodeObjectForKey:ivarName];
                    if (value != nil) {
                        ((void (*)(id, SEL, float))objc_msgSend)(self, setter, [value floatValue]);
                    }
                    continue;
                }
                
                // object
                id value = [aDecoder decodeObjectForKey:ivarName];
                if (value != nil) {
                    ((void (*)(id, SEL, id))objc_msgSend)(self, setter, value);
                }
            }
        }
        
        free(ivars);
    }
    
    return self;
}





@end
