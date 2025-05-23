//
//  WTLibrary.swift
//  Pods
//
//  Created by iMac on 12/16/15.
//
//
 
import Foundation

//MARK:

//swift 2.0 remove String function
//public func print<T>(object: T, _ file: String = __FILE__, _ function: String = __FUNCTION__, _ line: Int = __LINE__) {
//    Swift.print("\(file.lastPathComponent.stringByDeletingPathExtension).\(function)[\(line)]: \(object)")
//}

#if DEBUG
    func StLog(message: String, filename: String = #file, function: String = #function, line: Int = #line) {
        NSLog("[\(filename.lastPathComponent):\(line)] \(function) - \(message)")
    }
#else
    func StLog(_ message: String, filename: String = #file, function: String = #function, line: Int = #line) {}
#endif

func adLog(_ message: String, filename: String = #file, function: String = #function, line: Int = #line) {
    NSLog("[\(filename.lastPathComponent):\(line)] \(function) - \(message)")
}

import StoreKit

let productIds = ["pro_monthly", "pro_yearly", "pro_lifetime"]

private func loadProducts() async throws {
//    self.products = try await Product.products(for: productIds)
    let a:WTStoreProduct? = nil;
}

@available(iOS 15.0, *)
private func purchase(_ product: Product) async throws {
    let result = try await product.purchase()

    switch result {
    case let .success(.verified(transaction)):
        // Successful purhcase
        await transaction.finish()
    case let .success(.unverified(_, error)):
        // Successful purchase but transaction/receipt can't be verified
        // Could be a jailbroken phone
        break
    case .pending:
        // Transaction waiting on SCA (Strong Customer Authentication) or
        // approval from Ask to Buy
        break
    case .userCancelled:
        // ^^^
        break
    @unknown default:
        break
    }
}
