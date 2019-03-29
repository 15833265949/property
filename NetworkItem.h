//
//  NetworkItem.h
//  DoctorAndPatientExchange
//
//  Created by 开发2 on 2017/8/16.
//  Copyright © 2017年 shuangYouZhiChun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkDefine.h"

/**
 *  网络请求子项
 */
@interface NetworkItem : NSObject

/**
 *  网络请求方式
 */
@property (nonatomic,assign)  NetWorkType  netWorkType;

/**
 *  网络请求URL
 */
@property (nonatomic,copy) NSString * url;

/**
 *  网络请求参数
 */
@property (nonatomic,strong) NSDictionary * params;

/**
 *  是否显示HUD
 */
@property (nonatomic,assign) BOOL  showHUD;

/**
 *  移除网络item的block
 */
@property (nonatomic,copy) void(^removeNetworkItemBlock)(NetworkItem * item);

#pragma mark - 创建一个网络请求项，开始请求网络
/**
 *  创建一个网络请求项，开始请求网络
 *
 *  @param networkType  网络请求方式
 *  @param url          网络请求URL
 *  @param params       网络请求参数
 *  @param showHUD      是否显示HUD
 *  @param successBlock 请求成功后的block
 *  @param failureBlock 请求失败后的block
 *
 *  @return NetworkItem对象
 */

-(NetworkItem *)initWithtype:(NetWorkType)networkType
                         url:(NSString *)url
                      params:(NSDictionary *)params
                      showHUD:(BOOL)showHUD
                successBlock:(AsiSuccessBlock)successBlock
                failureBlock:(AsiFailureBlock)failureBlock;


@end
