//
//  AFHTTPSessionManagerVC.m
//  01-AFnetWorkingDemo
//
//  Created by qingyun on 16/5/3.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "AFHTTPSessionManagerVC.h"
#import "AFNetworking/AFNetworking.h"
#import "ConfigFiler.h"
@interface AFHTTPSessionManagerVC ()
@property(nonatomic,strong)AFHTTPSessionManager *manager;
@end

@implementation AFHTTPSessionManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(AFHTTPSessionManager *)manager{
    if (!_manager) {
        //创建manager对象
        _manager=[AFHTTPSessionManager manager];
        //设置网络监听
        _manager.reachabilityManager=[AFNetworkReachabilityManager sharedManager];
        
        __weak AFNetworkReachabilityManager *reachManager=_manager.reachabilityManager;
        
        //设置监听回调函数
        [_manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
           //显示监听状态
            NSLog(@"=====当前网络状态=%@",[reachManager localizedNetworkReachabilityStatusString]);
        }];
       
        //启动监听
        [_manager.reachabilityManager startMonitoring];
    }

    return _manager;
}
#pragma mark --GET
- (IBAction)getRequest:(id)sender {
#if 0   //合并请求路径
    NSString *url=[BASEURL stringByAppendingPathComponent:@"request_get.json"];
    //参数
    NSDictionary *parameter=@{@"foo":@"bar"};
    //返回json 默认就是json格式
    self.manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [self.manager GET:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"=====%@",responseObject);
        NSLog(@"====%@", [(NSHTTPURLResponse *)task.response allHeaderFields]
              );
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error=====%@",error);
        
    }];
#endif
    //参数
    NSDictionary *parameters=@{@"s":@"/Api/document/zxrd",@"page":@"1"};
    self.manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [self.manager GET:BASESMURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"======%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"=====%@",error);
    }];
}

- (IBAction)postRequest:(id)sender {
    //1.设置请求参数
    NSDictionary *parameters=@{@"foo":@"bar"};
    //请求参数如果是json格式需要设置请求序列化为json序列化
    self.manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //2.请求
    [self.manager POST:[BASEURL stringByAppendingPathComponent:@"request_post_body_json.json"] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"=========%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"====%@",error);
    }];

}

- (IBAction)multPartPostRequest:(id)sender {
    [self.manager POST:[BASEURL stringByAppendingPathComponent:@"upload2server.json"] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileURL:[[NSBundle mainBundle] URLForResource:@"1" withExtension:@"jpg"] name:@"image" fileName:@"xxxx1.jpg" mimeType:@"image/jpeg" error:nil];
        [formData appendPartWithFileURL:[[NSBundle mainBundle] URLForResource:@"2" withExtension:@"jpg"] name:@"image" fileName:@"xxxx2.jpg" mimeType:@"image/jpeg" error:nil];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"=======%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"=====%@",error);
        
    }];
    
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
