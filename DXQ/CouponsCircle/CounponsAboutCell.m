//
//  CounponsAboutCell.m
//  DXQ
//
//  Created by 黄修勇 on 12-10-14.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "CounponsAboutCell.h"

@implementation CounponsAboutCell

@synthesize counponsName=_counponsName;
@synthesize counponsLocation=_counponsLocation;
@synthesize counponsTel=_counponsTel;



-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.businessImageView.frame=CGRectMake(10.f, 10.f, 65.f, 65.f);
        
        self.businessNameLbl.frame=CGRectMake(80.f, 10.f, self.contentView.frame.size.width-90.f, 30.f);
        self.businessNameLbl.font=[UIFont boldSystemFontOfSize:20.f];
        
        self.businessLastestInfoLbl.frame=CGRectMake(80.f, 40.f, self.businessNameLbl.frame.size.width, 20.f);
        
        self.distanceLbl.frame=CGRectMake(80.f, 60.f, self.businessNameLbl.frame.size.width, 20.f);
    }
    return self;
}


-(void)setCounponsName:(NSString *)counponsName{

    self.businessNameLbl.text=counponsName;
}

-(NSString *)counponsName{

    return self.businessNameLbl.text;
}

-(void)setCounponsLocation:(NSString *)counponsLocation{

    self.businessLastestInfoLbl.text=counponsLocation;
}

-(NSString *)counponsLocation{

    return self.businessLastestInfoLbl.text;
}

-(void)setCounponsTel:(NSString *)counponsTel{

    self.distanceLbl.text=counponsTel;
}

-(NSString *)counponsTel{

    return self.distanceLbl.text;
}

-(void)setLabelSelect:(BOOL)selected{

    //over write do nothing
}
@end
