//
//  TestViewController.m
//  备课-百思不得姐
//
//  Created by huumac on 18/2/6.
//  Copyright © 2018年 小码哥. All rights reserved.
//

#import "TestViewController.h"
#import <AFNetworking.h>


@interface TestViewController ()

/** 请求管理者 */
@property (nonatomic, weak) AFHTTPSessionManager *manager;


@end

@implementation TestViewController



#pragma mark - 懒加载
- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"application"] = @"Synchronize.Req";
    params[@"version"] = @"2.9.0";
    params[@"osType"] = @"android2.3.5";
    params[@"mobileSerialNum"] = @"3598360434842560000000000000000000000000";
    
    params[@"userIP"] = @"localhost/127.0.0.1";
    params[@"appUser"] = @"qtpay";
    
    params[@"phone"] = @"13588996665";
    params[@"token"] = @"0000";
    
    params[@"clientType"] = @"02";
    params[@"password"] = @"28001";
    
    params[@"sign"] = @"412fadsfoinhuc450f8jcnalzq08mfja";
    params[@"transLogNo"] = @"532362";
    
    params[@"transDate"] = @"20130411";
    params[@"transTime"] = @"165337";
    
    params[@"mobileNo"] = @"13588996665";
    
    NSEnumerator * enumeratorKey = [params keyEnumerator];
    for (NSObject *object in enumeratorKey) {
        NSLog(@"---: %@",object);
    }
    
    
    // 发送请求
    //XMGWeakSelf;
    
    //初始化manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //序列化
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    //POST请求
    NSString *url = @"http://192.168.6.148:8080/parkAlipayTrade/parkAlipayTrade/login";
    //NSString *url = @"";
    
    
    
//    NSDictionary *mdic = [NSDictionary dictionaryWithObjectsAndKeys:@"admin",@"uid",@"123",@"pwd",nil];
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        // 这里可以获取到目前的数据请求的进度
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        
        // 请求成功，解析数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"%@",dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        
    }];
    
   
    
    
    
    
}










- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
