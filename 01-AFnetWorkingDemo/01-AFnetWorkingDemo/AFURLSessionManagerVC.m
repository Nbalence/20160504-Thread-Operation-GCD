//
//  AFURLSessionManagerVC.m
//  01-AFnetWorkingDemo
//
//  Created by qingyun on 16/5/3.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "AFURLSessionManagerVC.h"
#import "AFNetworking/AFNetworking.h"

#define KURLStr @"http://img.pconline.com.cn/images/upload/upc/tx/wallpaper/1212/06/c1/16396010_1354784049718.jpg"

#define KUPLoadStr @"http://afnetworking.sinaapp.com/upload2server.json"

@interface AFURLSessionManagerVC ()
@property (weak, nonatomic) IBOutlet UIProgressView *downProgressView;
@property (weak, nonatomic) IBOutlet UIProgressView *upLoadPressView;

@end

@implementation AFURLSessionManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark --下载任务
- (IBAction)touchDownAction:(id)sender {
    //1.创建AFURLSeesionManager对象
    NSURLSessionConfiguration *configuration=[NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager=[[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    //2.下载任务
   // NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:KURLStr]];
    
    NSMutableURLRequest *request=[[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:KURLStr parameters:nil error:nil];
    __weak UIProgressView *progressView=_downProgressView;
    
    NSURLSessionDownloadTask *downTask=[manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //更新进度条
        
       dispatch_async(dispatch_get_main_queue(), ^{
           //更新进度条
           progressView.progress=downloadProgress.fractionCompleted;
       });

        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //文件的存储路径
        NSHTTPURLResponse *httpResponse=(NSHTTPURLResponse *)response;
        if (httpResponse.statusCode==200) {
            NSString *filePath=[NSString stringWithFormat:@"/Users/qingyun/Desktop/%@",response.suggestedFilename];
            return [NSURL fileURLWithPath:filePath];
        }
        
        return nil;
        
    }completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //下载完成后的回调
        if (error) {
            NSLog(@"=======%@",error);
        }else {
            NSLog(@"======%@",filePath.absoluteString);
        
        }

    }];
    
    //3.启动下载任务
    [downTask resume];
}
#pragma mark --上传任务
- (IBAction)UPloadImage:(id)sender {
    //1.创建sessionManager对象
    NSURLSessionConfiguration *configuration=[NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager=[[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    //设置响应序列化
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    //2.创建上传任务
      //一次上传多张图片
      //设置请求序列化,封装请求
NSMutableURLRequest *request=[[AFHTTPRequestSerializer serializer]multipartFormRequestWithMethod:@"POST" URLString:KUPLoadStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //追加文件数据
        NSURL *fileURl1=[[NSBundle mainBundle] URLForResource:@"1" withExtension:@"jpg"];
        NSURL *fileURL2=[[NSBundle mainBundle] URLForResource:@"2" withExtension:@"jpg"];
        
        
        //添加第一张图片
        [formData appendPartWithFileURL:fileURl1 name:@"image" fileName:@"123455.jpg" mimeType:@"image/jpeg" error:nil];
        
        [formData appendPartWithFileURL:fileURL2 name:@"image" fileName:@"12344.jpg" mimeType:@"image/jpeg" error:nil];
    } error:nil];
    NSURLSessionUploadTask *task=[manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        __weak UIProgressView *tempView=_upLoadPressView;
        dispatch_async(dispatch_get_main_queue(), ^{
           //更新进度条
            tempView.progress=uploadProgress.fractionCompleted;
        });

        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"======%@",error);
        }else{
            NSLog(@"=======%@",responseObject);
        }
    }];

    
    //3.启动任务
    [task resume];

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
