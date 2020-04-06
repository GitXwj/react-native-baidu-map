//
//  PoiSearchModule.m
//  RCTBaiduMap
//  Copyright © 2018年 lovebing.org. All rights reserved.
//

#import "PoiSearchModule.h"

@implementation PoiSearchModule;

@synthesize bridge = _bridge;

static BMKPoiSearch *_poisearch;

RCT_EXPORT_MODULE(BaiduPoiSearchModule);

RCT_EXPORT_METHOD(searchNearbyProcess:(NSString *)keyword centerLat:(double)centerLat
                  centerLng:(double)centerLng radius:(int)radius pageNum:(int)pageNum){
    [self getPoisearch].delegate = self;

    BMKPOINearbySearchOption *nearbySearchOption = [[BMKPOINearbySearchOption alloc]init];
    CLLocationCoordinate2D baiduCoor = CLLocationCoordinate2DMake(centerLat, centerLng);
     nearbySearchOption.keywords = @[keyword];
    nearbySearchOption.location = baiduCoor;
    nearbySearchOption.radius = radius;
    nearbySearchOption.pageIndex = pageNum;
    nearbySearchOption.pageSize = 20;
    nearbySearchOption.tags = @[@"美食"];



    BOOL flag = [[self getPoisearch] poiSearchNearBy:nearbySearchOption];
    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
}

RCT_EXPORT_METHOD(searchInCityProcess:(NSString *)city keyword:(NSString *)keyword pageNum:(int)pageNum){
    [self getPoisearch].delegate = self;

    BMKPOICitySearchOption *citySearchOption = [[BMKPOICitySearchOption alloc]init];

    citySearchOption.pageIndex = pageNum;
    //citySearchOption.pageCapacity = 50;
    citySearchOption.pageSize =20;
    citySearchOption.city= city;
    citySearchOption.keyword = keyword;
    BOOL flag = [[self getPoisearch] poiSearchInCity:citySearchOption];
    if(flag)
    {
        NSLog(@"城市内检索发送成功");
    }
    else
    {
        NSLog(@"城市内检索发送失败");
    }
}

- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPOISearchResult*)result errorCode:(BMKSearchErrorCode)error{
    NSLog(@"onGetPoiResult获取检索结果");
    NSMutableDictionary *body = [self getEmptyBody];

    if (error == BMK_SEARCH_NO_ERROR) {
        NSMutableArray *annotations = [NSMutableArray array];

        for (int i = 0; i < result.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            NSMutableDictionary *item = [self getEmptyBody];
            item[@"name"] = poi.name;
            item[@"address"] = poi.address;
            item[@"province"] = poi.province;
            item[@"city"] = poi.city;
            item[@"area"] = poi.area;
            NSString *latitude = [NSString stringWithFormat:@"%f", poi.pt.latitude];
            NSString *longitude = [NSString stringWithFormat:@"%f", poi.pt.longitude];
            item[@"latitude"] = latitude;
            item[@"longitude"] = longitude;
            [annotations addObject:item];
        }
        body[@"errcode"] = @"0";
        body[@"message"] = @"成功";
        body[@"poiResult"] = @{
                               @"poiInfos": annotations
                               };
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
    } else {
        // 各种情况的判断。。。
    }
    [self sendEvent:@"onGetPoiResult" body:body];

}

-(BMKPoiSearch *)getPoisearch{
    if(_poisearch == nil) {
        _poisearch = [[BMKPoiSearch alloc]init];
    }
    return _poisearch;
}

@end
