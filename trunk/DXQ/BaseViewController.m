//
//  BaseViewController.m
//  DXQ
//
//  Created by Yuan.He on 12-9-23.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "BaseViewController.h"
#import "PPRevealSideViewController.h"
#import "BaseNavigationItemViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
@synthesize vDelegate;

@synthesize deSelectTableViewWhenViewDidAppear=_deSelectTableViewWhenViewDidAppear;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        _deSelectTableViewWhenViewDidAppear=YES;
    }
    return self;
}


-(void)loadView
{
    CGRect rect = [UIScreen mainScreen].bounds;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UIImage *leftImg=[UIImage imageNamed:@""];
//    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:nil];
	// Do any additional setup after loading the view.
}

-(void)setNavgationTitle:(NSString *)title backItemTitle:(NSString *)backitemtitle
{
    if (title) [self.navigationItem setTitle:title];
    if (backitemtitle)self.navigationItem.leftBarButtonItem=[BaseNavigationItemViewController defaultItemWithTitle:backitemtitle target:self action:@selector(back)];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)didSelectControl:(NSString *)viewController
{
    PPRevealSideViewController *menuController = [AppDelegate sharedAppDelegate].menuController;
    UIViewController *controller = [[NSClassFromString(viewController) alloc]init];
    CustonNavigationController *navController = [[CustonNavigationController alloc] initWithRootViewController:controller];
    [controller release];
    [menuController popViewControllerWithNewCenterController:navController animated:YES];
    [navController release];
}

-(void)showleft
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    PPRevealSideViewController *side=appDelegate.menuController;
    [side pushOldViewControllerOnDirection:PPRevealSideDirectionLeft animated:YES];
}


-(void)showRighte
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    PPRevealSideViewController *side=appDelegate.menuController;
    [side pushOldViewControllerOnDirection:PPRevealSideDirectionRight animated:YES];
    
}

-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    for (UITableView *tableView in self.view.subviews) {
        if ([tableView isKindOfClass:[UITableView class]]) {
            NSIndexPath *selectIndexPath=[tableView indexPathForSelectedRow];
            if (selectIndexPath) {
                [tableView deselectRowAtIndexPath:selectIndexPath animated:YES];
            }
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
