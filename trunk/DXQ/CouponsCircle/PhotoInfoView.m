//
//  PhotoInfoView.m
//  DXQ
//
//  Created by 黄修勇 on 12-10-17.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "PhotoInfoView.h"
#import "UIColor+ColorUtils.h"
#import <CoreText/CoreText.h>
#import "UIImageView+WebCache.h"

@interface PhotoInfoView ()
{
    UIView *imageContentView;
    UIImageView *userImageView;
    UILabel *userNameLabel;
    UILabel *locationLabel;
    UILabel *infoSourceLabel;
    UILabel *dateLabel;
    ViewNumberLabel *viewNumberLabel;
}
@end

@implementation PhotoInfoView

@synthesize userImage=_userImage;
@synthesize userName=_userName;
@synthesize location=_location;
@synthesize infoSource=_infoSource;
@synthesize dateString=_dateString;
@synthesize viewNumber=_viewNumber;

-(void)dealloc{
    
    [imageContentView release];
    [userNameLabel release];
    [locationLabel release];
    [infoSourceLabel release];
    [dateLabel release];
    [viewNumberLabel release];
    [_imgUrl release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // imgae
        
        UIImage *userBgImg=[UIImage imageNamed:@"user_bg"];
        imageContentView=[[UIView alloc]initWithFrame:CGRectMake(5.f, 5.f, userBgImg.size.width, userBgImg.size.height)];
        [self addSubview:imageContentView];
        
        UIImageView *userBgImgView=[[UIImageView alloc]initWithImage:userBgImg];
        [userBgImgView sizeToFit];
        [imageContentView addSubview:userBgImgView];
        [userBgImgView release];
        
        userImageView=[[UIImageView alloc]initWithFrame:CGRectMake(2.f, 2.f, imageContentView.frame.size.width-4., imageContentView.frame.size.height-4.f)];
        [imageContentView addSubview:userImageView];
        
        
        // name
        
        userNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(imageContentView.frame.origin.x+imageContentView.frame.size.width+5.f, 5.f, self.frame.size.width-100.f, 20.f)];
        userNameLabel.backgroundColor=[UIColor clearColor];
        userNameLabel.font=[UIFont boldSystemFontOfSize:15.f];
        userNameLabel.textColor=[UIColor colorWithString:@"#000000"];
        userNameLabel.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [self addSubview:userNameLabel];
        
        UIFont *font=[UIFont systemFontOfSize:12.f];
        UIColor *textColor=GrayColorForTextColor;
        
        //data label时间
        
        dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width-150.f, 5.f, 135.f, 20.f)];
        dateLabel.backgroundColor=[UIColor clearColor];
        dateLabel.textAlignment=UITextAlignmentRight;
        dateLabel.textColor=textColor;
        dateLabel.font=font;
        [self addSubview:dateLabel];
        
        //地址label
        
        NSString *locationBgImagePath=[[NSBundle mainBundle]pathForResource:@"address_bg" ofType:@"png"];
        
        UIImage *locationBgImg=[[UIImage alloc]initWithContentsOfFile:locationBgImagePath];
        UIImage *disLocationImg=[locationBgImg stretchableImageWithLeftCapWidth:locationBgImg.size.width/2 topCapHeight:locationBgImg.size.height/2];
        [locationBgImg release];
        
        UIImageView *locationImageView=[[UIImageView alloc]initWithImage:disLocationImg];
        locationImageView.frame=CGRectMake(userNameLabel.frame.origin.x, 30.0f, self.frame.size.width-userNameLabel.frame.origin.x-10.f, 20.f);
        [self addSubview:locationImageView];

        locationLabel=[[UILabel alloc]initWithFrame:CGRectMake(5.f, 0.f, locationImageView.frame.size.width-10.f, locationImageView.frame.size.height)];
        
        locationLabel.backgroundColor=[UIColor clearColor];
        locationLabel.textColor=[UIColor whiteColor];
        locationLabel.font=font;
        [locationImageView addSubview:locationLabel];
        [locationImageView release];
        
        //信息来源
        
        infoSourceLabel=[[UILabel alloc]initWithFrame:CGRectMake(10.f, imageContentView.frame.origin.y+imageContentView.frame.size.height+5.f, self.frame.size.width/2, 20.f)];
        infoSourceLabel.backgroundColor=[UIColor clearColor];
        infoSourceLabel.textColor=textColor;
        infoSourceLabel.font=font;
        [self addSubview:infoSourceLabel];
        
        //浏览次数
        
        viewNumberLabel=[[ViewNumberLabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2, infoSourceLabel.frame.origin.y+2.f, self.frame.size.width/2-15.f, 20.f)];
        viewNumberLabel.font=font;
        viewNumberLabel.textColor=textColor;
        [self addSubview:viewNumberLabel];
    }
    return self;
}


-(void)setUserImage:(UIImage *)userImage{
    
    userImageView.image=userImage;
}

-(UIImage *)userImage{
    
    return userImageView.image;
}

-(void)setUserName:(NSString *)userName{
    
    userNameLabel.text=userName;
}

-(NSString *)userName{
    
    return userNameLabel.text;
}

-(void)setLocation:(NSString *)location{
    
    locationLabel.text=location;
    [locationLabel sizeToFit];
    UIView *locationSuperView=[locationLabel superview];
    locationSuperView.frame=CGRectMake(locationSuperView.frame.origin.x, locationSuperView.frame.origin.y, locationLabel.frame.size.width+10.f, 20.f);
    locationLabel.frame=CGRectMake(locationLabel.frame.origin.x, locationLabel.frame.origin.y, locationLabel.frame.size.width, 20.f);
}

-(NSString *)location{
    return locationLabel.text;
}

-(void)setDateString:(NSString *)dateString{
    
    dateLabel.text=dateString;
}

-(NSString *)dateString{
    
    return dateLabel.text;
}

-(void)setInfoSource:(NSString *)infoSource{
    
    infoSourceLabel.text=infoSource;
}

-(NSString *)infoSource{
    
    return infoSourceLabel.text;
}

-(void)setViewNumber:(NSInteger)viewNumber{
    
    viewNumberLabel.viewNumber=viewNumber;
}

-(NSInteger)viewNumber{
    
    return viewNumberLabel.viewNumber;
}

-(void)setImgUrl:(NSString *)imgUrl{

    if ([imgUrl isEqualToString:_imgUrl]) {
        return;
    }
    [_imgUrl release];
    _imgUrl=[imgUrl retain];
    [userImageView setImageWithURL:[NSURL URLWithString:[imgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:nil];
}

@end


@interface ViewNumberLabel ()
{
    
    NSString *drawText;
}

@end
@implementation ViewNumberLabel

@synthesize viewNumber=_viewNumber;
@synthesize font=_font;
@synthesize textColor=_textColor;

-(void)dealloc{
    
    [_font release];
    [_textColor release];
    [drawText release];
    [super dealloc];
}

-(id)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    if (self) {
        
        _viewNumber=0;
        drawText=[[NSString alloc]initWithFormat:@"该照片已经被%d人浏览",_viewNumber];
        self.textColor=[UIColor blackColor];
        self.font=[UIFont systemFontOfSize:15.f];
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}

-(void)setViewNumber:(NSInteger)viewNumber{
    
    if (viewNumber==_viewNumber) {
        return;
    }
    
    self.backgroundColor=[UIColor clearColor];
    _viewNumber=viewNumber;
    [drawText release];
    drawText=[[NSString alloc]initWithFormat:@"该照片已经被%d人浏览",_viewNumber];
    [self setNeedsDisplay];
}

-(void)setFont:(UIFont *)font{
    
    if ([font isEqual:_font]) {
        return;
    }
    [_font release];
    _font=[font retain];
    [self setNeedsDisplay];
}

-(void)setTextColor:(UIColor *)textColor{
    
    if ([textColor isEqual:_textColor]) {
        return;
    }
    [_textColor  release];
    _textColor=[textColor retain];
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{    
    NSMutableAttributedString *attString=[[NSMutableAttributedString alloc]initWithString:drawText];
    CTTextAlignment alignment = kCTRightTextAlignment;
    CTParagraphStyleSetting settings[] = {
        {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment},
    };
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0]));
    NSDictionary *attrDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    (id)paragraphStyle, (NSString*)kCTParagraphStyleAttributeName,
                                    nil];
    [attString addAttributes:attrDictionary range:NSMakeRange(0, drawText.length)];
    CFRelease(paragraphStyle);
    
    CTFontRef cffont = CTFontCreateWithName((CFStringRef)_font.fontName, _font.pointSize, NULL);
    [attString addAttribute:(id)kCTFontAttributeName value:(id)cffont range:NSMakeRange(0, [drawText length])];
    CFRelease(cffont);
    
    [attString addAttribute:(id)kCTForegroundColorAttributeName
                      value:(id)_textColor.CGColor
                      range:NSMakeRange(0, drawText.length)];
    
    [attString addAttribute:(id)kCTForegroundColorAttributeName
                      value:(id)[UIColor colorWithString:@"#FF0000"].CGColor
                      range:[drawText rangeOfString:[NSString stringWithFormat:@"%d",_viewNumber]]];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(
                                                                           
                                                                           (CFAttributedStringRef)attString);
    
    CGMutablePathRef leftColumnPath = CGPathCreateMutable();
    
    CGPathAddRect(leftColumnPath, NULL,
                  
                  CGRectMake(0, 0,
                             
                             self.bounds.size.width,
                             
                             self.bounds.size.height));
    
    CTFrameRef leftFrame = CTFramesetterCreateFrame(framesetter,
                                                    
                                                    CFRangeMake(0, 0),
                                                    
                                                    leftColumnPath, NULL);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CTFrameDraw(leftFrame, context);
    CGPathRelease(leftColumnPath);
    CFRelease(framesetter);
    [attString release];
    UIGraphicsPushContext(context);
}

@end
