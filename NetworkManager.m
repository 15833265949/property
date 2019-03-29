//
//  NetworkManager.m
//  DoctorAndPatientExchange
//
//  Created by 开发2 on 2017/8/16.
//  Copyright © 2017年 shuangYouZhiChun. All rights reserved.
//

#import "NetworkManager.h"
#import "NetworkHandler.h"
#import "XPRSAEncrypt.h"
@implementation NetworkManager
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static NetworkManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super allocWithZone:zone];
    });
    return manager;
}
/// 返回单例
+(instancetype)sharedInstance
{
    return [[super alloc]init];
}
#pragma mark - 发送 GET 请求的方法

+(void)getRequestWithUrl:(NSString *)url
                  params:(NSDictionary*)paramsDict
                 showHUD:(BOOL)showHUD
                callBack:(CallBack)callBack
{
    //加统计的参数
    paramsDict = [self dicAddExtra:paramsDict];
    
    
    [self getRequstWithURL:url params:paramsDict successBlock:^(id returnData, int code, NSString *msg) {
        callBack(returnData , nil , msg);
    } failureBlock:^(NSError *error) {
        callBack(nil , error , nil);
    } showHUD:showHUD];
}
/**
 *   GET请求通过Block 回调结果
 *
 *   @param url          url
 *   @param params   paramsDict
 *   @param successBlock  成功的回调
 *   @param failureBlock  失败的回调
 *   @param showHUD      是否加载进度指示器
 */
+ (void)getRequstWithURL:(NSString*)url
                  params:(NSDictionary*)params
            successBlock:(AsiSuccessBlock)successBlock
            failureBlock:(AsiFailureBlock)failureBlock
                 showHUD:(BOOL)showHUD
{
    //加统计的参数
    params = [self dicAddExtra:params];
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:params];
    [[NetworkHandler shareInstance] conUrl:url networkType:NetWorkGET params:mutableDict showHUD:showHUD successBlock:successBlock failureBlock:failureBlock];
}

#pragma mark - 发送 POST 请求的方法

+(void)postRequestWithUrl:(NSString *)url
                   params:(NSDictionary*)paramsDict
                  showHUD:(BOOL)showHUD
                 callBack:(CallBack)callBack
{
    //加统计的参数
    paramsDict = [self dicAddExtra:paramsDict];
    [self postReqeustWithURL:url params:paramsDict successBlock:^(id returnData, int code, NSString *msg) {
        callBack(returnData , nil , msg);
    } failureBlock:^(NSError *error) {
        callBack(nil , error , nil);
    } showHUD:showHUD];
}

/**
 *   通过 Block回调结果
 *
 *   @param url           url
 *   @param paramsDict    请求的参数字典
 *   @param successBlock  成功的回调
 *   @param failureBlock  失败的回调
 *   @param showHUD       是否加载进度指示器
 */
+(void)postReqeustWithURL:(NSString*)url
                    params:(NSDictionary*)paramsDict
              successBlock:(AsiSuccessBlock)successBlock
              failureBlock:(AsiFailureBlock)failureBlock
                   showHUD:(BOOL)showHUD
{
    //加统计的参数
    paramsDict = [self dicAddExtra:paramsDict];
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:paramsDict];
    [[NetworkHandler shareInstance] conUrl:url networkType:NetWorkPOST params:mutableDict showHUD:showHUD successBlock:successBlock failureBlock:failureBlock];
}

#pragma mark - //上传录音
+(void)upLoadVoice:(NSString *)file
          withPath:(NSString *)path
        withParams:(NSDictionary *)params
      successBlock:(AsiSuccessBlock)successBlock
      failureBlock:(AsiFailureBlock)failureBlock
           showHUD:(BOOL)showHUD
{
//    if ([[NSFileManager defaultManager]fileExistsAtPath:file]) {
//        return;
//    }
//
//    NSData * data = [NSData dataWithContentsOfFile:file];
//    if (data == nil) {
//        return;
//    }
//    
//    NSString * fileName = [file lastPathComponent];
//    
//    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
//    [manager POST:path parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        
//        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"audio/amr"];
//        
//    } success:^(NSURLSessionDataTask *task, id responseObject) {
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//    }];

 
}

#pragma mark -   上传头像
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
                   showHUD:(BOOL)show
{
    //加统计的参数
    paramDic = [self dicAddExtra:paramDic];
    MBProgressHUD * progressHud;
    if (show) { //展示上传时的加载图
        if (imageDic.count) {
            progressHud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            progressHud.mode = MBProgressHUDModeAnnularDeterminate;
            progressHud.labelText = @"上传中...";
        }
        else{
            //网络的加载图
            [GIFHudHelper showWithCustomViewWithView:[UIApplication sharedApplication].keyWindow];
        }
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    }
    NSLog(@"图片上传请求URL:%@", strUrl);
    NSLog(@"图片上传请求参数:%@", paramDic);
    NSLog(@"图片上传图片参数:%@", imageDic);
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    //对SSL做处理
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    manager.securityPolicy = securityPolicy;
    
    [manager POST:strUrl parameters:paramDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [imageDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            //imageDic中遍历出的obj是NSArray<UIImage*>
            [obj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSData * reduceData = UIImageJPEGRepresentation(obj, 1); //是否压缩 1为不压缩
                NSString * fileNameStr = [NSString stringWithFormat:@"%@%zi.jpeg",key,idx];
                [formData appendPartWithFileData:reduceData name:key fileName:fileNameStr mimeType:@"image/jpeg"];
            }];
        }];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"进度:%lld/%lld,%.2f%%",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount,uploadProgress.fractionCompleted*100);
        if (progressHud) {
            dispatch_async(dispatch_get_main_queue(), ^{//在主线程更新
                progressHud.progress = uploadProgress.fractionCompleted;
            });
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic = responseObject;
        if (![responseObject isKindOfClass:NSDictionary.class]) {//???????????
            dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        }
        if (show) {
            [GIFHudHelper hide:[UIApplication sharedApplication].keyWindow];
            [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
            //网络的加载图
        }
        if ([dic[@"result"] isEqualToString:@"0000"]) {
            if (successBlock) {
                successBlock(task,responseObject);
            }
            return;
        }
        if (failureBlock) {
            NSError *error = [NSError errorWithDomain:SafeStr(responseObject[@"result"]) code:0 userInfo:responseObject];
            failureBlock(task,error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (show) {
            [GIFHudHelper hide:[UIApplication sharedApplication].keyWindow];
            [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
        }
//        [NSObject showError:error];//展示错误信息
        if (failureBlock) {
            failureBlock(task,error);
        }
    }];

}




+ (NSMutableDictionary *)dicAddExtra:(NSDictionary *)paramDic {
    NSMutableDictionary *mtbDic;
    if ([paramDic isKindOfClass:[NSMutableDictionary class]]) {
        mtbDic = (NSMutableDictionary*)paramDic;
    } else {
        if (paramDic.allKeys.count > 0) {
            mtbDic = paramDic.mutableCopy;
        }else{
            mtbDic = @{}.mutableCopy;
        }
    }
//    [self mtbDic:mtbDic addKey:@"userId" value:[UserModel sharedInstance].doctorId];
//    [self mtbDic:mtbDic addKey:@"clinicId" value:[UserModel sharedInstance].clinicId];
    [self mtbDic:mtbDic addKey:@"type" value:@"0"];//1医生端 0患者端
    [self mtbDic:mtbDic addKey:@"state" value:@"2"];//1安卓 2 IOS 3小程序 4web端
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [self mtbDic:mtbDic addKey:@"version" value:appVersion];
    
    [self mtbDic:mtbDic addKey:@"loginType" value:@"2"];//1安卓 2 IOS 3小程序
    [self mtbDic:mtbDic addKey:@"appType" value:@"2"];//1医生端 2患者端
    
    
    NSString *international = @"0";
    NSArray *languageArry = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languageArry objectAtIndex:0];
    NSArray *arr = [currentLanguage componentsSeparatedByString:@"-"];
    if(arr.count > 0 && ![arr[0] isEqualToString:@"zh"]){
        //代表不是中文状态
        international = @"1";
    }else{
        international = @"0";
    }
    
    [self mtbDic:mtbDic addKey:@"international" value:international];
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];
    [self mtbDic:mtbDic addKey:@"timestamp" value:timeString];
    
    NSString *str = [NSString stringWithFormat:@"a95e7d37306e4eb1b17689e4d02b59dd%@",timeString];
    
    [self mtbDic:mtbDic addKey:@"signature" value:[XPRSAEncrypt encryptString:str publicKey:PublicKey]];
    
    
    return mtbDic;
}
+ (void)mtbDic:(NSMutableDictionary *)mtbDic addKey:(NSString *)key value:(NSString *)value {
    if (!mtbDic[key]) {
        mtbDic[key] = value;
    }
}














@end
