//
//  AboutTableViewDataSource.m
//  DXQ
//
//  Created by Yuan on 12-10-20.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "AboutTableViewDataSource.h"
#import "UIFont+Height.h"
#import "ReceivedGiftsVC.h"
#import "UIImageView+WebCache.h"
#import "ShowAddressOnMapVC.h"


#define TABLEVIEW_SECTION_USERINFO  @"userinfo"
#define TABLEVIEW_SECTION_GIFTS  @"gifts"

#define CELL_ITEM_KEY_TITLE @"title" //标题
#define CELL_ITEM_KEY_KEY @"key" //显示出来值的key
#define CELL_ITEM_KEY_VALUE @"value"//显示出来的值
#define CELL_ITEM_KEY_STYLE @"style"//cell的样式
#define CELL_ITEM_KEY_HEIGHT @"height"//cell的高度
#define CELL_ITEM_KEY_ISACTION @"isAction"//是否能点击
#define CELL_ITEM_KEY_ACTION @"action"//点击事件

@interface AboutTableViewDataSource()
@property (nonatomic,assign)    UIViewController *viewControl;
@property (retain, nonatomic)   NSMutableArray   *data;

@end

@implementation AboutTableViewDataSource
@synthesize data = _data;
@synthesize viewControl = _viewControl;

- (void)dealloc
{
    [_viewControl release];_viewControl = nil;
    [_data release];_data = nil;
    [super dealloc];
}


-(NSString *)getCellHeight:(NSString*)detailString
{
    if (!detailString || [detailString length]<1) {
        return @"0";
    }
    CGFloat cellDetailLableWidth = 300.0f;
    CGSize size = [detailString sizeWithFont:NormalDefaultFont constrainedToSize:CGSizeMake(cellDetailLableWidth, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    return [NSString stringWithFormat:@"%f",size.height+26.0+4];//26为title的高度20和上下margin3
}

-(void)reloadData:(NSString *)accountID
{    
    [_data removeAllObjects];
    
    DXQAccount *user = [[DXQCoreDataManager sharedCoreDataManager]getAccountByAccountID:accountID];
    
    NSMutableArray *userinfoArray = [[NSMutableArray alloc]init];

    NSString *cellDefaultHeight = @"44.0f";
    NSString *cellGiftHeight = @"85.0f";
    
    //婚姻状况
//    NSString *marryStatus = [_userinfoDict objectForKey:@"IsMarry"];
    NSString *marryStatus = user.dxq_IsMarry;
    if (marryStatus&&[marryStatus isKindOfClass:[NSString class]] && [marryStatus length]>0)
    {
        NSString *marryStatusString =  ([marryStatus integerValue] == 0 )?@"未婚":@"已婚";
        NSDictionary *item =     [NSDictionary dictionaryWithObjectsAndKeys:
                                  AppLocalizedString(@"婚恋状态"),CELL_ITEM_KEY_TITLE,
                                  @"marray",CELL_ITEM_KEY_KEY,
                                  marryStatusString,CELL_ITEM_KEY_VALUE,
                                  @"0",CELL_ITEM_KEY_STYLE,
                                  cellDefaultHeight,CELL_ITEM_KEY_HEIGHT,
                                  @"0",CELL_ITEM_KEY_ISACTION,
                                  @"",CELL_ITEM_KEY_ACTION, nil];
        [userinfoArray addObject:item];
    }
    
    //年龄
//    NSNumber *age = [_userinfoDict objectForKey:@"Age"];
    NSNumber *age = user.dxq_Age;
    if (age&&[age isKindOfClass:[NSNumber class]])
    {
        NSString *ageString = [age stringValue];
        NSDictionary *item =     [NSDictionary dictionaryWithObjectsAndKeys:
                                  AppLocalizedString(@"年龄"),CELL_ITEM_KEY_TITLE,
                                  @"age",CELL_ITEM_KEY_KEY,
                                  ageString,CELL_ITEM_KEY_VALUE,
                                  @"0",CELL_ITEM_KEY_STYLE,
                                  cellDefaultHeight,CELL_ITEM_KEY_HEIGHT,
                                  @"0",CELL_ITEM_KEY_ISACTION,
                                  @"",CELL_ITEM_KEY_ACTION, nil];
        [userinfoArray addObject:item];
    }

    //月薪
//    NSNumber *salary = [_userinfoDict objectForKey:@"Salary"];
    NSString *salary = user.dxq_Salary;
    if (salary&&[salary isKindOfClass:[NSString class]]&&[salary length]>0)
    {
        NSString *salaryString = salary;
        NSDictionary *item =     [NSDictionary dictionaryWithObjectsAndKeys:
                                  AppLocalizedString(@"月薪"),CELL_ITEM_KEY_TITLE,
                                  @"salary",CELL_ITEM_KEY_KEY,
                                  salaryString,CELL_ITEM_KEY_VALUE,
                                  @"0",CELL_ITEM_KEY_STYLE,
                                  cellDefaultHeight,CELL_ITEM_KEY_HEIGHT,
                                  @"0",CELL_ITEM_KEY_ISACTION,
                                  @"",CELL_ITEM_KEY_ACTION, nil];
        [userinfoArray addObject:item];
    }
    
    //身高
//    NSNumber *height = [_userinfoDict objectForKey:@"Height"];
    NSString *height = user.dxq_Height;
    if (height&&[height isKindOfClass:[NSString class]]&&[height length]>0)
    {
        
        NSString *heightString = height;
        NSDictionary *item =     [NSDictionary dictionaryWithObjectsAndKeys:
                                  AppLocalizedString(@"身高"),CELL_ITEM_KEY_TITLE,
                                  @"height",CELL_ITEM_KEY_KEY,
                                  heightString,CELL_ITEM_KEY_VALUE,
                                  @"0",CELL_ITEM_KEY_STYLE,
                                  cellDefaultHeight,CELL_ITEM_KEY_HEIGHT,
                                  @"0",CELL_ITEM_KEY_ISACTION,
                                  @"",CELL_ITEM_KEY_ACTION, nil];
        [userinfoArray addObject:item];
    }
    
    //血型    
//    NSString *blood = [_userinfoDict objectForKey:@"Blood"];
    NSString *blood = user.dxq_Blood;
    if (blood&&[blood isKindOfClass:[NSString class]] && [blood length]>0)
    {
        NSDictionary *item =     [NSDictionary dictionaryWithObjectsAndKeys:
                                  AppLocalizedString(@"血型"),CELL_ITEM_KEY_TITLE,
                                  @"blood",CELL_ITEM_KEY_KEY,
                                  blood,CELL_ITEM_KEY_VALUE,
                                  @"0",CELL_ITEM_KEY_STYLE,
                                  cellDefaultHeight,CELL_ITEM_KEY_HEIGHT,
                                  @"0",CELL_ITEM_KEY_ISACTION,
                                  @"",CELL_ITEM_KEY_ACTION, nil];
        [userinfoArray addObject:item];
    }
    
    //交友目的
//    NSString *PalFor = [_userinfoDict objectForKey:@"PalFor"];
    NSString *PalFor = user.dxq_PalFor;
    if (PalFor&&[PalFor isKindOfClass:[NSString class]] && [PalFor length]>0)
    {
        NSDictionary *item =     [NSDictionary dictionaryWithObjectsAndKeys:
                                  AppLocalizedString(@"交友目的"),CELL_ITEM_KEY_TITLE,
                                  @"palfor",CELL_ITEM_KEY_KEY,
                                  PalFor,CELL_ITEM_KEY_VALUE,
                                  @"1",CELL_ITEM_KEY_STYLE,
                                  [self getCellHeight:PalFor],CELL_ITEM_KEY_HEIGHT,
                                  @"0",CELL_ITEM_KEY_ISACTION,
                                  @"",CELL_ITEM_KEY_ACTION, nil];
        [userinfoArray addObject:item];
    }
    
    // 职业
//    NSString *Profession = [_userinfoDict objectForKey:@"Profession"];
    NSString *Profession = user.dxq_Profession;
    if (Profession&&[Profession isKindOfClass:[NSString class]] && [Profession length]>0)
    {
        NSDictionary *item =     [NSDictionary dictionaryWithObjectsAndKeys:
                                  AppLocalizedString(@"职业"),CELL_ITEM_KEY_TITLE,
                                  @"profession",CELL_ITEM_KEY_KEY,
                                  Profession,CELL_ITEM_KEY_VALUE,
                                  @"1",CELL_ITEM_KEY_STYLE,
                                  [self getCellHeight:Profession],CELL_ITEM_KEY_HEIGHT,
                                  @"0",CELL_ITEM_KEY_ISACTION,
                                  @"",CELL_ITEM_KEY_ACTION, nil];
        [userinfoArray addObject:item];
    }
    
    
    // 学校
//    NSString *School = [_userinfoDict objectForKey:@"School"];
    NSString *School = user.dxq_School;
    if (School&&[School isKindOfClass:[NSString class]] && [School length]>0)
    {
        NSDictionary *item =     [NSDictionary dictionaryWithObjectsAndKeys:
                                  AppLocalizedString(@"学校"),CELL_ITEM_KEY_TITLE,
                                  @"school",CELL_ITEM_KEY_KEY,
                                  School,CELL_ITEM_KEY_VALUE,
                                  @"1",CELL_ITEM_KEY_STYLE,
                                  [self getCellHeight:School],CELL_ITEM_KEY_HEIGHT,
                                  @"0",CELL_ITEM_KEY_ISACTION,
                                  @"",CELL_ITEM_KEY_ACTION, nil];
        [userinfoArray addObject:item];
    }
    
    // 爱好
//    NSString *Hobby = [_userinfoDict objectForKey:@"Hobby"];
    NSString *Hobby = user.dxq_Hobby;
    if (Hobby&&[Hobby isKindOfClass:[NSString class]] && [Hobby length]>0)
    {
        NSDictionary *item =     [NSDictionary dictionaryWithObjectsAndKeys:
                                  AppLocalizedString(@"爱好"),CELL_ITEM_KEY_TITLE,
                                  @"hobby",CELL_ITEM_KEY_KEY,
                                  Hobby,CELL_ITEM_KEY_VALUE,
                                  @"1",CELL_ITEM_KEY_STYLE,
                                  [self getCellHeight:Hobby],CELL_ITEM_KEY_HEIGHT,
                                  @"0",CELL_ITEM_KEY_ISACTION,
                                  @"",CELL_ITEM_KEY_ACTION, nil];
        [userinfoArray addObject:item];
    }

    // 主页
//    NSString *Homepage = [_userinfoDict objectForKey:@"Homepage"];
    NSString *Homepage = user.dxq_Homepage;
    if (Homepage&&[Homepage isKindOfClass:[NSString class]] && [Homepage length]>0)
    {
        NSDictionary *item =     [NSDictionary dictionaryWithObjectsAndKeys:
                                  AppLocalizedString(@"主页"),CELL_ITEM_KEY_TITLE,
                                  @"homepage",CELL_ITEM_KEY_KEY,
                                  Homepage,CELL_ITEM_KEY_VALUE,
                                  @"1",CELL_ITEM_KEY_STYLE,
                                  [self getCellHeight:Homepage],CELL_ITEM_KEY_HEIGHT,
                                  @"0",CELL_ITEM_KEY_ISACTION,
                                  [Tool checkUrlValue:Homepage]?@"OpenUrl:":@"",CELL_ITEM_KEY_ACTION, nil];
        [userinfoArray addObject:item];
    }
    
    // 最后位置
//    NSString *LastestAddress = [_userinfoDict objectForKey:@"LastestAddress"];
//    NSString *LastestAddress = @"中国湖北省武汉市洪山区光谷广场东湖银座3栋一单元2302室";
    NSString *LastestAddress = user.dxq_Address;
    if (LastestAddress&&[LastestAddress isKindOfClass:[NSString class]] && [LastestAddress length]>0)
    {
        NSDictionary *item =     [NSDictionary dictionaryWithObjectsAndKeys:
                                  AppLocalizedString(@"最后位置"),CELL_ITEM_KEY_TITLE,
                                  @"lastestaddress",CELL_ITEM_KEY_KEY,
                                  LastestAddress,CELL_ITEM_KEY_VALUE,
                                  @"1",CELL_ITEM_KEY_STYLE,
                                  [self getCellHeight:LastestAddress],CELL_ITEM_KEY_HEIGHT,
                                  @"1",CELL_ITEM_KEY_ISACTION,
                                  @"LastestAddress:",CELL_ITEM_KEY_ACTION, nil];
        [userinfoArray addObject:item];
    }
    NSDictionary *u_section = [NSDictionary dictionaryWithObjectsAndKeys:AppLocalizedString(@"个人信息"),@"sectiontitle",userinfoArray,@"rows",TABLEVIEW_SECTION_USERINFO,@"type", nil];
    [userinfoArray release];

    NSDictionary *itemDict = [user.dxq_ReceivedGifts JSONValue];
    NSArray *gifts = [NSArray arrayWithObjects:nil, nil];;
    if (itemDict && [itemDict isKindOfClass:[NSDictionary class]])
        gifts = [itemDict objectForKey:@"Items"];
    NSMutableArray *giftsArray = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < [gifts count]; i++)
    {
        NSDictionary *gift = [gifts objectAtIndex:i];
         NSDictionary *item =  [NSDictionary dictionaryWithObjectsAndKeys:
                                [gift objectForKey:@"Name"],CELL_ITEM_KEY_TITLE,
                                @"gift",CELL_ITEM_KEY_KEY,
                                @"0",CELL_ITEM_KEY_STYLE,
                                cellGiftHeight,CELL_ITEM_KEY_HEIGHT,
                                @"1",CELL_ITEM_KEY_ISACTION,
                                @"ViewGift:",CELL_ITEM_KEY_ACTION,
                                [gift objectForKey:@"Url"],@"imgurl",
                                [gift objectForKey:@"ProductCode"],@"productcode", nil];
        [giftsArray addObject:item];
    }
    NSString *g_section_title = [giftsArray count]>0?AppLocalizedString(@"收到的礼物"):AppLocalizedString(@"还未收到礼物");
    NSDictionary *g_section = [NSDictionary dictionaryWithObjectsAndKeys:g_section_title,@"sectiontitle",giftsArray,@"rows",TABLEVIEW_SECTION_GIFTS,@"type", nil];
    [giftsArray release];
    
    [_data addObject:u_section];
    [_data addObject:g_section];
}

-(id)initWithViewControl:(UIViewController *)viewControl
{
    if(self = [super init])
    {
        _viewControl = viewControl;
        _data = [[NSMutableArray alloc]init];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[_data objectAtIndex:section] objectForKey:@"rows"] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_data count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *rows = [[_data objectAtIndex:indexPath.section] objectForKey:@"rows"];
    return [[[rows objectAtIndex:indexPath.row] objectForKey:CELL_ITEM_KEY_HEIGHT] floatValue];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CustomUIView *headerView = [[[CustomUIView alloc]initWithFrame:CGRectZero] autorelease];
    CGRect  lblFrame  = section == 0?CGRectMake(-5.0f,0.0f,330.0f,30.0f):CGRectMake(-5.0f,-1.0f,330.0f,31.0f);
    UITextView *titletxt = [[UITextView alloc]initWithFrame:lblFrame];
    titletxt.layer.borderColor = TABLEVIEW_SEPARATORCOLOR.CGColor;
    titletxt.layer.borderWidth = 1.0f;
    [titletxt setContentInset:UIEdgeInsetsMake(0,20,0,0)];
    [titletxt setUserInteractionEnabled:NO];
    [titletxt setFont:NormalDefaultFont];
    [titletxt setTextColor:[UIColor grayColor]];
    [titletxt setBackgroundColor:[UIColor clearColor]];
    [titletxt setText:[[_data objectAtIndex:section] objectForKey:@"sectiontitle"]];
    [headerView addSubview:titletxt];
    [titletxt release];    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *items = [[_data objectAtIndex:indexPath.section] objectForKey:@"rows"];
    NSDictionary *item = [items objectAtIndex:indexPath.row];
    NSString *indentifier = [item objectForKey:CELL_ITEM_KEY_STYLE];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil)
    {
        if ([indentifier intValue] == 0)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                           reuseIdentifier:indentifier] autorelease];
        }
        else
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                           reuseIdentifier:indentifier] autorelease];
        }
        UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10,10,65,65)];
        iconImageView.tag = 1;
        iconImageView.contentMode=UIViewContentModeScaleAspectFit;
        iconImageView.layer.cornerRadius = 4.0f;
        iconImageView.layer.masksToBounds = YES;
        [cell.contentView addSubview:iconImageView];
        [iconImageView release];
    }
    cell.accessoryType = [[item objectForKey:CELL_ITEM_KEY_ISACTION] intValue] == 1?UITableViewCellAccessoryDisclosureIndicator:UITableViewCellAccessoryNone;
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.textColor = [UIColor colorWithRed:0.000 green:0.180 blue:0.311 alpha:0.950];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.textLabel.font = MiddleNormalDefaultFont;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.text = [item objectForKey:CELL_ITEM_KEY_TITLE];
    cell.detailTextLabel.text = [item objectForKey:CELL_ITEM_KEY_VALUE];
    cell.detailTextLabel.font = NormalDefaultFont;
    UIImageView *iconImageView =(UIImageView *)[cell.contentView viewWithTag:1];
    if ([item objectForKey:@"imgurl"])
    {
        [iconImageView setImageWithURL:[NSURL URLWithString:[item objectForKey:@"imgurl"]] placeholderImage:[UIImage imageNamed:@"demo_gift"]];
        [cell.imageView setImage:[UIImage imageNamed:@"demo_gift"]];
        [cell.imageView setHidden:YES];
    }
    else
    {
        cell.imageView.image = nil;
        iconImageView.image =  nil;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *c = [tableView cellForRowAtIndexPath:indexPath];
    
    HYLog(@"%@",NSStringFromCGRect(c.detailTextLabel.frame));
    
    
    NSDictionary *item = [[[_data objectAtIndex:indexPath.section] objectForKey:@"rows"]  objectAtIndex:indexPath.row];
    NSString *actionString = [item objectForKey:CELL_ITEM_KEY_ACTION];
    if (actionString && [actionString length]>0)
    {
        SEL func = NSSelectorFromString(actionString);
        if ([self respondsToSelector:func])
        {
            [self performSelector:func withObject:item];
        }
    }
}

-(void)ViewGift:(NSDictionary *)info
{
    if (info)
    {
        ReceivedGiftsVC *vc=[[ReceivedGiftsVC alloc]init];
        [_viewControl.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
}

-(void)OpenUrl:(NSDictionary *)info
{
    if (info&&[info objectForKey:CELL_ITEM_KEY_VALUE])
    {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[info objectForKey:CELL_ITEM_KEY_VALUE]]];
    }
}

-(void)LastestAddress:(NSDictionary *)info
{
    if (info)
    {
        ShowAddressOnMapVC *vc=[[ShowAddressOnMapVC alloc]initWithDictionary:info];
        [_viewControl.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
}

@end
