//
//  WTStoreKit.m
//  Wat Wongtanuwat
//
//  Created by Wat Wongtanuwat on 2/23/12.
//  Copyright (c) 2012 aim. All rights reserved.
//

#if WT_NOT_CONSIDER_ARC
#error This file can be compiled with ARC and without ARC.
#endif

#import "WTStoreKit.h"
#import "WTStoreKitVerification.h"
#import "WTMacro.h"
#import "Reachability.h"
#import "NSData+Base64.h"
#import <Security/Security.h>
#import <CommonCrypto/CommonCrypto.h>

#define ITMS_PROD_VERIFY_RECEIPT_URL        @"https://buy.itunes.apple.com/verifyReceipt"
#define ITMS_SANDBOX_VERIFY_RECEIPT_URL     @"https://sandbox.itunes.apple.com/verifyReceipt"

//#ifndef __IPHONE_5_0
//#error "uses features (NSJSONSerialization) only available in iOS SDK 5.0 and later."
//#endif

//NSString *const WTSNSErrorDomain = @"wt.sns.manager";
//NSString *const WTSNSErrorTwitterVersionDescription = @"Device version must greater than or equal to 5.0";
//NSString *const WTSNSErrorFacebookVersionDescription = @"Device version must greater than or equal to 6.0";
//NSString *const WTSNSErrorAccountSetupDescription = @"Account is not setup";

#pragma mark -

@interface WTStoreProduct()

//@property (nonatomic,strong) NSString *localizedTitle;
//@property (nonatomic,strong) NSString *localizedDescription;
//@property (nonatomic,strong) NSString *price;
//@property (nonatomic,strong) NSString *priceFormat;
//@property (nonatomic,strong) NSString *productIdentifier;

@end

@implementation WTStoreProduct

+ (instancetype)product
{
    return WT_SAFE_ARC_AUTORELEASE([[self alloc] init]);
}

+ (instancetype)productFromSKProduct:(SKProduct*)product
{
    return WT_SAFE_ARC_AUTORELEASE([[self alloc] initFromSKProduct:product]);
}

- (instancetype)initFromSKProduct:(SKProduct*)product
{
    self = [self init];
    if (self) {
        
        NSNumberFormatter *numberFormatter = [WTStoreKit sharedManager].numberFormatter;
        [numberFormatter setLocale:product.priceLocale];
        
        NSString *localizedTitle = [NSString stringWithFormat:@"%@", product.localizedTitle];
        NSString *localizedDescription = [NSString stringWithFormat:@"%@", product.localizedDescription];
        NSString *price = [NSString stringWithFormat:@"%@", [product.price stringValue]];
        NSString *priceFormat = [NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:product.price]];
        NSString *productIdentifier = [NSString stringWithFormat:@"%@", product.productIdentifier];
        
        self.localizedTitle = localizedTitle;
        self.localizedDescription = localizedDescription;
        self.price = price;
        self.priceFormat = priceFormat;
        self.productIdentifier = productIdentifier;
        
//TODO: download purchase
    }
    return self;
}

- (NSString *)description
{
    return self.localizedTitle;
}

@end


#pragma mark -

@interface WTStoreReceipt()

//@property (nonatomic,strong) NSString *localizedTitle;
//@property (nonatomic,strong) NSString *localizedDescription;
//@property (nonatomic,strong) NSString *price;
//@property (nonatomic,strong) NSString *priceFormat;
//@property (nonatomic,strong) NSString *productIdentifier;

@end

@implementation WTStoreReceipt

@end

