//
//  LoadingMoreFooterView.m
//  Miu Ptt
//
//  Created by Xingzhi Cheng on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoadingMoreFooterView.h"

@interface LoadingMoreFooterView()
@property(nonatomic, retain) UILabel * textLabel;
@property(nonatomic, retain) UIActivityIndicatorView * activityView;
@property(nonatomic, readwrite) CGRect savedFrame;
@end

@implementation LoadingMoreFooterView
@synthesize textLabel = _textLabel;
@synthesize activityView = _activityView;
@synthesize showActivityIndicator = _showActivityIndicator;
@synthesize refreshing = _refreshing;
@synthesize enabled = _enabled;
@synthesize savedFrame = _savedFrame;


- (void) dealloc {
    self.textLabel = nil;
    self.activityView = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showActivityIndicator = NO;
        self.enabled = YES;
        self.refreshing = NO;
        
        self.textLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, frame.size.width, frame.size.height)] autorelease];
        self.textLabel.textAlignment = UITextAlignmentCenter;
        self.textLabel.text = @"加载更多...";
        self.textLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.textLabel];
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        self.activityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
        self.activityView.center = CGPointMake(self.frame.size.width/2- 50, self.frame.size.height / 2);
        [self addSubview:self.activityView];
        [self.activityView startAnimating];
    }
    return self;
}

- (void) setFrame:(CGRect)frame {
    self.savedFrame = frame;
    [super setFrame:frame];
}

- (void) setTextAlignment:(UITextAlignment)textAlignment {
    self.textLabel.textAlignment = textAlignment;
}

- (UITextAlignment) textAlignment {
    return self.textAlignment;
}

- (void) setShowActivityIndicator:(BOOL)showActivityIndicator 
{

}

- (void) setEnabled:(BOOL)enabled {
    _enabled = enabled;
    if (enabled) {
        [super setFrame:self.savedFrame];
        self.hidden = NO;
    }
    else {
        [super setFrame:CGRectZero];
        self.hidden = YES;
    }
}

@end
