//
//  EditUserInfoVC.m
//  DXQ
//
//  Created by Yuan on 12-11-13.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "EditUserInfoVC.h"
#import "DataPickerSelectView.h"
#import "WriteSignatureVC.h"
#import "InPutPageVC.h"
#import "UpdateAccountInfoRequest.h"
#import "InputProfesionVC.h"
#import "Tool.h"
#import "Definitions.h"
#import "CustomUIView.h"
#import "DXQAccount.h"
#import "ProgressHUD.h"
#import "SettingManager.h"
#import "DXQCoreDataManager.h"

@interface EditUserInfoVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,DataPickerSelectViewDelegate,UpdateAccountInfoRequestDelegate>
{
    NSMutableDictionary *infoDict;
    
    UITextField *focusTxtField;
    
    UpdateAccountInfoRequest *updateAccountInfoRequest;
    
    BOOL isUpdateAccountInfoRequesting;
}
@property(nonatomic,retain)UITableView *pTableView;

@property(nonatomic,retain)NSMutableArray *dataArray;

@property(nonatomic,retain)UITextField *focusTxtField;

@property(nonatomic,retain)NSMutableDictionary *infoDict;

@end

@implementation EditUserInfoVC
@synthesize pTableView = _pTableView;
@synthesize dataArray = _dataArray;
@synthesize focusTxtField = _focusTxtField;
@synthesize infoDict;

-(void)dealloc
{
    [infoDict release];infoDict = nil;
        
    [_focusTxtField release];_focusTxtField = nil;
    
    [_dataArray release];_dataArray = nil;

    [_pTableView release];_pTableView = nil;
   
    [super dealloc];
}

-(void)viewDidUnload
{
    self.focusTxtField = nil;
    
    self.pTableView = nil;
    
    [super viewDidUnload];
}


- (id)initWithDelegate:(id)delegate
{
    self = [super init];
    if (self)
    {
        NSString *defaultCellHeight = @"44";
        NSString *cellHeight = @"0";
        
        DXQAccount *account = [[DXQCoreDataManager sharedCoreDataManager]getCurrentLoggedInAccount];
        
        infoDict = [[NSMutableDictionary alloc]init];

        NSMutableArray *baseArray = [[NSMutableArray alloc]init];
        for (int i = 0 ; i < 3; i++)
        {
            NSString *title = @"";NSString *value = @"";
            NSString *style = @"";NSString *height = @"";
            NSString *action = @"";NSString *type = @"";
            NSArray *inputviewdatas = [NSArray array];
            switch (i)
            {
                case 0:
                    title = AppLocalizedString(@"昵称");
                    value = account.dxq_MemberName;
                    style = @"2";
                    height = defaultCellHeight;
                    action = @"";
                    type = @"alias";
                    break;
                case 1:
                    title = AppLocalizedString(@"性别");
                    NSLog(@"%@",account.dxq_Sex);
                    value = (account.dxq_Sex && [account.dxq_Sex intValue]==1)?@"男":@"女";
                    style = (@"0");
                    height = defaultCellHeight;
                    action = @"";
                    type = @"sex";
                    inputviewdatas = [NSArray arrayWithObjects:AppLocalizedString(@"男"),AppLocalizedString(@"女"), nil];
                    break;
                case 2:
                    title = AppLocalizedString(@"生日");
                    value = (account.dxq_Birthday)?[Tool convertDateToString:account.dxq_Birthday]:@"";
                    style = (@"0");
                    height = defaultCellHeight;
                    action = @"";
                    type = @"birthday";
                    break;
                default:
                    break;
            }
            NSDictionary *b_item = [NSDictionary dictionaryWithObjectsAndKeys:title,@"title",
                                    style,@"style",
                                    height,@"height",
                                    type,@"type",
                                    action,@"action",
                                    inputviewdatas,@"inputviewdatas",
                                    value,@"value",
                                    nil];
            [baseArray addObject:b_item];
            if (value == nil)value = @"";
            if ([type isEqualToString:@"birthday"])
            {
                NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[(NSDate*)account.dxq_Birthday timeIntervalSince1970]];
                [infoDict setObject:timeSp forKey:type];
            }
            else
            {
                [infoDict setObject:value forKey:type];
            }
        }
        NSDictionary *sectionBaseInfo = [NSDictionary dictionaryWithObjectsAndKeys:baseArray,@"rows",AppLocalizedString(@"基本资料"),@"sectiontitle",@"base",@"type", nil];
        [baseArray release];
        
        NSMutableArray *detailArray = [[NSMutableArray alloc]init];
        for (int i = 0 ; i < 9; i++)
        {
            NSString *title = @"";NSString *value = @"";
            NSString *style = @"";NSString *height = @"";
            NSString *action = @"";NSString *type = @"";
            NSArray *inputviewdatas = [NSArray array];
            switch (i)
            {
                case 0:
                    title = AppLocalizedString(@"婚恋状况");
                    style = (@"0");
                    height = (@"44");
                    action = @"";
                    type = @"marray";
                    inputviewdatas = [NSArray arrayWithObjects:@"未婚",@"已婚",nil];
                    value = (account.dxq_IsMarry && [account.dxq_IsMarry intValue] == 0)?@"未婚":@"已婚";
                    break;
                case 1:
                    title = AppLocalizedString(@"月薪");
                    style = (@"0");
                    height = (@"44");
                    action = @"";
                    type = @"salary";
                    inputviewdatas = [NSArray arrayWithObjects:@"2000元以下",@"2000-5000元",@"5000-10000元",@"10000-20000元",@"20000元以上", nil];
                    value = (account.dxq_Salary)?account.dxq_Salary:@"";
                    break;
                case 2:
                    title = AppLocalizedString(@"身高");
                    style = (@"0");
                    height = (@"44");
                    action = @"";
                    type = @"height";
                    NSMutableArray *harray = [[NSMutableArray alloc]init];
                    for (int i = 100; i <231; i++)
                    {
                        NSString *h = [NSString stringWithFormat:@"%dcm",i];
                        [harray addObject:h];
                    }
                    inputviewdatas = [NSArray arrayWithArray:harray];
                    [harray release];
                    value = (account.dxq_Height&&[account.dxq_Height isKindOfClass:[NSString class]] && [account.dxq_Height length]>0)?account.dxq_Height:@"";
                    break;
                case 3:
                    title = AppLocalizedString(@"血型");
                    style = (@"0");
                    height = (@"44");
                    type = @"blood";
                    inputviewdatas = [NSArray arrayWithObjects:@"O型",@"A型",@"B型",@"AB型",nil];
                    action = @"";
                    value = (account.dxq_Blood==nil||[account.dxq_Blood length]<1)?@"未知":account.dxq_Blood;
                    break;
                case 4:
                    title = AppLocalizedString(@"交友目的");
                    style = (@"1");
                    height = cellHeight;
                    action = @"editDatingpurpose";
                    type = @"datingpurpose";
                    value = account.dxq_PalFor;
                    break;
                case 5:
                    title = AppLocalizedString(@"职业");
                    style = (@"1");
                    height = cellHeight;
                    action = @"editProfession";
                    type = @"profession";
                    value = account.dxq_Profession;
                    break;
                case 6:
                    title = AppLocalizedString(@"学校");
                    style = (@"1");
                    height = cellHeight;
                    action = @"editSchool";
                    type = @"school";
                    value = account.dxq_School;
                    break;
                case 7:
                    title = AppLocalizedString(@"爱好");
                    style = (@"1");
                    height = cellHeight;
                    action = @"editHobby";
                    type = @"hobby";
                    value = account.dxq_Hobby;
                    break;
                case 8:
                    title = AppLocalizedString(@"主页");
                    style = @"1";
                    height = cellHeight;
                    action = @"editHomePage";
                    type = @"homepage";
                    value = account.dxq_Homepage;
                    break;
                default:
                    break;
            }
            if (value && [value length]>0)height = [self getCellHeight:value];

            if (value == nil)value = @"";

            [infoDict setObject:value forKey:type];
            
            NSDictionary *d_item = [NSDictionary dictionaryWithObjectsAndKeys:title,@"title",
                                    style,@"style",
                                    height,@"height",
                                    type,@"type",
                                    action,@"action",
                                    inputviewdatas,@"inputviewdatas",
                                    value,@"value",
                                    nil];
            [detailArray addObject:d_item];
            
        }
        NSDictionary *sectionDetailInfo = [NSDictionary dictionaryWithObjectsAndKeys:detailArray,@"rows",AppLocalizedString(@"详细资料"),@"sectiontitle",@"base",@"type", nil];
        [detailArray release];
        
        _dataArray = [[NSMutableArray alloc]initWithObjects:sectionBaseInfo,sectionDetailInfo, nil];
                
        self.vDelegate = delegate;
    }
    return self;
}

-(void)loadView
{
    CGRect rect =  [UIScreen mainScreen ].applicationFrame;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];
    
    CGRect aboutTableViewFrame = CGRectMake(0,0,rect.size.width,460);
    _pTableView=[[UITableView alloc]initWithFrame:aboutTableViewFrame style:UITableViewStyleGrouped];
    [_pTableView setSeparatorColor:TABLEVIEW_SEPARATORCOLOR];
    _pTableView.backgroundColor=[UIColor clearColor];
    _pTableView.backgroundView = nil;
    _pTableView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _pTableView.delegate = self;
    _pTableView.dataSource = self;
    [self.view addSubview:_pTableView];
    
    _focusTxtField = [[UITextField alloc]initWithFrame:CGRectZero];;
    [self.view addSubview:_focusTxtField];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_round"] forState:UIControlStateNormal];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(saveEdit:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:AppLocalizedString(@"保存") forState:UIControlStateNormal];
    [btn.titleLabel setFont:MiddleBoldDefaultFont];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem=rightItem;
    [rightItem release];
    
}

-(void)saveEdit:(UIButton *)btn
{
    [_focusTxtField becomeFirstResponder];
    [_focusTxtField resignFirstResponder];
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"正在处理")];
    [[ProgressHUD sharedProgressHUD]showInView:[[UIApplication sharedApplication].windows lastObject]];
    
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil, nil];
    HYLog(@"infoDict-->%@",infoDict);
    [parametersDic setObject:[[SettingManager sharedSettingManager]loggedInAccount] forKey:@"AccountId"];
    
    [parametersDic setObject:[infoDict objectForKey:@"alias"] forKey:@"MemberName"];
    
    NSString *sex = [infoDict objectForKey:@"sex"];
    if (sex && [sex length]>0)
    {
        sex = ([sex isEqualToString:@"男"])?@"1":@"0";
        [parametersDic setObject:sex forKey:@"Sex"];
    }
    
    NSString *birthday = [infoDict objectForKey:@"birthday"];
    if (birthday && [birthday length])
    {
        [parametersDic setObject:birthday forKey:@"Birthday"];
    }
    
    NSString *marray = [infoDict objectForKey:@"marray"];
    if (marray &&[marray isKindOfClass:[NSString class]]&& [marray length])
    {
        marray = [marray isEqualToString:@"未婚"]?@"0":@"1";
        [parametersDic setObject:marray forKey:@"IsMarry"];
    }
    [parametersDic setObject:[infoDict objectForKey:@"salary"] forKey:@"Salary"];
    [parametersDic setObject:[infoDict objectForKey:@"height"] forKey:@"Height"];
    [parametersDic setObject:[infoDict objectForKey:@"blood"] forKey:@"Blood"];
    [parametersDic setObject:[infoDict objectForKey:@"datingpurpose"] forKey:@"PalFor"];
    [parametersDic setObject:[infoDict objectForKey:@"profession"] forKey:@"Profession"];
    [parametersDic setObject:[infoDict objectForKey:@"school"] forKey:@"School"];
    [parametersDic setObject:[infoDict objectForKey:@"hobby"] forKey:@"Hobby"];
    [parametersDic setObject:[infoDict objectForKey:@"homepage"] forKey:@"Homepage"];

    isUpdateAccountInfoRequesting = YES;
    updateAccountInfoRequest = [[UpdateAccountInfoRequest alloc] initRequestWithDic:parametersDic];
    updateAccountInfoRequest.delegate = self;
    [updateAccountInfoRequest startAsynchronous];
}

-(void)updateAccountInfoRequestDidFinishedWithParamters:(NSDictionary *)dic
{
    updateAccountInfoRequest.delegate = nil,
    [updateAccountInfoRequest release];
    updateAccountInfoRequest = nil;
    isUpdateAccountInfoRequesting = NO;
    
    [[ProgressHUD sharedProgressHUD] setText:AppLocalizedString(@"保存成功")];
    [[ProgressHUD sharedProgressHUD]done:YES];

    if (self.vDelegate && [self.vDelegate respondsToSelector:@selector(didFinishedAction:)])
    {
        [self.vDelegate didFinishedAction:self];
    }
}

-(void)UpdateAccountInfoRequestDidFinishedWithErrorMessage:(NSString *)errorMsg
{
    updateAccountInfoRequest.delegate = nil,
    [updateAccountInfoRequest release];
    updateAccountInfoRequest = nil;
    [[ProgressHUD sharedProgressHUD] setText:errorMsg];
    [[ProgressHUD sharedProgressHUD]done:NO];
    isUpdateAccountInfoRequesting = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (isUpdateAccountInfoRequesting)
    {
        updateAccountInfoRequest.delegate = nil;
        [updateAccountInfoRequest cancel];
    }
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad
{
    self.navigationItem.title = AppLocalizedString(@"修改资料");

     UIImage *bgImage=[UIImage imageNamed:@"btn_round"];
     UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
     [rightBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
     [rightBtn sizeToFit];
     [rightBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
     [rightBtn setTitle:AppLocalizedString(@"取消") forState:UIControlStateNormal];
     [rightBtn.titleLabel setFont:MiddleBoldDefaultFont];
     UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
     self.navigationItem.leftBarButtonItem=rightItem;
     [rightItem release];
        
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)cancelBtn:(UIButton*)btn
{
    if (self.vDelegate && [self.vDelegate respondsToSelector:@selector(didCancelViewViewController)])
    {
        [self.vDelegate didCancelViewViewController];
    }
}

#define vDelegate Methord
-(void)didFinishedAction:(UIViewController *)viewController witfhInfo:(id)info
{
    HYLog(@"%@",info);
    NSIndexPath *indexPath = [infoDict objectForKey:@"currentSelcetIndex"];
    NSMutableArray *rows = [[_dataArray objectAtIndex:indexPath.section] objectForKey:@"rows"];
    NSMutableDictionary *item = [[NSMutableDictionary alloc]initWithDictionary:[rows objectAtIndex:indexPath.row]];
    [item setObject:info forKey:@"value"];
    [infoDict setObject:info forKey:[item objectForKey:@"type"]];
    [rows replaceObjectAtIndex:indexPath.row withObject:item];
    [item release];
    [_pTableView reloadData];
}

-(NSString *)getCellHeight:(NSString*)detailString
{
    if (!detailString || [detailString length]<1) {
        return @"0";
    }
    CGFloat cellDetailLableWidth = 260.0f;
    CGSize size = [detailString sizeWithFont:NormalDefaultFont constrainedToSize:CGSizeMake(cellDetailLableWidth, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    return [NSString stringWithFormat:@"%f",size.height+26.0+4];//26为title的高度20和上下margin3
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[_dataArray objectAtIndex:section] objectForKey:@"rows"] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)return 40.0;
    return 30.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *rows = [[_dataArray objectAtIndex:indexPath.section] objectForKey:@"rows"];
    CGFloat height = [[self getCellHeight:[[rows objectAtIndex:indexPath.row] objectForKey:@"value"]] floatValue];
    return height > 48?height:48;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[_dataArray objectAtIndex:section] objectForKey:@"sectiontitle"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *items = [[_dataArray objectAtIndex:indexPath.section] objectForKey:@"rows"];
    NSDictionary *item = [items objectAtIndex:indexPath.row];
    NSString *indentifier = [item objectForKey:@"style"];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil)
    {
        if ([indentifier intValue] == 0 || [indentifier intValue] == 2)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                           reuseIdentifier:indentifier] autorelease];
        }
        else
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                           reuseIdentifier:indentifier] autorelease];
        }
        UITextField *aliasField = [[UITextField alloc]initWithFrame:CGRectMake(80,11, 190, 20)];
        aliasField.tag = 2;
        aliasField.textColor = [UIColor colorWithRed:0.000 green:0.180 blue:0.311 alpha:0.950];
        aliasField.font = NormalDefaultFont;
        aliasField.delegate = self;
        aliasField.textAlignment = UITextAlignmentRight;
        if (!(indexPath.section == 0 && indexPath.row == 0))
        {
            DataPickerSelectViewType style = DataPickerSelectViewTypeCommen;
            if (indexPath.section == 0 && indexPath.row == 2)style = DataPickerSelectViewTypeDate;
            DataPickerSelectView *pDataPicker=[[DataPickerSelectView alloc]initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 260.f) withTitle:@"" inPutViewSuperView:aliasField style:style];
            pDataPicker.delegate=self;
            aliasField.clearButtonMode=UITextFieldViewModeNever;
            aliasField.inputView = pDataPicker;
            [pDataPicker release];
        }
        [aliasField setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:aliasField];
        [aliasField release];
    }
    cell.accessoryType = (indexPath.section == 0 && indexPath.row == 0)?UITableViewCellAccessoryNone:UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = ([item objectForKey:@"action"]&&[[item objectForKey:@"action"] length]>0)?UITableViewCellSelectionStyleBlue:UITableViewCellSelectionStyleNone;
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.textColor = [UIColor colorWithRed:0.000 green:0.180 blue:0.311 alpha:0.950];
    cell.textLabel.font = MiddleNormalDefaultFont;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.text = [item objectForKey:@"title"];
    cell.detailTextLabel.font = NormalDefaultFont;
    UITextField *aliasField = (UITextField*)[cell.contentView viewWithTag:2];
    if ([[item objectForKey:@"type"] isEqualToString:@"alias"])
    {
        aliasField.text = [item objectForKey:@"value"];
        aliasField.hidden = NO;
        cell.detailTextLabel.text = @"";
    }
    else
    {
        aliasField.text = @"";
        aliasField.hidden = YES;
        cell.detailTextLabel.text = [item objectForKey:@"value"];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *item = [[[_dataArray objectAtIndex:indexPath.section] objectForKey:@"rows"]  objectAtIndex:indexPath.row];
    if ([[item objectForKey:@"type"] isEqualToString:@"alias"])return;
    
    NSString *actionString = [item objectForKey:@"action"];
    
    if (actionString && [actionString length]>0)
    {
        SEL func = NSSelectorFromString(actionString);
        if ([self respondsToSelector:func])
        {
            [infoDict setObject:indexPath forKey:@"currentSelcetIndex"];
            [self performSelector:func withObject:item];
        }
    }
    else
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UITextField *txtField = (UITextField*)[cell.contentView viewWithTag:2];
        DataPickerSelectView *inputView = (DataPickerSelectView *)txtField.inputView;
        if(inputView)
        {
            [inputView setIndexPath:indexPath];
            [inputView setTitle:[item objectForKey:@"title"]];
            NSArray *data = [item objectForKey:@"inputviewdatas"];
            if(data)[inputView reloadData:data];
        }
        [txtField becomeFirstResponder];
    }
}

-(void)enterInputPageType:(NSInteger )type
{
    NSString *titleString = @"";
    switch (type)
    {
        case 0:
            titleString = AppLocalizedString(@"交友目的");
            break;
        case 1:
            titleString = AppLocalizedString(@"学校");
            break;
        case 2:
            titleString = AppLocalizedString(@"个人爱好");
            break;
        case 3:
            titleString = AppLocalizedString(@"个人主页");
            break;
        case 4:
            titleString = AppLocalizedString(@"个人职位");
            break;
        default:
            break;
    }
    NSIndexPath *indexPath = [infoDict objectForKey:@"currentSelcetIndex"];
    NSMutableArray *rows = [[_dataArray objectAtIndex:indexPath.section] objectForKey:@"rows"];
    NSDictionary *item = [rows objectAtIndex:indexPath.row];
    InPutPageVC *vc = [[InPutPageVC alloc]initWithTitle:titleString content:[item objectForKey:@"value"] delegate:self];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

-(void)editDatingpurpose
{
    [self enterInputPageType:0];
}

-(void)editSchool
{
    [self enterInputPageType:1];
}

-(void)editHobby
{
    [self enterInputPageType:2];
}

-(void)editHomePage
{
    [self enterInputPageType:3];
}

-(void)editProfession
{
    [self enterInputPageType:4];
    /*
    InputProfesionVC *vc = [[InputProfesionVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
     */
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string   // return NO to not change text
{
    NSString *alias = @"";
    if (string&&[string length]>0)
    {
        alias = [NSString stringWithFormat:@"%@%@",textField.text,string];
    }
    else
    {
        alias = [textField.text substringToIndex:[textField.text length]-1];
    }
    [infoDict setObject:alias forKey:@"alias"];
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    UITableViewCell *cell = (UITableViewCell *)[[textField superview] superview];
    NSIndexPath *_index = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *index = [_pTableView indexPathForCell:cell];
    if ([index isEqual:_index])
    {
        UITextField *tf = (UITextField*)[cell.contentView viewWithTag:2];
        HYLog(@"%@",tf.text);
        [infoDict setObject:tf.text forKey:@"alias"];
    }
}

-(void)dataPickerSelectViewDidCancel:(DataPickerSelectView *)selectView inPutViewSuperView:(UIView *)view
{
    [view resignFirstResponder];
}

-(void)dataPickerSelectViewDidDone:(DataPickerSelectView *)selectView inPutViewSuperView:(UIView *)view
{
    [view resignFirstResponder];
}

-(void)dataPickerSelectView:(DataPickerSelectView *)selectView selectIndex:(NSInteger)row withInfo:(NSObject *)info inPutViewSuperView:(UIView *)view style:(DataPickerSelectViewType)style
{
    UITableViewCell *cell = (UITableViewCell *)[[view superview] superview];
    NSIndexPath *indexPath = selectView.indexPath;
    NSMutableArray *rows = [[_dataArray objectAtIndex:indexPath.section] objectForKey:@"rows"];
    NSDictionary *currentItem =  [rows objectAtIndex:indexPath.row];
    
    NSString *selectString = @"";
    
    if (style == DataPickerSelectViewTypeDate)
    {
        selectString = [self formatedBirthdayDate:(NSDate*)info];
        
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[(NSDate*)info timeIntervalSince1970]];
        [infoDict setObject:timeSp forKey:[currentItem objectForKey:@"type"]];
    }
    else
    {
        selectString = (NSString *)info;
        NSMutableDictionary *item = [[NSMutableDictionary alloc]initWithDictionary:currentItem];
        [item setObject:info forKey:@"value"];
        [infoDict setObject:selectString forKey:[item objectForKey:@"type"]];
        [rows replaceObjectAtIndex:indexPath.row withObject:item];
        [item release];
    }
    cell.detailTextLabel.text = selectString;
}

-(NSString *)formatedBirthdayDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *result = [dateFormatter stringFromDate:date];
    [dateFormatter release];
	return result;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
