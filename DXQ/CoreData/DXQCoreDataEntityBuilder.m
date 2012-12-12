//
//  DXQCoreDataEntityBuilder.m
//  DXQ
//
//  Created by Yuan on 12-11-16.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "DXQCoreDataEntityBuilder.h"

@interface DXQCoreDataEntityBuilder(PrivateMethod)

- (void)assignToAccount:(DXQAccount*)account dictionary:(NSDictionary*)dictionary password:(NSString*)password;

- (void)assignToUser:(Users*)user dictionary:(NSDictionary*)dictionary saveUpdateDate:(BOOL)isUpdate;

@end

@implementation DXQCoreDataEntityBuilder

static DXQCoreDataEntityBuilder *dXQCoreDataEntityBuilder = nil;

+(DXQCoreDataEntityBuilder*)sharedCoreDataEntityBuilder
{
    @synchronized(dXQCoreDataEntityBuilder)
    {
        if (!dXQCoreDataEntityBuilder) {
            dXQCoreDataEntityBuilder = [[DXQCoreDataEntityBuilder alloc]init];
        }
    }
    return dXQCoreDataEntityBuilder;
}


#pragma mark -
#pragma mark Private Method
- (void)assignToAccount:(DXQAccount*)account dictionary:(NSDictionary*)dictionary password:(NSString*)password
{
    if (account && dictionary && [dictionary isKindOfClass:[NSDictionary class]])
    {
        NSString* accountName = [dictionary objectForKey:@"AccountId"];
        
        if (accountName &&[accountName length]>0)
        {
            account.dxq_AccountName = accountName;
        }
        
        if (password&&[password length]>0)
        {
            account.dxq_Password = password;
        }
        
        NSObject* AddDate = [dictionary objectForKey:@"AddDate"];
        if (AddDate && [AddDate isKindOfClass:[NSNumber class]])
        {
            long int timeSp = [(NSNumber*)AddDate longLongValue];
            HYLog(@" timeSp = %ld",timeSp);
            account.dxq_AddDate = [NSDate dateWithTimeIntervalSince1970:timeSp];
        }
    }
}

//set user info
- (void)assignToUser:(Users*)user dictionary:(NSDictionary*)dictionary saveUpdateDate:(BOOL)isUpdate
{
    if (user && dictionary && [dictionary isKindOfClass:[NSDictionary class]])
    {
        NSObject* AccountId = [dictionary objectForKey:@"AccountId"];
        if (AccountId && [AccountId isKindOfClass:[NSString class]])
        {
            user.dxq_AccountId = (NSString*)AccountId;
        }
        
        NSObject* address = [dictionary objectForKey:@"Address"];
        if (address && [address isKindOfClass:[NSString class]])
        {
            user.dxq_Address = (NSString*)address;
        }
        
        NSObject* dxq_AdvancePayment = [dictionary objectForKey:@"AdvancePayment"];
        if (dxq_AdvancePayment && [dxq_AdvancePayment isKindOfClass:[NSNumber class]])
        {
            user.dxq_AdvancePayment = (NSNumber*)dxq_AdvancePayment;
        }
        
        NSObject* dxq_Email = [dictionary objectForKey:@"Email"];
        if (dxq_Email && [dxq_Email isKindOfClass:[NSString class]])
        {
            user.dxq_Email = (NSString*)dxq_Email;
        }
      
        NSObject* dxq_Answer = [dictionary objectForKey:@"Answer"];
        if (dxq_Answer && [dxq_Answer isKindOfClass:[NSString class]])
        {
            user.dxq_Answer = (NSString*)dxq_Answer;
        }
        
        NSObject* dxq_Blood = [dictionary objectForKey:@"Blood"];
        if (dxq_Blood && [dxq_Blood isKindOfClass:[NSString class]])
        {
            user.dxq_Blood = (NSString*)dxq_Blood;
        }
        
        NSObject* dxq_City = [dictionary objectForKey:@"City"];
        if (dxq_City && [dxq_City isKindOfClass:[NSString class]])
        {
            user.dxq_City = (NSString*)dxq_City;
        }
        
        NSObject* dxq_Coins = [dictionary objectForKey:@"Coins"];
        if (dxq_Coins && [dxq_Coins isKindOfClass:[NSNumber class]])
        {
            user.dxq_Coins = (NSNumber*)dxq_Coins;
        }
        
        NSObject* dxq_Icq = [dictionary objectForKey:@"Icq"];
        if (dxq_Icq && [dxq_Icq isKindOfClass:[NSNumber class]]) {
            user.dxq_Icq = (NSNumber*)dxq_Icq;
        }
        
        NSObject* dxq_id = [dictionary objectForKey:@"Id"];
        if (dxq_id && [dxq_id isKindOfClass:[NSNumber class]]) {
            user.dxq_id = (NSNumber*)dxq_id;
        }
        
        NSObject* dxq_IdentityNo = [dictionary objectForKey:@"IdentityNo"];
        if (dxq_IdentityNo && [dxq_IdentityNo isKindOfClass:[NSString class]])
        {
            user.dxq_IdentityNo = (NSString*)dxq_IdentityNo;
        }
        
        NSObject* dxq_IdentityType = [dictionary objectForKey:@"IdentityType"];
        if (dxq_IdentityType && [dxq_IdentityType isKindOfClass:[NSString class]])
        {
            user.dxq_IdentityType = (NSString*)dxq_IdentityType;
        }
        
        NSObject* dxq_Introducer = [dictionary objectForKey:@"Introducer"];
        if (dxq_Introducer && [dxq_Introducer isKindOfClass:[NSString class]])
        {
            user.dxq_Introducer = (NSString*)dxq_Introducer;
        }
        
        NSObject* dxq_Introduction = [dictionary objectForKey:@"Introduction"];
        if (dxq_Introduction && [dxq_Introduction isKindOfClass:[NSString class]])
        {
            user.dxq_Introduction = (NSString*)dxq_Introduction;
        }
 
        NSObject* dxq_IsOnline = [dictionary objectForKey:@"IsOnline"];
        if (dxq_IsOnline && [dxq_IsOnline isKindOfClass:[NSString class]])
        {
            user.dxq_IsOnline = (NSString*)dxq_IsOnline;
        }
        
        NSObject* dxq_IsFriend = [dictionary objectForKey:@"IsFriend"];
        if (dxq_IsFriend && [dxq_IsFriend isKindOfClass:[NSString class]])
        {
            user.dxq_IsFriend = (NSString*)dxq_IsFriend;
        }
        
        NSObject* dxq_IsBlackList = [dictionary objectForKey:@"IsBlackList"];
        if (dxq_IsBlackList && [dxq_IsBlackList isKindOfClass:[NSString class]])
        {
            user.dxq_IsBlackList = (NSString*)dxq_IsBlackList;
        }
        
        NSObject* dxq_IsOpenPosition = [dictionary objectForKey:@"Introduction"];
        if (dxq_IsOpenPosition && [dxq_IsOpenPosition isKindOfClass:[NSNumber class]])
        {
            user.dxq_IsOpenPosition = (NSNumber*)dxq_IsOpenPosition;
        }
        
        NSObject* dxq_LastLog = [dictionary objectForKey:@"LastLog"];
        if (dxq_LastLog && [dxq_LastLog isKindOfClass:[NSNumber class]])
        {
            long int timeSp = [(NSNumber*)dxq_LastLog longLongValue];
            user.dxq_LastLog  = [NSDate dateWithTimeIntervalSince1970:timeSp];            
        }
        
        NSObject* dxq_Birthday = [dictionary objectForKey:@"Birthday"];
        if (dxq_Birthday && [dxq_Birthday isKindOfClass:[NSString class]])
        {
            long int timeSp = [(NSString*)dxq_Birthday longLongValue];
            user.dxq_Birthday  = [NSDate dateWithTimeIntervalSince1970:timeSp];
        }
        
        NSObject* dxq_Level = [dictionary objectForKey:@"Level"];
        if (dxq_Level && [dxq_Level isKindOfClass:[NSString class]])
        {
            user.dxq_Level = (NSString*)dxq_Level;
        }
    
        NSObject* dxq_LogTimes = [dictionary objectForKey:@"LogTimes"];
        if (dxq_LogTimes && [dxq_LogTimes isKindOfClass:[NSNumber class]])
        {
            user.dxq_LogTimes = (NSNumber*)dxq_LogTimes;
        }
                
        NSObject* dxq_MemberName = [dictionary objectForKey:@"MemberName"];
        if (dxq_MemberName && [dxq_MemberName isKindOfClass:[NSString class]])
        {
            user.dxq_MemberName = (NSString*)dxq_MemberName;
        }
                
        NSObject* dxq_Msn = [dictionary objectForKey:@"Msn"];
        if (dxq_Msn && [dxq_Msn isKindOfClass:[NSString class]])
        {
            user.dxq_Msn = (NSString*)dxq_Msn;
        }        
        
        NSObject* dxq_NewsSetting = [dictionary objectForKey:@"NewsSetting"];
        if (dxq_NewsSetting && [dxq_NewsSetting isKindOfClass:[NSString class]])
        {
            user.dxq_NewsSetting = (NSString*)dxq_NewsSetting;
        }
        
        NSObject* dxq_PhotoUrl = [dictionary objectForKey:@"PhotoUrl"];
        if (dxq_PhotoUrl && [dxq_PhotoUrl isKindOfClass:[NSString class]])
        {
            user.dxq_PhotoUrl = (NSString*)dxq_PhotoUrl;
        }
                
        NSObject* dxq_PostalCode = [dictionary objectForKey:@"PostalCode"];
        if (dxq_PostalCode && [dxq_PostalCode isKindOfClass:[NSString class]])
        {
            user.dxq_PostalCode = (NSString*)dxq_PostalCode;
        }
        
        NSObject* dxq_Province = [dictionary objectForKey:@"Province"];
        if (dxq_Province && [dxq_Province isKindOfClass:[NSString class]])
        {
            user.dxq_Province = (NSString*)dxq_Province;
        }        
        
        NSObject* dxq_Qq = [dictionary objectForKey:@"Qq"];
        if (dxq_Qq && [dxq_Qq isKindOfClass:[NSString class]])
        {
            user.dxq_Qq = (NSString*)dxq_Qq;
        }
        
        NSObject* dxq_Question = [dictionary objectForKey:@"Question"];
        if (dxq_Question && [dxq_Question isKindOfClass:[NSString class]])
        {
            user.dxq_Question = (NSString*)dxq_Question;
        }
        
        NSObject* dxq_Remarks = [dictionary objectForKey:@"Remarks"];
        if (dxq_Remarks && [dxq_Remarks isKindOfClass:[NSString class]])
        {
            user.dxq_Remarks = (NSString*)dxq_Remarks;
        }
        
        NSObject* dxq_Score = [dictionary objectForKey:@"Score"];
        if (dxq_Score && [dxq_Score isKindOfClass:[NSNumber class]])
        {
            user.dxq_Score = (NSNumber*)dxq_Score;
        }
        
        NSObject* dxq_SearchSize = [dictionary objectForKey:@"SearchSize"];
        if (dxq_SearchSize && [dxq_SearchSize isKindOfClass:[NSNumber class]])
        {
            user.dxq_SearchSize = (NSNumber*)dxq_SearchSize;
        }
        
        NSObject* dxq_SellPassword = [dictionary objectForKey:@"SellPassword"];
        if (dxq_SellPassword && [dxq_SellPassword isKindOfClass:[NSString class]])
        {
            user.dxq_SellPassword = (NSString*)dxq_SellPassword;
        }
    
        NSObject* dxq_Sex = [dictionary objectForKey:@"Sex"];
        if (dxq_Sex && [dxq_Sex isKindOfClass:[NSString class]])
        {
            user.dxq_Sex = [NSNumber numberWithInt:[(NSString *)dxq_Sex intValue]];
        }
        
        NSObject* dxq_Status = [dictionary objectForKey:@"Status"];
        if (dxq_Status && [dxq_Status isKindOfClass:[NSNumber class]])
        {
            user.dxq_Status = (NSNumber*)dxq_Status;
        }
        
        NSObject* dxq_Telephone = [dictionary objectForKey:@"Telephone"];
        if (dxq_Telephone && [dxq_Telephone isKindOfClass:[NSString class]])
        {
            user.dxq_Telephone = (NSString*)dxq_Telephone;
        }
        
        NSObject* dxq_VisitCount = [dictionary objectForKey:@"VisitCount"];
        if (dxq_VisitCount && [dxq_VisitCount isKindOfClass:[NSNumber class]])
        {
            user.dxq_VisitCount = (NSNumber*)dxq_VisitCount;
        }
        
        NSObject* dxq_GiftCount = [dictionary objectForKey:@"GiftCount"];
        if (dxq_GiftCount && [dxq_GiftCount isKindOfClass:[NSNumber class]])
        {
            user.dxq_GiftCount = (NSNumber*)dxq_GiftCount;
        }
        
        NSObject* dxq_Age = [dictionary objectForKey:@"Age"];
        if (dxq_Age && [dxq_Age isKindOfClass:[NSNumber class]])
        {
            user.dxq_Age = (NSNumber*)dxq_Age;
        }
        
        NSObject* dxq_Height = [dictionary objectForKey:@"Height"];
        if (dxq_Height && [dxq_Height isKindOfClass:[NSString class]])
        {
            user.dxq_Height = (NSString*)dxq_Height;
        }
        
        NSObject* dxq_Hobby = [dictionary objectForKey:@"Hobby"];
        if (dxq_Hobby && [dxq_Hobby isKindOfClass:[NSString class]])
        {
            user.dxq_Hobby = (NSString*)dxq_Hobby;
        }
        
        NSObject* dxq_Homepage = [dictionary objectForKey:@"Homepage"];
        if (dxq_Homepage && [dxq_Homepage isKindOfClass:[NSString class]])
        {
            user.dxq_Homepage = (NSString*)dxq_Homepage;
        }
        
        NSObject* dxq_IsMarry = [dictionary objectForKey:@"IsMarry"];
        if (dxq_IsMarry && [dxq_IsMarry isKindOfClass:[NSString class]])
        {
            user.dxq_IsMarry = (NSString*)dxq_IsMarry;
        }
        
        NSObject* dxq_JingDu = [dictionary objectForKey:@"JingDu"];
        if (dxq_JingDu && [dxq_JingDu isKindOfClass:[NSString class]])
        {
            user.dxq_JingDu = (NSString*)dxq_JingDu;
        }
        
        NSObject* dxq_LinkmeCount = [dictionary objectForKey:@"LinkmeCount"];
        if (dxq_LinkmeCount && [dxq_LinkmeCount isKindOfClass:[NSString class]])
        {
            user.dxq_LinkmeCount = (NSString*)dxq_LinkmeCount;
        }
  
        NSObject* dxq_MylinkCount = [dictionary objectForKey:@"MylinkCount"];
        if (dxq_MylinkCount && [dxq_MylinkCount isKindOfClass:[NSString class]])
        {
            user.dxq_MylinkCount = (NSString*)dxq_MylinkCount;
        }
        
        
        NSObject* dxq_PalFor = [dictionary objectForKey:@"PalFor"];
        if (dxq_PalFor && [dxq_PalFor isKindOfClass:[NSString class]])
        {
            user.dxq_PalFor = (NSString*)dxq_PalFor;
        }
        
        NSObject* dxq_Profession = [dictionary objectForKey:@"Profession"];
        if (dxq_Profession && [dxq_Profession isKindOfClass:[NSString class]])
        {
            user.dxq_Profession = (NSString*)dxq_Profession;
        }
        
        NSObject* dxq_School = [dictionary objectForKey:@"School"];
        if (dxq_School && [dxq_School isKindOfClass:[NSString class]])
        {
            user.dxq_School = (NSString*)dxq_School;
        }
        
        NSObject* dxq_Salary = [dictionary objectForKey:@"Salary"];
        if (dxq_Salary && [dxq_Salary isKindOfClass:[NSString class]])
        {
            user.dxq_Salary = (NSString*)dxq_Salary;
        }
        
        NSObject* dxq_WeiDu = [dictionary objectForKey:@"WeiDu"];
        if (dxq_WeiDu && [dxq_WeiDu isKindOfClass:[NSString class]])
        {
            user.dxq_WeiDu = (NSString*)dxq_WeiDu;
        }
        
        NSObject* dxq_ReceivedGifts = [dictionary objectForKey:@"ReceivedGifts"];
        if (dxq_ReceivedGifts && [dxq_ReceivedGifts isKindOfClass:[NSString class]])
        {
            user.dxq_ReceivedGifts = (NSString*)dxq_ReceivedGifts;
        }
        
        //最后保存时间，这个是记录本地的
        if (isUpdate)
        {
            user.dxq_LastUpdateTime  = [NSDate date];
        }
    }
}

/*
 
 @property (nonatomic, retain) NSDate   * dxq_LastUpdateTime;
 @property (nonatomic, retain) NSNumber * dxq_GiftCount;
 @property (nonatomic, retain) NSNumber * dxq_Age;
 @property (nonatomic, retain) NSNumber * dxq_Height;
 @property (nonatomic, retain) NSString * dxq_Hobby;
 @property (nonatomic, retain) NSString * dxq_Homepage;
 @property (nonatomic, retain) NSString * dxq_IsMarry;
 @property (nonatomic, retain) NSString * dxq_JingDu;
 @property (nonatomic, retain) NSString * dxq_LinkmeCount;
 @property (nonatomic, retain) NSString * dxq_MylinkCount;
 @property (nonatomic, retain) NSString * dxq_PalFor;
 @property (nonatomic, retain) NSString * dxq_Profession;
 @property (nonatomic, retain) NSString * dxq_Salary;
 @property (nonatomic, retain) NSString * dxq_WeiDu;
 @property (nonatomic, retain) NSString * dxq_ReceivedGifts;

 
 */

#pragma
#pragma mark Public Method

-(NSDictionary *)DXQAccountToNSDictionary:(DXQAccount *)account
{
    if (account)
    {
        NSMutableDictionary *accountDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil, nil];
        if (account.dxq_AccountId)[accountDict setObject:account.dxq_AccountId forKey:@"AccountId"];
        if (account.dxq_Email)[accountDict setObject:account.dxq_Email forKey:@"Email"];
        if (account.dxq_Blood)[accountDict setObject:account.dxq_Blood forKey:@"Blood"];
        if (account.dxq_City)[accountDict setObject:account.dxq_City forKey:@"City"];
        if (account.dxq_Coins)[accountDict setObject:account.dxq_Coins forKey:@"Coins"];
        if (account.dxq_Introduction)[accountDict setObject:account.dxq_Introduction forKey:@"Introduction"];
        if (account.dxq_IsOnline)[accountDict setObject:account.dxq_IsOnline forKey:@"IsOnline"];
        if (account.dxq_IsOpenPosition)[accountDict setObject:account.dxq_IsOpenPosition forKey:@"dxq_IsOpenPosition"];
        if (account.dxq_Birthday)[accountDict setObject:account.dxq_Birthday forKey:@"Birthday"];
        if (account.dxq_MemberName)[accountDict setObject:account.dxq_MemberName forKey:@"MemberName"];
        if (account.dxq_PhotoUrl)[accountDict setObject:account.dxq_PhotoUrl forKey:@"PhotoUrl"];
        if (account.dxq_PostalCode)[accountDict setObject:account.dxq_PostalCode forKey:@"PostalCode"];
        if (account.dxq_Province)[accountDict setObject:account.dxq_Province forKey:@"Province"];
        if (account.dxq_MemberName)[accountDict setObject:account.dxq_MemberName forKey:@"MemberName"];
        return accountDict;
    }
    return nil;
}


- (DXQAccount*)buildAccountWitdDictionary:(NSDictionary*)dictionary accountPassword:(NSString*)accountPassword
{
   return [self buildAccountWitdDictionary:dictionary accountPassword:accountPassword managedObjectContext:[DXQCoreDataManager sharedCoreDataManager].managedObjectContext];
}

- (DXQAccount*)buildAccountWitdDictionary:(NSDictionary*)dictionary accountPassword:(NSString*)accountPassword managedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
    
    DXQAccount* account = nil;
    
    if (dictionary && [dictionary isKindOfClass:[NSDictionary class]] && managedObjectContext)
    {
        //current login  account info
        
        NSObject* accountID = [dictionary objectForKey:@"AccountId"];
        
        //get account ,if the account is not exist then add a new account
        if (accountID && [accountID isKindOfClass:[NSString class]])
        {
            account = [[DXQCoreDataManager sharedCoreDataManager] getAccountByAccountID:(NSString*)accountID];
        }
        if (!account)
        {
            account = (DXQAccount*)[NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([DXQAccount class]) inManagedObjectContext:managedObjectContext];
        }
        
        [self assignToUser:account dictionary:dictionary saveUpdateDate:(accountPassword && [accountPassword length]>0)?NO:YES];
        
        [self assignToAccount:account dictionary:dictionary password:accountPassword];        
    }
    return account;
}

@end
