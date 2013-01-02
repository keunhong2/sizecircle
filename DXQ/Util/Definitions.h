//  YKDefinitions.h
//  DXQ
//
//  Created by Yuan on 12-10-10.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.

#define AppLocalizedString(string) NSLocalizedString(string, nil)

//only enabled in Debug mode
#ifdef DEBUG_MODE
#define HYLog( s, ... ) NSLog( @"<%p %@ %s:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent],__FUNCTION__, __LINE__,[NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define HYLog( s, ... )
#endif

//#define WebServiceURL @"http://zlan20120816001.h101.996h.cn/webservice.aspx"
#define WebServiceURL @"http://www.daxiaoquan.com:90/webservice.aspx"
//#define WebServiceURL @"http://124.237.121.75:8000/webservice.aspx"
//#define WebSocketURL  @"ws://zlan20120816001.h101.996h.cn:2100"
#define WebSocketURL  @"ws://www.daxiaoquan.com:2100"
//#define WebSocketURL  @"ws://124.237.121.75:2100"

#define kServerRequest_Timeout 10


//sina weibo
#define kAppKey             @"3793227528"
#define kAppSecret          @"9d68a02716a2bd3c482fa2e778e8078c"
#define kAppRedirectURI     @"http://www.heyuan110.com/dxq"


//UIFONT
#define TitleDefaultFont  [UIFont boldSystemFontOfSize:18.f] //标题字体大小
#define MiddleBoldDefaultFont  [UIFont boldSystemFontOfSize:16.0f] //介于标题和正常字体间粗体大小
#define MiddleNormalDefaultFont  [UIFont systemFontOfSize:16.0f] //介于标题和正常字体间大小
#define NormalDefaultFont  [UIFont systemFontOfSize:14.0f] //正常和detail时字体大小
#define NormalBoldDefaultFont  [UIFont boldSystemFontOfSize:14.0f] //正常和Bolder时字体大小


#define GrayColorForTextColor       [UIColor colorWithString:@"#797979"]    //常用 灰色字颜色

//COLOR
#define TABLEVIEW_SEPARATORCOLOR  [UIColor colorWithWhite:0.697 alpha:1.000]

#define SETTING_IS_AUTO_LOGIN_KEY           @"setting _ is _ auto _login"
#define SETTING_ACCOUNT_KEY                 @"setting_ acctoun _key"
#define SETTING_PASSWORD_KEY                @"setting_password_key"

#define STATUS_HEIGHT 20.0f

//user detail info
#define USER_ACTION_ITEMS ([NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"pyq_toolbar_icon_1.png",@"img",AppLocalizedString(@"礼物"),@"title", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"pyq_toolbar_icon_2.png",@"img",AppLocalizedString(@"聊天"),@"title", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"pyq_toolbar_icon_3.png",@"img",AppLocalizedString(@"打招呼"),@"title", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"pyq_toolbar_icon_4.png",@"img",AppLocalizedString(@"加好友"),@"title", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"pyq_toolbar_icon_5.png",@"img",AppLocalizedString(@"更多"),@"title", nil], nil])

//user detail info
#define USER_SELF_ACTION_ITEMS ([NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"pyq_toolbar_icon_1.png",@"img",AppLocalizedString(@"修改资料"),@"title", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"pyq_toolbar_icon_2.png",@"img",AppLocalizedString(@"修改头像"),@"title", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"pyq_toolbar_icon_3.png",@"img",AppLocalizedString(@"上传照片"),@"title", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"pyq_toolbar_icon_4.png",@"img",AppLocalizedString(@"修改签名"),@"title", nil], nil])


// user info dic key
#define SETTING_USER_ACCOUNTID_KEY          @"AccountId"

#define DEFAULT_REQUEST_PAGE_COUNT          20
//
#define DEFAULT_DISTANCE_FILTER 1000.0f

#define NEARBY_FRIENDSLIST_FILTER_CONFIG @"nearby_friendslist_filter_config"

typedef NS_ENUM(NSInteger, OrderType)
{
    OrderTypePopularity,//人气
    OrderTypeDistance,// 距离
    OrderTypeReleaseDate,//发布日期
};

#define THUMB_IMAGE_SUFFIX @".thumb.jpg"

#define NOTIFICATIONCENTER_MENU_LEFTCONTROL_REFRESH @"NOTIFICATIONCENTER_MENU_LEFTCONTROL_REFRESH"

#define NOTIFICATIONCENTER_RECEIVED_MESSAGES @"NOTIFICATIONCENTER_RECEIVED_MESSAGES"
#define NOTIFICATIONCENTER_RECEIED_NOTICE   @"NOTIFICATIONCENTER_RECEIED_NOTICE"
#define NOTIFICATIONCENTER_SIGNIN @"NOTIFICATIONCENTER_SIGNIN"

#define LASTEST_CONTACTS  @"LASTEST_CONTACTS"

#define APPID               111111

#define DXQFeedbackEmail            @"616313050@qq.com"

#define HomeWebSite                 @"http://www.daxiaoquan.com"
#define HelpWebSite                 @"http://www.daxiaoquan.com"
#define ServiceTel                  @"10086"
