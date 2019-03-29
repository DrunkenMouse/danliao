//
//  XiaoMaViewController.m
//  anbang_ios
//
//  Created by pactera on 2017/7/21.
//  Copyright © 2017年 ch. All rights reserved.
//

#import "XiaoMaViewController.h"
#import "ADXiaoMaHelperTableView.h"

#import "ADXiaoMaHelperPrintView.h"
#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"


@interface XiaoMaViewController ()

@end

@implementation XiaoMaViewController{
    ADXiaoMaHelperTableView *_bull;

    ADXiaoMaHelperPrintView*_printView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
 
    
    //IQ键盘管理
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.toolbarManageBehaviour=IQAutoToolbarBySubviews;
    manager.enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    self.view.userInteractionEnabled = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    _bull = [[ADXiaoMaHelperTableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-45 - 64) style:UITableViewStylePlain];
    
    self.view.backgroundColor = AB_Color_f2f2f2;
    
    [self.view addSubview:_bull];
    
}

- (void)changeViewFrameWithHeight:(CGFloat)height
{
    
     _bull.frame=CGRectMake(0, 0, WIDTH, HEIGHT-64-45 - height);
     _printView.frame = CGRectMake(0, CGRectGetMaxY(_bull.frame), WIDTH, 45);
    
}

-(void)initNav{
    self.title = @"小马智能秘书";
    self.navigationItem.leftBarButtonItems = @[
                                               [[AIBackBarButtonItem alloc] initWithTitle:NSLocalizedString(@"public.back", @"title")/*@"返回"*/
                                                                                   target:self
                                                                                   action:@selector(backItemClick)]];
    
        AIImageBarButtonItem *item = [[AIImageBarButtonItem alloc] initWithImageNamed:@"home_xiaomaService" target:self action:@selector(showActinSheet)];
    
        self.navigationItem.rightBarButtonItems = @[item];
    
}

#pragma  导航栏左右按钮
-(void)showActinSheet{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"呼叫客服" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"010-85257184"];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)backItemClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}



@end
