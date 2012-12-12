//
//  BuyViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-11-28.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "BuyViewController.h"
#import "VerifyOrderViewController.h"
#import "OrderRequest.h"

@interface BuyViewController ()<BusessRequestDelegate>{

    UILabel *nameLabel;
    UILabel *priceLabel;
    UILabel *allPriceLabel;
    
    OrderRequest *orderRequest;
}

@end

@implementation BuyViewController


-(void)dealloc{

    [_productDic release];
    [_tableView release];
    [_buyNumberTextField release];
    [_nameTextField release];
    [_addressTextField release];
    [_postCodeTextField release];
    [_phoneNumberTextField release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _canEditeBuyNumber=YES;
    }
    return self;
}

-(void)loadView{
    
    CGRect rect = [UIScreen mainScreen].bounds;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.backgroundColor=[UIColor clearColor];
    tableView.backgroundView=nil;
    tableView.dataSource=self;
    tableView.delegate=self;
    tableView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:tableView];
    self.tableView=tableView;
    [tableView release];
    
    UIImage *btnImg=[UIImage imageNamed:@"btn_red"];

    UIButton *buyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [buyBtn setBackgroundImage:btnImg forState:UIControlStateNormal];
    [buyBtn addTarget:self action:@selector(buyBtn) forControlEvents:UIControlEventTouchUpInside];
    [buyBtn sizeToFit];
    [buyBtn setTitle:AppLocalizedString(@"确认订单 付款") forState:UIControlStateNormal];
    [buyBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:20.f]];
    
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0.f, self.view.frame.size.height-btnImg.size.height-10.f, self.view.frame.size.width, btnImg.size.height+10.f)];
    footView.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
    footView.backgroundColor=[UIColor clearColor];
    buyBtn.center=CGPointMake(footView.frame.size.width/2, footView.frame.size.height/2);
    footView.tag=20;
    [footView addSubview:buyBtn];
    [self.tableView setTableFooterView:footView];
    [footView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavgationTitle:AppLocalizedString(@"订单") backItemTitle:AppLocalizedString(@"返回")];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [self cancelAllRequest];
}

-(void)setProductDic:(NSDictionary *)productDic{

    if ([productDic isEqualToDictionary:_productDic]) {
        return;
    }
    [_productDic release];
    _productDic=[productDic retain];
    
    if (!_buyNumberTextField) {
        _buyNumberTextField=[self textFieldWithFrame:CGRectMake(170.f, 10.f, 80.f, 31.f)];
        _buyNumberTextField.keyboardType=UIKeyboardTypeNumberPad;
        _buyNumberTextField.text=@"1";
    }
    
    if ([[_productDic objectForKey:@"IsVirtual"] isEqualToString:@"1"]) {
        self.nameTextField=nil;
        self.addressTextField=nil;
        self.phoneNumberTextField=nil;
        self.postCodeTextField=nil;
    }else
    {
        _nameTextField=[self textFieldWithFrame:CGRectMake(100.f, 10.f, 190.f, 31.f)];
        _addressTextField=[self textFieldWithFrame:CGRectMake(100.f, 10.f, 190.f, 31.f)];
        _phoneNumberTextField=[self textFieldWithFrame:CGRectMake(100.f, 10.f, 190.f, 31.f)];
        _postCodeTextField=[self textFieldWithFrame:CGRectMake(100.f, 10.f, 190.f, 31.f)];
        _postCodeTextField.keyboardType=UIKeyboardTypeNumberPad;
        _phoneNumberTextField.keyboardType=UIKeyboardTypeNumberPad;
    }
    [self.tableView reloadData];
}

-(UITextField *)textFieldWithFrame:(CGRect)frame{

    UITextField *textField=[[UITextField alloc]initWithFrame:frame];
    textField.borderStyle=UITextBorderStyleNone;
    textField.clearButtonMode=UITextFieldViewModeWhileEditing;
    textField.delegate=self;
    textField.returnKeyType=UIReturnKeyNext;
    return textField;
}

-(void)keyBoardHidden:(NSNotification *)not{
    
    [UIView animateWithDuration:0.25f animations:^{
        
        self.view.frame=CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

-(void)buyBtn{

    if ([_buyNumberTextField.text integerValue]<=0) {
        [Tool showAlertWithTitle:AppLocalizedString(@"提示") msg:AppLocalizedString(@"购买的数量不能少于1")];
        [_buyNumberTextField becomeFirstResponder];
        return;
    }
    
    BOOL isVirtual=YES;
    if ([[_productDic objectForKey:@"IsVirtual"] isEqualToString:@"0"]) {
        
        isVirtual=NO;
        if (_nameTextField.text.length==0) {
            [Tool showAlertWithTitle:AppLocalizedString(@"提示") msg:AppLocalizedString(@"姓名不能为空!")];
            [_nameTextField becomeFirstResponder];
            return;
        }
        
        if (_addressTextField.text.length==0) {
            [Tool showAlertWithTitle:AppLocalizedString(@"提示") msg:AppLocalizedString(@"详细地址不能为空!")];
            [_addressTextField becomeFirstResponder];
            return;

        }
        if (_phoneNumberTextField.text.length==0) {
            [Tool showAlertWithTitle:AppLocalizedString(@"提示") msg:AppLocalizedString(@"手机号码不能为空!")];
            [_phoneNumberTextField becomeFirstResponder];
            return;
            
        }
        if (_postCodeTextField.text.length==0) {
            [Tool showAlertWithTitle:AppLocalizedString(@"提示") msg:AppLocalizedString(@"邮政编码不能为空!")];
            [_postCodeTextField becomeFirstResponder];
            return;
        }
    }
    
    [_nameTextField resignFirstResponder];
    [_addressTextField resignFirstResponder];
    [_buyNumberTextField resignFirstResponder];
    [_phoneNumberTextField resignFirstResponder];
    [self orderRequestByDic:[self buyInfoDic]];
}

-(NSDictionary *)buyInfoDic{
    
    NSString *name=nil;
    if (_nameTextField.text.length==0) {
        name=@"";
    }else
        name=_nameTextField.text;
    NSString *address=nil;
    if (_addressTextField.text.length==0) {
        address=@"";
    }else
        address=_addressTextField.text;
    
    NSString *accountID=[[SettingManager sharedSettingManager]loggedInAccount];
//    NSString *accountID=[[SettingManager sharedSettingManager]loggedInAccount];
    NSDictionary *buyInfoDic=[NSDictionary dictionaryWithObjectsAndKeys:
                              accountID,@"AccountId",
                              [_productDic objectForKey:@"ProductCode"],@"ProductCode",
                              _buyNumberTextField.text,@"ProductCount",
                              address,@"ReceiverAddress",
                              @"",@"ReceiverEmail",
                              name,@"ReceiverName",
                              _phoneNumberTextField.text,@"ReceiverPhone",
                              _postCodeTextField.text,@"ReceiverPostalCode", nil];
    return buyInfoDic;
}

#pragma mark- Request

-(void)cancelAllRequest{
    
    if (orderRequest) {
        [orderRequest cancel];
        [orderRequest release];
        orderRequest=nil;
    }
}


-(void)orderRequestByDic:(NSDictionary *)dic{
    
    if (orderRequest) {
        [orderRequest cancel];
        [orderRequest release];
        orderRequest=nil;
    }
  
    [[ProgressHUD sharedProgressHUD]showInView:[[[UIApplication sharedApplication]windows]objectAtIndex:0]];
    [[ProgressHUD sharedProgressHUD]setText:@""];
    orderRequest=[[OrderRequest alloc]initWithRequestWithDic:dic];
    orderRequest.delegate=self;
    [orderRequest startAsynchronous];
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFailedWithErrorMsg:(NSString *)msg{

    [[ProgressHUD sharedProgressHUD]setText:msg];
    [[ProgressHUD sharedProgressHUD]done:NO];
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFinishWithData:(id)data{

    if([request isEqual:orderRequest]){
        
        if ([[data objectForKey:@"IsPayed"] integerValue]==1) {
            [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"购买成功")];
            [[ProgressHUD sharedProgressHUD]done:YES];
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
        [[ProgressHUD sharedProgressHUD]hide];
        
        BOOL isVirtual=YES;
        if ([[_productDic objectForKey:@"IsVirtual"] isEqualToString:@"0"]) {
            isVirtual=NO;
        }
        VerifyOrderViewController *verify=[[VerifyOrderViewController alloc]init];
        verify.orderInfoDic=[self buyInfoDic];
        verify.needAddress=!isVirtual;
        verify.productInfoDic=_productDic;
        [self.navigationController pushViewController:verify animated:YES];
        [verify release];
    }
}
#pragma mark -UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    if ([textField isEqual:_nameTextField]) {
        [_addressTextField becomeFirstResponder];
    }else if([textField isEqual:_addressTextField])
    {
        [_postCodeTextField becomeFirstResponder];
    }else if ([_postCodeTextField isEqual:textField]){
    
        [_phoneNumberTextField becomeFirstResponder];
    } else
        [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if ([textField isEqual:_buyNumberTextField]||[textField isEqual:_phoneNumberTextField]||[textField isEqual:_postCodeTextField]) {
        NSString *match=@"^[0-9]*$";
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"self matches %@",match];
        return [predicate evaluateWithObject:string];
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:_buyNumberTextField]) {
        return _canEditeBuyNumber;
    }
    CGRect viewFrame=CGRectZero;
    if (textField.tag>1) {
        viewFrame=CGRectMake(0.f, -50.0f-(textField.tag-1)*40.f, self.view.frame.size.width, self.view.frame.size.height);
    }else
        viewFrame=CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView animateWithDuration:0.25f animations:^{
        
        self.view.frame=viewFrame;
    }];
    return YES;
}

#pragma mark -UITableViewDataSouce And Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    if (!_productDic) {
        return 0;
    }else
    {
        if ([[_productDic objectForKey:@"IsVirtual"] isEqualToString:@"1"]) {
            return 1;
        }else
            return 2;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (!_productDic) {
        return 0;
    }else
    {
        if ([[_productDic objectForKey:@"IsVirtual"] isEqualToString:@"1"]) {
            return 1;
        }else
        {
            if (section==0) {
                return 4;
            }else
                return 1;
        }
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    if (section==0) {
        return [_productDic objectForKey:@"ProductTitle"];
    }else
        return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *orderInput=@"Order input";
    TextFieldTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:orderInput];
    if (!cell) {
        cell=[[[TextFieldTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:orderInput] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    UIColor *textColor=[UIColor colorWithRed:182.f/255.f green:182.f/255.f blue:182.f/255.f alpha:1.f];
    if (indexPath.row==0&&indexPath.section==0) {
        cell.textLabel.text=AppLocalizedString(@"购买数量:");
        cell.detailTextLabel.text=AppLocalizedString(@"份");
        cell.textLabel.textColor=textColor;
        cell.detailTextLabel.textColor=textColor;
        cell.textFiled=_buyNumberTextField;
        return cell;
    }else
        cell.detailTextLabel.text=nil;
    
    if ([[_productDic objectForKey:@ "IsVirtual"] isEqualToString:@"0"]) {
        if (indexPath.section==0) {
            switch (indexPath.row) {
                case 1:
                {
                    cell.textLabel.text=AppLocalizedString(@"姓     名:");
                    cell.textFiled=_nameTextField;
                }
                    break;
                case 2:
                {
                    cell.textLabel.text=AppLocalizedString(@"详细地址:");
                    cell.textFiled=_addressTextField;
                }
                    break;
                case 3:
                {
                    cell.textLabel.text=AppLocalizedString(@"邮政编码:");
                    cell.textFiled=_postCodeTextField;
                }
                    break;
                default:
                {
                    cell.textFiled=nil;
                    cell.textLabel.text=nil;
                }
                    break;
            }
        }else
        {
            cell.textLabel.text=AppLocalizedString(@"手机号码:");
            cell.textFiled=_phoneNumberTextField;
        }
    }
    cell.textFiled.tag=indexPath.row;
    
    if (indexPath.section==1) {
        cell.textFiled.tag=4;
    }
    cell.textLabel.textColor=textColor;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    TextFieldTableViewCell *cell=(TextFieldTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textFiled isFirstResponder]) {
        [cell.textFiled resignFirstResponder];
    }else
        [cell.textFiled becomeFirstResponder];
}

//tableView cell for virtual
@end


@implementation TextFieldTableViewCell

-(void)dealloc{

    [_textFiled release];
    [super dealloc];
}


-(void)setTextFiled:(UITextField *)textFiled{

    if (textFiled==nil) {
        [_textFiled removeFromSuperview];
        [_textFiled release];
        _textFiled=nil;
        return;
    }
    if ([textFiled isEqual:_textFiled]) {
        return;
    }
    [_textFiled release];
    [_textFiled removeFromSuperview];
    _textFiled=[textFiled retain];
    [self.contentView addSubview:textFiled];
}

@end