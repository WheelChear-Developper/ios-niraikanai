//
//  MyAnnotation.m
//  belleamie
//
//  Created by SMARTTECNO. on 2014/01/24.
//  Copyright (c) 2014年 akafune, inc. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation

@synthesize coordinate, subtitle, title;

- (id) initWithCoordinate:(CLLocationCoordinate2D)c {
    coordinate = c;
    return self;
}

@end