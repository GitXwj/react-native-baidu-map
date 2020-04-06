//
//  PoiSearchModule.h
//  RCTBaiduMap
//  Copyright © 2018年 lovebing.org. All rights reserved.
//

#ifndef PoiSearchModule_h
#define PoiSearchModule_h

#import "BaseModule.h"
#import "BaiduMapViewManager.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface PoiSearchModule : BaseModule <BMKPoiSearchDelegate> {
    int searchType;
}

@end

#endif /* PoiSearchModule_h */

