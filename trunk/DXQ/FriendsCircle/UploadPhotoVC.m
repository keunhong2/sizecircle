//
//  UploadPhotoVC.m
//  DXQ
//
//  Created by Yuan on 12-11-27.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "UploadPhotoVC.h"
#import "MoreTagVC.h"
#import "UploadImageToAlbum.h"

@interface UploadPhotoVC ()<UniversalViewControlDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate,UploadImageToAlbumDelegate>
{
    UIImage *uploadImage;
    
    UIImageView *imageView;
    
    UITextView *desTextView;
    
    UITableView *tableView;
    
    UIScrollView *scrollView;
    
    NSMutableArray *dataArray;
    
    NSMutableArray *selectTagsArray;
    
    NSString *locationString;
    
    BOOL isLocationSuccess;
    
    BOOL isLocationOpen;
    
    BOOL isHD;
    
    BOOL isShareToSina;
    
    BOOL isShareToQQ;
}
@property(nonatomic,retain)UITableView *tableView;

@property(nonatomic,retain)UIImageView *imageView;

@property(nonatomic,retain)UITextView *desTextView;

@property(nonatomic,retain)NSMutableArray *dataArray;

@property(nonatomic,retain)UIScrollView *scrollView;

@end

@implementation UploadPhotoVC
@synthesize tableView = _tableView;
@synthesize imageView = _imageView;
@synthesize desTextView = _desTextView;
@synthesize dataArray = _dataArray;
@synthesize scrollView = _scrollView;
@synthesize geoCoder = _geoCoder;
@synthesize reverseGeocoder = _reverseGeocoder;

-(void)dealloc
{
    [selectTagsArray release];selectTagsArray = nil;
    
    [_scrollView release];_scrollView = nil;
    
    [_dataArray release];_dataArray = nil;
    
    [_tableView release];_tableView = nil;
    
    [_desTextView release];_desTextView = nil;
    
    [_imageView release];_imageView = nil;
    
    self.geoCoder = nil;self.reverseGeocoder = nil;
    [_productID release];_productID=nil;
    [super dealloc];
}

-(id)initWithImage:(UIImage *)image;
{
    self = [super init];
    if (self)
    {
        uploadImage = image;
        
        isLocationOpen = YES;
        
        NSMutableDictionary *item1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:AppLocalizedString(@"HD模式"),@"title",[NSArray arrayWithObjects:@"HD模式", nil],@"rows", nil];
        
        NSMutableDictionary *item2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:AppLocalizedString(@"标签"),@"title",[NSArray arrayWithObjects:@"美女",@"帅哥",@"旅游",@"更多标签",@"正在定位...", nil],@"rows", nil];
        
        NSMutableDictionary *item3 = [NSMutableDictionary dictionaryWithObjectsAndKeys:AppLocalizedString(@"分享到社交网络"),@"title",[NSArray arrayWithObjects:@"新浪微博",@"腾讯微博", nil],@"rows", nil];
        
        _dataArray = [[NSMutableArray alloc]initWithObjects:item1,item2,item3, nil];
        
        selectTagsArray = [[NSMutableArray alloc]initWithObjects:nil, nil];
        
        // Custom initialization
    }
    return self;
}


-(void)loadView
{
    CGRect rect =  [UIScreen mainScreen ].applicationFrame;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width,416)];
    [self.view addSubview:_scrollView];
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
    [_imageView setImage:uploadImage];
    [_scrollView addSubview:_imageView];
    
    _desTextView = [[UITextView alloc]initWithFrame:CGRectMake(80, 10,230, 60)];
    _desTextView.layer.cornerRadius = 2.0f;
    _desTextView.delegate = self;
    _desTextView.font = MiddleNormalDefaultFont;
    _desTextView.layer.masksToBounds = YES;
    _desTextView.layer.borderColor = [UIColor grayColor].CGColor;
    _desTextView.layer.borderWidth = 1.0f;
    [_scrollView addSubview:_desTextView];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 80, 320, 300) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_scrollView addSubview:_tableView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    CGRect tableFrame = _tableView.frame;
    tableFrame.size.height = _tableView.contentSize.height;
    _tableView.frame = tableFrame;
    _scrollView.contentSize = CGSizeMake(0, 80+ _tableView.contentSize.height);
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [self setNavgationTitle:AppLocalizedString(@"上传照片") backItemTitle:AppLocalizedString(@"返回")];
    
    UIImage *bgImage=[UIImage imageNamed:@"btn_round"];
    UIImage *btnFitImg=[bgImage stretchableImageWithLeftCapWidth:bgImage.size.width/2 topCapHeight:bgImage.size.height/2];
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:btnFitImg forState:UIControlStateNormal];
    [rightBtn sizeToFit];
    rightBtn.frame=CGRectMake(rightBtn.frame.origin.x, rightBtn.frame.origin.y, rightBtn.frame.size.width+10.f,bgImage.size.height);
    [rightBtn addTarget:self action:@selector(uploadAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:AppLocalizedString(@"上传") forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:MiddleBoldDefaultFont];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    [rightItem release];
    
    if (_locationManager)
    {
        _locationManager.delegate = nil;
        [_locationManager release];
        _locationManager = nil;
    }
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDelegate:self];
    _locationManager.distanceFilter = 1000;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];
    
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)uploadAction:(UIButton*)btn
{
    if ([_desTextView.text length]<1)
    {
        [Tool showAlertWithTitle:@"请添加描述" msg:nil];
        return;
    }
    
    if ([selectTagsArray count]<1)
    {
        [Tool showAlertWithTitle:@"请添加至少一个标签" msg:nil];
        return;
    }
    
    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil, nil, nil];
    
    if ([selectTagsArray count]>0)
    {
        NSString *tags = [selectTagsArray componentsJoinedByString:@","];
        [info setObject:tags forKey:@"Label"];
    }
    
    if ([_desTextView.text length]>0)
    {
        [info setObject:_desTextView.text forKey:@"FileDesc"];
    }
    
    if (isLocationOpen)
    {
        if (locationString && [locationString length]>0)
        {
            [info setObject:locationString forKey:@"AddressInfo"];
        }
        
        NSString *lat = [[GPS gpsManager]getLocation:GPSLocationLatitude];
        
        NSString *lon = [[GPS gpsManager]getLocation:GPSLocationLongitude];
        
        if ([lat length]>0)
        {
            [info setObject:lat forKey:@"WeiDu"];
        }
        
        if ([lon length]>0)
        {
            [info setObject:lon forKey:@"JingDu"];
        }
    }
    if (_productID) {
        [info setObject:_productID forKey:@"ProductCode"];
    }
    
    UploadImageToAlbum *up = [[UploadImageToAlbum alloc]initWithDelegate:self info:info];
    [up startUploadImage:_imageView.image isHD:isHD];
}

-(void)uploadImageToAlbumFinished:(UploadImageToAlbum *)up
{
    [up release];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"_image_is_upload" object:nil];
}

#pragma mark -UITableViewDataSourceAndDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataArray count];
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return [[_dataArray objectAtIndex:section] objectForKey:@"title"];
//}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CustomUIView *headerView = [[[CustomUIView alloc]initWithFrame:CGRectZero] autorelease];
    CGRect  lblFrame  = CGRectMake(0.0f,-1.0f,330.0f,31.0f);
    UITextView *titletxt = [[UITextView alloc]initWithFrame:lblFrame];
    titletxt.layer.borderColor = TABLEVIEW_SEPARATORCOLOR.CGColor;
    titletxt.layer.borderWidth = 1.0f;
    [titletxt setContentInset:UIEdgeInsetsMake(0,20,0,0)];
    [titletxt setUserInteractionEnabled:NO];
    [titletxt setFont:NormalDefaultFont];
    [titletxt setTextColor:[UIColor grayColor]];
    [titletxt setBackgroundColor:[UIColor clearColor]];
    [titletxt setText: [[_dataArray objectAtIndex:section] objectForKey:@"title"]];
    [headerView addSubview:titletxt];
    [titletxt release];
    return headerView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //for test
    return [[[_dataArray objectAtIndex:section] objectForKey:@"rows"] count];
}

-(UITableViewCell *)tableView:(UITableView *)tb cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"UITableViewCell";
    UITableViewCell *cell=[tb dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    NSArray *array =  [[_dataArray objectAtIndex:indexPath.section] objectForKey:@"rows"];
    NSString *item = [array objectAtIndex:indexPath.row];
    
    if (indexPath.section == 0 || indexPath.section == 2 )
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UISwitch *switchView = [[UISwitch alloc]initWithFrame:CGRectMake(0,0, 79, 27)];
        [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        
        if (indexPath.section == 0 && indexPath.row == 0)
        {
            switchView.on = isHD;
        }
        else if(indexPath.section == 2 && indexPath.row == 0)
        {
            switchView.on = isShareToSina;
        }
        else if(indexPath.section == 2 && indexPath.row == 1)
        {
            switchView.on = isShareToQQ;
        }
        cell.accessoryView = switchView;
        [switchView release];
        
        if (indexPath.section == 2)
        {
            if (indexPath.row == 0)
            {
                cell.imageView.image = [UIImage imageNamed:@"Sina.png"];
            }
            else if(indexPath.row == 1)
            {
                cell.imageView.image = [UIImage imageNamed:@"QQ.png"];
            }
        }
        else
        {
            cell.imageView.image = nil;
        }
    }
    else
    {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        if (indexPath.row == 4)
        {
            cell.imageView.image = [UIImage imageNamed:@"Location.png"];
        }
        else
        {
            cell.imageView.image = nil;
        }
        
        if(indexPath.row == 3)
        {
            cell.accessoryView = nil;
        }
        else
        {
            UIImage *selectImage = [UIImage imageNamed:@"select.png"];
            if (indexPath.row == 4)
            {
                if (isLocationOpen)selectImage = [UIImage imageNamed:@"select_selected.png"];
            }
            else
            {
                if ([selectTagsArray containsObject:item])
                    selectImage = [UIImage imageNamed:@"select_selected.png"];
            }
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:selectImage forState:UIControlStateNormal];
            btn.userInteractionEnabled = NO;
            [btn setFrame:CGRectMake(0, 0,selectImage.size.width,selectImage.size.height)];
            cell.accessoryView = btn;
        }
    }
    if (indexPath.section == 1)
    {
        if (indexPath.row == 3|| indexPath.row == 4)[cell.textLabel setFont:NormalDefaultFont];
        else[cell.textLabel setFont:MiddleBoldDefaultFont];
    }
    else
    {
        [cell.textLabel setFont:MiddleBoldDefaultFont];
    }
    
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.text = item;
    return cell;
}

-(void) switchAction:(UISwitch *)sender
{
    UITableViewCell *cell =  (UITableViewCell *)[sender superview];
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        isHD = sender.on;
    }
    else if(indexPath.section == 2 && indexPath.row == 0)
    {
        isShareToSina = sender.on;
    }
    else if(indexPath.section == 2 && indexPath.row == 1)
    {
        isShareToQQ = sender.on;
    }
}

-(void)tableView:(UITableView *)tb didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_desTextView resignFirstResponder];
    [tb deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 )
    {
        if (indexPath.row == 3)
        {
            MoreTagVC *vc = [[MoreTagVC alloc]initWithSelectedArray:selectTagsArray];
            vc.vDelegate = self;
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        }
        else if(indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2)
        {
            NSArray *array =  [[_dataArray objectAtIndex:indexPath.section] objectForKey:@"rows"];
            NSString *item = [array objectAtIndex:indexPath.row];
            if ([selectTagsArray containsObject:item])
            {
                [selectTagsArray removeObject:item];
            }
            else
            {
                [selectTagsArray addObject:item];
            }
            [_tableView reloadData];
        }
        else if (indexPath.row == 4)
        {
            isLocationOpen = !isLocationOpen;
            [_tableView reloadData];
        }
    }
}

-(void)didFinishedAction:(UIViewController *)viewController witfhInfo:(id)info;
{
    [selectTagsArray removeAllObjects];
    [selectTagsArray addObjectsFromArray:info];
    if ([selectTagsArray count]>0)
    {
        NSMutableDictionary *item = [_dataArray objectAtIndex:1];
        NSMutableArray *oldtags = [[NSMutableArray alloc]initWithArray:[item objectForKey:@"rows"]];
        NSMutableArray *tags = [[NSMutableArray alloc]initWithArray:selectTagsArray];
        if ([tags count]<3)
        {
            for (int i = 0; i < 3; i++)
            {
                NSString *item = [oldtags objectAtIndex:i];
                if (![tags containsObject:item]&& [tags count]<3)
                {
                    [tags addObject:item];
                }
            }
        }
        [oldtags replaceObjectAtIndex:0 withObject:[tags objectAtIndex:0]];
        [oldtags replaceObjectAtIndex:1 withObject:[tags objectAtIndex:1]];
        [oldtags replaceObjectAtIndex:2 withObject:[tags objectAtIndex:2]];
        [item setObject:oldtags forKey:@"rows"];
        [oldtags release];
        [tags release];
    }
    [_tableView reloadData];
}

#pragma mark - 获取城市名称
//   iso  5.0 以下版本使用此方法
- (void)startedReverseGeoderWithLatitude:(double)latitude longitude:(double)longitude
{
    CLLocationCoordinate2D coordinate2D;
    coordinate2D.longitude = longitude;
    coordinate2D.latitude = latitude;
    MKReverseGeocoder *geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:coordinate2D];
    self.reverseGeocoder = geoCoder;
    [geoCoder release];
    
    self.reverseGeocoder.delegate = self;
    [self.reverseGeocoder start];
}

#pragma mark -
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placeMark
{
    isLocationSuccess = YES;
    
    locationString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",placeMark.country,placeMark.administrativeArea,
                      placeMark.locality,//武汉市
                      placeMark.subLocality,//洪山区
                      placeMark.thoroughfare,//雄楚大道
                      placeMark.subThoroughfare, //68号
                      placeMark.name];//毛毛美容店
    if (locationString)
    {
        [self setLocation:locationString];
    }
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    NSLog(@"获取失败");
    isLocationSuccess = NO;
}

//  IOS 5.0 及以上版本使用此方法
- (void)locationAddressWithLocation:(CLLocation *)locationGps
{
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    self.geoCoder = clGeoCoder;
    [clGeoCoder release];
    
    [self.geoCoder reverseGeocodeLocation:locationGps completionHandler:^(NSArray *placemarks, NSError *error)
     {
         NSLog(@"error %@ placemarks count %d",error.localizedDescription,placemarks.count);
         for (CLPlacemark *placeMark in placemarks)
         {
             isLocationSuccess = YES;
             
             locationString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",placeMark.country,placeMark.administrativeArea,
                               placeMark.locality,//武汉市
                               placeMark.subLocality,//洪山区
                               placeMark.thoroughfare,//雄楚大道
                               placeMark.subThoroughfare, //68号
                               placeMark.name];//毛毛美容店
             if (locationString)
             {
                 [self setLocation:locationString];
             }
         }
     }];
}

-(void)setLocation:(NSString *)loc
{
    NSMutableDictionary *item = [_dataArray objectAtIndex:1];
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:[item objectForKey:@"rows"]];
    [arr replaceObjectAtIndex:4 withObject:loc];
    [item setObject:arr forKey:@"rows"];
    [arr release];
    [_tableView reloadData];
}

#pragma mark - location Delegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"定位出错");
    isLocationSuccess = NO;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    if (!newLocation) {
        [self locationManager:manager didFailWithError:(NSError *)NULL];
        return;
    }
    
    if (signbit(newLocation.horizontalAccuracy)) {
		[self locationManager:manager didFailWithError:(NSError *)NULL];
		return;
	}
    
    [manager stopUpdatingLocation];
    
    NSLog(@"%f,%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    _coordinate.latitude = newLocation.coordinate.latitude;
    _coordinate.longitude = newLocation.coordinate.longitude;
    
    //解析并获取当前坐标对应得地址信息
    
    isLocationSuccess = YES;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
    {
        [self locationAddressWithLocation:newLocation];
    }
    else
    {
        [self startedReverseGeoderWithLatitude:newLocation.coordinate.latitude
                                     longitude:newLocation.coordinate.longitude];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
