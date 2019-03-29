//
//  NetworkHandler.h
//  DoctorAndPatientExchange
//
//  Created by 开发2 on 2017/8/16.
//  Copyright © 2017年 shuangYouZhiChun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkDefine.h"

@class NetworkItem;
/**
 *  网络请求Handler类
 */
@interface NetworkHandler : NSObject

/**
 *  单例
 *
 *  @return NetworkHandler的单例对象
 */
+ (NetworkHandler *)shareInstance;

/**z
 *  items
 */
@property (nonatomic,strong) NSMutableArray * items;



/**
    判断是否重复请求
 */
@property (nonatomic,strong) NSMutableArray *urls;

/**
 *   单个网络请求项
 */
@property (nonatomic,strong) NetworkItem * networkItem;

/**
 *  networkError
 */
@property(nonatomic,assign)BOOL networkError;

#pragma mark - 创建一个网络请求项
/**
 *  创建一个网络请求项
 *
 *  @param url          网络请求URL
 *  @param networkType  网络请求方式
 *  @param params       网络请求参数
 *  @param showHUD      是否显示HUD
 *  @param successBlock 请求成功后的block
 *  @param failureBlock 请求失败后的block
 *
 */

-(NetworkItem *)conUrl:(NSString *)url
           networkType:(NetWorkType)networkType
                params:(NSDictionary *)params
               showHUD:(BOOL)showHUD
          successBlock:(AsiSuccessBlock)successBlock
          failureBlock:(AsiFailureBlock)failureBlock;

/**
 *   监听网络状态的变化
 */
+ (void)startMonitoring;

/**
 *   取消所有正在执行的网络请求项
 */
+ (void)cancelAllNetItems;


@end
