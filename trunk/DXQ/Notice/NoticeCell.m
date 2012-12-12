//
//  NoticeCell.m
//  DXQ
//
//  Created by 黄修勇 on 12-12-12.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "NoticeCell.h"

@implementation NoticeCell


-(void)dealloc{

    [_dateLabel release];
    [super dealloc];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width-100, 20.f, 100.0f, 20.f)];
        _dateLabel.backgroundColor=[UIColor clearColor];
        _dateLabel.textColor=[UIColor grayColor];
        _dateLabel.textAlignment=UITextAlignmentRight;
        _dateLabel.font=[UIFont systemFontOfSize:15.f];
        _dateLabel.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview:_dateLabel];
        
        self.productNameLabel.frame=CGRectMake(self.productNameLabel.frame.origin.x, self.productNameLabel.frame.origin.y, self.productNameLabel.frame.size.width-50.f, self.productNameLabel.frame.size.height);
    }
    return self;
}

@end
