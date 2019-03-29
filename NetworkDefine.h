//
//  NetworkDefine.h
//  DoctorAndPatientExchange
//
//  Created by 开发2 on 2017/8/16.
//  Copyright © 2017年 shuangYouZhiChun. All rights reserved.
//

#ifndef NetworkDefine_h
#define NetworkDefine_h

/**
 *请求类型
 *
 */
typedef NS_ENUM(NSInteger , NetWorkType){
    NetWorkGET = 1,     //GET请求
    NetWorkPOST         //POST请求
};

/**
 *网络请求超时的时间
 *
 */
#define Asi_API_TIME_OUT 10


#if NS_BLOCKS_AVAILABLE
/**
 *请求开始的回调 (下载时用到)
 *
 */
typedef void(^AsiStartBlock)(void);

/**
 *  请求成功回调
 *
 *  @param returnData 回调block
 */
typedef void(^AsiSuccessBlock)(id returnData , int code , NSString *msg);

/**
 *  请求失败回调
 *
 *  @param error 回调block
 */

typedef void(^AsiFailureBlock)(NSError *error);


/**
 *  上传成功回调
 * success:^(NSURLSessionDataTask *task, id responseObject) 
 *
 */
typedef void(^upLoadSuccessBlock)(NSURLSessionDataTask  *  task ,id returnData);

/**
 *  上传失败回调
 *failure:^(NSURLSessionDataTask *task, NSError *error)
 *
 */

typedef void(^upLoadFailureBlock)(NSURLSessionDataTask  *  task ,NSError *error);






#endif

#endif /* NetworkDefine_h */
