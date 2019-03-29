//
//  NetworkManager.h
//  DoctorAndPatientExchange
//
//  Created by 开发2 on 2017/8/16.
//  Copyright © 2017年 shuangYouZhiChun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkDefine.h"

typedef void(^CallBack)(id responseObject, NSError * error ,NSString * msg);

/// 请求管理着
@interface NetworkManager : NSObject

/// 返回单例
+(instancetype)sharedInstance;

#pragma mark - 发送 GET 请求的方法
+(void)getRequestWithUrl:(NSString *)url
                  params:(NSDictionary*)paramsDict
                 showHUD:(BOOL)showHUD
                callBack:(CallBack)callBack;

#pragma mark - 发送 POST 请求的方法
+(void)postRequestWithUrl:(NSString *)url
                   params:(NSDictionary*)paramsDict
                  showHUD:(BOOL)showHUD
                 callBack:(CallBack)callBack;



/**
 *   通过 Block回调结果
 *
 *   @param file           文件名
 *   @param path           url
 *   @param params        请求的参数字典
 *   @param successBlock  成功的回调
 *   @param failureBlock  失败的回调
 *   @param showHUD       是否加载进度指示器
 */
#pragma mark - //上传录音
+(void)upLoadVoice:(NSString *)file
          withPath:(NSString *)path
        withParams:(NSDictionary *)params
      successBlock:(AsiSuccessBlock)successBlock
      failureBlock:(AsiFailureBlock)failureBlock
           showHUD:(BOOL)showHUD;


#pragma mark -   上传图片
/**
 上传图片,可带其他参数
 
 @param strUrl 上传图片的服务器地址
 @param paramDic 其他参数（如userId等）
 @param imageDic 图片参数（字典中的object一定要是NSArray<UIImage*>）
 */
+(void)uploadImageWithUrl:(NSString* )strUrl
                  ParamDic:(NSDictionary *)paramDic
                  ImageDic:(NSDictionary *)imageDic
             successsBlock:(upLoadSuccessBlock)successBlock
              failureBlock:(upLoadFailureBlock)failureBlock
                   showHUD:(BOOL)show;



@end
