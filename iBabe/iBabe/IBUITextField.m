//
//  IBUITextField.m
//  iBabe
//
//  Created by David Liang on 6/07/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//

#import "IBUITextField.h"

@implementation IBUITextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (CGRect)textRectForBounds:(CGRect)bounds;
{
    return CGRectInset([super textRectForBounds:bounds], 10.f, 0.f);
}

- (CGRect)editingRectForBounds:(CGRect)bounds;
{
    return CGRectInset([super editingRectForBounds:bounds], 10.f, 0.f);
}

@end
