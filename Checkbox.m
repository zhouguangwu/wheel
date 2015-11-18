//
//  Checkbox.m
//  jhq
//
//  Created by wayos-ios on 6/13/14.
//  Copyright (c) 2014 wayos. All rights reserved.
//

#import "Checkbox.h"

@interface Checkbox (){
    void (^_callback)(Checkbox *);
}
@end

@implementation Checkbox
- (instancetype) initWithFrame:(CGRect)frame checkedImage:(UIImage *)checkedImage unckeckedImage:(UIImage *)unckeckedImage checked:(BOOL)isChecked{
    if (self = [super initWithFrame:frame]) {
        [self addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        _isChecked = isChecked;
        _checkedImage = checkedImage;
        _unCheckedImage = unckeckedImage;
        if (_isChecked) {
            [self setBackgroundImage:_checkedImage forState:UIControlStateNormal];
        }else{
            [self setBackgroundImage:_unCheckedImage forState:UIControlStateNormal];
        }
    }
    return self;
}

- (instancetype) initWithCheckedImage:(UIImage *) checkedImage unckeckedImage:(UIImage *) unckeckedImage checked:(BOOL) isChecked{
    if (self = [super init]) {
        [self addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        _isChecked = isChecked;
        _checkedImage = checkedImage;
        _unCheckedImage = unckeckedImage;
        if (_isChecked) {
            [self setBackgroundImage:_checkedImage forState:UIControlStateNormal];
        }else{
            [self setBackgroundImage:_unCheckedImage forState:UIControlStateNormal];
        }
    }
    return self;
}


- (void) setCheckedImage:(UIImage *)checkedImage{
    _checkedImage = checkedImage;
    if (self.isChecked) {
        [self setBackgroundImage:_checkedImage forState:UIControlStateNormal];
    }else{
        [self setBackgroundImage:_unCheckedImage forState:UIControlStateNormal];
    }
}

- (void) setUnCheckedImage:(UIImage *)unCheckedImage{
    _unCheckedImage = unCheckedImage;
    if (self.isChecked) {
        [self setBackgroundImage:_checkedImage forState:UIControlStateNormal];
    }else{
        [self setBackgroundImage:_unCheckedImage forState:UIControlStateNormal];
    }
}

- (void) setCallback:(void (^)(Checkbox *))block{
    _callback = block;
}

- (void) click{
    [self toggle];
    if (_callback) {
        _callback(self);
    }
}

- (void) toggle{
    _isChecked = !_isChecked;
    if (_isChecked) {//之前没点, 现在点了
        [self setBackgroundImage:self.checkedImage forState:UIControlStateNormal];
    }else{
        [self setBackgroundImage:self.unCheckedImage forState:UIControlStateNormal];
    }
}

- (void) unCheck{
    if (_isChecked) {
        [self toggle];
    }
}

- (void) check{
    if (!_isChecked) {
        [self toggle];
    }
}
@end
