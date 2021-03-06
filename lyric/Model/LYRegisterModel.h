//
//  LYRegisterModel.h
//  lyric
//
//  Created by guotianji on 15/3/14.
//  Copyright (c) 2015年 guotianji. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface LYRegisterModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *uid;

@end
