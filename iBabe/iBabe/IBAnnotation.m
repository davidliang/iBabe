//
//  IBAnnotation.m
//  iBabe
//
//  Created by David Liang on 28/06/12.
//  Copyright (c) 2012 Sigmapps Application Development. All rights reserved.
//

#import "IBAnnotation.h"

@implementation IBAnnotation
@synthesize coordinate,title,subtitle;


-(void)dealloc{
    [title release];
    [super dealloc];
}

@end
