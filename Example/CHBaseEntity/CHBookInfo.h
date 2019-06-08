//
//  CHBookInfo.h
//  CHBaseEntity_Example
//
//  Created by 李长鸿 on 2019/6/8.
//  Copyright © 2019 1211054926@qq.com. All rights reserved.
//

#import <CHBaseEntity.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHAuthors : CHBaseEntity
@property (nonatomic,copy)NSString *birthday;
@property (nonatomic,copy)NSString *name;

@end


@interface CHBookInfo : CHBaseEntity
@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *bookname;
@property (nonatomic,copy)NSArray <CHAuthors *> *authors;

@end

NS_ASSUME_NONNULL_END

