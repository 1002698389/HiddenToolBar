//
//  ViewController.m
//  HiddenToolBar
//
//  Created by Mac on 2016/12/5.
//  Copyright © 2016年 zhangjing90s@foxmail.com. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *topToolView;//顶部工具条
@property (weak, nonatomic) IBOutlet UIView *bottomTollView;//底部工具条
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tap;//点击手势
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBotCanstraint;//约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewtopCanstraint;//约束
@property (nonatomic,assign)NSUInteger tapStaticCount;//屏幕静止没有点击的时间，超过5秒自动隐藏工具栏
@property (nonatomic, strong) NSTimer *globalTimer;//定时器
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //时间计数设为0
    _tapStaticCount = 0;
    //定时器响应globalTimerOut  5秒超时的函数
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.globalTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(globalTimerOut:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] run];
    });

}

/**
 超过5秒就自动隐藏
 */
- (void)globalTimerOut:(NSTimer *)sender
{
    if (++_tapStaticCount >= 5) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideToolView:YES];
            });
        
    }

}

/**
 隐藏

 @param bHiden 是否隐藏
 */
- (void)hideToolView:(BOOL)bHiden
{
    if (bHiden) {
        //                if (_toolViewBottomConstraint.constant != 0) {
        //                        return;
        //                }
        _bottomViewBotCanstraint.constant = -CGRectGetHeight(_bottomTollView.frame);
        _topViewtopCanstraint.constant = -CGRectGetHeight(_topToolView.frame);

    } else {
        _bottomViewBotCanstraint.constant = 0;
        _topViewtopCanstraint.constant = 0;
    }
    
    [UIView animateWithDuration:0.25f animations:^{
        [self.view layoutIfNeeded];
    }];
}

/**
 单击手势 隐藏 打开
 */
- (IBAction)singleTap:(id)sender {
    _tapStaticCount = 0;
    [self hideToolView:_bottomViewBotCanstraint.constant == 0];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
