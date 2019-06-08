//
//  CHBookInfo.m
//  CHBaseEntity_Example
//
//  Created by 李长鸿 on 2019/6/8.
//  Copyright © 2019 1211054926@qq.com. All rights reserved.
//

#import "CHBookInfo.h"


@implementation CHAuthors

@end

@implementation CHBookInfo

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"authors":[CHAuthors class] };
}
//+ (CHMapperType)mapperType;
//{
//    return CHMapperTypeUnderscoreCaseToCamelCase;
//}
//+ (NSDictionary *)customPropertyMapper {
//    return @{@"name"  : @"n",
//             @"page"  : @"p",
//             @"desc"  : @"ext.desc",
//             @"bookID": @[@"id", @"ID", @"book_id"]};
//}

@end
