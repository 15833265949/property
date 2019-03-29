//
//  NetworkItem.m
//  DoctorAndPatientExchange
//
//  Created by 开发2 on 2017/8/16.
//  Copyright © 2017年 shuangYouZhiChun. All rights reserved.
//

#import "NetworkItem.h"
//#import "Network.h"
#import "XPShowView.h"
@interface NetworkItem ()

@end
@implementation NetworkItem

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
                failureBlock:(AsiFailureBlock)failureBlock
{
    if (self = [super init]) {
        
        self.netWorkType = networkType;
        self.url         = url;
        self.params      = params;
        self.showHUD     = showHUD;
        if (showHUD) {
            //开始网络加载
            [GIFHudHelper showWithCustomViewWithView:[UIApplication sharedApplication].keyWindow];
            [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
        }
        __weak typeof(self) weakSelf = self;
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];//kvo
        manager.requestSerializer.timeoutInterval = Asi_API_TIME_OUT;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];//kvo
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",nil];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        if (networkType == NetWorkGET) {
            [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //停止加载动画
                if (showHUD) {
                    [GIFHudHelper hide:[UIApplication sharedApplication].keyWindow];
                    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                }
                int code = 0;
                NSString * msg = nil;
                if (responseObject) {
                    
                    NSString * success   = responseObject[@"success"];
                    code                 = success.intValue;
                    msg                  = responseObject[@"message"];
                    
                    if ([responseObject[@"result"] isEqualToString:@"0001"]) {
                        [HUDHelper alertTitle:@"提示" message:responseObject[@"message"] cancel:@"去更新" action:^{
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/%E7%9F%A5%E5%BF%83%E5%8C%BB%E7%94%9F/id1274027886?mt=8"]];
                        }];
                        return;
                    }
                    
                    if (![responseObject[@"result"] isEqualToString:@"0000"] && ![responseObject[@"result"] isEqualToString:@"0001"] && showHUD) {
                        [[HUDHelper sharedInstance] tipMessage:msg];
                    }
                    NSArray *languageArry = [NSLocale preferredLanguages];
                    NSString *currentLanguage = [languageArry objectAtIndex:0];
                    NSArray *arr = [currentLanguage componentsSeparatedByString:@"-"];
                    if(arr.count > 0 && ![arr[0] isEqualToString:@"zh"]){

                    }else{
                        if(responseObject[@"gd_status"] && responseObject[@"integral"]){
                            NSString *num = nil;
                            if(responseObject[@"loginRank"]){
                                num = [NSString stringWithFormat:@"%@",responseObject[@"loginRank"]];
                            }
                            XPShowView *showView = [[XPShowView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) WithTitle:responseObject[@"gd_status"] withGrade:responseObject[@"integral"] withNum:num];
                            [[[UIApplication sharedApplication].delegate window] addSubview:showView];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3.0 * NSEC_PER_SEC), dispatch_get_main_queue(),^{
                                [showView removeFromSuperview];
                            });
                        }
                    }
                }
                
                if (successBlock) {
                    successBlock(responseObject,code,msg);
                }
                [weakSelf removeItem];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (showHUD) {//停止加载动画
                    [GIFHudHelper hide:[UIApplication sharedApplication].keyWindow];
                    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                }
                [NSObject showError:error];//展示错误信息
                if (failureBlock) {
                    failureBlock(error);
                    if(error.code == -1001){
                        [[HUDHelper sharedInstance] tipMessage:@"网络异常，请检测网络连接是否正常！"];
                    }
                }
                [weakSelf removeItem];
            }];

        }
        else if (networkType == NetWorkPOST){
            [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //停止加载动画
                if (showHUD) {
                    [GIFHudHelper hide:[UIApplication sharedApplication].keyWindow];
                    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                }
                int code = 0;
                NSString * msg = nil;
                if (responseObject) {
                    NSString * success     = responseObject[@"success"];
                    code                   = success.intValue;
                    msg                    = responseObject[@"message"];
                    
                    if ([responseObject[@"result"] isEqualToString:@"0001"]) {
                        [HUDHelper alertTitle:@"提示" message:responseObject[@"message"] cancel:@"去更新" action:^{
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/%E7%9F%A5%E5%BF%83%E5%8C%BB%E7%94%9F/id1274027886?mt=8"]];
                        }];
                        return;
                    }
                    
                    if (![responseObject[@"result"] isEqualToString:@"0000"] && ![responseObject[@"result"] isEqualToString:@"0001"] && showHUD) {
                        [[HUDHelper sharedInstance] tipMessage:msg];
                    }
                    NSArray *languageArry = [NSLocale preferredLanguages];
                    NSString *currentLanguage = [languageArry objectAtIndex:0];
                    NSArray *arr = [currentLanguage componentsSeparatedByString:@"-"];
                    if(arr.count > 0 && ![arr[0] isEqualToString:@"zh"]){
                        
                    }else{
                        if(responseObject[@"gd_status"] && responseObject[@"integral"]){
                            NSString *num = nil;
                            if(responseObject[@"loginRank"]){
                                num = [NSString stringWithFormat:@"%@",responseObject[@"loginRank"]];
                            }
                            XPShowView *showView = [[XPShowView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) WithTitle:responseObject[@"gd_status"] withGrade:responseObject[@"integral"] withNum:num];
                            [[[UIApplication sharedApplication].delegate window] addSubview:showView];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3.0 * NSEC_PER_SEC), dispatch_get_main_queue(),^{
                                [showView removeFromSuperview];
                            });
                            //检测如果等级发生了变动,通知个人中心页
                            if(responseObject[@"grade"] && ![[NSString stringWithFormat:@"%@",responseObject[@"grade"]] isEqualToString:[LoginModel currentUser].grade]){
                                NSString *grade =[NSString stringWithFormat:@"%@",responseObject[@"grade"]];
                                
                                NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
                                [userDic setValue:grade forKey:@"grade"];
                                [LoginModel updateUserModelWithParameters:userDic];
                                
                                NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
                                [defaultCenter postNotificationName:@"changeGrade" object:nil userInfo:@{@"grade":grade}];
                            }
                        }
                    }
                    
 
                }
                NSLog(@"%@",responseObject);
                if (successBlock) {
                    successBlock(responseObject,code,msg);
                }
                [weakSelf removeItem];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //停止加载动画
                if (showHUD) {
                    [GIFHudHelper hide:[UIApplication sharedApplication].keyWindow];
                    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                }
                //[NSObject showError:error];//展示错误信息
                if (failureBlock) {
                    failureBlock(error);
                    if(error.code == -1001){
                        [[HUDHelper sharedInstance] tipMessage:@"网络异常，请检测网络连接是否正常！"];
                    }
                }
                [weakSelf removeItem];
            }];
        }
    }
    return self;
}

/**
 *   移除网络请求项
 */
-(void)removeItem
{
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.removeNetworkItemBlock(weakSelf);
    });
}

-(void)dealloc
{
    NSLog(@"请求的网络被移除了");
}


@end
