//
//  ScreenViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-10-22.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "ScreenViewController.h"
#import "UIColor+ColorUtils.h"
#import "ScreenSelectCell.h"
#import "AreaSelectView.h"

@interface ScreenViewController ()<AreaSelectDelegate,UITextFieldDelegate>
{
    UITextField *areaTextFiled;
    UITextField *classTextFiled;
}
@end

@implementation ScreenViewController

@synthesize name;
@synthesize selectClassName;
@synthesize selectLocationName;

-(void)dealloc{

    [selectLocationName release];
    [selectClassName release];
    [super dealloc];
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{

    return [self initWithScreenType:ScreenTypeDefault];
}

-(id)initWithScreenType:(ScreenType)type{

    self=[super initWithNibName:nil bundle:nil];
    if (self) {
        _screenType=type;
        selectLocationName=[[NSString alloc]initWithString:@"不限"];
        selectClassName=[[NSString alloc]initWithString:@"不限"];
    }
    return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    switch (_screenType) {
        case ScreenTypeDefault:
            return 2;
            break;
        case ScreenTypeWithName:
            return 3;
            break;
        default:
            return 0;
            break;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if ((_screenType==ScreenTypeDefault&&indexPath.section==0)||(_screenType==ScreenTypeWithName&&indexPath.section==1)) {
        ScreenSelectCell *cell=[[[ScreenSelectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"screnn "] autorelease];
        cell.textLabel.text=@"地区:";
        cell.showSelectPickerImageView=YES;
        cell.textField.text=selectLocationName;
        cell.textField.delegate=self;
        areaTextFiled=cell.textField;
        cell.textField.inputView=[[[AreaSelectView alloc]initWithDelegate:self] autorelease];
        cell.textLabel.textColor=GrayColorForTextColor;
        return cell;
    }else if ((_screenType==ScreenTypeDefault&&indexPath.section==1)||(_screenType==ScreenTypeWithName&&indexPath.section==2)){
    
        ScreenSelectCell *cell=[[[ScreenSelectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"screnn "] autorelease];
        cell.textLabel.text=@"分类:";
        cell.textField.delegate=self;
        cell.showSelectPickerImageView=YES;
        cell.textField.text=selectClassName;
        classTextFiled=cell.textField;
        cell.textLabel.textColor=GrayColorForTextColor;
        return cell;
    }else if (_screenType==ScreenTypeWithName&&indexPath.row==0)
    {
        ScreenSelectCell *cell=[[[ScreenSelectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"scree "] autorelease];
        cell.textLabel.text=@"名称:";
        cell.textLabel.textColor=GrayColorForTextColor;
        cell.textField.text=name;
        cell.textField.delegate=self;
        return cell;
    }
    
    return nil;
}

-(NSDictionary *)screenInfo{

    ScreenSelectCell *nameCell=(ScreenSelectCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *tempName=nil;
    if (nameCell.textField.text==nil||nameCell.textField.text.length==0) {
        tempName=@"-1";
    }else
        tempName=nameCell.textField.text;
   
    NSString *location=nil;
    ScreenSelectCell *locationCell=(ScreenSelectCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    if (locationCell.textField.text==nil||locationCell.textField.text==0||[locationCell.textField.text isEqualToString:@"不限"]) {
        location=@"-1";
    }else
        location=locationCell.textField.text;
    
    NSString *classText=nil;
    ScreenSelectCell *classCell=(ScreenSelectCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    if (classCell.textField.text==nil||classCell.textField.text.length==0||[classCell.textField.text isEqualToString:@"不限"]) {
        classText=@"-1";
    }else
        classText=classCell.textField.text;
    
    if (self.screenType==ScreenTypeDefault) {
        return [NSDictionary dictionaryWithObjectsAndKeys:[tempName isEqualToString:@"不限"]?@"-1":tempName,@"Area",location,@"Classify", nil];
    }else
        return [NSDictionary dictionaryWithObjectsAndKeys:
                tempName,@"Name",
                location,@"Area",
                classText,@"Classify", nil];
}
#pragma mark -Delegate

-(void)cancelDoneAreaSelectView:(AreaSelectView *)areaSelectView{
    [self hiddenKeyboredByAreaSelectView:areaSelectView];
}

-(void)doneSelectAreaSelectView:(AreaSelectView *)areaSelectView{
    [self hiddenKeyboredByAreaSelectView:areaSelectView];
}

-(void)areaSelectView:(AreaSelectView *)areaSelectView didSelectArea:(NSString *)area{

    [self setTextByAreaView:areaSelectView text:area];
}

-(void)hiddenKeyboredByAreaSelectView:(AreaSelectView *)areaView{

    if (areaTextFiled.inputView==areaView) {
        [areaTextFiled resignFirstResponder];
        return;
    }
    if (classTextFiled.inputView==areaView) {
        [classTextFiled resignFirstResponder];
        return;
    }
}

-(void)setTextByAreaView:(AreaSelectView *)areaView text:(NSString *)text{

    if (areaTextFiled.inputView==areaView) {
        areaTextFiled.text=text;
        return;
    }
    if (classTextFiled.inputView==areaView) {
        classTextFiled.text=text;
        return;
    }
}
#pragma mark -UITextFiledDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    if ([textField isEqual:classTextFiled]) {
        return NO;
    }else
        return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([textField.inputView isKindOfClass:[AreaSelectView class]]) {
        AreaSelectView *areaView=(AreaSelectView *)[textField inputView];
        [areaView setRowByText:textField.text];
    }
}
@end
