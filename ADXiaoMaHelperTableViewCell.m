//
//  ADXiaoMaHelperTableViewCell.m
//  anbang_ios
//
//  Created by 王奥东 on 17/7/15.
//  Copyright © 2017年 ch. All rights reserved.
//

#import "ADXiaoMaHelperTableViewCell.h"
#import "NSString+Extension.h"
#import "ADXiaoMaBangHelperModel.h"
#import "UIView+ABExtend.h"

/**
 *  textView 正问内边距
 */
#define margin 10
#define ImGViewW 35

@interface ADXiaoMaHelperTableViewCell()



@property(nonatomic, assign)BOOL isHepler;

/**
 *  时间
 */
@property (nonatomic, weak) UILabel *timeView;
/**
 *  头像
 */
@property (nonatomic, weak) UIImageView *iconView;
/**
 *  正文
 */
@property (nonatomic, weak) UIButton *textView;

@end

@implementation ADXiaoMaHelperTableViewCell {
    
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
     
        
        
        // 1.时间
        UILabel *timeView = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-50)/2.f, margin*2, 50, 20)];
        timeView.textAlignment = NSTextAlignmentCenter;
        timeView.font = [UIFont systemFontOfSize:12];
        timeView.backgroundColor = [UIColor grayColor];
        timeView.alpha = 0.5;
        timeView.textColor = [UIColor whiteColor];
        [timeView drawCornerWithCorners:UIRectCornerAllCorners withCornerRadii:CGSizeMake(5.f,5.f)];
        [self.contentView addSubview:timeView];
        self.timeView = timeView;
    
        
        // 2.头像
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(margin, CGRectGetMaxY(self.timeView.frame)+margin, ImGViewW, ImGViewW)];
        iconView.image = [UIImage imageNamed:@"home_xiaomabang"];
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        
        
        // 3.正文
        UIButton *textView = [[UIButton alloc] init];
        
        textView.layer.masksToBounds = YES;
        textView.layer.cornerRadius = 4;
        textView.titleLabel.numberOfLines = 0; // 自动换行
        textView.titleLabel.font = [UIFont systemFontOfSize:14];
        textView.contentEdgeInsets = UIEdgeInsetsMake(margin, margin, margin, margin);
        [textView setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.contentView addSubview:textView];
        self.textView = textView;
        
    }
    return self;
}

-(void)setIsHepler:(BOOL)isHepler {
    if (!isHepler) {
        self.iconView.hidden = YES;
    }else{
        self.iconView.hidden = NO;
    }
}

-(void)setModel:(ADXiaoMaBangHelperModel *)model{
    
    self.timeView.text = model.sendTextTime;
    CGFloat textX;
    //头像的修改
    NSString * isUser = [NSString stringWithFormat:@"%@",model.isUser];
    
    if ([isUser isEqualToString:@"1"]) {
        // 用户背景色
        [self.textView setBackgroundColor:Color(@"#d4edfd")];
        self.iconView.hidden = YES;
    }else {
        [self.textView setBackgroundColor:Color(@"#f0f0f0")];

        self.iconView.hidden = NO;
        textX = margin*2+ImGViewW;
    }
    
    
    //文本的修改
    NSString *text = [NSString stringWithFormat:@"%@",model.text];
    [self.textView setTitle:text forState:UIControlStateNormal];
    
    // 3.正文
    CGFloat textY = CGRectGetMaxY(self.timeView.frame)+margin;
    
    // 文字计算的最大尺寸
    CGSize textMaxSize = CGSizeMake(MAX_WIDTH , MAXFLOAT); //WIDTH-ImGViewW-margin*(2+3)
    // 文字计算出来的真实尺寸(按钮内部label的尺寸)
    CGSize textRealSize = [text sizeWithFont:[UIFont systemFontOfSize:14] maxSize:textMaxSize];
    // 按钮最终的真实尺寸
    CGSize textViewSize = CGSizeMake(textRealSize.width + margin*2, textRealSize.height + margin*2);
    
    if ([isUser isEqualToString:@"1"]){
        //内容多于一行的高度
        if (textRealSize.height>[UIFont systemFontOfSize:14].lineHeight) {
            textX = WIDTH-MAX_WIDTH-3*margin;
            //内容中含有回车
            if (textViewSize.width<MAX_WIDTH) {
                textX = WIDTH-textViewSize.width-margin;
            }
            NSLog(@"test");
        }else{
            //内容不足一行
            textX = WIDTH-textViewSize.width-margin;
            NSLog(@"test1");
        }
    }
    
    self.textView.frame = CGRectMake(textX, textY, textViewSize.width, textViewSize.height);
}



@end
