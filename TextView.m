//
//  TextView.m
//  ad
//
//  Created by webuser on 11/25/15.
//  Copyright © 2015 fish. All rights reserved.
//

#import "TextView.h"

@implementation TextView{
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_begin) name:UITextViewTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_end) name:UITextViewTextDidEndEditingNotification object:nil];
    }
    return self;
}
-(void)setPlaceHolder:(NSString *)placeHolder{
    _placeHolder = placeHolder;
    self.text = placeHolder;
}
-(void)setAttributedPlaceHolder:(NSAttributedString *)attributedPlaceHolder{
    _attributedPlaceHolder = attributedPlaceHolder;
    self.attributedText = attributedPlaceHolder;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)_end{
    if (!self.hasText) {
        if (_attributedPlaceHolder) {
            self.attributedText = _attributedPlaceHolder;
        }else{
            self.text = _placeHolder;
        }
    }
}
-(void)_begin{
    if (_placeHolder.length > 0 && [_placeHolder isEqualToString:self.text]) {//是placehoder
        self.text = @"";
    }else if ([self.attributedText.string isEqualToString:_attributedPlaceHolder.string]){
        self.text = @"";
        self.typingAttributes = @{};
    }
}
@end
