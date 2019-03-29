//
//  ADXiaoMaHelperTableView.m
//  anbang_ios
//
//  Created by 王奥东 on 17/7/15.
//  Copyright © 2017年 ch. All rights reserved.
//

#import "ADXiaoMaHelperTableView.h"
#import "ADXiaoMaHelperTableViewCell.h"
#import "ADXiaoMaHelperPrintView.h"


#import "ABHomeService.h"//获取接口数据
#import "ADXiaoMaBangHelperModel.h"//小马邦的Model
#import "NSString+Extension.h"



#define margin 10
#define ImGViewW 35

@interface ADXiaoMaHelperTableView()<UITableViewDelegate,UITableViewDataSource>
{
    int _numbershow;
}

@property(nonatomic,strong)NSMutableArray *menuDataArray;

@property (nonatomic,strong)NSDateFormatter *formatter;



@end

static NSString * ADXiaoMaHelperTableViewCellId = @"ADXiaoMaHelperTableViewCellId";

@implementation ADXiaoMaHelperTableView {
    ADXiaoMaHelperPrintView *_printView;
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}
-(NSDateFormatter*)formatter{
    
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc]init];
        [_formatter setDateFormat:@"hh:mm"];
        _formatter.locale = [NSLocale currentLocale];// [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    }
    return _formatter;
}



-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        
        _numbershow = 0;
        //注册键盘出现的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardDidShowNotification object:nil];
        
        //注册键盘消失的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
        
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = [UIColor whiteColor];
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        NSArray * array = @[@"欢迎来到邦邦社区，我是您的小马秘书，有什么可以帮到您的？",@"有事儿找小马，你的眼光棒棒哒～",@"Can i help you？",@"客官，欢迎您呐～～"];
        int x = arc4random() % 4;
        ADXiaoMaBangHelperModel *model = [[ADXiaoMaBangHelperModel alloc]init];
        model.text = array[x];
        model.isUser = @"0";
        model.sendTextTime = [self getCurrentTime];
        _menuDataArray =[NSMutableArray array];
        [_menuDataArray addObject:model];
        [self reloadData];
        
        UITapGestureRecognizer *tapEffGesName = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboardTap)];
        [self addGestureRecognizer:tapEffGesName];
        
    }
    return self;
}

-(void)didMoveToSuperview {
    self.superview.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    if (_printView) {
        return;
    }
    _printView = [[ADXiaoMaHelperPrintView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame), WIDTH, 45)];
    _printView.backgroundColor = [UIColor whiteColor];
    
    WEAKSELF;
    _printView.printBlock = ^(ADXiaoMaBangHelperModel *model){
        
        [weakSelf.menuDataArray addObject:model];
        [weakSelf reloadData];
        [weakSelf scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.menuDataArray.count-1 inSection:0]  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        [weakSelf userSendMessage:model.text];
        
    };
    
    [self.superview addSubview:_printView];
    [self changeViewFrameWithHeight:0];
    [self.superview bringSubviewToFront:_printView];
}


-(void)keyboardWillBeHidden:(NSNotification*)aNotification

{

    [self changeViewFrameWithHeight:0 animation:YES];
}
- (void)changeViewFrameWithHeight:(CGFloat)height
{
    self.frame=CGRectMake(0, 0, WIDTH, HEIGHT-45 - 64-height);
    _printView.frame = CGRectMake(0, CGRectGetMaxY(self.frame), WIDTH, 45);
    
}
- (void)keyboardWillShow:(NSNotification*)aNotification
{
    
    if (_menuDataArray.count>1) {
        
        [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.menuDataArray.count-1 inSection:0]  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    
    NSDictionary *infoDic = aNotification.userInfo;
    NSValue *aValue = [infoDic objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    CGFloat height = keyboardRect.size.height;
 
    [self changeViewFrameWithHeight:height];
    
    NSLog(@"%@",aNotification);
    
}


- (void)changeViewFrameWithHeight:(CGFloat)height animation:(BOOL)animation
{
    if (animation) {
        WEAKSELF;
        [UIView animateWithDuration:0 //时长
                              delay:0 //延迟时间
                            options:UIViewAnimationOptionTransitionFlipFromLeft//动画效果
                         animations:^{
                             
                             [weakSelf changeViewFrameWithHeight:height];
                         } completion:^(BOOL finish){
//                             动画结束时调用
                             [weakSelf changeViewFrameWithHeight:height];
                         }];
        
    }else
    {
        [self changeViewFrameWithHeight:height];
    }

}
#pragma mark - 拿到了用户发送的消息
-(void)userSendMessage:(NSString *)message {
    
    WEAKSELF
    
    NSDictionary *dict = @{@"userid":MY_USER_NAME,@"info":message};
//    http://uwap.bangcommunity.com:9000/bangBotServer/Bot?userId=241062&info=a
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    

    [[ABHomeService sharedInstanced] xiaoMaBangHelperWithParamJson:jsonStr success:^(ADXiaoMaBangHelperModel *model) {
        
        if ([model.message isEqualToString:@"success"]) {
            
            model.sendTextTime = [weakSelf getCurrentTime];
            model.isUser = @"0";
            [_menuDataArray addObject:model];
            [weakSelf reloadData];
            [weakSelf scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.menuDataArray.count-1 inSection:0]  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            NSLog(@"xiaoMaBangHelper success ===%@",model.text);
        }
        
    } failure:^(NSError *error) {
        NSLog(@"xiaoMaBangHelper failed");
    }];
    
    
}

-(NSString *)getCurrentTime{
    NSDate *date = [NSDate date];
    NSString *dateTime = [self.formatter stringFromDate:date];
    return dateTime;
}
-(void)dismissKeyboardTap{
    _printView.textView.editable = NO;
    _printView.textView.editable = YES;
}

#pragma mark -  tableView delegate&dataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return _menuDataArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ADXiaoMaBangHelperModel *model = _menuDataArray[indexPath.row];
    
    NSString *textMsg = model.text;

    // 文字计算的最大尺寸
    CGSize textMaxSize = CGSizeMake(MAX_WIDTH, MAXFLOAT);
    // 文字计算出来的真实尺寸(按钮内部label的尺寸)
    CGSize textRealSize = [textMsg sizeWithFont:[UIFont systemFontOfSize:14] maxSize:textMaxSize];
    // 按钮最终的真实尺寸
    CGSize textViewSize = CGSizeMake(textRealSize.width + margin*2, textRealSize.height + margin);
    
    return margin*2 +15 + margin *2 + textViewSize.height +margin;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADXiaoMaHelperTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ADXiaoMaHelperTableViewCellId];
    if (!cell) {
        cell = [[ADXiaoMaHelperTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ADXiaoMaHelperTableViewCellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ADXiaoMaBangHelperModel *model = _menuDataArray[indexPath.row];
    cell.model = model;

    return cell;
}


@end
