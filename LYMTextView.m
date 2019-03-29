//
//  LYMTextView.m
//  anbang_ios
//
//  Created by pactera on 2017/7/20.
//  Copyright © 2017年 ch. All rights reserved.
//

#import "LYMTextView.h"

@interface LYMTextView ()

@property (weak, nonatomic) UILabel *placeholderLabel;

@end

@implementation LYMTextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;
    [self setUp];
    return self;
}

- (void)setUp {
    
    UILabel *placeholderLabel = [[UILabel alloc] init];
    placeholderLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_placeholderLabel = placeholderLabel];
    
    self.placeholderColor = [UIColor lightGrayColor];
    self.placeholderFont = [UIFont systemFontOfSize:16.0f];
    self.font = [UIFont systemFontOfSize:16.0f];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
}

#pragma mark - UITextViewTextDidChangeNotification

- (void)textDidChange {
    self.placeholderLabel.hidden = self.hasText;
}


- (void)setText:(NSString *)text {
    [super setText:text];
    
    [self textDidChange];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    
    [self textDidChange];
}


- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    _placeholderFont = placeholderFont;
    self.placeholderLabel.font = placeholderFont;
    [self setNeedsLayout];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = [placeholder copy];
    
    self.placeholderLabel.text = placeholder;
    
    [self setNeedsLayout];
    
}


- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.placeholderLabel.frame;
    frame.origin.y = self.textContainerInset.top;
    frame.origin.x = self.textContainerInset.left+6.0f;
    frame.size.width = self.frame.size.width - self.textContainerInset.left*2.0;
    
    CGSize maxSize = CGSizeMake(frame.size.width, MAXFLOAT);
    frame.size.height = [self.placeholder boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.placeholderLabel.font} context:nil].size.height;
    self.placeholderLabel.frame = frame;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:UITextViewTextDidChangeNotification];
}


@end
