//
//  NetworkHandler.m
//  DoctorAndPatientExchange
//
//  Created by 开发2 on 2017/8/16.
//  Copyright © 2017年 shuangYouZhiChun. All rights reserved.
//

#import "NetworkHandler.h"
#import "NetworkItem.h"
//#import "Network.h"
@implementation NetworkHandler
/**
 *  单例
 *
 *  @return NetworkHandler的单例对象
 */
+ (NetworkHandler *)shareInstance
{
    static NetworkHandler * handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[NetworkHandler alloc]init];
    });
    return handler;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.networkError = NO;
    }
    return self;
}
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
          failureBlock:(AsiFailureBlock)failureBlock
{
    if (self.networkError) {//手机没有网
        [[HUDHelper sharedInstance] tipMessage:@"网络异常，请检测网络连接是否正常！"];
        return nil;
    }
    
    if([self.urls containsObject:url]){
//        [[HUDHelper sharedInstance] tipMessage:@"请不要重复请求!"];
        return nil;
    }else{
        [self.urls addObject:url];
    }
    
    
    
    NSLog(@"url=====%@",url);
    NSLog(@"params=====%@",params);    
    //如果有一些公共的处理可以写在这里
    __weak typeof(self) weakSelf = self;
    self.networkItem = [[NetworkItem alloc]initWithtype:networkType url:url params:params showHUD:showHUD successBlock:successBlock failureBlock:failureBlock];
    [self.items addObject:self.networkItem];
    
    //取消正在执行的网络请求项
    self.networkItem.removeNetworkItemBlock = ^(NetworkItem *item) {
        [weakSelf.items removeObject:item];
        item = nil;
        [weakSelf.urls removeObject:url];
    };
    
    return self.networkItem;
}
#pragma makr - 开始监听网络连接
/**
 *   监听网络状态的变化
 */
+ (void)startMonitoring
{
    //获得网络监控的管理者
    AFNetworkReachabilityManager * mgr = [AFNetworkReachabilityManager sharedManager];
    //设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //网络状态改变,就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown://未知
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi://wifi
                [[self shareInstance] setNetworkError:NO];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: //手机自带网络
                [[self shareInstance] setNetworkError:NO];
                break;
            case AFNetworkReachabilityStatusNotReachable: //手机没有网络
                [[HUDHelper sharedInstance] tipMessage:@"请检查手机网络"];
                [[self shareInstance] setNetworkError:YES];
                break;
            default:
                break;
        }
    }];
    [mgr startMonitoring];
}
/**
 *   懒加载网络请求项的 items 数组
 *
 *   @return 返回一个数组
 */
- (NSMutableArray *)items
{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (NSMutableArray *)urls
{
    if (!_urls) {
        _urls = [NSMutableArray array];
    }
    return _urls;
}
/**
 *   取消所有正在执行的网络请求项
 */
+ (void)cancelAllNetItems
{
    NetworkHandler * handler = [NetworkHandler shareInstance];
    [handler.items removeAllObjects];
    handler.networkItem = nil;
}
@end
