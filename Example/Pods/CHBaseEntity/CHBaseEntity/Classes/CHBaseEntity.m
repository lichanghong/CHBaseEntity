//
//  CHBaseEntity.m
//
//  Created by lichanghong on 4/17/19.
//  Copyright © 2019 lichanghong. All rights reserved.
//

#import "CHBaseEntity.h"
#import "YYModel.h"
 
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






@end
