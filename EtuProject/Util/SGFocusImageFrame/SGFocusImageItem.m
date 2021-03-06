//
//  SGFocusImageItem.m
//  ScrollViewLoop
//
//  Created by Vincent Tang on 13-7-18.
//  Copyright (c) 2013年 Vincent Tang. All rights reserved.
//

#import "SGFocusImageItem.h"

@implementation SGFocusImageItem
@synthesize title = _title;
@synthesize image = _image;
@synthesize tag = _tag;

- (void)dealloc
{
    self.title = nil;
    self.image = nil;
    
    self.content = nil;
    self.detail = nil;
    self.progress = nil;
    self.trackTintColor = nil;
    [super dealloc];
}

- (id)initWithTitle:(NSString *)title image:(NSString *)image tag:(NSInteger)tag
{
    self = [super init];
    if (self) {
        self.title = title;
        self.image = image;
        self.tag = tag;
    }
    
    return self;
}

- (id)initWithDict:(NSDictionary *)dict tag:(NSInteger)tag
{
    self = [super init];
    if (self)
    {
        if ([dict isKindOfClass:[NSDictionary class]])
        {
            self.title = [dict objectForKey:@"title"];
            self.image = [dict objectForKey:@"image"];
            self.content = [dict objectForKey:@"content"];
            self.detail = [dict objectForKey:@"detail"];
            self.progress = [dict objectForKey:@"progress"];
            self.trackTintColor = [dict objectForKey:@"trackTintColor"];
            //...
        }
    }
    return self;
}
@end
