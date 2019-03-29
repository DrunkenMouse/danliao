//
//  ADXiaoMaHelperPrintView.m
//  anbang_ios
//
//  Created by 王奥东 on 17/7/15.
//  Copyright © 2017年 ch. All rights reserved.
//

#import "ADXiaoMaHelperPrintView.h"
#import "ADXiaoMaBangHelperModel.h"
#import "LYMTextView.h"
#import "NSString+Extension.h"

#define margin 10
#define marginToTop 5
#define btnW 40
#define btnFont 15

@interface ADXiaoMaHelperPrintView()<UITextViewDelegate>

@property (nonatomic,strong)NSDateFormatter *formatter;


@end

@implementation ADXiaoMaHelperPrintView {
    
    UIButton *_sendBtn;
    NSInteger _textFont;
    NSInteger _textViewHeight;
    
    
    UIButton *_keepChatBtn;
}





-(NSDateFormatter*)formatter{
    
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc]init];
        [_formatter setDateFormat:@"hh:mm"];
        _formatter.locale = [NSLocale currentLocale];//[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    }
    return _formatter;
}



-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
       

        // 此功能暂时先不上
        /*
        _keepChatBtn = [[UIButton alloc] initWithFrame:CGRectMake(margin, marginToTop, btnW, self.frame.size.height-2*marginToTop)];
        [_keepChatBtn setTitle:@"陪聊" forState:UIControlStateNormal];
        _keepChatBtn.userInteractionEnabled = NO;
        _keepChatBtn.titleLabel.font = [UIFont systemFontOfSize:btnFont];
        [_keepChatBtn addTarget:self action:@selector(keepChatBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_keepChatBtn];
        */
        _textFont = 13;
        _textViewHeight = 30;
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(margin, marginToTop, self.frame.size.width-btnW-margin*3, _textViewHeight)];
        _textView.layer.masksToBounds = YES;
        _textView.layer.cornerRadius = 4;
        _textView.userInteractionEnabled = YES;
//        _textView.returnKeyType = UIReturnKeyDone;
//        _textView.placeholder = @"问题关键字搜索。。。" ;
//        _textView.placeholderFont = [UIFont systemFontOfSize:14];
//        _textView.placeholderColor = [UIColor grayColor];
        _textView.delegate = self;
        _textView.backgroundColor = Color(@"#f0f0f0");
        _textView.font = [UIFont systemFontOfSize:_textFont];
        _textView.textColor = [UIColor grayColor];
//        _textView.editable = NO;
        _textView.contentInset = UIEdgeInsetsMake(0, 3, 0, 0);
        _textView.autoresizingMask
        = UIViewAutoresizingFlexibleHeight;//自适应高度
        
        _textView.layoutManager.allowsNonContiguousLayout = NO;//解决颤动
        
        [self addSubview:_textView];
        [self bringSubviewToFront:_textView];
        
        _sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_textView.frame)+margin, marginToTop, btnW, _textViewHeight)];
        _sendBtn.layer.masksToBounds = YES;
        _sendBtn.layer.cornerRadius = 4;
        [_sendBtn setImage:[UIImage imageNamed:@"home_xiaomabang_send_unenable"] forState:UIControlStateDisabled];
        [_sendBtn setImage:[UIImage imageNamed:@"home_xiaomabang_send_enable"] forState:UIControlStateNormal];
        _sendBtn.enabled = NO;
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:btnFont];
        [_sendBtn addTarget:self action:@selector(clickSendBtn) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_sendBtn];
        
    }
    return self;
}


#pragma mark texrView的代理方法
//内容将要发生改变编辑
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    [self textViewChangeHeight:text];
    //内容（滚动视图）高度大于一定数值时
    
    if ([text isEqualToString:@"\n"]) {
        
        [_textView resignFirstResponder];
        return NO;
    }

    if (textView.text.length >60)
    {
        //删除最后一行的第一个字符，以便减少一行。
        textView.text = [textView.text substringToIndex:[textView.text length]-1];
        return NO;
    }
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    
    
    NSLog(@"====test");
}

- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length >60)
    {
        //删除最后一行的第一个字符，以便减少一行。
        textView.text = [textView.text substringToIndex:60];
    }
    
    [self textViewChangeHeight:textView.text];

}

//监听，以便随时更改textView的高度
-(void)textViewChangeHeight:(NSString*)text {
    
    
    text = [text deletStringWhitespaceAndNewlineCharacterSet];
   
    if (text.length >= 1) {//至少要有两个字符，才能允许发送
        _sendBtn.enabled = YES;
    }else {//只有一个或没有字符，撤销之后则为空。不允许发送
        _sendBtn.enabled = NO;
    }
    
}


#pragma mark - 点击发送按钮
-(void)clickSendBtn {
    
    if (self.printBlock) {
        
        NSDate *date = [NSDate date];
        NSString *dateTime = [self.formatter stringFromDate:date];
        
        ADXiaoMaBangHelperModel *model = [[ADXiaoMaBangHelperModel alloc]init];
        model.text = _textView.text;
        model.isUser = @"1";
        model.sendTextTime = dateTime;
        
        _textView.text = nil;
        _sendBtn.enabled = NO;
        self.printBlock(model);
        
    }
}

#pragma mark - 陪聊点击事件
-(void)keepChatBtnClicked{
    
}

@end
