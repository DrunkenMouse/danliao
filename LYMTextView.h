//
//  LYMTextView.h
//  anbang_ios
//
//  Created by pactera on 2017/7/20.
//  Copyright © 2017年 ch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYMTextView : UITextView

@property (copy, nonatomic)  NSString *placeholder;

@property (strong, nonatomic)  UIColor *placeholderColor;

@property (strong, nonatomic) UIFont *placeholderFont;

@end
