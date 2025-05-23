//
//  WTStoreKit.h
//  Wat Wongtanuwat
//
//  Created by Wat Wongtanuwat on 2/23/12.
//  Copyright (c) 2012 aim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

#define WTStoreKit_VERSION 0x00020005

@interface WTStoreProduct : NSObject

//@property (nonatomic,readonly) NSString *localizedTitle;
//@property (nonatomic,readonly) NSString *localizedDescription;
//@property (nonatomic,readonly) NSString *price;
//@property (nonatomic,readonly) NSString *priceFormat;
//@property (nonatomic,readonly) NSString *productIdentifier;

@property (nonatomic,strong) NSString *localizedTitle;
@property (nonatomic,strong) NSString *localizedDescription;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *priceFormat;
@property (nonatomic,strong) NSString *productIdentifier;

+ (instancetype)product;
+ (instancetype)productFromSKProduct:(SKProduct*)product;

@end


@interface WTStoreReceipt : NSObject

@end


