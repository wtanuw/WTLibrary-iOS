////
////  WTStoreKitVerification.m
////  BushiRoadCardViewer
////
////  Created by Wat Wongtanuwat on 10/10/12.
////  Copyright (c) 2012 aim. All rights reserved.
////
//
//#if WT_NOT_CONSIDER_ARC
//#error This file can be compiled with ARC and without ARC.
//#endif
//
//#import "WTStoreKitVerification.h"
//#import "WTStoreKit.h"
//#import "WTMacro.h"
//#import "NSData+Base64.h"
//
//#ifndef __IPHONE_5_0
//#warning "uses (NSJSONSerialization) only available in iOS SDK 5.0 and later."
//#endif
//
//@interface WTStoreKitVerification()
//
////@property (nonatomic,retain) NSURLConnection *connec;
////@property (nonatomic,retain) NSMutableData *dataConnec;
//@property (nonatomic, copy) void (^completionBlock)(BOOL,NSDictionary*);
////@property (nonatomic,retain) SKPaymentTransaction *paymentTransaction;
//
//- (void)startVerifyWithApple:(SKPaymentTransaction *)transaction __deprecated;
//
//
//- (BOOL)isTransactionAndItsReceiptValid:(SKPaymentTransaction *)transaction;
//- (BOOL)doTransactionDetailsMatchPurchaseInfo:(SKPaymentTransaction *)transaction withPurchaseInfo:(NSDictionary *)purchaseInfoDict;
//- (BOOL)isTransactionIdUnique:(NSString *)transactionId;
//- (void)saveTransactionId:(NSString *)transactionId;
//- (BOOL)doesTransactionInfoMatchReceipt:(NSString*) receiptString;
//
//- (BOOL)validateTrust:(SecTrustRef)trust error:(NSError **)error;
//
//BOOL checkReceiptSecurity(NSString *purchase_info_string, NSString *signature_string, CFDateRef purchaseDate);
//
////- (NSString *)encodeBase64:(const uint8_t *)input length:(NSInteger)length;
////- (NSString *)decodeBase64:(NSString *)input length:(NSInteger *)length;
////
////char* base64_encode(const void* buf, size_t size);
////void * base64_decode(const char* s, size_t * data_len);
//
//@end
//
//
////@interface WTStoreKitVerificationProduct
////
////@end
////
////@implementation WTStoreKitVerificationProduct
////
////@end
//
//
//@implementation WTStoreKitVerification
//@synthesize completionBlock;
//
////+ (WTStoreKitVerification *)sharedInstance
////{
////    if (singleton == nil)
////    {
////        singleton = [[WTStoreKitVerification alloc] init];
////    }
////    return singleton;
////}
//
//+ (instancetype)sharedManager
//{
//    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
//        return [[self alloc] init];
//    });
//}
//
//- (id)init
//{
//    self = [super init];
//    if (self != nil)
//    {
//        paymentTransactionDictionary = [[NSMutableDictionary alloc] init];
//        dataDictionary = [[NSMutableDictionary alloc] init];
//        jsonReceiptStorageDictionary = [[NSMutableDictionary alloc] init];
//        transactionsReceiptStorageDictionary = [[NSMutableDictionary alloc] init];
//    }
//    return self;
//}
//
//#pragma mark -
//
//- (NSDictionary *)dictionaryFromPlistData:(NSData *)data
//{
//    NSError *error;
//    NSDictionary *dictionaryParsed = [NSPropertyListSerialization propertyListWithData:data
//                                                                               options:NSPropertyListImmutable
//                                                                                format:nil
//                                                                                 error:&error];
//    if (!dictionaryParsed)
//    {
//        if (error)
//        {
//            NSLog(@"%@", [error localizedDescription]);
//        }
//        return nil;
//    }
//    return dictionaryParsed;
//}
//
//
//- (NSDictionary *)dictionaryFromJSONData:(NSData *)data
//{
//    NSError *error;
//    NSDictionary *dictionaryParsed = [NSJSONSerialization JSONObjectWithData:data
//                                                                     options:0
//                                                                       error:&error];
//    if (!dictionaryParsed)
//    {
//        if (error)
//        {
//            NSLog(@"%@", [error localizedDescription]);
//        }
//        return nil;
//    }
//    return dictionaryParsed;
//}
//
//- (NSDictionary *)purchaseInfoDictionaryFromReceipt:(NSData *)data
//{
//    NSDictionary *receiptDict = [self dictionaryFromPlistData:data];
//    NSString *transactionPurchaseInfo = [receiptDict objectForKey:@"purchase-info"];
////    NSDictionary *purchaseInfoDict  = [self dictionaryFromPlistData:[NSData dataFromBase64String:transactionPurchaseInfo]];
//    NSDictionary *purchaseInfoDict  = [self dictionaryFromPlistData:WTCBDataFromBase64EncodedString(transactionPurchaseInfo)];
//    return purchaseInfoDict;
//}
//
//#pragma mark - Receipt Verification
//
//- (void)startVerifyWithApple:(SKPaymentTransaction *)transaction __deprecated
//{
//    [self startVerifyProductID:transaction.payment.productIdentifier withReceipt:transaction.transactionReceipt isAutoRenewSubscription:NO];
//}
//
//- (void)startVerifyWithApple:(SKPaymentTransaction *)transaction isAutoRenewSubscription:(BOOL)useAutoRenewSubscription
//{
//    [self startVerifyProductID:transaction.payment.productIdentifier withReceipt:transaction.transactionReceipt isAutoRenewSubscription:useAutoRenewSubscription];
//}
//
//- (void)startVerifyProductID:(NSString*)productIdentifier withReceipt:(NSData *)transactionReceipt isAutoRenewSubscription:(BOOL)useAutoRenewSubscription
//{
//    // Encode the receiptData for the itms receipt verification POST request.
////    NSString *jsonObjectString = [transactionReceipt base64EncodedString];
//    NSString *jsonObjectString = WTCBBase64EncodedStringFromData(transactionReceipt);
//    
//    // Create the POST request payload.
//    NSString *payload = nil;
//    if(useAutoRenewSubscription){
//        NSString *sharedSecret = [[WTStoreKit sharedManager] sharedSecretPassword];
//        if(!sharedSecret){
//            NSLog(@"auto-renewable subscription verify require shared secret");
//        }
//        payload = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\", \"password\" : \"%@\"}",
//                   jsonObjectString, sharedSecret];
//    }else{
//        payload = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}",
//                   jsonObjectString];
//    }
//    
//    NSData *payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSString *serverURL = APPLE_VERIFY_RECEIPT_URL;
//    if(switchVerifyUrl) serverURL = APPLE_VERIFY_RECEIPT_URL_2;
//    
//    // Create the POST request to the server.
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:serverURL]];
//    [request setHTTPMethod:@"POST"];
//    [request setHTTPBody:payloadData];
//    WTStoreKitURLConnection *conn = [[WTStoreKitURLConnection alloc] initWithRequest:request delegate:self];
//    conn.productIdentifier = productIdentifier;
//    conn.useAutoRenewableSubscription = useAutoRenewSubscription;
//    
//    [conn start];
//    
//    //[conn release];
//}
//
//- (BOOL)verifyPurchaseProduct:(SKPaymentTransaction *)transaction onComplete:(WTVerificationCompletionBlock)complete
//{
//    self.completionBlock = complete;
//    
//    return [self verifyPurchase:transaction isSubscription:NO];
//}
//
//- (BOOL)verifyPurchaseSubscription:(SKPaymentTransaction *)transaction onComplete:(WTVerificationCompletionBlock)complete
//{
//    self.completionBlock = complete;
//    
//    return [self verifyPurchase:transaction isSubscription:YES];
//}
//
//// This method should be called once a transaction gets to the SKPaymentTransactionStatePurchased or SKPaymentTransactionStateRestored state
//// Call it with the SKPaymentTransaction.transactionReceipt
//- (BOOL)verifyPurchase:(SKPaymentTransaction *)transaction isSubscription:(BOOL)sub
//{
//    BOOL isOk = [self isTransactionAndItsReceiptValid:transaction];
//    if (!isOk)
//    {
//        // There was something wrong with the transaction we got back, so no need to call verifyReceipt.
//        if(completionBlock){
//            completionBlock(NO,nil);
//            self.completionBlock = nil;
//        }
//        return isOk;
//    }
//    
//    [paymentTransactionDictionary setObject:transaction forKey:transaction.payment.productIdentifier];
//    
//    // The transaction looks ok, so start the verify process.
////    [self startVerifyWithApple:transaction];
//    [self startVerifyWithApple:transaction isAutoRenewSubscription:sub];
//    
//    // The transation receipt has not been validated yet.  That is done from the NSURLConnection callback.
//    return isOk;
//}
//
//- (BOOL)verifyReceiptProduct:(NSData *)receipt onComplete:(void (^)(BOOL,NSDictionary*))complete
//{
//    self.completionBlock = complete;
//    
//    return [self verifyReceipt:receipt isSubscription:NO];
//}
//
//- (BOOL)verifyReceiptSubscription:(NSData *)receipt onComplete:(void (^)(BOOL,NSDictionary*))complete
//{
//    self.completionBlock = complete;
//    
//    return [self verifyReceipt:receipt isSubscription:YES];
//}
//
//- (BOOL)verifyReceipt:(NSData *)receipt isSubscription:(BOOL)sub
//{
//    if(!receipt){
//        return NO;
//    }
//    
//    BOOL isOk = [self isReceiptValid:receipt];
//    if (!isOk)
//    {
//        // There was something wrong with the transaction we got back, so no need to call verifyReceipt.
//        if(completionBlock){
//            completionBlock(NO,nil);
//            self.completionBlock = nil;
//        }
//        return isOk;
//    }
//    
////    NSDictionary *purchaseInfoDict =     [transactionsReceiptStorageDictionary objectForKey:@""];
////
//    // The transaction looks ok, so start the verify process.
//    NSDictionary *receiptDict = [self dictionaryFromPlistData:receipt];
//    NSString *transactionPurchaseInfo = [receiptDict objectForKey:@"purchase-info"];
////    NSDictionary *purchaseInfoDict  = [self dictionaryFromPlistData:[NSData dataFromBase64String:transactionPurchaseInfo]];
//    NSDictionary *purchaseInfoDict  = [self dictionaryFromPlistData:WTCBDataFromBase64EncodedString(transactionPurchaseInfo)];
//    
////    [self startVerifyWithApple:transaction];
//    [self startVerifyProductID:[purchaseInfoDict objectForKey:@"product-id"] withReceipt:receipt isAutoRenewSubscription:sub];
//    
//    // The transation receipt has not been validated yet.  That is done from the NSURLConnection callback.
//    return isOk;
//}
//
//#pragma mark vvv
//#pragma mark -
//
//// Check the validity of the receipt.  If it checks out then also ensure the transaction is something
//// we haven't seen before and then decode and save the purchaseInfo from the receipt for later receipt validation.
////- (BOOL)isTransactionAndItsReceiptValid:(SKPaymentTransaction *)transaction
////{
////
////}
//- (BOOL)isTransactionAndItsReceiptValid:(SKPaymentTransaction *)transaction
//{
//    if (!(transaction && transaction.transactionReceipt && [transaction.transactionReceipt length] > 0))
//    {
//        // Transaction is not valid.
//        return NO;
//    }
//    
//    BOOL isOk = [self isReceiptValid:transaction.transactionReceipt];
//    
//    NSDictionary *purchaseInfoDict =     [transactionsReceiptStorageDictionary objectForKey:transaction.transactionIdentifier];
//    
//    // Ensure the transaction itself is legit
//    if (![self doTransactionDetailsMatchPurchaseInfo:transaction withPurchaseInfo:purchaseInfoDict])
//    {
//        return NO;
//    }
//    
//    return isOk;
//}
//
//- (BOOL)isReceiptValid:(NSData *)receipt
//{
////    if (!(transaction && transaction.transactionReceipt && [transaction.transactionReceipt length] > 0))
////    {
////        // Transaction is not valid.
////        return NO;
////    }
//    
//    // Pull the purchase-info out of the transaction receipt, decode it, and save it for later so
//    // it can be cross checked with the verifyReceipt.
//    NSDictionary *receiptDict       = [self dictionaryFromPlistData:receipt];
//    NSString *transactionPurchaseInfo = [receiptDict objectForKey:@"purchase-info"];
////    NSString *decodedPurchaseInfo   = [self decodeBase64:transactionPurchaseInfo length:nil];
////    NSDictionary *purchaseInfoDict  = [self dictionaryFromPlistData:[decodedPurchaseInfo dataUsingEncoding:NSUTF8StringEncoding]];
//    NSDictionary *purchaseInfoDict  = [self dictionaryFromPlistData:WTCBDataFromBase64EncodedString(transactionPurchaseInfo)];
//    
//    NSString *transactionId         = [purchaseInfoDict objectForKey:@"transaction-id"];
//#ifdef skipCheckReceiptSecurity
//#else
//    NSString *purchaseDateString    = [purchaseInfoDict objectForKey:@"purchase-date"];
//    NSString *signature             = [receiptDict objectForKey:@"signature"];
//#endif
//    
//    // Convert the string into a date
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss z"];
//    
//#ifdef skipCheckReceiptSecurity
//#else
//    NSDate *purchaseDate = [dateFormat dateFromString:[purchaseDateString stringByReplacingOccurrencesOfString:@"Etc/" withString:@""]];
////    NSDate *purchaseDate = WTCBDateFromDateString(purchaseDateString);
//    NSLog(@"%@",[purchaseDateString stringByReplacingOccurrencesOfString:@"Etc/" withString:@""]);
//#endif
//    //[dateFormat release];
//    
//    if (![self isTransactionIdUnique:transactionId])
//    {
//        // We've seen this transaction before.
//        // Had [transactionsReceiptStorageDictionary objectForKey:transactionId]
//        // Got purchaseInfoDict
//        return NO;
//    }
//    
//    // Check the authenticity of the receipt response/signature etc.
//#ifdef skipCheckReceiptSecurity
//    BOOL result = YES;
//#else
//    BOOL result = WTCBCheckReceiptSecurity(transactionPurchaseInfo, signature,
//                                       (purchaseDate));
//#endif
//    
//    if (!result)
//    {
//        return NO;
//    }
//    
////    // Ensure the transaction itself is legit
////    if (![self doTransactionDetailsMatchPurchaseInfo:transaction withPurchaseInfo:purchaseInfoDict])
////    {
////        return NO;
////    }
//    
//    // Make a note of the fact that we've seen the transaction id already
//    [self saveTransactionId:transactionId];
//    
//    // Save the transaction receipt's purchaseInfo in the transactionsReceiptStorageDictionary.
//    [transactionsReceiptStorageDictionary setObject:purchaseInfoDict forKey:transactionId];
//    
//    return YES;
//}
//
//// Make sure the transaction details actually match the purchase info
//- (BOOL)doTransactionDetailsMatchPurchaseInfo:(SKPaymentTransaction *)transaction withPurchaseInfo:(NSDictionary *)purchaseInfoDict
//{
//    if (!transaction || !purchaseInfoDict)
//    {
//        return NO;
//    }
//    
//    int failCount = 0;
//    
//    if (![transaction.payment.productIdentifier isEqualToString:[purchaseInfoDict objectForKey:@"product-id"]])
//    {
//        
//        failCount++;
//    }
//    
//    if (transaction.payment.quantity != [[purchaseInfoDict objectForKey:@"quantity"] intValue])
//    {
//        failCount++;
//    }
//    
//    if (![transaction.transactionIdentifier isEqualToString:[purchaseInfoDict objectForKey:@"transaction-id"]])
//    {
//        failCount++;
//    }
//    
//    // Optionally check the bid and bvrs match this app's current bundle ID and bundle version.
//    // Optionally check the requestData.
//    // Optionally check the dates.
//    
//    if (failCount != 0)
//    {
//        return NO;
//    }
//    
//    // The transaction and its signed content seem ok.
//    return YES;
//}
//
//- (BOOL)isTransactionIdUnique:(NSString *)transactionId
//{
//    return YES;
////    NSString *transactionDictionary = kKNOWN_TRANSACTIONS_KEY;
////    // Save the transactionId to the standardUserDefaults so we can check against that later
////    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
////    [defaults synchronize];
////
////    if (![defaults objectForKey:transactionDictionary])
////    {
////        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
////        [defaults setObject:dict forKey:transactionDictionary];
////        [defaults synchronize];
////        [dict release];
////    }
////
////    if (![[defaults objectForKey:transactionDictionary] objectForKey:transactionId])
////    {
////        return YES;
////    }
////    // The transaction already exists in the defaults.
////    return NO;
//}
//
//
//- (void)saveTransactionId:(NSString *)transactionId
//{
////    // Save the transactionId to the standardUserDefaults so we can check against that later
////    // If dictionary exists already then retrieve it and add new transactionID
////    // Regardless save transactionID to dictionary which gets saved to NSUserDefaults
////    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
////    NSString *transactionDictionary = kKNOWN_TRANSACTIONS_KEY;
////    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:
////                                       [defaults objectForKey:transactionDictionary]];
////    if (!dictionary)
////    {
////        dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:1], transactionId, nil];
////        [defaults setObject:dictionary forKey:transactionDictionary];
////        [dictionary release];
////    } else {
////        [dictionary setObject:[NSNumber numberWithInt:1] forKey:transactionId];
////        [defaults setObject:dictionary forKey:transactionDictionary];
////    }
////    [defaults synchronize];
//}
//
//#pragma mark -
//
//- (BOOL)doesTransactionInfoMatchReceipt:(NSString*) receiptString
//{
//    // Convert the responseString into a dictionary and pull out the receipt data.
//    NSDictionary *verifiedReceiptDictionary = [self dictionaryFromJSONData:[receiptString dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    // Check the status of the verifyReceipt call
//    id status = [verifiedReceiptDictionary objectForKey:@"status"];
//    if (!status)
//    {
//        return NO;
//    }
//    int verifyReceiptStatus = [status integerValue];
//    // 21006 = This receipt is valid but the subscription has expired.
//    if (0 != verifyReceiptStatus && 21006 != verifyReceiptStatus)
//    {
//        return NO;
//    }
//    
//    // The receipt is valid, so checked the receipt specifics now.
//    
//    NSDictionary *verifiedReceiptReceiptDictionary  = [verifiedReceiptDictionary objectForKey:@"receipt"];
//    NSString *verifiedReceiptUniqueIdentifier       = [verifiedReceiptReceiptDictionary objectForKey:@"unique_identifier"];
//    NSString *transactionIdFromVerifiedReceipt      = [verifiedReceiptReceiptDictionary objectForKey:@"transaction_id"];
//    
//    // Get the transaction's receipt data from the transactionsReceiptStorageDictionary
//    NSDictionary *purchaseInfoFromTransaction = [transactionsReceiptStorageDictionary objectForKey:transactionIdFromVerifiedReceipt];
//    
//    if (!purchaseInfoFromTransaction)
//    {
//        // We didn't find a receipt for this transaction.
//        return NO;
//    }
//    
//    
//    // NOTE: Instead of counting errors you could just return early.
//    int failCount = 0;
//    
//    // Verify all the receipt specifics to ensure everything matches up as expected
//    if (![[verifiedReceiptReceiptDictionary objectForKey:@"bid"]
//          isEqualToString:[purchaseInfoFromTransaction objectForKey:@"bid"]])
//    {
//        failCount++;
//    }
//    
//    if (![[verifiedReceiptReceiptDictionary objectForKey:@"product_id"]
//          isEqualToString:[purchaseInfoFromTransaction objectForKey:@"product-id"]])
//    {
//        failCount++;
//    }
//    
//    if (![[verifiedReceiptReceiptDictionary objectForKey:@"quantity"]
//          isEqualToString:[purchaseInfoFromTransaction objectForKey:@"quantity"]])
//    {
//        failCount++;
//    }
//    
//    if (![[verifiedReceiptReceiptDictionary objectForKey:@"item_id"]
//          isEqualToString:[purchaseInfoFromTransaction objectForKey:@"item-id"]])
//    {
//        failCount++;
//    }
//    
//    if ([[UIDevice currentDevice] respondsToSelector:NSSelectorFromString(@"identifierForVendor")]) // iOS 6?
//    {
////#if IS_IOS6_AWARE
//#ifdef __IPHONE_6_0
//        // iOS 6 (or later)
//        NSString *localIdentifier                   = [[[UIDevice currentDevice] performSelector:NSSelectorFromString(@"identifierForVendor")] performSelector:NSSelectorFromString(@"UUIDString")];
//        NSString *purchaseInfoUniqueVendorId        = [purchaseInfoFromTransaction objectForKey:@"unique-vendor-identifier"];
//        NSString *verifiedReceiptVendorIdentifier   = [verifiedReceiptReceiptDictionary objectForKey:@"unique_vendor_identifier"];
//        
//        
//        if(verifiedReceiptVendorIdentifier)
//        {
//            if (![purchaseInfoUniqueVendorId isEqualToString:verifiedReceiptVendorIdentifier]
//                || ![purchaseInfoUniqueVendorId isEqualToString:localIdentifier])
//            {
//                // Comment this line out to test in the Simulator.
//#if !TARGET_IPHONE_SIMULATOR
//                failCount++;
//#endif
//            }
//        }
//#endif
//    }
////    else {
////        // Pre iOS 6
////        NSString *localIdentifier           = [UIDevice currentDevice].uniqueIdentifier;
////        NSString *purchaseInfoUniqueId      = [purchaseInfoFromTransaction objectForKey:@"unique-identifier"];
////
////
////        if (![purchaseInfoUniqueId isEqualToString:verifiedReceiptUniqueIdentifier]
////            || ![purchaseInfoUniqueId isEqualToString:localIdentifier])
////        {
////            // Comment this line out to test in the Simulator.
////#if !TARGET_IPHONE_SIMULATOR
////            failCount++;
////#endif
////        }
////    }
//    
//    
//    // Do addition time checks for the transaction and receipt.
//    
//    if(failCount != 0)
//    {
//        return NO;
//    }
//    
//    return YES;
//}
//
//- (BOOL)doesTransactionStatusCorrectUrlVerificationForReceiptDict:(NSDictionary*) receiptDict
//{
//    id status = [receiptDict objectForKey:@"status"];
//    if (!status)
//    {
//        return YES;
//    }
//    int verifyReceiptStatus = [status integerValue];
//    if (21007 == verifyReceiptStatus || 21008 == verifyReceiptStatus)
//    {
//        return NO;
//    }
//    
//    return YES;
//}
//
//#pragma mark ^^^
//#pragma mark - NSURLConnectionDelegate (for the verifyReceipt connection)
//
//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
//{
//    WTStoreKitURLConnection *conn = (WTStoreKitURLConnection*)connection;
//    
//    [dataDictionary removeObjectForKey:conn.productIdentifier];
//    [NSURLConnection sendAsynchronousRequest:nil queue:nil completionHandler:nil];
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//    WTStoreKitURLConnection *conn = (WTStoreKitURLConnection*)connection;
//    
//    NSMutableData *receiptData = [dataDictionary objectForKey:conn.productIdentifier];
//    if(!receiptData){
//        receiptData = [NSMutableData data];
//        [dataDictionary setObject:receiptData forKey:conn.productIdentifier];
//    }
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//    WTStoreKitURLConnection *conn = (WTStoreKitURLConnection*)connection;
//    
//    NSMutableData *receiptData = [dataDictionary objectForKey:conn.productIdentifier];
//    if(!receiptData){
//        receiptData = [NSMutableData data];
//        [dataDictionary setObject:receiptData forKey:conn.productIdentifier];
//    }
//    
//    [receiptData appendData:data];
//}
//
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//    WTStoreKitURLConnection *conn = (WTStoreKitURLConnection*)connection;
//    
//    NSMutableData *receiptData = [dataDictionary objectForKey:conn.productIdentifier];
//    
//    NSString *responseString = [[NSString alloc] initWithData:receiptData encoding:NSUTF8StringEncoding];
//    
//    NSDictionary *verifiedReceiptDictionary = [self dictionaryFromJSONData:[responseString dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    BOOL isUrlOk = [self doesTransactionStatusCorrectUrlVerificationForReceiptDict:verifiedReceiptDictionary];
//    
//    // So we got some receipt data. Now does it all check out?
//    BOOL isInfoOk = [self doesTransactionInfoMatchReceipt:responseString];
//    
//    [dataDictionary removeObjectForKey:conn.productIdentifier];
//    
//    //[responseString release];
//    
//    if(!isUrlOk){
//        switchVerifyUrl = YES;
//        [self startVerifyWithApple:[paymentTransactionDictionary objectForKey:conn.productIdentifier] isAutoRenewSubscription:conn.useAutoRenewableSubscription];
//        return;
//    }
//    
//    if (isInfoOk)
//    {
//        //Validation suceeded. Unlock content here.
//        if(completionBlock){
//            completionBlock(isInfoOk,verifiedReceiptDictionary);
//            self.completionBlock = nil;
////            self.paymentTransaction = nil;
//        }
//    }else
//    {
//        if(completionBlock){
//            completionBlock(isInfoOk,verifiedReceiptDictionary);
//            self.completionBlock = nil;
////            self.paymentTransaction = nil;
//        }
//    }
//}
//
//- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
//{
//    if ([[[challenge protectionSpace] authenticationMethod] isEqualToString:NSURLAuthenticationMethodServerTrust])
//    {
//        SecTrustRef trust = [[challenge protectionSpace] serverTrust];
//        NSError *error = nil;
//        BOOL didUseCredential = NO;
//        BOOL isTrusted = [self validateTrust:trust error:&error];
//        if (isTrusted)
//        {
//            NSURLCredential *trust_credential = [NSURLCredential credentialForTrust:trust];
//            if (trust_credential)
//            {
//                [[challenge sender] useCredential:trust_credential forAuthenticationChallenge:challenge];
//                didUseCredential = YES;
//            }
//        }
//        if (!didUseCredential)
//        {
//            [[challenge sender] cancelAuthenticationChallenge:challenge];
//        }
//    } else {
//        [[challenge sender] performDefaultHandlingForAuthenticationChallenge:challenge];
//    }
//}
//
//// NOTE: These are needed for 4.x (as willSendRequestForAuthenticationChallenge: is not supported)
//- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
//{
//    return [[protectionSpace authenticationMethod] isEqualToString:NSURLAuthenticationMethodServerTrust];
//}
//
//
//- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
//{
//    if ([[[challenge protectionSpace] authenticationMethod] isEqualToString:NSURLAuthenticationMethodServerTrust])
//    {
//        SecTrustRef trust = [[challenge protectionSpace] serverTrust];
//        NSError *error = nil;
//        BOOL didUseCredential = NO;
//        BOOL isTrusted = [self validateTrust:trust error:&error];
//        if (isTrusted)
//        {
//            NSURLCredential *credential = [NSURLCredential credentialForTrust:trust];
//            if (credential)
//            {
//                [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
//                didUseCredential = YES;
//            }
//        }
//        if (! didUseCredential) {
//            [[challenge sender] cancelAuthenticationChallenge:challenge];
//        }
//    } else {
//        [[challenge sender] performDefaultHandlingForAuthenticationChallenge:challenge];
//    }
//}
//
//
//#pragma mark NSURLConnection - Trust validation
//
//- (BOOL)validateTrust:(SecTrustRef)trust error:(NSError **)error
//{
//    
//    // Include some Security framework SPIs
//    extern CFStringRef kSecTrustInfoExtendedValidationKey;
//    extern CFDictionaryRef SecTrustCopyInfo(SecTrustRef trust);
//    
//    BOOL trusted = NO;
//    SecTrustResultType trust_result;
//    if ((noErr == SecTrustEvaluate(trust, &trust_result)) && (trust_result == kSecTrustResultUnspecified))
//    {
//        NSDictionary *trust_info = (NSDictionary *)SecTrustCopyInfo(trust);
//        id hasEV = [trust_info objectForKey:(NSString *)kSecTrustInfoExtendedValidationKey];
//        //[trust_info release];
//        trusted =  [hasEV isKindOfClass:[NSValue class]] && [hasEV boolValue];
//    }
//    
//    if (trust)
//    {
//        if (!trusted && error)
//        {
//            *error = [NSError errorWithDomain:@"kSecTrustError" code:(NSInteger)trust_result userInfo:nil];
//        }
//        return trusted;
//    }
//    return NO;
//}
//
//
//#pragma mark
//#pragma mark Check Receipt signature
//
//#include <CommonCrypto/CommonDigest.h>
//#include <Security/Security.h>
//#include <AssertMacros.h>
//
//BOOL WTCBCheckReceiptSecurity(NSString *purchaseInfoString, NSString *signatureString, NSDate *purchaseDate) {
//#ifdef _SECURITY_SECBASE_H_
//    BOOL isValid = NO;
//    SecCertificateRef leaf = NULL;
//    SecCertificateRef intermediate = NULL;
//    SecTrustRef trust = NULL;
//    SecPolicyRef policy = SecPolicyCreateBasicX509();
//    
//    {
//        // This scope is required to prevent the compiler from complaining about protected scope
//        // FIXME: Intermediate will expires in 2016. See comments below.
//        static unsigned int const iTS_intermediate_der_len = 1039;
//        
//        static unsigned char const iTS_intermediate_der[] = {
//            0x30, 0x82, 0x04, 0x0b, 0x30, 0x82, 0x02, 0xf3, 0xa0, 0x03, 0x02, 0x01,
//            0x02, 0x02, 0x01, 0x1a, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
//            0xf7, 0x0d, 0x01, 0x01, 0x05, 0x05, 0x00, 0x30, 0x62, 0x31, 0x0b, 0x30,
//            0x09, 0x06, 0x03, 0x55, 0x04, 0x06, 0x13, 0x02, 0x55, 0x53, 0x31, 0x13,
//            0x30, 0x11, 0x06, 0x03, 0x55, 0x04, 0x0a, 0x13, 0x0a, 0x41, 0x70, 0x70,
//            0x6c, 0x65, 0x20, 0x49, 0x6e, 0x63, 0x2e, 0x31, 0x26, 0x30, 0x24, 0x06,
//            0x03, 0x55, 0x04, 0x0b, 0x13, 0x1d, 0x41, 0x70, 0x70, 0x6c, 0x65, 0x20,
//            0x43, 0x65, 0x72, 0x74, 0x69, 0x66, 0x69, 0x63, 0x61, 0x74, 0x69, 0x6f,
//            0x6e, 0x20, 0x41, 0x75, 0x74, 0x68, 0x6f, 0x72, 0x69, 0x74, 0x79, 0x31,
//            0x16, 0x30, 0x14, 0x06, 0x03, 0x55, 0x04, 0x03, 0x13, 0x0d, 0x41, 0x70,
//            0x70, 0x6c, 0x65, 0x20, 0x52, 0x6f, 0x6f, 0x74, 0x20, 0x43, 0x41, 0x30,
//            0x1e, 0x17, 0x0d, 0x30, 0x39, 0x30, 0x35, 0x31, 0x39, 0x31, 0x38, 0x33,
//            0x31, 0x33, 0x30, 0x5a, 0x17, 0x0d, 0x31, 0x36, 0x30, 0x35, 0x31, 0x38,
//            0x31, 0x38, 0x33, 0x31, 0x33, 0x30, 0x5a, 0x30, 0x7f, 0x31, 0x0b, 0x30,
//            0x09, 0x06, 0x03, 0x55, 0x04, 0x06, 0x13, 0x02, 0x55, 0x53, 0x31, 0x13,
//            0x30, 0x11, 0x06, 0x03, 0x55, 0x04, 0x0a, 0x0c, 0x0a, 0x41, 0x70, 0x70,
//            0x6c, 0x65, 0x20, 0x49, 0x6e, 0x63, 0x2e, 0x31, 0x26, 0x30, 0x24, 0x06,
//            0x03, 0x55, 0x04, 0x0b, 0x0c, 0x1d, 0x41, 0x70, 0x70, 0x6c, 0x65, 0x20,
//            0x43, 0x65, 0x72, 0x74, 0x69, 0x66, 0x69, 0x63, 0x61, 0x74, 0x69, 0x6f,
//            0x6e, 0x20, 0x41, 0x75, 0x74, 0x68, 0x6f, 0x72, 0x69, 0x74, 0x79, 0x31,
//            0x33, 0x30, 0x31, 0x06, 0x03, 0x55, 0x04, 0x03, 0x0c, 0x2a, 0x41, 0x70,
//            0x70, 0x6c, 0x65, 0x20, 0x69, 0x54, 0x75, 0x6e, 0x65, 0x73, 0x20, 0x53,
//            0x74, 0x6f, 0x72, 0x65, 0x20, 0x43, 0x65, 0x72, 0x74, 0x69, 0x66, 0x69,
//            0x63, 0x61, 0x74, 0x69, 0x6f, 0x6e, 0x20, 0x41, 0x75, 0x74, 0x68, 0x6f,
//            0x72, 0x69, 0x74, 0x79, 0x30, 0x82, 0x01, 0x22, 0x30, 0x0d, 0x06, 0x09,
//            0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03,
//            0x82, 0x01, 0x0f, 0x00, 0x30, 0x82, 0x01, 0x0a, 0x02, 0x82, 0x01, 0x01,
//            0x00, 0xa4, 0xbc, 0xaf, 0x32, 0x94, 0x43, 0x3e, 0x0b, 0xbc, 0x37, 0x87,
//            0xcd, 0x63, 0x89, 0xf2, 0xcc, 0xd9, 0xbe, 0x20, 0x4d, 0x5a, 0xb4, 0xfe,
//            0x87, 0x67, 0xd2, 0x9a, 0xde, 0x1a, 0x54, 0x9d, 0xa2, 0xf3, 0xdf, 0x87,
//            0xe4, 0x4c, 0xcb, 0x93, 0x11, 0x78, 0xa0, 0x30, 0x8f, 0x34, 0x41, 0xc1,
//            0xd3, 0xbe, 0x66, 0x6d, 0x47, 0x6c, 0x98, 0xb8, 0xec, 0x7a, 0xd5, 0xc9,
//            0xdd, 0xa5, 0xe4, 0xea, 0xc6, 0x70, 0xf4, 0x35, 0xd0, 0x91, 0xf7, 0xb3,
//            0xd8, 0x0a, 0x11, 0x99, 0xab, 0x3a, 0x62, 0x3a, 0xbd, 0x7b, 0xf4, 0x56,
//            0x4f, 0xdb, 0x9f, 0x24, 0x93, 0x51, 0x50, 0x7c, 0x20, 0xd5, 0x66, 0x4d,
//            0x66, 0xf3, 0x18, 0xa4, 0x13, 0x96, 0x22, 0x16, 0xfd, 0x31, 0xa7, 0xf4,
//            0x39, 0x66, 0x9b, 0xfb, 0x62, 0x69, 0x5c, 0x4b, 0x9f, 0x94, 0xa8, 0x4b,
//            0xe8, 0xec, 0x5b, 0x64, 0x5a, 0x18, 0x79, 0x8a, 0x16, 0x75, 0x63, 0x42,
//            0xa4, 0x49, 0xd9, 0x8c, 0x33, 0xde, 0xad, 0x7b, 0xd6, 0x39, 0x04, 0xf4,
//            0xe2, 0x9d, 0x0a, 0x69, 0x8c, 0xeb, 0x4b, 0x12, 0x28, 0x4b, 0x34, 0x48,
//            0x07, 0x9b, 0x0e, 0x59, 0xf9, 0x1f, 0x62, 0xb0, 0x03, 0x9f, 0x36, 0xb8,
//            0x4e, 0xa3, 0xd3, 0x75, 0x59, 0xd4, 0xf3, 0x3a, 0x05, 0xca, 0xc5, 0x33,
//            0x3b, 0xf8, 0xc0, 0x06, 0x09, 0x08, 0x93, 0xdb, 0xe7, 0x4d, 0xbf, 0x11,
//            0xf3, 0x52, 0x2c, 0xa5, 0x16, 0x35, 0x15, 0xf3, 0x41, 0x02, 0xcd, 0x02,
//            0xd1, 0xfc, 0xf5, 0xf8, 0xc5, 0x84, 0xbd, 0x63, 0x6a, 0x86, 0xd6, 0xb6,
//            0x99, 0xf6, 0x86, 0xae, 0x5f, 0xfd, 0x03, 0xd4, 0x28, 0x8a, 0x5a, 0x5d,
//            0xaf, 0xbc, 0x65, 0x74, 0xd1, 0xf7, 0x1a, 0xc3, 0x92, 0x08, 0xf4, 0x1c,
//            0xad, 0x69, 0xe8, 0x02, 0x4c, 0x0e, 0x95, 0x15, 0x07, 0xbc, 0xbe, 0x6a,
//            0x6f, 0xc1, 0xb3, 0xad, 0xa1, 0x02, 0x03, 0x01, 0x00, 0x01, 0xa3, 0x81,
//            0xae, 0x30, 0x81, 0xab, 0x30, 0x0e, 0x06, 0x03, 0x55, 0x1d, 0x0f, 0x01,
//            0x01, 0xff, 0x04, 0x04, 0x03, 0x02, 0x01, 0x86, 0x30, 0x0f, 0x06, 0x03,
//            0x55, 0x1d, 0x13, 0x01, 0x01, 0xff, 0x04, 0x05, 0x30, 0x03, 0x01, 0x01,
//            0xff, 0x30, 0x1d, 0x06, 0x03, 0x55, 0x1d, 0x0e, 0x04, 0x16, 0x04, 0x14,
//            0x36, 0x1d, 0xe8, 0xe2, 0x9d, 0x82, 0xd2, 0x01, 0x18, 0xb5, 0x32, 0x6b,
//            0x0e, 0xd7, 0x43, 0x0b, 0x91, 0x58, 0x43, 0x3a, 0x30, 0x1f, 0x06, 0x03,
//            0x55, 0x1d, 0x23, 0x04, 0x18, 0x30, 0x16, 0x80, 0x14, 0x2b, 0xd0, 0x69,
//            0x47, 0x94, 0x76, 0x09, 0xfe, 0xf4, 0x6b, 0x8d, 0x2e, 0x40, 0xa6, 0xf7,
//            0x47, 0x4d, 0x7f, 0x08, 0x5e, 0x30, 0x36, 0x06, 0x03, 0x55, 0x1d, 0x1f,
//            0x04, 0x2f, 0x30, 0x2d, 0x30, 0x2b, 0xa0, 0x29, 0xa0, 0x27, 0x86, 0x25,
//            0x68, 0x74, 0x74, 0x70, 0x3a, 0x2f, 0x2f, 0x77, 0x77, 0x77, 0x2e, 0x61,
//            0x70, 0x70, 0x6c, 0x65, 0x2e, 0x63, 0x6f, 0x6d, 0x2f, 0x61, 0x70, 0x70,
//            0x6c, 0x65, 0x63, 0x61, 0x2f, 0x72, 0x6f, 0x6f, 0x74, 0x2e, 0x63, 0x72,
//            0x6c, 0x30, 0x10, 0x06, 0x0a, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x63, 0x64,
//            0x06, 0x02, 0x02, 0x04, 0x02, 0x05, 0x00, 0x30, 0x0d, 0x06, 0x09, 0x2a,
//            0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01, 0x05, 0x05, 0x00, 0x03, 0x82,
//            0x01, 0x01, 0x00, 0x75, 0xa6, 0x90, 0xe6, 0x9a, 0xa7, 0xdb, 0x65, 0x70,
//            0xa6, 0x09, 0x93, 0x6f, 0x08, 0xdf, 0x2c, 0xdb, 0xe9, 0x28, 0x8d, 0x40,
//            0x1b, 0x57, 0x5e, 0xa0, 0xea, 0xf4, 0xec, 0x13, 0x65, 0x1b, 0x71, 0x4a,
//            0x4d, 0xdc, 0x80, 0x48, 0x4f, 0xf2, 0xe5, 0xa9, 0xfb, 0x85, 0x6c, 0xb7,
//            0x1e, 0x9d, 0xdb, 0xf4, 0x18, 0x48, 0x10, 0x79, 0x17, 0xea, 0xc3, 0x3d,
//            0x87, 0xd8, 0xb4, 0x79, 0x6d, 0x14, 0x50, 0xad, 0xd2, 0xbf, 0x3d, 0x4e,
//            0xfc, 0x0d, 0xe2, 0xc5, 0x03, 0x94, 0x75, 0x80, 0x73, 0x4d, 0xa5, 0xa1,
//            0x91, 0xfe, 0x1c, 0xde, 0x15, 0x17, 0xac, 0x89, 0x71, 0x2a, 0x6f, 0x0f,
//            0x67, 0x0a, 0xd3, 0x9c, 0x30, 0xa1, 0x68, 0xfb, 0xcf, 0x70, 0x17, 0xca,
//            0xd9, 0x40, 0xfc, 0xf8, 0x1b, 0xbf, 0xce, 0xb0, 0xc4, 0xae, 0xf4, 0x4a,
//            0x2d, 0xa9, 0x99, 0x87, 0x06, 0x42, 0x09, 0x86, 0x22, 0x6a, 0x84, 0x40,
//            0x39, 0xf4, 0xbb, 0xac, 0x56, 0x18, 0xf7, 0x9a, 0x1c, 0x01, 0x81, 0x5c,
//            0x8c, 0x6e, 0x41, 0xf2, 0x5d, 0x19, 0x2c, 0x17, 0x1c, 0x49, 0x46, 0xd9,
//            0x1c, 0x7e, 0x93, 0x12, 0x13, 0xc8, 0x67, 0x99, 0xc2, 0xea, 0x83, 0xe3,
//            0xa2, 0x8c, 0x0e, 0xb8, 0x3b, 0x2a, 0xdf, 0x1c, 0xbf, 0x4b, 0x8b, 0x6f,
//            0x1a, 0xb8, 0xee, 0x97, 0x67, 0x4a, 0xd8, 0xab, 0xaf, 0x8b, 0xa4, 0xda,
//            0x5c, 0x87, 0x1e, 0x20, 0xb8, 0xc5, 0xf3, 0xb1, 0xc4, 0x98, 0xa2, 0x37,
//            0xf8, 0x9e, 0xc6, 0x9a, 0x6b, 0xa5, 0xad, 0xf6, 0x78, 0x96, 0x0e, 0x82,
//            0x8f, 0x04, 0x46, 0x1c, 0xb2, 0xa5, 0xfd, 0x9a, 0x30, 0x51, 0x28, 0xfd,
//            0x52, 0x04, 0x15, 0x03, 0xd5, 0x3c, 0xad, 0xfe, 0xf6, 0x78, 0xe0, 0xea,
//            0x35, 0xef, 0x65, 0xb5, 0x21, 0x76, 0xdb, 0xa4, 0xef, 0xcb, 0x72, 0xef,
//            0x54, 0x6b, 0x01, 0x0d, 0xc7, 0xdd, 0x1a
//        };
//        
//        require([purchaseInfoString canBeConvertedToEncoding:NSASCIIStringEncoding], _out);
//        NSData *purchaseInfoData = WTCBDataFromBase64EncodedString(purchaseInfoString);
//        size_t purchaseInfoLength = purchaseInfoData.length;
//        uint8_t *purchaseInfoBytes = (uint8_t *)purchaseInfoData.bytes;
//        
//        require([signatureString canBeConvertedToEncoding:NSASCIIStringEncoding], _out);
//        NSData *signatureData = WTCBDataFromBase64EncodedString(signatureString);
//        size_t signatureLength = signatureData.length;
//        uint8_t *signatureBytes = (uint8_t *)signatureData.bytes;
//        
//        require(purchaseInfoBytes && signatureBytes, _out);
//        
//        /*
//         Binary format looks as follows:
//         
//         +-----------------+-----------+------------------+-------------+
//         | RECEIPT VERSION | SIGNATURE | CERTIFICATE SIZE | CERTIFICATE |
//         +-----------------+-----------+------------------+-------------+
//         |          1 byte | 128 bytes |          4 bytes |             |
//         +-----------------+-----------+------------------+-------------+
//         | big endian                                                   |
//         +--------------------------------------------------------------+
//         
//         1. Extract receipt version, signature and certificate(s).
//         2. Check receipt version == 2.
//         3. Sanity check that signature is 128 bytes.
//         4. Sanity check certification size <= remaining payload data.
//         */
//        
//#pragma pack(push, 1)
//        struct CBSignatureBlob {
//            uint8_t _receiptVersion;
//            uint8_t _signature[128];
//            uint32_t _certificateLength;
//            uint8_t _certificate[];
//        } *signatureBlob = (struct CBSignatureBlob *)signatureBytes;
//#pragma pack(pop)
//        uint32_t certificateLength;
//        
//        // Make sure the signature blob is long enough to safely extract the _receiptVersion and _certificateLength fields, then perform a sanity check on the fields.
//        require(signatureLength > offsetof(struct CBSignatureBlob, _certificate), _out);
//        require(signatureBlob->_receiptVersion == 2, _out);
//        certificateLength = ntohl(signatureBlob->_certificateLength);
//        require(signatureLength - offsetof(struct CBSignatureBlob, _certificate) >= certificateLength, _out);
//        
//        // Validate certificate chains back to valid receipt signer; policy approximation for now set intermediate as a trust anchor; current intermediate lapses in 2016.
//        NSData *certificateData = [NSData dataWithBytes:signatureBlob->_certificate length:certificateLength];
//        require(leaf = SecCertificateCreateWithData(NULL, (CFDataRef)certificateData), _out);
//        
//        certificateData = [NSData dataWithBytes:iTS_intermediate_der length:iTS_intermediate_der_len];
//        require(intermediate = SecCertificateCreateWithData(NULL, (CFDataRef)certificateData), _out);
//        
//        NSArray *anchors = [NSArray arrayWithObject:(id)intermediate];
//        require(anchors, _out);
//        
//        require_noerr(SecTrustCreateWithCertificates(leaf, policy, &trust), _out);
//        require_noerr(SecTrustSetAnchorCertificates(trust, (CFArrayRef)anchors), _out);
//        
//        if (purchaseDate) {
//            require_noerr(SecTrustSetVerifyDate(trust, (CFDateRef)purchaseDate), _out);
//        }
//        
//        SecTrustResultType trustResult;
//        require_noerr(SecTrustEvaluate(trust, &trustResult), _out);
//        require(trustResult == kSecTrustResultUnspecified, _out);
//        
//        require(SecTrustGetCertificateCount(trust) == 2, _out);
//        
//        // Chain is valid, use leaf key to verify signature on receipt by calculating SHA1(version|purchaseinfo)
//        CC_SHA1_CTX SHA1Context;
//        uint8_t dataToBeVerified[CC_SHA1_DIGEST_LENGTH];
//        
//        CC_SHA1_Init(&SHA1Context);
//        CC_SHA1_Update(&SHA1Context, &signatureBlob->_receiptVersion, sizeof(signatureBlob->_receiptVersion));
//        CC_SHA1_Update(&SHA1Context, purchaseInfoBytes, purchaseInfoLength);
//        CC_SHA1_Final(dataToBeVerified, &SHA1Context);
//        
//        SecKeyRef receiptSigningKey = SecTrustCopyPublicKey(trust);
//        require(receiptSigningKey, _out);
//        require_noerr(SecKeyRawVerify(receiptSigningKey, kSecPaddingPKCS1SHA1, dataToBeVerified, sizeof(dataToBeVerified), signatureBlob->_signature, sizeof(signatureBlob->_signature)), _out);
//        
//        // TODO: Implements optional verification step.
//        // Optional: Verify that the receipt certificate has the 1.2.840.113635.100.6.5.1 Null OID.
//        // The signature is a 1024-bit RSA signature.
//        
//        isValid = YES;
//    }
//    
//_out:
//    if (leaf) {
//        CFRelease(leaf);
//    }
//    
//    if (intermediate) {
//        CFRelease(intermediate);
//    }
//    
//    if (trust) {
//        CFRelease(trust);
//    }
//    
//    if (policy) {
//        CFRelease(policy);
//    }
//    
//    return isValid;
//#else
//    return YES;
//#endif
//}
//
////unsigned int iTS_intermediate_der_len = 1039;
////
////unsigned char iTS_intermediate_der[] = {
////    0x30, 0x82, 0x04, 0x0b, 0x30, 0x82, 0x02, 0xf3, 0xa0, 0x03, 0x02, 0x01,
////    0x02, 0x02, 0x01, 0x1a, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
////    0xf7, 0x0d, 0x01, 0x01, 0x05, 0x05, 0x00, 0x30, 0x62, 0x31, 0x0b, 0x30,
////    0x09, 0x06, 0x03, 0x55, 0x04, 0x06, 0x13, 0x02, 0x55, 0x53, 0x31, 0x13,
////    0x30, 0x11, 0x06, 0x03, 0x55, 0x04, 0x0a, 0x13, 0x0a, 0x41, 0x70, 0x70,
////    0x6c, 0x65, 0x20, 0x49, 0x6e, 0x63, 0x2e, 0x31, 0x26, 0x30, 0x24, 0x06,
////    0x03, 0x55, 0x04, 0x0b, 0x13, 0x1d, 0x41, 0x70, 0x70, 0x6c, 0x65, 0x20,
////    0x43, 0x65, 0x72, 0x74, 0x69, 0x66, 0x69, 0x63, 0x61, 0x74, 0x69, 0x6f,
////    0x6e, 0x20, 0x41, 0x75, 0x74, 0x68, 0x6f, 0x72, 0x69, 0x74, 0x79, 0x31,
////    0x16, 0x30, 0x14, 0x06, 0x03, 0x55, 0x04, 0x03, 0x13, 0x0d, 0x41, 0x70,
////    0x70, 0x6c, 0x65, 0x20, 0x52, 0x6f, 0x6f, 0x74, 0x20, 0x43, 0x41, 0x30,
////    0x1e, 0x17, 0x0d, 0x30, 0x39, 0x30, 0x35, 0x31, 0x39, 0x31, 0x38, 0x33,
////    0x31, 0x33, 0x30, 0x5a, 0x17, 0x0d, 0x31, 0x36, 0x30, 0x35, 0x31, 0x38,
////    0x31, 0x38, 0x33, 0x31, 0x33, 0x30, 0x5a, 0x30, 0x7f, 0x31, 0x0b, 0x30,
////    0x09, 0x06, 0x03, 0x55, 0x04, 0x06, 0x13, 0x02, 0x55, 0x53, 0x31, 0x13,
////    0x30, 0x11, 0x06, 0x03, 0x55, 0x04, 0x0a, 0x0c, 0x0a, 0x41, 0x70, 0x70,
////    0x6c, 0x65, 0x20, 0x49, 0x6e, 0x63, 0x2e, 0x31, 0x26, 0x30, 0x24, 0x06,
////    0x03, 0x55, 0x04, 0x0b, 0x0c, 0x1d, 0x41, 0x70, 0x70, 0x6c, 0x65, 0x20,
////    0x43, 0x65, 0x72, 0x74, 0x69, 0x66, 0x69, 0x63, 0x61, 0x74, 0x69, 0x6f,
////    0x6e, 0x20, 0x41, 0x75, 0x74, 0x68, 0x6f, 0x72, 0x69, 0x74, 0x79, 0x31,
////    0x33, 0x30, 0x31, 0x06, 0x03, 0x55, 0x04, 0x03, 0x0c, 0x2a, 0x41, 0x70,
////    0x70, 0x6c, 0x65, 0x20, 0x69, 0x54, 0x75, 0x6e, 0x65, 0x73, 0x20, 0x53,
////    0x74, 0x6f, 0x72, 0x65, 0x20, 0x43, 0x65, 0x72, 0x74, 0x69, 0x66, 0x69,
////    0x63, 0x61, 0x74, 0x69, 0x6f, 0x6e, 0x20, 0x41, 0x75, 0x74, 0x68, 0x6f,
////    0x72, 0x69, 0x74, 0x79, 0x30, 0x82, 0x01, 0x22, 0x30, 0x0d, 0x06, 0x09,
////    0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03,
////    0x82, 0x01, 0x0f, 0x00, 0x30, 0x82, 0x01, 0x0a, 0x02, 0x82, 0x01, 0x01,
////    0x00, 0xa4, 0xbc, 0xaf, 0x32, 0x94, 0x43, 0x3e, 0x0b, 0xbc, 0x37, 0x87,
////    0xcd, 0x63, 0x89, 0xf2, 0xcc, 0xd9, 0xbe, 0x20, 0x4d, 0x5a, 0xb4, 0xfe,
////    0x87, 0x67, 0xd2, 0x9a, 0xde, 0x1a, 0x54, 0x9d, 0xa2, 0xf3, 0xdf, 0x87,
////    0xe4, 0x4c, 0xcb, 0x93, 0x11, 0x78, 0xa0, 0x30, 0x8f, 0x34, 0x41, 0xc1,
////    0xd3, 0xbe, 0x66, 0x6d, 0x47, 0x6c, 0x98, 0xb8, 0xec, 0x7a, 0xd5, 0xc9,
////    0xdd, 0xa5, 0xe4, 0xea, 0xc6, 0x70, 0xf4, 0x35, 0xd0, 0x91, 0xf7, 0xb3,
////    0xd8, 0x0a, 0x11, 0x99, 0xab, 0x3a, 0x62, 0x3a, 0xbd, 0x7b, 0xf4, 0x56,
////    0x4f, 0xdb, 0x9f, 0x24, 0x93, 0x51, 0x50, 0x7c, 0x20, 0xd5, 0x66, 0x4d,
////    0x66, 0xf3, 0x18, 0xa4, 0x13, 0x96, 0x22, 0x16, 0xfd, 0x31, 0xa7, 0xf4,
////    0x39, 0x66, 0x9b, 0xfb, 0x62, 0x69, 0x5c, 0x4b, 0x9f, 0x94, 0xa8, 0x4b,
////    0xe8, 0xec, 0x5b, 0x64, 0x5a, 0x18, 0x79, 0x8a, 0x16, 0x75, 0x63, 0x42,
////    0xa4, 0x49, 0xd9, 0x8c, 0x33, 0xde, 0xad, 0x7b, 0xd6, 0x39, 0x04, 0xf4,
////    0xe2, 0x9d, 0x0a, 0x69, 0x8c, 0xeb, 0x4b, 0x12, 0x28, 0x4b, 0x34, 0x48,
////    0x07, 0x9b, 0x0e, 0x59, 0xf9, 0x1f, 0x62, 0xb0, 0x03, 0x9f, 0x36, 0xb8,
////    0x4e, 0xa3, 0xd3, 0x75, 0x59, 0xd4, 0xf3, 0x3a, 0x05, 0xca, 0xc5, 0x33,
////    0x3b, 0xf8, 0xc0, 0x06, 0x09, 0x08, 0x93, 0xdb, 0xe7, 0x4d, 0xbf, 0x11,
////    0xf3, 0x52, 0x2c, 0xa5, 0x16, 0x35, 0x15, 0xf3, 0x41, 0x02, 0xcd, 0x02,
////    0xd1, 0xfc, 0xf5, 0xf8, 0xc5, 0x84, 0xbd, 0x63, 0x6a, 0x86, 0xd6, 0xb6,
////    0x99, 0xf6, 0x86, 0xae, 0x5f, 0xfd, 0x03, 0xd4, 0x28, 0x8a, 0x5a, 0x5d,
////    0xaf, 0xbc, 0x65, 0x74, 0xd1, 0xf7, 0x1a, 0xc3, 0x92, 0x08, 0xf4, 0x1c,
////    0xad, 0x69, 0xe8, 0x02, 0x4c, 0x0e, 0x95, 0x15, 0x07, 0xbc, 0xbe, 0x6a,
////    0x6f, 0xc1, 0xb3, 0xad, 0xa1, 0x02, 0x03, 0x01, 0x00, 0x01, 0xa3, 0x81,
////    0xae, 0x30, 0x81, 0xab, 0x30, 0x0e, 0x06, 0x03, 0x55, 0x1d, 0x0f, 0x01,
////    0x01, 0xff, 0x04, 0x04, 0x03, 0x02, 0x01, 0x86, 0x30, 0x0f, 0x06, 0x03,
////    0x55, 0x1d, 0x13, 0x01, 0x01, 0xff, 0x04, 0x05, 0x30, 0x03, 0x01, 0x01,
////    0xff, 0x30, 0x1d, 0x06, 0x03, 0x55, 0x1d, 0x0e, 0x04, 0x16, 0x04, 0x14,
////    0x36, 0x1d, 0xe8, 0xe2, 0x9d, 0x82, 0xd2, 0x01, 0x18, 0xb5, 0x32, 0x6b,
////    0x0e, 0xd7, 0x43, 0x0b, 0x91, 0x58, 0x43, 0x3a, 0x30, 0x1f, 0x06, 0x03,
////    0x55, 0x1d, 0x23, 0x04, 0x18, 0x30, 0x16, 0x80, 0x14, 0x2b, 0xd0, 0x69,
////    0x47, 0x94, 0x76, 0x09, 0xfe, 0xf4, 0x6b, 0x8d, 0x2e, 0x40, 0xa6, 0xf7,
////    0x47, 0x4d, 0x7f, 0x08, 0x5e, 0x30, 0x36, 0x06, 0x03, 0x55, 0x1d, 0x1f,
////    0x04, 0x2f, 0x30, 0x2d, 0x30, 0x2b, 0xa0, 0x29, 0xa0, 0x27, 0x86, 0x25,
////    0x68, 0x74, 0x74, 0x70, 0x3a, 0x2f, 0x2f, 0x77, 0x77, 0x77, 0x2e, 0x61,
////    0x70, 0x70, 0x6c, 0x65, 0x2e, 0x63, 0x6f, 0x6d, 0x2f, 0x61, 0x70, 0x70,
////    0x6c, 0x65, 0x63, 0x61, 0x2f, 0x72, 0x6f, 0x6f, 0x74, 0x2e, 0x63, 0x72,
////    0x6c, 0x30, 0x10, 0x06, 0x0a, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x63, 0x64,
////    0x06, 0x02, 0x02, 0x04, 0x02, 0x05, 0x00, 0x30, 0x0d, 0x06, 0x09, 0x2a,
////    0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01, 0x05, 0x05, 0x00, 0x03, 0x82,
////    0x01, 0x01, 0x00, 0x75, 0xa6, 0x90, 0xe6, 0x9a, 0xa7, 0xdb, 0x65, 0x70,
////    0xa6, 0x09, 0x93, 0x6f, 0x08, 0xdf, 0x2c, 0xdb, 0xe9, 0x28, 0x8d, 0x40,
////    0x1b, 0x57, 0x5e, 0xa0, 0xea, 0xf4, 0xec, 0x13, 0x65, 0x1b, 0x71, 0x4a,
////    0x4d, 0xdc, 0x80, 0x48, 0x4f, 0xf2, 0xe5, 0xa9, 0xfb, 0x85, 0x6c, 0xb7,
////    0x1e, 0x9d, 0xdb, 0xf4, 0x18, 0x48, 0x10, 0x79, 0x17, 0xea, 0xc3, 0x3d,
////    0x87, 0xd8, 0xb4, 0x79, 0x6d, 0x14, 0x50, 0xad, 0xd2, 0xbf, 0x3d, 0x4e,
////    0xfc, 0x0d, 0xe2, 0xc5, 0x03, 0x94, 0x75, 0x80, 0x73, 0x4d, 0xa5, 0xa1,
////    0x91, 0xfe, 0x1c, 0xde, 0x15, 0x17, 0xac, 0x89, 0x71, 0x2a, 0x6f, 0x0f,
////    0x67, 0x0a, 0xd3, 0x9c, 0x30, 0xa1, 0x68, 0xfb, 0xcf, 0x70, 0x17, 0xca,
////    0xd9, 0x40, 0xfc, 0xf8, 0x1b, 0xbf, 0xce, 0xb0, 0xc4, 0xae, 0xf4, 0x4a,
////    0x2d, 0xa9, 0x99, 0x87, 0x06, 0x42, 0x09, 0x86, 0x22, 0x6a, 0x84, 0x40,
////    0x39, 0xf4, 0xbb, 0xac, 0x56, 0x18, 0xf7, 0x9a, 0x1c, 0x01, 0x81, 0x5c,
////    0x8c, 0x6e, 0x41, 0xf2, 0x5d, 0x19, 0x2c, 0x17, 0x1c, 0x49, 0x46, 0xd9,
////    0x1c, 0x7e, 0x93, 0x12, 0x13, 0xc8, 0x67, 0x99, 0xc2, 0xea, 0x83, 0xe3,
////    0xa2, 0x8c, 0x0e, 0xb8, 0x3b, 0x2a, 0xdf, 0x1c, 0xbf, 0x4b, 0x8b, 0x6f,
////    0x1a, 0xb8, 0xee, 0x97, 0x67, 0x4a, 0xd8, 0xab, 0xaf, 0x8b, 0xa4, 0xda,
////    0x5c, 0x87, 0x1e, 0x20, 0xb8, 0xc5, 0xf3, 0xb1, 0xc4, 0x98, 0xa2, 0x37,
////    0xf8, 0x9e, 0xc6, 0x9a, 0x6b, 0xa5, 0xad, 0xf6, 0x78, 0x96, 0x0e, 0x82,
////    0x8f, 0x04, 0x46, 0x1c, 0xb2, 0xa5, 0xfd, 0x9a, 0x30, 0x51, 0x28, 0xfd,
////    0x52, 0x04, 0x15, 0x03, 0xd5, 0x3c, 0xad, 0xfe, 0xf6, 0x78, 0xe0, 0xea,
////    0x35, 0xef, 0x65, 0xb5, 0x21, 0x76, 0xdb, 0xa4, 0xef, 0xcb, 0x72, 0xef,
////    0x54, 0x6b, 0x01, 0x0d, 0xc7, 0xdd, 0x1a
////};
////
////
////BOOL checkReceiptSecurity(NSString *purchase_info_string, NSString *signature_string, CFDateRef purchaseDate)
////{
////    BOOL valid = NO;
////    SecCertificateRef leaf = NULL, intermediate = NULL;
////    SecTrustRef trust = NULL;
////    SecPolicyRef policy = SecPolicyCreateBasicX509();
////
////    NSData *certificate_data;
////    NSArray *anchors;
////
////    /*
////     Parse inputs:
////     purchase_info_string and signature_string are base64 encoded JSON blobs that need to
////     be decoded.
////     */
////
////    require([purchase_info_string canBeConvertedToEncoding:NSASCIIStringEncoding] &&
////            [signature_string canBeConvertedToEncoding:NSASCIIStringEncoding], outLabel);
////
////    size_t purchase_info_length;
////    uint8_t *purchase_info_bytes = base64_decode([purchase_info_string cStringUsingEncoding:NSASCIIStringEncoding],
////                                                 &purchase_info_length);
////
////    size_t signature_length;
////    uint8_t *signature_bytes = base64_decode([signature_string cStringUsingEncoding:NSASCIIStringEncoding],
////                                             &signature_length);
////
////    require(purchase_info_bytes && signature_bytes, outLabel);
////
////    /*
////     Binary format looks as follows:
////
////     RECEIPTVERSION | SIGNATURE | CERTIFICATE SIZE | CERTIFICATE
////     1 byte           128         4 bytes
////     big endian
////
////     Extract version, signature and certificate(s).
////     Check receipt version == 2.
////     Sanity check that signature is 128 bytes.
////     Sanity check certificate size <= remaining payload data.
////     */
////
////#pragma pack(push, 1)
////    struct signature_blob {
////        uint8_t version;
////        uint8_t signature[128];
////        uint32_t cert_len;
////        uint8_t certificate[];
////    } *signature_blob_ptr = (struct signature_blob *)signature_bytes;
////#pragma pack(pop)
////    uint32_t certificate_len;
////
////    /*
////     Make sure the signature blob is long enough to safely extract the version and
////     cert_len fields, then perform a sanity check on the fields.
////     */
////    require(signature_length > offsetof(struct signature_blob, certificate), outLabel);
////    require(signature_blob_ptr->version == 2, outLabel);
////    certificate_len = ntohl(signature_blob_ptr->cert_len);
////
////    require(signature_length - offsetof(struct signature_blob, certificate) >= certificate_len, outLabel);
////
////    /*
////     Validate certificate chains back to valid receipt signer; policy approximation for now
////     set intermediate as a trust anchor; current intermediate lapses in 2016.
////     */
////
////    certificate_data = [NSData dataWithBytes:signature_blob_ptr->certificate length:certificate_len];
////    require(leaf = SecCertificateCreateWithData(NULL, (CFDataRef) certificate_data), outLabel);
////
////    certificate_data = [NSData dataWithBytes:iTS_intermediate_der length:iTS_intermediate_der_len];
////    require(intermediate = SecCertificateCreateWithData(NULL, (CFDataRef) certificate_data), outLabel);
////
////    anchors = [NSArray arrayWithObject:(id)intermediate];
////    require(anchors, outLabel);
////
////    require_noerr(SecTrustCreateWithCertificates(leaf, policy, &trust), outLabel);
////    require_noerr(SecTrustSetAnchorCertificates(trust, (CFArrayRef) anchors), outLabel);
////
////    if (purchaseDate)
////    {
////        require_noerr(SecTrustSetVerifyDate(trust, purchaseDate), outLabel);
////    }
////
////    SecTrustResultType trust_result;
////    require_noerr(SecTrustEvaluate(trust, &trust_result), outLabel);
////    require(trust_result == kSecTrustResultUnspecified, outLabel);
////
////    require(2 == SecTrustGetCertificateCount(trust), outLabel);
////
////    /*
////     Chain is valid, use leaf key to verify signature on receipt by
////     calculating SHA1(version|purchaseInfo)
////     */
////
////    CC_SHA1_CTX sha1_ctx;
////    uint8_t to_be_verified_data[CC_SHA1_DIGEST_LENGTH];
////
////    CC_SHA1_Init(&sha1_ctx);
////    CC_SHA1_Update(&sha1_ctx, &signature_blob_ptr->version, sizeof(signature_blob_ptr->version));
////    CC_SHA1_Update(&sha1_ctx, purchase_info_bytes, purchase_info_length);
////    CC_SHA1_Final(to_be_verified_data, &sha1_ctx);
////
////    SecKeyRef receipt_signing_key = SecTrustCopyPublicKey(trust);
////    require(receipt_signing_key, outLabel);
////    require_noerr(SecKeyRawVerify(receipt_signing_key, kSecPaddingPKCS1SHA1,
////                                  to_be_verified_data, sizeof(to_be_verified_data),
////                                  signature_blob_ptr->signature, sizeof(signature_blob_ptr->signature)),
////                  outLabel);
////
////    /*
////     Optional:  Verify that the receipt certificate has the 1.2.840.113635.100.6.5.1 Null OID
////
////     The signature is a 1024-bit RSA signature.
////     */
////
////    valid = YES;
////
////outLabel:
////    if (leaf) CFRelease(leaf);
////    if (intermediate) CFRelease(intermediate);
////    if (trust) CFRelease(trust);
////    if (policy) CFRelease(policy);
////
////    return valid;
////}
//
//#pragma mark
//#pragma mark Base 64 encoding
//
//NSDate * WTCBDateFromDateString(NSString *string) {
//    if (!string) {
//        return nil;
//    }
//    
//    NSString* dateString = [string stringByReplacingOccurrencesOfString:@"Etc/" withString:@""];
//    
//    static NSDateFormatter *_dateFormatter = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _dateFormatter =  [[NSDateFormatter alloc] init];
//        _dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
//        _dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"utc"];
//        _dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss z";
//    });
//    
//    return [_dateFormatter dateFromString:dateString];
//}
//
//NSString * WTCBBase64EncodedStringFromData(NSData *data) {
//    NSUInteger length = [data length];
//    NSMutableData *mutableData = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
//    
//    uint8_t *input = (uint8_t *)[data bytes];
//    uint8_t *output = (uint8_t *)[mutableData mutableBytes];
//    
//    static uint8_t const kAFBase64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
//    
//    for (NSUInteger i = 0; i < length; i += 3) {
//        NSUInteger value = 0;
//        for (NSUInteger j = i; j < (i + 3); j++) {
//            value <<= 8;
//            if (j < length) {
//                value |= (0xFF & input[j]);
//            }
//        }
//        
//        NSUInteger idx = (i / 3) * 4;
//        output[idx + 0] = kAFBase64EncodingTable[(value >> 18) & 0x3F];
//        output[idx + 1] = kAFBase64EncodingTable[(value >> 12) & 0x3F];
//        output[idx + 2] = (i + 1) < length ? kAFBase64EncodingTable[(value >> 6)  & 0x3F] : '=';
//        output[idx + 3] = (i + 2) < length ? kAFBase64EncodingTable[(value >> 0)  & 0x3F] : '=';
//    }
//    
//    return [[NSString alloc] initWithData:mutableData encoding:NSASCIIStringEncoding];
//}
//
//// Reference http://cocoawithlove.com/2009/06/base64-encoding-options-on-mac-and.html
//NSData* WTCBDataFromBase64EncodedString(NSString *base64EncodedString) {
//    NSData *base64EncodedStringASCIIData = [base64EncodedString dataUsingEncoding:NSASCIIStringEncoding];
//    uint8_t *input = (uint8_t *)base64EncodedStringASCIIData.bytes;
//    NSUInteger length = base64EncodedStringASCIIData.length;
//    
//    NSUInteger outputLength = ((length + 3) / 4) * 3;
//    if (input[length - 1] == 61) {
//        if (input[length - 2] == 61) {
//            outputLength -= 2;
//        } else {
//            outputLength -= 1;
//        }
//    }
//    
//    NSMutableData *data = [NSMutableData dataWithLength:outputLength];
//    uint8_t *output = (uint8_t *)data.mutableBytes;
//    
//    static uint8_t const kAFBase64DecodingTable[256] = {
//        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
//        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
//        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 62,  0,  0,  0, 63,
//        52, 53, 54, 55, 56, 57, 58, 59, 60, 61,  0,  0,  0,  0,  0,  0,
//        0,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
//        15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,  0,  0,  0,  0,  0,
//        0, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
//        41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51,  0,  0,  0,  0,  0,
//        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
//        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
//        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
//        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
//        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
//        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
//        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
//        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
//    };
//    
//    for (NSUInteger i = 0; i < length; i += 4) {
//        NSUInteger value = 0;
//        for (NSUInteger j = i; j < (i + 4); j++) {
//            value <<= 6;
//            if (j < length) {
//                value |= (0x3F & kAFBase64DecodingTable[input[j]]);
//            }
//        }
//        
//        NSUInteger outputIndex = (i / 4) * 3;
//        output[outputIndex + 0] = (value >> 16) & 0xFF;
//        output[outputIndex + 1] = (value >> 8) & 0xFF;
//        output[outputIndex + 2] = (value >> 0) & 0xFF;
//    }
//    
//    return [NSData dataWithData:data];
//}
//
////static int POS(char c)
////{
////    if (c>='A' && c<='Z') return c - 'A';
////    if (c>='a' && c<='z') return c - 'a' + 26;
////    if (c>='0' && c<='9') return c - '0' + 52;
////    if (c == '+') return 62;
////    if (c == '/') return 63;
////    if (c == '=') return -1;
////
////    [NSException raise:@"invalid BASE64 encoding" format:@"Invalid BASE64 encoding"];
////    return 0;
////}
////
////- (NSString *)encodeBase64:(const uint8_t *)input length:(NSInteger)length
////{
////    return [NSString stringWithUTF8String:base64_encode(input, (size_t)length)];
////}
////
////- (NSString *)decodeBase64:(NSString *)input length:(NSInteger *)length
////{
////    size_t retLen;
////    uint8_t *retStr = base64_decode([input UTF8String], &retLen);
////    if (length)
////        *length = (NSInteger)retLen;
////    NSString *st = [[[NSString alloc] initWithBytes:retStr
////                                             length:retLen
////                                           encoding:NSUTF8StringEncoding] autorelease];
////    free(retStr);    // If base64_decode returns dynamically allocated memory
////    return st;
////}
////
//////+(NSString *) encodeString:(NSString *)inString
//////{
//////    NSData *data = [inString dataUsingEncoding:NSUTF8StringEncoding];
//////    //Point to start of the data and set buffer sizes
//////    int inLength = [data length];
//////    int outLength = ((((inLength * 4)/3)/4)*4) + (((inLength * 4)/3)%4 ? 4 : 0);
//////    const char *inputBuffer = [data bytes];
//////    char *outputBuffer = malloc(outLength);
//////    outputBuffer[outLength] = 0;
//////
//////    //64 digit code
//////    static char Encode[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
//////
//////    //start the count
//////    int cycle = 0;
//////    int inpos = 0;
//////    int outpos = 0;
//////    char temp;
//////
//////    outputBuffer[outLength-1] = '=';
//////    outputBuffer[outLength-2] = '=';
//////
//////    while (inpos < inLength){
//////        switch (cycle) {
//////            case 0:
//////                outputBuffer[outpos++] = Encode[(inputBuffer[inpos]&0xFC)>>2];
//////                cycle = 1;
//////                break;
//////            case 1:
//////                temp = (inputBuffer[inpos++]&0x03)<<4;
//////                outputBuffer[outpos] = Encode[temp];
//////                cycle = 2;
//////                break;
//////            case 2:
//////                outputBuffer[outpos++] = Encode[temp|(inputBuffer[inpos]&0xF0)>> 4];
//////                temp = (inputBuffer[inpos++]&0x0F)<<2;
//////                outputBuffer[outpos] = Encode[temp];
//////                cycle = 3;
//////                break;
//////            case 3:
//////                outputBuffer[outpos++] = Encode[temp|(inputBuffer[inpos]&0xC0)>>6];
//////                cycle = 4;
//////                break;
//////            case 4:
//////                outputBuffer[outpos++] = Encode[inputBuffer[inpos++]&0x3f];
//////                cycle = 0;
//////                break;
//////            default:
//////                cycle = 0;
//////                break;
//////        }
//////    }
//////
//////    NSString *pictemp = [NSString stringWithUTF8String:outputBuffer];
//////    free(outputBuffer);
//////
//////    return pictemp;
//////}
//////
//////+(NSString *) decodeString:(NSString *)inString
//////{
//////    const char* string = [inString cStringUsingEncoding:NSASCIIStringEncoding];
//////
//////    NSInteger inputLength = inString.length;
//////
//////    static char decodingTable[128];
//////
//////    static char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
//////
//////    for (NSInteger i = 0; i < 128; i++) {
//////        decodingTable[encodingTable[i]] = i;
//////    }
//////
//////    if ((string == NULL) || (inputLength % 4 != 0)) {
//////        return nil;
//////    }
//////
//////    while (inputLength > 0 && string[inputLength - 1] == '=') {
//////        inputLength--;
//////    }
//////
//////    NSInteger outputLength = inputLength * 3 / 4;
//////    NSMutableData* data = [NSMutableData dataWithLength:outputLength];
//////    uint8_t* output = data.mutableBytes;
//////
//////    NSInteger inputPoint = 0;
//////    NSInteger outputPoint = 0;
//////    while (inputPoint < inputLength) {
//////        char i0 = string[inputPoint++];
//////        char i1 = string[inputPoint++];
//////        char i2 = inputPoint < inputLength ? string[inputPoint++] : 'A'; /* 'A' will decode to \0 */
//////        char i3 = inputPoint < inputLength ? string[inputPoint++] : 'A';
//////
//////        output[outputPoint++] = (decodingTable[i0] << 2) | (decodingTable[i1] >> 4);
//////        if (outputPoint < outputLength) {
//////            output[outputPoint++] = ((decodingTable[i1] & 0xf) << 4) | (decodingTable[i2] >> 2);
//////        }
//////        if (outputPoint < outputLength) {
//////            output[outputPoint++] = ((decodingTable[i2] & 0x3) << 6) | decodingTable[i3];
//////        }
//////    }
//////
//////    NSLog(@"%@",data);
//////
//////    NSString *finalString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
//////
//////    return finalString;
//////}
//////
//////char* base64_encode(const void* buf, size_t size)
//////{
//////    NSData* data = [NSData dataWithBytesNoCopy:(void*)buf length:size];
//////    NSString* string = [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
//////    return (char *)[[WTStoreKitVerification encodeString:string] UTF8String];
//////}
//////
//////void* base64_decode (const char* s, size_t* data_len)
//////{
//////    NSString* result = [WTStoreKitVerification decodeString:[NSString stringWithCString:s encoding:NSASCIIStringEncoding]];
//////    *data_len = result.length;
//////    return (char *)[result UTF8String];
//////}
////
////char* base64_encode(const void* buf, size_t size)
////{
////    static const char base64[] =  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
////
////    char* str = (char*) malloc((size+3)*4/3 + 1);
////
////    char* p = str;
////    unsigned char* q = (unsigned char*) buf;
////    size_t i = 0;
////
////    while(i < size) {
////        int c = q[i++];
////        c *= 256;
////        if (i < size) c += q[i];
////        i++;
////
////        c *= 256;
////        if (i < size) c += q[i];
////        i++;
////
////        *p++ = base64[(c & 0x00fc0000) >> 18];
////        *p++ = base64[(c & 0x0003f000) >> 12];
////
////        if (i > size + 1)
////            *p++ = '=';
////        else
////            *p++ = base64[(c & 0x00000fc0) >> 6];
////
////        if (i > size)
////            *p++ = '=';
////        else
////            *p++ = base64[c & 0x0000003f];
////    }
////
////    *p = 0;
////
////    return str;
////}
////
////void* base64_decode(const char* s, size_t* data_len_ptr)
////{
////    size_t len = strlen(s);
////
////    if (len % 4)
////        [NSException raise:@"Invalid input in base64_decode" format:@"%d is an invalid length for an input string for BASE64 decoding", (int)len];
////
////    unsigned char* data = (unsigned char*) malloc(len/4*3);
////
////    int n[4];
////    unsigned char* q = (unsigned char*) data;
////
////    for(const char*p=s; *p; )
////    {
////        n[0] = POS(*p++);
////        n[1] = POS(*p++);
////        n[2] = POS(*p++);
////        n[3] = POS(*p++);
////
////        if (n[0]==-1 || n[1]==-1)
////            [NSException raise:@"Invalid input in base64_decode" format:@"Invalid BASE64 encoding"];
////
////        if (n[2]==-1 && n[3]!=-1)
////            [NSException raise:@"Invalid input in base64_decode" format:@"Invalid BASE64 encoding"];
////
////        q[0] = (n[0] << 2) + (n[1] >> 4);
////        if (n[2] != -1) q[1] = ((n[1] & 15) << 4) + (n[2] >> 2);
////        if (n[3] != -1) q[2] = ((n[2] & 3) << 6) + n[3];
////        q += 3;
////    }
////
////    // make sure that data_len_ptr is not null
////    if (!data_len_ptr)
////        [NSException raise:@"Invalid input in base64_decode" format:@"Invalid destination for output string length"];
////
////    *data_len_ptr = q-data - (n[2]==-1) - (n[3]==-1);
////
////    return data;
////}
//
////default
////- (NSString *)encodeBase64:(const uint8_t *)input length:(NSInteger)length
////{
////#warning Replace this method.
////    return nil;
////}
////
////- (NSString *)decodeBase64:(NSString *)input length:(NSInteger *)length
////{
////#warning Replace this method.
////    return nil;
////}
////
////#warning Implement this function.
////char* base64_encode(const void* buf, size_t size)
////{ return NULL; }
////
////#warning Implement this function.
////void * base64_decode(const char* s, size_t * data_len)
////{ return NULL; }
//
//@end
//
//#pragma mark -
//
//@implementation WTStoreKitURLConnection
//@synthesize productIdentifier = _productIdentifier;
//@synthesize useAutoRenewableSubscription = _useAutoRenewableSubscription;
//
//@end
