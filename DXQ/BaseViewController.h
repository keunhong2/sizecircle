//
//  BaseViewController.h
//  DXQ
//
//  Created by Yuan.He on 12-9-23.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomUIView.h"
#import "CustonNavigationController.h"

@protocol UniversalViewControlDelegate <NSObject>

@optional
-(void)didCancelViewViewController;

-(void)didFinishedAction:(UIViewController *)viewController;

-(void)didFinishedAction:(UIViewController *)viewController witfhInfo:(id)info;

@end

@interface BaseViewController : UIViewController
{
    id<UniversalViewControlDelegate>vDelegate;
}

@property(nonatomic,assign)id<UniversalViewControlDelegate>vDelegate;

@property (nonatomic)BOOL deSelectTableViewWhenViewDidAppear;//default YES ,when view did appear ,if self.view subviews contain UITableView, and the indexPath of select is not nil, tableview will deselect tableview animated


-(void)setNavgationTitle:(NSString *)title backItemTitle:(NSString *)backitemtitle;

-(void)back;

-(void)didSelectControl:(NSString *)viewController;

@end
