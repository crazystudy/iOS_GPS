//
//  ViewController.m
//  GPSlocation
//
//  Created by 李恒昌 on 2018/7/9.
//  Copyright © 2018年 李恒昌. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface ViewController ()<CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
     CLLocationCoordinate2D coordinate;

}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLocation];

    // Do any additional setup after loading the view, typically from a nib.
}


#pragma mark 初始化定位
-(void)initLocation {
    locationManager=[[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;//设置定位精度
    [locationManager setDistanceFilter:1000];
    
    locationManager.allowsBackgroundLocationUpdates =YES;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [locationManager requestAlwaysAuthorization];
    }
//    //如果没有授权则请求用户授权
//    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
//    {
//        [locationManager requestAlwaysAuthorization];
//    }
    if(![CLLocationManager locationServicesEnabled]){
        NSLog(@"请开启定位:设置 > 隐私 > 位置 > 定位服务");
    }
    if([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        
        [locationManager requestAlwaysAuthorization]; // 永久授权
    }
    locationManager.pausesLocationUpdatesAutomatically = NO;
    [locationManager startUpdatingLocation];
    //[locationManager startMonitoringSignificantLocationChanges];
}

#pragma mark 定位成功
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation * newLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        NSString *str = [[NSString alloc] initWithFormat:@""];
        for (CLPlacemark * place in placemarks) {
           
            str = [str stringByAppendingFormat:@"%@ %@ %@ %@", @"\n", place.name, @", ", place.administrativeArea];
            NSLog(@"%@", str);
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *destDateString = [dateFormatter stringFromDate:[NSDate date]];
            [self mylog:destDateString andValue:str];
        }
    }];
//    double lat = newLocation.coordinate.latitude;
//    double lon = newLocation.coordinate.longitude;
}

#pragma mark 定位失败
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"error:%@",error);
}
-(void)mylog:(NSString*)logKey andValue:(NSString*)logValue{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectroy = [paths objectAtIndex:0];
    NSString *filename =@"test2.plist";
    NSString *filePath = [documentsDirectroy stringByAppendingPathComponent:filename];
    NSFileManager *file =  [NSFileManager defaultManager];
    NSMutableDictionary *dic;
    if ([file fileExistsAtPath:filePath]) {
        dic = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    }else{
        dic = [[NSMutableDictionary alloc] init];
    }
    [dic setValue:logValue  forKey:logKey];
    [dic writeToFile:filePath atomically:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
