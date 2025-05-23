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
#import <WTLibrary_iOS/WTWatLog.h>

#define ITMS_PROD_VERIFY_RECEIPT_URL        @"https://buy.itunes.apple.com/verifyReceipt"
#define ITMS_SANDBOX_VERIFY_RECEIPT_URL     @"https://sandbox.itunes.apple.com/verifyReceipt"

//#ifndef __IPHONE_5_0
//#error "uses features (NSJSONSerialization) only available in iOS SDK 5.0 and later."
//#endif

//NSString *const WTSNSErrorDomain = @"wt.sns.manager";
//NSString *const WTSNSErrorTwitterVersionDescription = @"Device version must greater than or equal to 5.0";
//NSString *const WTSNSErrorFacebookVersionDescription = @"Device version must greater than or equal to 6.0";
//NSString *const WTSNSErrorAccountSetupDescription = @"Account is not setup";

static WTStoreKit *sharedMyManager = nil;

@interface WTStoreKit ()

//@property (nonatomic, retain) NSMutableArray *purchasableObjects;
@property (nonatomic, retain) NSMutableDictionary *skProductDictionary;
@property (nonatomic, retain) NSMutableDictionary *subscriptionDict;

@property (nonatomic, WT_SAFE_ARC_PROP_RETAIN) UIAlertView *prcAlert;

- (void) requestProductData:(NSSet*)setOfProductIdentifier;
- (void) buyProductData:(NSString*)productIdentifier quantity:(NSInteger)quantity;
- (void)validateReceiptsWithAppStore:(NSData*)requestData withSandbox:(BOOL)useSandbox withCompletion:(void (^)(BOOL success,NSArray* receiptsInfoArray))completion;

//- (void) successBuyProductID:(NSString*)productIdentifier 
//                  forReceipt:(NSData*)receiptData;
- (void) transactionPurchaseSuccessed:(SKPaymentTransaction *)transaction;
- (void) transactionRestoreSuccessed:(SKPaymentTransaction *)transaction;
- (void) transactionPurchaseFailed:(SKPaymentTransaction *)transaction;

-(void)completeTransaction:(SKPaymentTransaction *)transaction;
-(void)failedTransaction:(SKPaymentTransaction *)transaction;
-(void)restoreTransaction:(SKPaymentTransaction *)transaction;

@end

#pragma mark -

@implementation WTStoreKit
//@synthesize purchasableObjects = purchasableObjects;
//@synthesize storeDelegate = delegate;
//@synthesize useAutoDimScreen;
//@synthesize sharedSecretPassword;
//@synthesize subscriptionDict;
//
//@synthesize prcAlert;


+ (instancetype)sharedManager
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (id)init
{
    if (self = [super init])
    {
//        self.purchasableObjects = [NSMutableArray array];
        self.skProductDictionary = [NSMutableDictionary dictionary];
        self.subscriptionDict = [NSMutableDictionary dictionary];
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
//        [numberFormatter setLocale:product.priceLocale];//set locale later when receive product
        WT_SAFE_ARC_RELEASE(numberFormatter);
        self.numberFormatter = numberFormatter;
        
        _sharedSecretPassword = nil;
        _useAutoDimScreen = YES;
        _userAccountName = nil;
        _testMode = NO;
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
        WatLog(@"%@",[SKPaymentQueue defaultQueue].transactions);
    }
    return self;
}

- (void)dealloc
{
    _storeDelegate = nil;
    WT_SAFE_ARC_RELEASE(_purchasableObjects);
    WT_SAFE_ARC_RELEASE(_subscriptionDict);
    WT_SAFE_ARC_RELEASE(_sharedSecretPassword);
    WT_SAFE_ARC_RELEASE(_prcAlert release);
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    WT_SAFE_ARC_SUPER_DEALLOC();
}

#pragma mark - Function

- (void)testModeWithData:(NSDictionary *)dummyStoreProductDictionary
{
    self.testMode = YES;
    self.testModeDummyStoreProductDictionary = dummyStoreProductDictionary;
}

- (void)addSubScriptionProductIdentifier:(NSString*)productIdentifier withSharedSecretPassword:(NSString*)password
{
    [self addProduct:productIdentifier isSubscription:YES];
    _sharedSecretPassword = password;
}

- (void)requestProduct:(NSSet*)setOfProductIdentifier
{
    if ([SKPaymentQueue canMakePayments])
	{
        [self requestProductData:setOfProductIdentifier];
	}
	else
	{
		[self alertCanNotMakePayments];
	}
}

- (void)buyProduct:(NSString*)productIdentifier __deprecated
{
    [self purchaseProduct:productIdentifier];
}

- (void)purchaseProduct:(NSString*)productIdentifier
{
    if ([SKPaymentQueue canMakePayments])
    {
        [self buyProductData:productIdentifier quantity:1];
    }
    else
    {
        [self alertCanNotMakePayments];
    }
}

- (void)purchaseProduct:(NSString*)productIdentifier quantity:(NSInteger)quantity
{
    if ([SKPaymentQueue canMakePayments])
    {
        [self buyProductData:productIdentifier quantity:quantity];
    }
    else
    {
        [self alertCanNotMakePayments];
    }
}

- (void)purchaseSubscription:(NSString*)productIdentifier
{
	if ([SKPaymentQueue canMakePayments])
	{
        [self buyProductData:productIdentifier quantity:0];
	}
	else
	{
		[self alertCanNotMakePayments];
	}
}

- (void)restorePreviousTransactions __deprecated
{
    [self restoreTransactions];
}

- (void)restoreTransactions
{
    restoreModeDim = YES;
    
    [self startDimScreen];
    
    [self restoreTransactionsData];
}

- (void)restoreTransactions:(NSSet*)setOfProductIdentifier
{
    restoreModeDim = YES;
    
    [self startDimScreen];
    
    [self restoreTransactionsData];
}

- (NSArray<WTStoreProduct*>*)purchasableObjectsDescription
{
//	NSMutableArray *purchasableObjectsDescriptions = [[NSMutableArray alloc] initWithCapacity:[self.purchasableObjects count]];
//    
//	for(int i=0;i<[self.purchasableObjects count];i++)
//	{
//		SKProduct *product = [self.purchasableObjects objectAtIndex:i];
//        
//        WTStoreProduct *storeProduct = [WTStoreProduct productFromSKProduct:product];
//        
//		[purchasableObjectsDescriptions addObject:storeProduct];
//        
//        WT_SAFE_ARC_RELEASE(storeProduct);
//	}
//    
//	return WT_SAFE_ARC_AUTORELEASE(purchasableObjectsDescriptions);
    
    NSMutableArray *storeProductArray = [[NSMutableArray alloc] initWithCapacity:[self.skProductDictionary count]];
    
    [self.skProductDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
        SKProduct *product = (SKProduct*)object;
        if (product) {
            WTStoreProduct *storeProduct = [WTStoreProduct productFromSKProduct:product];
            [storeProductArray addObject:storeProduct];
        }
    }];
    
    return WT_SAFE_ARC_AUTORELEASE(storeProductArray);
}

- (NSArray*)storeProductFromProductIdentifierSet:(NSSet*)productIdentifierSet
{
    NSMutableArray *storeProductArray = [[NSMutableArray alloc] initWithCapacity:[productIdentifierSet count]];
    
    [productIdentifierSet enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        NSString *productIdentifier = (NSString*)obj;
        SKProduct *product = [self.skProductDictionary objectForKey:productIdentifier];
        if (product) {
            WTStoreProduct *storeProduct = [WTStoreProduct productFromSKProduct:product];
            [storeProductArray addObject:storeProduct];
        }
    }];
    
    return WT_SAFE_ARC_AUTORELEASE(storeProductArray);
}

- (void)openManageSubscriptionURL
{
    NSString *url = @"https://buy.itunes.apple.com/WebObjects/MZFinance.woa/wa/manageSubscriptions";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success){
        
    }];
}

//- (void) verifyReceiptProduct:(NSData*)receipt
//{
//    if(!receipt){
//        return;
//    }
//    
//    [self startDimScreen];
//    
//    __block WTStoreKit *blocksafeSelf = self;
//    [[WTStoreKitVerification sharedManager] verifyReceiptProduct:receipt onComplete:^(BOOL valid,NSDictionary* purchaseInfo){
//        [blocksafeSelf verifyCompleteProductIdentifier:[[purchaseInfo objectForKey:@"receipt"] objectForKey:@"product_id"] purchaseInfoDict:purchaseInfo andValid:valid];
//        
//        [self stopDimScreen];
//    }];
//}
//
//- (void) verifyReceiptSubscription:(NSData*)receipt
//{
//    if(!receipt){
//        return;
//    }
//    
//    [self startDimScreen];
//    
//    __block WTStoreKit *blocksafeSelf = self;
//    [[WTStoreKitVerification sharedManager] verifyReceiptSubscription:receipt onComplete:^(BOOL valid,NSDictionary* purchaseInfo){
//        [blocksafeSelf verifyCompleteProductIdentifier:[[purchaseInfo objectForKey:@"receipt"] objectForKey:@"product_id"] purchaseInfoDict:purchaseInfo andValid:valid];
//        
//        [self stopDimScreen];
//    }];
//}

//- (BOOL) isSubscriptionproductIdentifierActive:(NSString*)productIdentifier
//{
//    NSData *receipt = [[[WTStoreKitVerification sharedManager] receiptDictionary] objectForKey:productIdentifier];
//    return [self isSubscriptionActive:receipt];
//}

- (BOOL) isSubscriptionActive:(NSData*)receipt
{
    if(!receipt) return NO;
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:receipt options:NSJSONReadingAllowFragments error:nil];
    NSData *receiptData = [NSData dataFromBase64String:[jsonObject objectForKey:@"latest_receipt"]];
    
    NSPropertyListFormat plistFormat;
    NSDictionary *payloadDict = [NSPropertyListSerialization propertyListWithData:receiptData
                                                                          options:NSPropertyListImmutable
                                                                           format:&plistFormat
                                                                            error:nil];
    
    receiptData = [NSData dataFromBase64String:[payloadDict objectForKey:@"purchase-info"]];
    
    NSDictionary *receiptDict = [NSPropertyListSerialization propertyListWithData:receiptData
                                                                          options:NSPropertyListImmutable
                                                                           format:&plistFormat
                                                                            error:nil];
    
    NSTimeInterval expiresDate = [[receiptDict objectForKey:@"expires-date"] doubleValue]/1000.0f;
    
    return expiresDate > [[NSDate date] timeIntervalSince1970];
}

- (BOOL)isSubscriptionActiveForTransactionReceipt:(NSData*)receipt
{
    return NO;
}

- (BOOL)isSubscriptionActiveForReceipts:(NSData*)receipt
{
    return NO;
}

- (NSData*) receiptForProduct:(NSString*)productIdentifier
{
//    NSData *receipt = [[[WTStoreKitVerification sharedManager] receiptDictionary] objectForKey:productIdentifier];
//    return receipt;
    return nil;
}

- (void)refreshAppReceipt
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
        SKReceiptRefreshRequest *request = [[SKReceiptRefreshRequest alloc] init];
        request.delegate = self;
        [request start];
    }
}
//12
//
//It is very simple difference between SKReceiptRefreshRequest vs RestoreCompletedTransactions:
//
//SKReceiptRefreshRequest
//
//Refreshing the receipt asks the App Store for the latest copy of the receipt. Refreshing a receipt does not create any new transactions. Although you should avoid refreshing multiple times in a row, this action would have same result as refreshing it just once.
//
//RestoreCompletedTransactions
//
//Restoring completed transactions creates a new transaction for every completed transaction the user made, essentially replaying history for your transaction queue observer. While transactions are being restored, your app maintains its own state to keep track of why it’s restoring completed transactions and how it needs to handle them. Restoring multiple times creates multiple restored transactions for each completed transaction.
//
//We can use both SKReceiptRefreshRequest & Restore completed transactions for validating user subscription, But here in below cases we must used to Restore completed transaction instead refreshing receipt:
//
//If you use Apple-hosted content, restoring completed transactions gives your app the transaction objects it uses to download the content.
//
//If you need to support versions of iOS earlier than iOS 7, where the app receipt isn’t available, restore completed transactions instead.
//
//If your app uses non-renewing subscriptions, your app is responsible for the restoration process.
//
//Reference: https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/StoreKitGuide/Chapters/Restoring.html#//apple_ref/doc/uid/TP40008267-CH8-SW9

//- (void) startVerifyingSubscriptionReceipts
//{
//    NSDictionary *subscriptions = [[MKStoreManager storeKitItems] objectForKey:@"Subscriptions"];
//
//    self.subscriptionProducts = [NSMutableDictionary dictionary];
//    for(NSString *productId in [subscriptions allKeys])
//    {
//        MKSKSubscriptionProduct *product = [[MKSKSubscriptionProduct alloc] initWithProductId:productId subscriptionDays:[[subscriptions objectForKey:productId] intValue]];
//        product.receipt = [MKStoreManager dataForKey:productId]; // cached receipt
//
//        if(product.receipt)
//        {
//            [product verifyReceiptOnComplete:^(NSNumber* isActive)
//             {
//                 if([isActive boolValue] == NO)
//                 {
//                     [[NSNotificationCenter defaultCenter] postNotificationName:kSubscriptionsInvalidNotification
//                                                                         object:product.productId];
//
//                     NSLog(@"Subscription: %@ is inactive", product.productId);
//                     product.receipt = nil;
//                     [self.subscriptionProducts setObject:product forKey:productId];
//                     [MKStoreManager setObject:nil forKey:product.productId];
//                 }
//                 else
//                 {
//                     NSLog(@"Subscription: %@ is active", product.productId);
//                 }
//             }
//                                     onError:^(NSError* error)
//             {
//                 NSLog(@"Unable to check for subscription validity right now");
//             }];
//        }
//
//        [self.subscriptionProducts setObject:product forKey:productId];
//    }
//}


- (void)validateTransactionReceiptWithAppStore:(NSData*)receipt withCompletion:(void (^)(BOOL success,NSArray* receiptsInfoArray))completion
{
    // Create the JSON object that describes the request
    NSError *error;
    NSMutableDictionary *requestContents = [NSMutableDictionary dictionary];
    [requestContents addEntriesFromDictionary:@{@"receipt-data":[receipt base64EncodedString]}];
    if(_sharedSecretPassword){
        [requestContents addEntriesFromDictionary:@{@"password":_sharedSecretPassword}];
    }
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents
                                                          options:0
                                                            error:&error];
    
    if (!requestData) {
        /* ... Handle error ... */
    }
    
    BOOL useSandbox = NO;
#if DEBUG
        useSandbox = YES;
#endif
    
    [self validateReceiptsWithAppStore:requestData withSandbox:useSandbox withCompletion:completion];
}

- (NSData*)readReceipt
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
        // Load the receipt from the app bundle.
        NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
        NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
        if (!receipt) {
            /* No local receipt -- handle the error. */
            return nil;
        }
        
        /* ... Send the receipt data to your server ... */
        return receipt;
    }
    return nil;
}

- (void)validateReceiptsLocally
{
//    RMAppReceipt *receipt = [RMAppReceipt bundleReceipt];
//    const BOOL verified = [self verifyTransaction:transaction inReceipt:receipt success:successBlock failure:nil]; // failureBlock is nil intentionally. See below.
//    if (verified) return;
//    
//    // Apple recommends to refresh the receipt if validation fails on iOS
//    [[RMStore defaultStore] refreshReceiptOnSuccess:^{
//        RMAppReceipt *receipt = [RMAppReceipt bundleReceipt];
//        [self verifyTransaction:transaction inReceipt:receipt success:successBlock failure:failureBlock];
//    } failure:^(NSError *error) {
//        [self failWithBlock:failureBlock error:error];
//    }];
}

- (void)validateReceiptsWithAppStore:(NSString*)productIdentifier withCompletion:(void (^)(BOOL success,NSArray* receiptsInfoArray))completion
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
        NSData *receipt = [self readReceipt]; // Sent to the server by the device
        
        if (!receipt) {
            return;
        }
        
        // Create the JSON object that describes the request
        NSError *error;
        NSMutableDictionary *requestContents = [NSMutableDictionary dictionary];
        [requestContents addEntriesFromDictionary:@{@"receipt-data": [receipt base64EncodedStringWithOptions:0]}];
        if(_sharedSecretPassword){
            [requestContents addEntriesFromDictionary:@{@"password":_sharedSecretPassword}];
        }
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents
                                                              options:0
                                                                error:&error];
        
        if (!requestData) {
            /* ... Handle error ... */
        }
        
        BOOL useSandbox = NO;
#if DEBUG
            useSandbox = YES;
#endif
        
        [self validateReceiptsWithAppStore:requestData withSandbox:useSandbox withCompletion:^(BOOL success, NSArray *receiptsInfoArray) {
            
            NSMutableArray *array = [NSMutableArray array];
            for(NSDictionary *dict in receiptsInfoArray)
            {
                if([dict[@"product_id"] isEqualToString:productIdentifier]){
                    [array addObject:dict];
                }
            }
            completion(success,array);
        }];
    }
}

- (void)validateReceiptsWithAppStoreWithCompletion:(void (^)(BOOL success,NSArray* receiptsInfoArray))completion
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
        NSData *receipt = [self readReceipt]; // Sent to the server by the device
        
        if (!receipt) {
            return;
        }
        
        // Create the JSON object that describes the request
        NSError *error;
        NSMutableDictionary *requestContents = [NSMutableDictionary dictionary];
        [requestContents addEntriesFromDictionary:@{@"receipt-data": [receipt base64EncodedStringWithOptions:0]}];
        if(_sharedSecretPassword){
            [requestContents addEntriesFromDictionary:@{@"password":_sharedSecretPassword}];
        }
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents
                                                              options:0
                                                                error:&error];
        
        if (!requestData) {
            /* ... Handle error ... */
        }
        
        BOOL useSandbox = NO;
#if DEBUG
            useSandbox = YES;
#endif
        
        [self validateReceiptsWithAppStore:requestData withSandbox:useSandbox withCompletion:completion];
        
//        // Create a POST request with the receipt data.
//        NSURL *storeURL = [NSURL URLWithString:@"https://buy.itunes.apple.com/verifyReceipt"];
//        NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL];
//        [storeRequest setHTTPMethod:@"POST"];
//        [storeRequest setHTTPBody:requestData];
//        
//        // Make a connection to the iTunes Store on a background queue.
//        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//        [NSURLConnection sendAsynchronousRequest:storeRequest queue:queue
//                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//                                   if (connectionError) {
//                                       /* ... Handle error ... */
//                                   } else {
//                                       NSError *error;
//                                       NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
//                                       if (!jsonResponse) { /* ... Handle error ...*/ }
//                                       /* ... Send a response back to the device ... */
//                                       
//                                   }
//                               }];
    }
}

- (SKStoreProductViewController*)storeProductVCTWithITunesItemIdentifier:(NSString*)identifier completionBlock:(WTStoreProductCompletionBlock)completion
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
    {
        NSDictionary *appParameters = @{SKStoreProductParameterITunesItemIdentifier:identifier};
        
        SKStoreProductViewController *storeProductViewController = [[SKStoreProductViewController alloc] init];
        [storeProductViewController loadProductWithParameters:appParameters
                                              completionBlock:^(BOOL result, NSError *error){
                                                  completion(storeProductViewController,result,error);
                                              }];
        return storeProductViewController;
    }
    else
    {
        return nil;
    }
}

- (SKStoreProductViewController*)storeProductVCTWithITunesItemIdentifier:(NSString*)identifier completionBlock:(WTStoreProductCompletionBlock)completion withFallBackURL:(NSString*)url
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
    {
        SKStoreProductViewController *vct = [self storeProductVCTWithITunesItemIdentifier:identifier completionBlock:completion];
        return vct;
    }
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success){
            
        }];
        return nil;
    }
}


- (void)startDownloads:(NSArray*)downloads
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
    {
        if([downloads count] > 0)
        {
            [[SKPaymentQueue defaultQueue] startDownloads:downloads];
        }
    }
    
}

- (void)startDownloadTransaction:(SKPaymentTransaction*)transaction
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
    {
        NSArray *downloads = transaction.downloads;
        if([downloads count] > 0)
        {
            [[SKPaymentQueue defaultQueue] startDownloads:downloads];
        }
    }
    
}

- (void)cancelDownloadTransaction:(SKPaymentTransaction*)transaction
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
    {
        NSArray *downloads = transaction.downloads;
        if([downloads count] > 0)
        {
            [[SKPaymentQueue defaultQueue] cancelDownloads:downloads];
        }
    }
    
}

#pragma mark - Request

- (void)requestProductData:(NSSet*)setOfProductIdentifier
{
    if(!self.testMode){
        if ([self canConnectToNetwork:@""])
        {
            [self startDimScreen];
            
            SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:setOfProductIdentifier];
            request.delegate = self;
            [request start];
            WT_SAFE_ARC_AUTORELEASE(request);
        }
        else
        {
            [self alertCanNotConnectToNetwork];
        }
    }else{
        NSMutableArray *storeProductArray = [NSMutableArray array];
        [setOfProductIdentifier enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
            NSString *productIdentifier = (NSString*)obj;
            WTStoreProduct *storeProduct = self.testModeDummyStoreProductDictionary[productIdentifier];
            if (storeProduct) {
                [storeProductArray addObject:storeProduct];
            }
        }];
        if([_storeDelegate respondsToSelector:@selector(WTStoreKitProductFetchComplete:)])
            [_storeDelegate WTStoreKitProductFetchComplete:storeProductArray];
    }
}

#pragma mark - SKRequestDelegate

- (void)requestDidFinish:(SKRequest *)request
{
    if([request isKindOfClass:[SKProductsRequest class]]){
        
    }else if ([request isKindOfClass:[SKReceiptRefreshRequest class]]){
        if([_storeDelegate respondsToSelector:@selector(WTStoreKitReceiptRefreshComplete)])
            [_storeDelegate WTStoreKitReceiptRefreshComplete];
    }
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    [self stopDimScreen];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue(), ^{
        if([request isKindOfClass:[SKProductsRequest class]]){
            if([_storeDelegate respondsToSelector:@selector(WTStoreKitProductFetchComplete:)])
                [_storeDelegate WTStoreKitProductFetchComplete:@[ ]];
        }else if ([request isKindOfClass:[SKReceiptRefreshRequest class]]){
        }
    });
    
}

#pragma mark - SKProductsRequest delegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
//    request = nil;
    
    [self stopDimScreen];
    
    for (SKProduct *product in response.products) {
        self.skProductDictionary[product.productIdentifier] = product;
    }
    
//    [self.purchasableObjects removeAllObjects];
//	[self.purchasableObjects addObjectsFromArray:response.products];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue(), ^{
        if([_storeDelegate respondsToSelector:@selector(WTStoreKitProductFetchComplete:)])
            [_storeDelegate WTStoreKitProductFetchComplete:[self purchasableObjectsDescription]];
    });
}

#pragma mark - Purchase

- (void)buyProductData:(NSString*)productIdentifier quantity:(NSInteger)quantity
{
    if(!self.testMode){
    if ([self canConnectToNetwork:@""])
    {
        [self startDimScreen];
        /*
         SKPayment *payment = [SKPayment paymentWithProductIdentifier:productIdentifier];
         [[SKPaymentQueue defaultQueue] addPayment:payment];
         */
        
//        NSArray *allIds = [self.purchasableObjects valueForKey:@"productIdentifier"];
//        NSUInteger index = [allIds indexOfObject:productIdentifier];
//        
//        if(index == NSNotFound) {
//            [self stopDimScreen];
//            return;
//        }
//        
//        SKProduct *product = [self.purchasableObjects objectAtIndex:index];
        
        SKProduct *product = [self.skProductDictionary objectForKey:productIdentifier];
        
        if(!product) {
            [self stopDimScreen];
            return;
        }
        
        SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
        
        if(_userAccountName && SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
            payment.applicationUsername = [self hashedValueForAccountName:_userAccountName];
        }
        if(quantity>1){
            payment.quantity = quantity;
        }
        
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    else
    {
        [self alertCanNotConnectToNetwork];
    }
    }else{
        if([_storeDelegate respondsToSelector:@selector(WTStoreKitFinishPurchaseProduct:fromTransaction:successWithValid:)]){
            [_storeDelegate WTStoreKitFinishPurchaseProduct:productIdentifier fromTransaction:nil successWithValid:YES];
        }
    }
}

#pragma mark - Subscription

- (void)addProduct:(NSString*)productIdentifier isSubscription:(BOOL)subscription
{
    if(productIdentifier){
        [_subscriptionDict setObject:[NSNumber numberWithBool:subscription] forKey:productIdentifier];
    }
}

- (BOOL)isProductDataIsSubscription:(NSString*)productIdentifier
{
    NSNumber *subscription = [_subscriptionDict objectForKey:productIdentifier];
    if(subscription){
        return [subscription boolValue];
    }
    return NO;
}

#pragma mark - Restore

- (void)restoreTransactionsData
{
    if(_userAccountName && SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactionsWithApplicationUsername:[self hashedValueForAccountName:_userAccountName]];
    }else{
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    }
}

#pragma mark - Verify

- (void)validateReceiptsWithAppStore:(NSData*)requestData withSandbox:(BOOL)useSandbox withCompletion:(void (^)(BOOL success,NSArray* receiptsInfoArray))completion
{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
        
        // Create a POST request with the receipt data.
        NSURL *storeURL = nil;
        if(useSandbox){
            storeURL = [NSURL URLWithString:ITMS_SANDBOX_VERIFY_RECEIPT_URL];
        }else{
            storeURL = [NSURL URLWithString:ITMS_PROD_VERIFY_RECEIPT_URL];
        }
        NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL];
        [storeRequest setHTTPMethod:@"POST"];
        [storeRequest setHTTPBody:requestData];
        
        // Make a connection to the iTunes Store on a background queue.
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:storeRequest queue:queue
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   if (connectionError) {
                                       /* ... Handle error ... */
                                       
                                   } else {
                                       NSError *error;
                                       NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                       if (!jsonResponse) { /* ... Handle error ...*/ }
                                       /* ... Send a response back to the device ... */
                                       id status = [jsonResponse objectForKey:@"status"];
                                       NSInteger verifyReceiptStatusCode = [status integerValue];
                                       switch (verifyReceiptStatusCode) {
//                                               21000
//                                               The App Store could not read the JSON object you provided.
//                                               21002
//                                               The data in the receipt-data property was malformed or missing.
//                                               21003
//                                               The receipt could not be authenticated.
//                                               21004
//                                               The shared secret you provided does not match the shared secret on file for your account.
//                                                   Only returned for iOS 6 style transaction receipts for auto-renewable subscriptions.
//                                               21005
//                                               The receipt server is not currently available.
//                                               21006
//                                               This receipt is valid but the subscription has expired. When this status code is returned to your server, the receipt data is also decoded and returned as part of the response.
//                                               Only returned for iOS 6 style transaction receipts for auto-renewable subscriptions.
                                           case 21006:
                                               
                                               break;
                                           case 21007:
                                               [self validateReceiptsWithAppStore:requestData withSandbox:YES withCompletion:completion];
                                               break;
                                           case 21008:
                                               [self validateReceiptsWithAppStore:requestData withSandbox:NO withCompletion:completion];
                                               break;
                                           case 0:
                                           {
                                               NSMutableArray *receipts = [jsonResponse[@"latest_receipt_info"] mutableCopy];
                                               NSArray *inAppReceipts = jsonResponse[@"receipt"][@"in_app"];
                                               [receipts addObjectsFromArray:inAppReceipts];

                                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue(), ^{
                                                   completion(YES, receipts);
                                               });
                                           }
                                               break;
                                           default:
                                           {
                                               NSMutableArray *receipts = [jsonResponse[@"latest_receipt_info"] mutableCopy];
                                               NSArray *inAppReceipts = jsonResponse[@"receipt"][@"in_app"];
                                               [receipts addObjectsFromArray:inAppReceipts];

                                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue(), ^{
                                                   completion(NO, nil);
                                               });
                                           }
                                               break;
                                       }
                                   }
                               }];
    }
}

#pragma mark - download

- (void)download:(SKPaymentTransaction*)transaction{
    
    if (transaction.downloads) {
        [[SKPaymentQueue defaultQueue] startDownloads:@[transaction.downloads]];
    }
}

#pragma mark - delegate call

//- (void) verifyCompleteProductIdentifier:(NSString*)productIdentifier purchaseInfoDict:(NSDictionary *)purchaseInfo andValid:(BOOL)valid
//{
//    if([_storeDelegate respondsToSelector:@selector(WTStoreKitFinishVerifyProduct:purchaseInfoDict:withValid:)]){
//        [_storeDelegate WTStoreKitFinishVerifyProduct:productIdentifier purchaseInfoDict:purchaseInfo withValid:valid];
//    }
//    
//    [self stopDimScreen];
//}

- (void) verifyCompleteProductIdentifier:(NSString*)productIdentifier fromTransaction:(SKPaymentTransaction *)transaction andValid:(BOOL)valid
{
    if([_storeDelegate respondsToSelector:@selector(WTStoreKitFinishPurchaseProduct:fromTransaction:successWithValid:)]){
        [_storeDelegate WTStoreKitFinishPurchaseProduct:productIdentifier fromTransaction:transaction successWithValid:valid];
    }
    
    [self stopDimScreen];
}

- (void) transactionPurchaseSuccessed: (SKPaymentTransaction *)transaction
{
    NSString* productIdentifier = transaction.payment.productIdentifier;
    
//    __block WTStoreKit *weak_self = self;
//#if IS_IOS_BASE_SDK_ATLEAST(__IPHONE_7_0)
//    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
//        [self validateReceiptsWithAppStore:productIdentifier withCompletion:^(BOOL success, NSArray *receiptsInfoArray) {
//            [weak_self verifyCompleteProductIdentifier:productIdentifier fromTransaction:transaction andValid:success];
//        }];
//    }
//#if IS_IOS_DEPLOY_TARGET_BELOW(__IPHONE_7_0)
//    else
//#endif
//#endif
//#if IS_IOS_DEPLOY_TARGET_BELOW(__IPHONE_7_0)
//    {
//        [self validateTransactionReceiptWithAppStore:transaction.transactionReceipt withCompletion:^(BOOL success, NSArray *receiptsInfoArray) {
//            [weak_self verifyCompleteProductIdentifier:productIdentifier fromTransaction:transaction andValid:success];
//        }];
//    }
//#endif
    
    __block WTStoreKit *weak_self = self;
    [weak_self verifyCompleteProductIdentifier:productIdentifier fromTransaction:transaction andValid:YES];
}

- (void) transactionPurchaseFailed: (SKPaymentTransaction *)transaction
{
    NSString* productIdentifier = transaction.payment.productIdentifier;
    
    if([_storeDelegate respondsToSelector:@selector(WTStoreKitFinishPurchaseProduct:fromTransaction:failWithError:)]){
        [_storeDelegate WTStoreKitFinishPurchaseProduct:productIdentifier fromTransaction:transaction failWithError:transaction.error];
    }
    
    [self stopDimScreen];
}

- (void) transactionRestoreSuccessed: (SKPaymentTransaction *)transaction
{
    NSString* productIdentifier = transaction.payment.productIdentifier;
    
//    __block WTStoreKit *weak_self = self;
//#if IS_IOS_BASE_SDK_ATLEAST(__IPHONE_7_0)
//    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
//        [self validateReceiptsWithAppStore:productIdentifier withCompletion:^(BOOL success, NSArray *receiptsInfoArray) {
//            if([_storeDelegate respondsToSelector:@selector(WTStoreKitRestoreProduct:fromTransaction:successWithValid:)]){
//                [_storeDelegate WTStoreKitRestoreProduct:productIdentifier fromTransaction:transaction successWithValid:YES];
//            }
//        }];
//    }
//#if IS_IOS_DEPLOY_TARGET_BELOW(__IPHONE_7_0)
//    else
//#endif
//#endif
//#if IS_IOS_DEPLOY_TARGET_BELOW(__IPHONE_7_0)
//    {
//        [self validateTransactionReceiptWithAppStore:transaction.transactionReceipt withCompletion:^(BOOL success, NSArray *receiptsInfoArray) {
//            if([_storeDelegate respondsToSelector:@selector(WTStoreKitRestoreProduct:fromTransaction:successWithValid:)]){
//                [_storeDelegate WTStoreKitRestoreProduct:productIdentifier fromTransaction:transaction successWithValid:YES];
//            }
//        }];
//    }
//#endif
    
    __block WTStoreKit *weak_self = self;
    if([_storeDelegate respondsToSelector:@selector(WTStoreKitRestoreProduct:fromTransaction:successWithValid:)]){
        [_storeDelegate WTStoreKitRestoreProduct:productIdentifier fromTransaction:transaction successWithValid:YES];
    }
}

#pragma mark - Payment Queue Handler

- (void)completeTransaction: (SKPaymentTransaction *)transaction
{
	[self transactionPurchaseSuccessed:transaction];
}

- (void)failedTransaction: (SKPaymentTransaction *)transaction
{
	[self transactionPurchaseFailed:transaction];
}

- (void)restoreTransaction: (SKPaymentTransaction *)transaction
{
    [self transactionRestoreSuccessed:transaction];
}

- (void)deferredTransaction: (SKPaymentTransaction *)transaction
{
    
}

- (void)removeTransaction: (SKPaymentTransaction *)transaction
{
    
}

- (void)restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    if([_storeDelegate respondsToSelector:@selector(WTStoreKitRestoreCompletedWithSuccess:withError:)]){
        [_storeDelegate WTStoreKitRestoreCompletedWithSuccess:NO withError:error];
    }
    
    restoreModeDim = NO;
    
    [self stopDimScreen];
}

- (void)restoreCompletedTransactionsFinished
{
    if([_storeDelegate respondsToSelector:@selector(WTStoreKitRestoreCompletedWithSuccess:withError:)]){
        [_storeDelegate WTStoreKitRestoreCompletedWithSuccess:YES withError:nil];
    }
    
    restoreModeDim = NO;
    
    [self stopDimScreen];
}

//#ifdef __IPHONE_6_0
//-(void) hostedContentDownloadStatusChanged:(SKDownload*) download {
//    // Finish any completed downloads
//    switch (download.downloadState) {
//        case SKDownloadStateFinished:
//            break;
//        case SKDownloadStateActive:
//            break;
//        default:
//            break;
//    }
//    if([_storeDelegate respondsToSelector:@selector(WTStoreKitUpdatedDownload:)]){
//        [_storeDelegate WTStoreKitUpdatedDownload:download];
//    }
//}
//#endif

#pragma mark - SKPaymentQueue, SKPaymentTransactionObserver delegate

// Sent when the transaction array has changed (additions or state changes).  Client should check state of transactions and finish as appropriate.
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        [WTStoreKit logTransaction:transaction];
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing:
                
                break;
                
            case SKPaymentTransactionStatePurchased:
                
                [self completeTransaction:transaction];
                
                               // [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                
                break;
                
            case SKPaymentTransactionStateFailed:
                
                [self failedTransaction:transaction];
                
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                
                break;
                
            case SKPaymentTransactionStateRestored:
                
                [self restoreTransaction:transaction];
                
                //                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                
                break;
                
            case SKPaymentTransactionStateDeferred:
                
                [self deferredTransaction:transaction];
                
                break;
                
            default:
                
                break;
        }
    }
}

// Sent when transactions are removed from the queue (via finishTransaction:).
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        [self removeTransaction:transaction];
    }
}

// Sent when an error is encountered while adding transactions from the user's purchase history back to the queue.
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    [self restoreCompletedTransactionsFailedWithError:error];
}

// Sent when all transactions from the user's purchase history have successfully been added back to the queue.
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    [self restoreCompletedTransactionsFinished];
}

// Sent when a user initiates an IAP buy from the App Store
- (BOOL)paymentQueue:(SKPaymentQueue *)queue shouldAddStorePayment:(SKPayment *)payment forProduct:(SKProduct *)product
{
    return NO;
}

- (void)processDownload:(SKDownload *)download {
    // NSFileManager
    NSString *path = [download.contentURL path];
    
    // ダウンロードしたコンテンツのディレクトリ
    path = [path stringByAppendingPathComponent:@"Contents"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *files = [fileManager contentsOfDirectoryAtPath:path error:&error];
    NSString *dir = [self downloadableContentPath];
    
    for (NSString *file in files) {
        NSString *fullPathSrc = [path stringByAppendingPathComponent:file];
        NSString *fullPathDst = [dir stringByAppendingPathComponent:file];
        
        // 上書きできないので一旦削除
        [fileManager removeItemAtPath:fullPathDst error:NULL];
        
        // ダウンロード先から保存先へファイルを移動する
        if ([fileManager moveItemAtPath:fullPathSrc toPath:fullPathDst error:&error] == NO) {
            NSLog(@"Error: ファイルの移動に失敗: %@", error);
        }
        
        // 設定にプロダクトIDを保持
        [[NSUserDefaults standardUserDefaults] setObject:fullPathDst
                                                  forKey:download.transaction.payment.productIdentifier];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSString *)downloadableContentPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *directory = [paths objectAtIndex:0];
    directory = [directory stringByAppendingPathComponent:@"Downloads"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:directory] == NO) {
        NSError *error;
        if ([fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error] == NO) {
            NSLog(@"Error: ディレクトリ作成失敗: %@", error);
        }
        
        NSURL *url = [NSURL fileURLWithPath:directory];
        // iCloud backupからダウンロードしたコンテンツを排除しないと、リジェクト対象になるので注意
        if ([url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error] == NO) {
            NSLog(@"Error: iCloud backup対象除外が失敗: %@", error);
        }
    }
    
    return directory;
}


// ダウンロード通知処理
// Sent when the download state has changed.
- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray<SKDownload *> *)downloads
{
    for (SKDownload *download in downloads) {
        [WTStoreKit logDownload:download];
        if (download.downloadState == SKDownloadStateFinished) {
            [self processDownload:download]; // ダウンロード処理
            //
            [queue finishTransaction:download.transaction];
            
            if([_storeDelegate respondsToSelector:@selector(WTStoreKitUpdatedDownload:)]){
                [_storeDelegate WTStoreKitUpdatedDownload:download];
            }
            
            [self stopDimScreen];
        }
        else if (download.downloadState == SKDownloadStateActive) {
//            NSTimeInterval remaining = download.timeRemaining; // secs
//            float progress = download.progress; // 0.0 -> 1.0
//            NSLog(@"%lf%% (残り %lf 秒)", progress, remaining);
            
            if([_storeDelegate respondsToSelector:@selector(WTStoreKitUpdatedDownload:)]){
                [_storeDelegate WTStoreKitUpdatedDownload:download];
            }
        }
        else if (download.downloadState == SKDownloadStateFailed || download.downloadState == SKDownloadStateCancelled) { // waiting, paused, failed, cancelled
//            NSLog(@"ダウンロード一時停止またはキャンセルを検出: %ld %@", (long)download.downloadState, download.contentIdentifier);
            
            if([_storeDelegate respondsToSelector:@selector(WTStoreKitUpdatedDownload:)]){
                [_storeDelegate WTStoreKitUpdatedDownload:download];
            }
            [queue finishTransaction:download.transaction];
        }
    }
}
//- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads
//{
//    for (SKDownload *download in downloads)
//    {
//        [self hostedContentDownloadStatusChanged:download];
//    }
//    
//    if([_storeDelegate respondsToSelector:@selector(WTStoreKitUpdatedDownloads:)]){
//        [_storeDelegate WTStoreKitUpdatedDownloads:downloads];
//    }
//}

#pragma mark - SKStoreProductViewController delegate

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    if([_storeDelegate respondsToSelector:@selector(WTStoreKitProductViewControllerDidFinish:)]){
        [_storeDelegate WTStoreKitProductViewControllerDidFinish:viewController];
    }
}

#pragma mark - Non Storekit

-(UIAlertView*)processingAlert:(UIAlertView*)prevAlert withMessage:(NSString*)msg{
	if (!msg) {
		msg = @"Waiting For Server...";
    }
    prevAlert = [[UIAlertView alloc] initWithTitle:msg
                                           message:nil
                                          delegate:nil
                                 cancelButtonTitle:nil
                                 otherButtonTitles:nil];
    WT_SAFE_ARC_AUTORELEASE(prevAlert);
	return prevAlert;
}

-(void)showAlert{
    if (!_prcAlert) {
        _prcAlert = [self processingAlert:nil withMessage:nil];
        [_prcAlert show];
    }
}

-(void)dismissAlert{
    if(_prcAlert){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue(), ^{
            [_prcAlert dismissWithClickedButtonIndex:0 animated:YES];
            _prcAlert = nil;
        });
    }
}

-(BOOL)canConnectToNetwork:(NSString*)_URLPath
{
//    if([_URLPath isEqualToString:@""]){
//        _URLPath = @"www.google.com";
//    }
    Reachability *r;
    if([_URLPath isEqualToString:@""]){
        r = [Reachability reachabilityForInternetConnection];
    }else{
        r = [Reachability reachabilityWithHostName:_URLPath];
    }
	NetworkStatus internetStatus = [r currentReachabilityStatus];
	
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
		return NO;
    }
    else
    {
        return YES;
    }
}

-(void)alertCanNotConnectToNetwork
{
    UIAlertView * myAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Please check your internet connection.", @"") 
                                                       message:nil
                                                      delegate:self 
                                             cancelButtonTitle:NSLocalizedString(@"OK", @"") 
                                             otherButtonTitles:nil];
    [myAlert show];
    WT_SAFE_ARC_RELEASE(myAlert);
}

-(void)alertCanNotMakePayments
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"In-App Purchasing disabled", @"")
                                                    message:NSLocalizedString(@"Check your parental control settings and try again later", @"")
                                                   delegate:self 
                                          cancelButtonTitle:NSLocalizedString(@"Dismiss", @"")
                                          otherButtonTitles: nil];
    [alert show];
    WT_SAFE_ARC_RELEASE(alert);
}

-(void)startDimScreen
{
    if(!_useAutoDimScreen && _storeDelegate){
        if([_storeDelegate respondsToSelector:@selector(WTStoreKitDimScreen:)]){
            [_storeDelegate WTStoreKitDimScreen:YES];
        }
    }else{
        [self showAlert];
    }
}

-(void)stopDimScreen
{
    if(!restoreModeDim){
        if(!_useAutoDimScreen && _storeDelegate){
            if([_storeDelegate respondsToSelector:@selector(WTStoreKitDimScreen:)]){
                [_storeDelegate WTStoreKitDimScreen:NO];
            }
        }else{
            [self dismissAlert];
        }
    }
}

- (NSString *)hashedValueForAccountName:(NSString*)userAccountName
{
    const int HASH_SIZE = 32;
    unsigned char hashedChars[HASH_SIZE];
    const char *accountName = [userAccountName UTF8String];
    size_t accountNameLen = strlen(accountName);
    
    // Confirm that the length of the user name is small enough
    // to be recast when calling the hash function.
    if (accountNameLen > UINT32_MAX) {
        NSLog(@"Account name too long to hash: %@", userAccountName);
        return nil;
    }
    CC_SHA256(accountName, (CC_LONG)accountNameLen, hashedChars);
    
    // Convert the array of bytes into a string showing its hex representation.
    NSMutableString *userAccountHash = [[NSMutableString alloc] init];
    for (int i = 0; i < HASH_SIZE; i++) {
        // Add a dash every four bytes, for readability.
        if (i != 0 && i%4 == 0) {
            [userAccountHash appendString:@"-"];
        }
        [userAccountHash appendFormat:@"%02x", hashedChars[i]];
    }
    
    return userAccountHash;
}

+ (void)logTransaction:(SKPaymentTransaction*)transaction
{
    NSString *transactionState;
    switch (transaction.transactionState) {
        case SKPaymentTransactionStatePurchasing:transactionState = @"Purchasing";break;
        case SKPaymentTransactionStatePurchased:transactionState = @"Purchased";break;
        case SKPaymentTransactionStateFailed:transactionState = @"Failed";break;
        case SKPaymentTransactionStateRestored:transactionState = @"Restored";break;
        case SKPaymentTransactionStateDeferred:transactionState = @"Deferred";break;
        default:
            break;
    }
    WatLog(@"transaction %@ %@\n\
           -- download %ld item",
           transaction.payment.productIdentifier, transactionState, (long)[transaction.downloads count]);
}

+ (void)logDownload:(SKDownload*)download
{
    NSString *downloadState;
    switch (download.downloadState) {
        case SKDownloadStateWaiting:downloadState = @"Waiting";break;
        case SKDownloadStateActive:downloadState = @"Active";break;
        case SKDownloadStatePaused:downloadState = @"Paused";break;
        case SKDownloadStateFinished:downloadState = @"Finished";break;
        case SKDownloadStateFailed:downloadState = @"Failed";break;
        case SKDownloadStateCancelled:downloadState = @"Cancelled";break;
        default:
            break;
    }
    WatLog(@"download %@ %@\n\
           -- progress %.2f%%  %.0f / %lld ",
           download.contentIdentifier,downloadState,
           download.progress*100,download.progress*download.contentLength,download.contentLength);
}

@end

@implementation WTStoreKit (SKProductsRequestDelegate)

#pragma mark - SKProductsRequest delegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
//    request = nil;
    
    [self stopDimScreen];
    
    for (SKProduct *product in response.products) {
        self.skProductDictionary[product.productIdentifier] = product;
    }
    
//    [self.purchasableObjects removeAllObjects];
//    [self.purchasableObjects addObjectsFromArray:response.products];
    
    __weak typeof (self) weakSelf = self;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue(), ^{
        if([weakSelf.storeDelegate respondsToSelector:@selector(WTStoreKitProductFetchComplete:)])
            [weakSelf.storeDelegate WTStoreKitProductFetchComplete:[self purchasableObjectsDescription]];
    });
}

@end

@implementation WTStoreKit (SKPaymentTransactionObserver)

#pragma mark - SKPaymentQueue, SKPaymentTransactionObserver delegate

// Sent when the transaction array has changed (additions or state changes).  Client should check state of transactions and finish as appropriate.
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        [WTStoreKit logTransaction:transaction];
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing:
                
                break;
                
            case SKPaymentTransactionStatePurchased:
                
                [self completeTransaction:transaction];
                
                               // [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                
                break;
                
            case SKPaymentTransactionStateFailed:
                
                [self failedTransaction:transaction];
                
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                
                break;
                
            case SKPaymentTransactionStateRestored:
                
                [self restoreTransaction:transaction];
                
                //                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                
                break;
                
            case SKPaymentTransactionStateDeferred:
                
                [self deferredTransaction:transaction];
                
                break;
                
            default:
                
                break;
        }
    }
}

// Sent when transactions are removed from the queue (via finishTransaction:).
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        [self removeTransaction:transaction];
    }
}

// Sent when an error is encountered while adding transactions from the user's purchase history back to the queue.
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    [self restoreCompletedTransactionsFailedWithError:error];
}

// Sent when all transactions from the user's purchase history have successfully been added back to the queue.
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    [self restoreCompletedTransactionsFinished];
}

// Sent when a user initiates an IAP buy from the App Store
- (BOOL)paymentQueue:(SKPaymentQueue *)queue shouldAddStorePayment:(SKPayment *)payment forProduct:(SKProduct *)product
{
    return NO;
}

- (void)processDownload:(SKDownload *)download {
    // NSFileManager
    NSString *path = [download.contentURL path];
    
    // ダウンロードしたコンテンツのディレクトリ
    path = [path stringByAppendingPathComponent:@"Contents"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *files = [fileManager contentsOfDirectoryAtPath:path error:&error];
    NSString *dir = [self downloadableContentPath];
    
    for (NSString *file in files) {
        NSString *fullPathSrc = [path stringByAppendingPathComponent:file];
        NSString *fullPathDst = [dir stringByAppendingPathComponent:file];
        
        // 上書きできないので一旦削除
        [fileManager removeItemAtPath:fullPathDst error:NULL];
        
        // ダウンロード先から保存先へファイルを移動する
        if ([fileManager moveItemAtPath:fullPathSrc toPath:fullPathDst error:&error] == NO) {
            NSLog(@"Error: ファイルの移動に失敗: %@", error);
        }
        
        // 設定にプロダクトIDを保持
        [[NSUserDefaults standardUserDefaults] setObject:fullPathDst
                                                  forKey:download.transaction.payment.productIdentifier];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSString *)downloadableContentPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *directory = [paths objectAtIndex:0];
    directory = [directory stringByAppendingPathComponent:@"Downloads"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:directory] == NO) {
        NSError *error;
        if ([fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error] == NO) {
            NSLog(@"Error: ディレクトリ作成失敗: %@", error);
        }
        
        NSURL *url = [NSURL fileURLWithPath:directory];
        // iCloud backupからダウンロードしたコンテンツを排除しないと、リジェクト対象になるので注意
        if ([url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error] == NO) {
            NSLog(@"Error: iCloud backup対象除外が失敗: %@", error);
        }
    }
    
    return directory;
}


// ダウンロード通知処理
// Sent when the download state has changed.
- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray<SKDownload *> *)downloads
{
    for (SKDownload *download in downloads) {
        [WTStoreKit logDownload:download];
        if (download.downloadState == SKDownloadStateFinished) {
            [self processDownload:download]; // ダウンロード処理
            //
            [queue finishTransaction:download.transaction];
            
            if([_storeDelegate respondsToSelector:@selector(WTStoreKitUpdatedDownload:)]){
                [_storeDelegate WTStoreKitUpdatedDownload:download];
            }
            
            [self stopDimScreen];
        }
        else if (download.downloadState == SKDownloadStateActive) {
//            NSTimeInterval remaining = download.timeRemaining; // secs
//            float progress = download.progress; // 0.0 -> 1.0
//            NSLog(@"%lf%% (残り %lf 秒)", progress, remaining);
            
            if([_storeDelegate respondsToSelector:@selector(WTStoreKitUpdatedDownload:)]){
                [_storeDelegate WTStoreKitUpdatedDownload:download];
            }
        }
        else if (download.downloadState == SKDownloadStateFailed || download.downloadState == SKDownloadStateCancelled) { // waiting, paused, failed, cancelled
//            NSLog(@"ダウンロード一時停止またはキャンセルを検出: %ld %@", (long)download.downloadState, download.contentIdentifier);
            
            if([_storeDelegate respondsToSelector:@selector(WTStoreKitUpdatedDownload:)]){
                [_storeDelegate WTStoreKitUpdatedDownload:download];
            }
            [queue finishTransaction:download.transaction];
        }
    }
}
@end

@implementation WTStoreKit (SKStoreProductViewControllerDelegate)

#pragma mark - SKStoreProductViewController delegate

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    __weak typeof (self) weakSelf = self;
    if([_storeDelegate respondsToSelector:@selector(WTStoreKitProductViewControllerDidFinish:)]){
        [_storeDelegate WTStoreKitProductViewControllerDidFinish:viewController];
    }
}

@end
