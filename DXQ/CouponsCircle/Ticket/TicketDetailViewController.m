//
//  TicketDetailViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-10-21.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "TicketDetailViewController.h"
#import "TicketInfoHeaderView.h"

@interface TicketDetailViewController ()

@end

@implementation TicketDetailViewController

@synthesize ticketImagesView=_ticketImagesView;

-(void)dealloc{
    
    [_ticketImagesView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView{
    
    [super loadView];
    
    TicketInfoHeaderView *header=[[TicketInfoHeaderView alloc]initWithFrame:self.memberInfoView.frame];
    [header.actionView.praiseBtn addTarget:self action:@selector(admireRequest) forControlEvents:UIControlEventTouchUpInside];
    [[header.actionView follwerBtn]addTarget:self action:@selector(relationRequest) forControlEvents:UIControlEventTouchUpInside];
    [header.actionView.shareBtn addTarget:self action:@selector(shareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:header];
    
    self.memberInfoView=header;
    
    TicketImagesView *tempTicketImageView=[[TicketImagesView alloc]initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 130.f)];
    self.tableView.tableHeaderView=tempTicketImageView;
    self.ticketImagesView=tempTicketImageView;
    [tempTicketImageView release];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavgationTitle:AppLocalizedString(@"优惠券详情") backItemTitle:AppLocalizedString(@"返回")];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)busessRequest:(DXQBusessBaseRequest *)request didFinishWithData:(id)data{
    
    [super busessRequest:request didFinishWithData:data];
    if ([request.actionName isEqualToString:@"UserLoadProductDetail"]) {
        TicketImagesView *tempView=(TicketImagesView *)self.tableView.tableHeaderView;
        if ([tempView isKindOfClass:[TicketImagesView class]]) {
            tempView.imageArray=[NSArray arrayWithObject:data];
        }
    }
}

@end
