//  Created by Yuan on 12-11-14.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "HYEmojiView.h"
#import <QuartzCore/QuartzCore.h>

#define PAGE_COLUMNS 7 //每页7列

#define PAGE_ROWS 3 //每页3行

#define EMOJISIZE  32.0f //表情尺寸

#define EMOJIZOOM_SIZE 55 //放大的表情尺寸

#define SCROLLVIEW_HEIGHT 152.0f //表情框的高度

#define HYEMOJIVIEW_SHOWER_WIDTH 82

#define HYEMOJIVIEW_SHOWER_HEIGHT 111

@interface HYEmojiView(Private)

-(void)reloadEmoji:(EmojiType)type;

-(void)updateToolBarWithIndex:(NSInteger)index;

@end

@implementation HYEmojiView

@synthesize emojiDictData = _emojiDictData;

@synthesize pageControl = _pageControl;

@synthesize scrollView = _scrollView;

@synthesize currentEmojiType = _currentEmojiType;

@synthesize emojiBoardView = _emojiBoardView;

@synthesize clickImageView = _clickImageView;

@synthesize delegate;

-(void)dealloc
{
    [_clickImageView release];_clickImageView = nil;
    
    [_emojiDictData release];_emojiDictData = nil;
    
    [_emojiBoardView release];_emojiBoardView = nil;
    
    [_pageControl release];_pageControl  = nil;
    
    [_scrollView release];_scrollView = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame superViewHeight:(CGFloat)superViewHeight delegate:(id)delegate_
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.delegate = delegate_;
        
        HYEmojiData *data = [[HYEmojiData alloc]init];
        _emojiDictData = [[NSDictionary alloc]initWithDictionary:[data emojiDictionary]];
        [data release];
        
        CGRect rect = [UIScreen mainScreen].applicationFrame;
        CGFloat selfHeight = 216.0; //keyboard height
        frame.size.width = rect.size.width;
        frame.size.height = selfHeight;
        frame.origin.y = superViewHeight - selfHeight;
        self.frame = frame;
        self.layer.shadowColor = [UIColor grayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0.0,-2.0);
        self.layer.shadowOpacity = 0.6;
        self.layer.shadowRadius = 2.0f;
        self.backgroundColor = [UIColor colorWithWhite:0.936 alpha:1.000];
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0,10.0f, frame.size.width, 10)];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.numberOfPages = 0;
        _pageControl.currentPage = 0;
        [self addSubview:_pageControl];
        
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,15.0f,frame.size.width,SCROLLVIEW_HEIGHT)];
        [_scrollView setBackgroundColor:[UIColor clearColor]];
        [_scrollView setPagingEnabled:YES];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setDelegate:self];
        [self addSubview:_scrollView];
        
        _emojiBoardView = [[HYEmojiBoardView alloc]initWithFrame:CGRectMake(0,0,frame.size.width,SCROLLVIEW_HEIGHT) withDelegate:delegate_];
        [_scrollView addSubview:_emojiBoardView];
        
        HYEmojiViewLayer *_emojiViewLayer = [HYEmojiViewLayer layer];
        [self.layer addSublayer:_emojiViewLayer];
        _emojiBoardView.emojiViewLayer = _emojiViewLayer;
        
        UIImage *toolBarImage = [UIImage imageNamed:@"bg_emoji_type.jpg"];
        CGRect toolRect = CGRectMake(0.0,frame.size.height-toolBarImage.size.height,toolBarImage.size.width,toolBarImage.size.height);
        UIView *bottomView = [[UIView alloc]initWithFrame:toolRect];
        [bottomView setBackgroundColor:[UIColor colorWithPatternImage:toolBarImage]];
        _clickImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,toolBarImage.size.width/PAGE_COLUMNS,toolBarImage.size.height)];
        [bottomView addSubview:_clickImageView];
        [self addSubview:bottomView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toolbarAction:)];
        [bottomView addGestureRecognizer:tap];
        [tap release];
        [bottomView release];
    }
    _currentEmojiType = EmojiTypeHistory;
    
    [self reloadEmoji:EmojiTypeSmile];
    
    return self;
}

-(void)updateToolBarWithIndex:(NSInteger)index
{
    if (index >5 && [self.delegate respondsToSelector:@selector(showKeyBoard:)])
    {
        [self.delegate showKeyBoard:self];
    }
    else
    {
        [self reloadEmoji:index];
    }
    CGRect rect = _clickImageView.frame;
    rect.origin.x = index*self.frame.size.width/PAGE_COLUMNS-1;
    _clickImageView.frame = rect;
    [_clickImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_emoji_type%d.jpg",index]]];
}

-(void)toolbarAction:(UIGestureRecognizer *)gesture
{
    NSUInteger index = [gesture locationInView:self].x/(self.frame.size.width/ PAGE_COLUMNS);
    [self updateToolBarWithIndex:index];
}

-(void)reloadEmoji:(EmojiType)type
{
    if (type ==  _currentEmojiType)return;
    
    _currentEmojiType = type;
    
    NSArray *items ;
    
    if (type == EmojiTypeHistory)
        items = [NSArray arrayWithContentsOfFile:[HYEmojiData historyFilePath]];
    else
        items = [_emojiDictData objectForKey:[NSString stringWithFormat:@"%d",type]];
    
    NSInteger totalPages = ceil((float)[items count]/(PAGE_ROWS*PAGE_COLUMNS));
    
    CGRect boardFrame = _emojiBoardView.frame;
    boardFrame.size.width = _scrollView.frame.size.width * totalPages;
    [_emojiBoardView setFrame:boardFrame];
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width * totalPages,0.0)];
    _pageControl.numberOfPages = totalPages;
    _pageControl.currentPage = 0;
    _emojiBoardView.currentPage = 0;
    _emojiBoardView.emojiArray = items;
    
    [_emojiBoardView setNeedsDisplay];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sv
{
	CGFloat pageWidth = sv.frame.size.width;
	int page = floor((sv.contentOffset.x - pageWidth/2)/pageWidth)+1;
    _emojiBoardView.currentPage = page;
    _pageControl.currentPage = page;
}

- (void)drawRect:(CGRect)rect
{
    //top edge line
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ref, 2.0);
    CGContextSetRGBStrokeColor(ref, 0, 0, 0, 0.7);
    CGContextMoveToPoint(ref, 0.0, 0.0);
    CGContextAddLineToPoint(ref,self.frame.size.width, 0);
    CGContextStrokePath(ref);
}
@end

@implementation HYEmojiBoardView

@synthesize currentPage = _currentPage;

@synthesize emojiArray = _emojiArray;

@synthesize emojiViewLayer = _emojiViewLayer;

@synthesize touchedIndex = _touchedIndex;

@synthesize delegate;

-(void)dealloc
{
    _emojiViewLayer = nil;
    [_emojiArray release];_emojiArray = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame withDelegate:(id)delegate_
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.delegate = delegate_;
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGRect applicationFrame = [UIScreen mainScreen].applicationFrame;
    CGFloat itemSpace_X = (applicationFrame.size.width-PAGE_COLUMNS*EMOJISIZE)/(PAGE_COLUMNS+1);
    CGFloat itemSpace_Y = (SCROLLVIEW_HEIGHT - PAGE_ROWS*EMOJISIZE)/(PAGE_ROWS+1);
    NSInteger totalPages = ceil((float)[_emojiArray count]/(PAGE_ROWS*PAGE_COLUMNS));
    for (int page = 0 ; page < totalPages; page++)
    {
        CGFloat base_X = applicationFrame.size.width*page;
        for (int row = 0 ; row < PAGE_ROWS ; row++)
        {
            for (int col = 0 ; col < PAGE_COLUMNS ; col++)
            {
                NSInteger idx = page*PAGE_ROWS*PAGE_COLUMNS + row*PAGE_COLUMNS + col;
                if (idx >= [_emojiArray count])break;
                CGFloat item_x = base_X + itemSpace_X + col*(EMOJISIZE + itemSpace_X);
                CGFloat item_y = itemSpace_Y + row*(EMOJISIZE + itemSpace_Y);
                CGRect itemFrame = CGRectMake(item_x,item_y,EMOJISIZE,EMOJISIZE);
                UIImage *image = [UIImage imageNamed:[[_emojiArray objectAtIndex:idx] objectForKey:kHYEMOJI_IMG]];
                [image drawInRect:itemFrame];
            }
        }
    }
}

#pragma mark 获取点击表情的index
- (NSUInteger)touchesEmojiIndex:(UIEvent*)event
{
    UITouch* touch = [[event allTouches] anyObject];
    CGRect applicationFrame = [UIScreen mainScreen].applicationFrame;
    
    NSUInteger x = ([touch locationInView:self].x - applicationFrame.size.width*_currentPage)/ (applicationFrame.size.width/ PAGE_COLUMNS);
    NSUInteger y = [touch locationInView:self].y / (self.bounds.size.height / PAGE_ROWS);
    
    NSInteger index = x + (y * PAGE_COLUMNS) + _currentPage*PAGE_ROWS*PAGE_COLUMNS;
    return index;
}

- (void)updateWithIndex:(NSUInteger)index
{
    if(index < _emojiArray.count)
    {
        _touchedIndex = index;
        
        if (_emojiViewLayer.opacity != 1.0)_emojiViewLayer.opacity = 1.0;

        CGRect applicationFrame = [UIScreen mainScreen].applicationFrame;
        
        CGFloat itemSpace_X = (applicationFrame.size.width-PAGE_COLUMNS*EMOJISIZE)/(PAGE_COLUMNS+1);
        CGFloat itemSpace_Y = (SCROLLVIEW_HEIGHT - PAGE_ROWS*EMOJISIZE)/(PAGE_ROWS+1);
        
        CGFloat gridWidth = (applicationFrame.size.width-itemSpace_X)/PAGE_COLUMNS;
        CGFloat gridHeight = (self.frame.size.height-itemSpace_Y)/PAGE_ROWS;
       
        NSInteger touchRow = floor((float)_touchedIndex/PAGE_COLUMNS)-PAGE_ROWS*_currentPage;
        
        CGFloat emoji_x = itemSpace_X/2  + (_touchedIndex%PAGE_COLUMNS)*gridWidth;
        CGFloat emoji_y = itemSpace_Y/2 + touchRow*gridHeight;
        
        CGFloat layer_x = emoji_x+(gridWidth - HYEMOJIVIEW_SHOWER_WIDTH)/2;
        CGFloat layer_y = emoji_y-HYEMOJIVIEW_SHOWER_HEIGHT/2;
      
        CGRect  layerFrame = CGRectMake(layer_x,layer_y, HYEMOJIVIEW_SHOWER_WIDTH, HYEMOJIVIEW_SHOWER_HEIGHT);
        NSDictionary *selectItem = [_emojiArray objectAtIndex:_touchedIndex];
        UIImage *image = [UIImage imageNamed:[selectItem objectForKey:kHYEMOJI_IMG]];
        
        [_emojiViewLayer setCurrentEmoji:image];
        [_emojiViewLayer setFrame:layerFrame];
        [_emojiViewLayer setNeedsDisplay];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSUInteger index = [self touchesEmojiIndex:event];
    if(index < _emojiArray.count)
    {
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        [self updateWithIndex:index];
        [CATransaction commit];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSUInteger index = [self touchesEmojiIndex:event];
    if (_touchedIndex >=0 && index != _touchedIndex && index < _emojiArray.count)
    {
        [self updateWithIndex:index];
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    _touchedIndex = -1;
    _emojiViewLayer.opacity = 0.0;
    [self setNeedsDisplay];
    [_emojiViewLayer setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.delegate && _touchedIndex >= 0 && _touchedIndex < [_emojiArray count])
    {
        if ([self.delegate respondsToSelector:@selector(didSelectEmojiImage:EmojiString:)])
        {
            //callback
            NSDictionary *selectItem = [_emojiArray objectAtIndex:_touchedIndex];
            [self.delegate didSelectEmojiImage:[UIImage imageNamed:[selectItem objectForKey:kHYEMOJI_IMG]] EmojiString:[selectItem objectForKey:kHYEMOJI_EM]];
           
            //record history
            NSArray *history = [NSArray arrayWithContentsOfFile:[HYEmojiData historyFilePath]];
            if (![history containsObject:selectItem])
            {
                NSMutableArray *wHistory = [[NSMutableArray alloc]initWithArray:history];
                [wHistory addObject:selectItem];
                [wHistory writeToFile:[HYEmojiData historyFilePath] atomically:YES];
                [wHistory release];
            }
        }
    }
    _touchedIndex = -1;
    _emojiViewLayer.opacity = 0.0;
    [self setNeedsDisplay];
    [_emojiViewLayer setNeedsDisplay];
}


@end

@implementation HYEmojiViewLayer

@synthesize currentEmoji = _currentEmoji;

- (id)init
{
    self = [super init];
    if (self) {}
    return self;
}

- (void)dealloc
{
    _showerBackGroundImage = nil;
    _currentEmoji = nil;
    [super dealloc];
}

- (void)drawInContext:(CGContextRef)context
{
    //绘制小弹出层的背景
    _showerBackGroundImage = [[UIImage imageNamed:@"emoji_touch.png"] CGImage];
    UIGraphicsBeginImageContext(CGSizeMake(HYEMOJIVIEW_SHOWER_WIDTH, HYEMOJIVIEW_SHOWER_HEIGHT));
    CGContextTranslateCTM(context, 0.0, HYEMOJIVIEW_SHOWER_HEIGHT);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGRectMake(0, 0, HYEMOJIVIEW_SHOWER_WIDTH, HYEMOJIVIEW_SHOWER_HEIGHT), _showerBackGroundImage);
    UIGraphicsEndImageContext();
    
    //绘制放大的表情
    UIGraphicsBeginImageContext(CGSizeMake(EMOJIZOOM_SIZE, EMOJIZOOM_SIZE));
    CGContextDrawImage(context, CGRectMake((HYEMOJIVIEW_SHOWER_WIDTH - EMOJIZOOM_SIZE) / 2 ,45.0f, EMOJIZOOM_SIZE, EMOJIZOOM_SIZE), [_currentEmoji CGImage]);
    UIGraphicsEndImageContext();
}

@end

