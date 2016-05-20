//
//  ViewController.m
//  03-NSOperationDemo
//
//  Created by qingyun on 16/5/4.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *temLab;
@property (weak, nonatomic) IBOutlet UIImageView *IconImageView;
//1.声明队列
@property(strong,nonatomic)NSOperationQueue *queue;
@end

@implementation ViewController




-(void)featchImage:(NSData *)data{
//    if ([NSThread isMainThread]) {
        _IconImageView.image=[UIImage imageWithData:data];
//    }
}

- (IBAction)TouchImageView:(id)sender {
    
    NSBlockOperation *operation=[NSBlockOperation blockOperationWithBlock:^{
      //网络的实现逻辑
        //1.耗时操作模拟网络
        [NSThread sleepForTimeInterval:2];
        
        NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://pic7.nipic.com/20100514/4675637_053340049985_2.jpg"]];
        //2主线程刷新Image
        
       //

        
        if ([NSThread isMainThread]) {
            [self featchImage:data];
        }else{
        //子线程调用
            [self performSelectorOnMainThread:@selector(featchImage:) withObject:data waitUntilDone:YES];
        
        }
    }];
    //operation 添加到队列里边
    [_queue addOperation:operation];
    
}


-(void)updataUI:(NSString *)str{
    if ([NSThread isMainThread]) {
        _temLab.text=str;
    }
}

-(void)dosomeThing:(NSString *)str{
    //子线程执行
     //线程休眠
    [NSThread sleepForTimeInterval:5];
    //主线程调用
    [self performSelectorOnMainThread:@selector(updataUI:) withObject:str waitUntilDone:YES];
}

- (IBAction)TouchLab:(id)sender {
    //声明子线程
    NSInvocationOperation *operation=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(dosomeThing:) object:@"更新成功"];
    //opeation 添加到队列里边
    [_queue addOperation:operation];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    //实例化队列
    _queue=[[NSOperationQueue alloc] init];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
