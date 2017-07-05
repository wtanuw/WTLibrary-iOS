//
//  WTStoreKit.h
//  Wat Wongtanuwat
//
//  Created by Wat Wongtanuwat on 2/23/12.
//  Copyright (c) 2012 aim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

#define WTStoreKit_VERSION 0x00020004

//support Non-Consumable Products
//not test Consumable Products
//support Auto-Renewable Subscriptions
//not test with Non-Renewable Subscriptions
//not test with free subscriptions
//will support Hosted Content Download

//2014-01-13
//Differences Between Product Types
//
//Each product type is designed for a particular use. The behavior of different product types varies in certain ways, as summarized in Table 1-1 and Table 1-2.
//
//Table 1-1  Comparison of product types
//Product type          |Non-consumable  |Consumable
//Users can buy         |    Once        |Multiple times
//Appears in the receipt|    Always      |Once
//Synced across devices |By the system   |Not synced
//Restored              |By the system   |Not restored
//
//Table 1-2  Comparison of subscription types
//Subscription type     |Auto-renewable  |Non-renewing    |Free
//Users can buy         |Multiple times  |Multiple times  |Once
//Appears in the receipt|    Always      |    Once        |Always
//Synced across devices |By the system   |By your app     |By the system
//Restored              |By the system   |By your app     |By the system


#define kProductFetchedNotification @"MKStoreKitProductsFetched"
#define kSubscriptionsPurchasedNotification @"MKStoreKitSubscriptionsPurchased"
#define kSubscriptionsInvalidNotification @"MKStoreKitSubscriptionsInvalid"

//wtstorekit
//#define kWTStoreKitProductTitle @"productTitle"
//#define kWTStoreKitProductDescription @"productDescription"
//#define kWTStoreKitProductPrice @"productPrice"
//#define kWTStoreKitProductPriceFormat @"productPriceFormat"
//#define kWTStoreKitProductID @"productIdentifier"

#define ITMS_PROD_VERIFY_RECEIPT_URL        @"https://buy.itunes.apple.com/verifyReceipt"
#define ITMS_SANDBOX_VERIFY_RECEIPT_URL     @"https://sandbox.itunes.apple.com/verifyReceipt"


typedef void (^WTStoreProductCompletionBlock)(SKStoreProductViewController *storeProductVCT, BOOL result, NSError *error);

@protocol WTStoreKitDelegate;

FOUNDATION_EXPORT NSString * const WTStoreKitErrorDomain;
enum {
    WTStoreKitErrorUnknown = -1,
    WTStoreKitErrorConnection = 1,
    WTStoreKitErrorRestrict = 2,
};

@interface WTStoreKit : NSObject<SKProductsRequestDelegate,SKPaymentTransactionObserver,SKStoreProductViewControllerDelegate>{
    BOOL restoreModeDim;
}

@property (nonatomic, assign) id<WTStoreKitDelegate> storeDelegate;
@property (nonatomic, retain) NSString *sharedSecretPassword;//Only used for receipts that contain auto-renewable subscriptions
@property (nonatomic, assign) BOOL useAutoDimScreen;
@property (nonatomic, retain) NSString *userAccountName;
@property (nonatomic, assign) BOOL testMode;
@property (nonatomic, strong) NSDictionary *testModeDummyStoreProductDictionary;

+ (instancetype)sharedManager;

- (void)testModeWithData:(NSDictionary *)dummyStoreProductDictionary;

- (void)addSubScriptionProductIdentifier:(NSString*)productIdentifier withSharedSecretPassword:(NSString*)password;

//request
- (void)requestProduct:(NSSet*)setOfProductIdentifier;

//product type
//- (void) buyProduct:(NSString*)productIdentifier __deprecated;
- (void)purchaseProduct:(NSString*)productIdentifier;
- (void)purchaseProduct:(NSString*)productIdentifier quantity:(NSInteger)quantity;

//subscription type
- (void)purchaseSubscription:(NSString*)productIdentifier;

//restore type
- (void)restoreTransactions;
//- (void) restorePreviousTransactions __deprecated;
- (void)restoreTransactions:(NSSet*)setOfProductIdentifier;

- (NSArray*)purchasableObjectsDescription;
- (NSArray*)storeProductFromProductIdentifierSet:(NSSet*)productIdentifierSet;

- (void)openManageSubscriptionURL;


//- (void) verifyReceiptProductIdentifier:(NSString*)productIdentifier;
//- (void) verifyReceiptProduct:(NSData*)receipt;
//- (void) verifyReceiptSubscription:(NSData*)receipt;
//- (BOOL) isSubscriptionProductIdentifierActive:(NSString*)productIdentifier;
- (BOOL) isSubscriptionActive:(NSData*)receipt;
- (BOOL)isSubscriptionActiveForTransactionReceipt:(NSData*)receipt;
- (BOOL)isSubscriptionActiveForReceipts:(NSData*)receipt;
- (NSData*) receiptForProduct:(NSString*)productIdentifier;
// for 7.0
- (void)refreshAppReceipt;



//+ (BOOL) isFeaturePurchased:(NSString*) featureId;
//
//- (BOOL) canConsumeProduct:(NSString*) productName quantity:(int) quantity;
//- (BOOL) consumeProduct:(NSString*) productName quantity:(int) quantity;
//- (BOOL) isSubscriptionActive:(NSString*) featureId;
//
//// for testing proposes you can use this method to remove all the saved keychain data (saved purchases, etc.)
//- (BOOL) removeAllKeychainData;

//for 6.0
- (void)validateTransactionReceiptWithAppStore:(NSData*)receipt withCompletion:(void (^)(BOOL success,NSArray* receiptsInfoArray))completion;
// for 7.0
- (NSData*)readReceipt;
- (void)validateReceiptsLocally;
- (void)validateReceiptsWithAppStore:(NSString*)productIdentifier withCompletion:(void (^)(BOOL success,NSArray* receiptsInfoArray))completion;
- (void)validateReceiptsWithAppStoreWithCompletion:(void (^)(BOOL success,NSArray* receiptsInfoArray))completion;

//StoreProductViewController
- (SKStoreProductViewController*)storeProductVCTWithITunesItemIdentifier:(NSString*)identifier completionBlock:(WTStoreProductCompletionBlock)completion withFallBackURL:(NSString*)url;

- (void)startDownloads:(NSArray*)downloads;
- (void)startDownloadTransaction:(SKPaymentTransaction*)transaction;
- (void)cancelDownloadTransaction:(SKPaymentTransaction*)transaction;
@end


@protocol WTStoreKitDelegate <NSObject>

@optional

- (void)WTStoreKitProductFetchComplete:(NSArray *)productsInformation;

//    - (void)WTStoreKitFinishPurchaseProduct:(NSString *)productIdentifier successWithValid:(BOOL)valid __deprecated;
//    - (void)WTStoreKitFinishPurchaseProduct:(NSString *)productIdentifier failWithError:(NSError *)error __deprecated;
- (void)WTStoreKitFinishPurchaseProduct:(NSString *)productIdentifier fromTransaction:(SKPaymentTransaction *)transaction successWithValid:(BOOL)valid;
- (void)WTStoreKitFinishPurchaseProduct:(NSString *)productIdentifier fromTransaction:(SKPaymentTransaction *)transaction failWithError:(NSError *)error;

- (void)WTStoreKitRestoreProduct:(NSString *)productIdentifier fromTransaction:(SKPaymentTransaction *)transaction successWithValid:(BOOL)valid;//assume to yes
//    - (void)WTStoreKitRestoreCompleted:(BOOL)complete withError:(NSError *)error __deprecated;
- (void)WTStoreKitRestoreCompletedWithSuccess:(BOOL)success withError:(NSError *)error;

- (void)WTStoreKitUpdatedDownload:(SKDownload *)download;
- (void)WTStoreKitUpdatedDownloads:(NSArray *)downloads;

- (void)WTStoreKitFinishVerifyProduct:(NSString *)productIdentifier purchaseInfoDict:(NSDictionary*)dict withValid:(BOOL)valid;

//if useAutoDimScreen NO, act as datasource
- (void)WTStoreKitDimScreen:(BOOL)show;

- (void)WTStoreKitProductViewControllerDidFinish:(SKStoreProductViewController *)viewController;

@end


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

