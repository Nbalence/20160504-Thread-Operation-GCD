//
//  ViewController.m
//  02-NsThreadDemo
//
//  Created by qingyun on 16/5/4.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "ViewController.h"
#define KURL @"http://pic7.nipic.com/20100514/4675637_053340049985_2.jpg"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@end

@implementation ViewController


//刷新ui
-(void)UpdateUI:(UIImage *)image{
    if ([NSThread isMainThread]) {
        NSLog(@"======mian");
    }

    _iconImageView.image=image;
}

//网络请求
-(void)requestImage:(NSString *)urlstr{
    @autoreleasepool {
    if ([NSThread isMainThread]) {
        NSLog(@"======mian");
    }
    
    NSURL *url=[NSURL URLWithString:urlstr];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    NSHTTPURLResponse *response;
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    if (response.statusCode==200) {
        //data=====》image
        UIImage *image=[UIImage imageWithData:data];
        //刷新ui必须在主线程调用
       // [self UpdateUI:image];
        
        [self performSelectorOnMainThread:@selector(UpdateUI:) withObject:image waitUntilDone:YES];
    
       }
        
    }
    
}


- (IBAction)touchFeatchImageview:(id)sender {
    //1网络请求
    //[self requestImage:KURL];
    
  
    
    //1开辟子线程
    [NSThread detachNewThreadSelector:@selector(requestImage:) toTarget:self withObject:KURL];
    
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
