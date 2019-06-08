//
//  CHBaseEntity.h
//
//  Created by lichanghong on 4/17/19.
//  Copyright © 2019 lichanghong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CHMapperType) {
    CHMapperTypeNone = 0,
    /** 下划线转驼峰  user_name->userName */
    CHMapperTypeUnderscoreCaseToCamelCase,
};
 
@interface CHBaseEntity : NSObject
#pragma mark - 实例化相关
/**
 * 根据json的dictionaryValue创建模型
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue;

/**
 * 根据json的dictionaryValue数组 批量创建模型
 */
+ (NSMutableArray *)arrayOfModelsWithDictionaries:(NSArray *)dictionaries;

/**
 * 根据json的dictionaryValue创建模型
 */
+ (instancetype)modelWithDictionary:(NSDictionary *)dictionaryValue;
+ (instancetype)modelWithJSON:(id)json;



#pragma mark - 数组相关
/**
 * 当对应的property时数组，而且数组里要存放指定模型时，传入对应的数组的property 返回该property数组里面存放的模型类型 需要时由子类重写 多重继承关系时  最好在最后返回super的方法
 *
 * 例：模型有一个@property (nonatomic, strong) NSArray<AModel *> model_list;
 *    此处的json为 @{@"model_list": @[@{},
 *                                   @{},
 *                                   @{}]}
 *    重写该方法     return @{@"model_list" : [AModel class] };
 *    这样创建后 model_list里就是有3个AModel对象的数组
 */
+ (NSDictionary *)modelContainerPropertyGenericClass;

/**
 * 将当前模型转换成字典
 */
- (NSString *)toJSONString;
- (id)toJSONObject;

#pragma mark - 字段转换方式
/**
 * MTLJSONSerializing增加的协议
 * 字段转换的方式  写在.h文件里 仅仅是为了提醒有这个功能...
 */
+ (CHMapperType)mapperType;


/**
 @implementation YYBook
 + (NSDictionary *)customPropertyMapper {
 return @{@"name"  : @"n",
 @"page"  : @"p",
 @"desc"  : @"ext.desc",
 @"bookID": @[@"id", @"ID", @"book_id"]};
 }
 */
+ (NSDictionary<NSString *, id> *)customPropertyMapper;


@end




