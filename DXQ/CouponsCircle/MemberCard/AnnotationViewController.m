//
//  AnnotationViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-11-1.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "AnnotationViewController.h"
#import "BaseAnnotation.h"

@interface AnnotationViewController ()

@end

@implementation AnnotationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setNavgationTitle:@"地图" backItemTitle:AppLocalizedString(@"返回")];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    BaseAnnotation *ann=nil;
    if (_theMapView.annotations.count>0) {
        ann=[_theMapView.annotations objectAtIndex:0];
    }
    if (ann) {
        [_theMapView selectAnnotation:ann animated:YES];
        [_theMapView setCenterCoordinate:ann.coordinate animated:YES];
    }
}
-(void)setNavgationTitle:(NSString *)title backItemTitle:(NSString *)backitemtitle
{
    if (title) [self.navigationItem setTitle:title];
    if (backitemtitle)self.navigationItem.leftBarButtonItem=[BaseNavigationItemViewController defaultItemWithTitle:backitemtitle target:self action:@selector(back)];
}

-(void)back{

    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
//    // [super didReceiveMemoryWarning];
}

#pragma mark -MKMapViewDelegate


- (void)dealloc {
    [_theMapView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTheMapView:nil];
    [super viewDidUnload];
}
@end
