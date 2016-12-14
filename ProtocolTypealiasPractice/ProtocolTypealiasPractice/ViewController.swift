//
//  ViewController.swift
//  ProtocolTypealiasPractice
//
//  Created by UBT on 2016/12/13.
//  Copyright © 2016年 martin. All rights reserved.
//

import UIKit

protocol GenericProtocol {
    associatedtype AbstractType
    func magic() -> AbstractType
}

struct GenericProtocolThunk<T> : GenericProtocol {
    // closure which will be used to implement `magic()` as declared in the protocol
    private let _magic : () -> T
    
    // `T` is effectively a handle for `AbstractType` in the protocol
    init<P : GenericProtocol>(_ dep : P) where P.AbstractType == T {
        // requires Swift 2, otherwise create explicit closure
        _magic = dep.magic
    }
    
    func magic() -> T {
        // any protocol methods are implemented by forwarding
        return _magic()
    }
}

struct StringMagic : GenericProtocol {
    typealias AbstractType = String
    func magic() -> String {
        return "Magic!"
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//示例1，报错
//        let generic : GenericProtocol = StringMagic()

//示例2，报错
//        let list : [GenericProtocol] = []
// 
//示例3，报错
//        let stringMagic = StringMagic()
//        let anyArr : [Any] = [stringMagic as Any]
//        if let item = anyArr.first as? GenericProtocol {
//            
//        }
        
//示例1，解决
        let genericThunk : GenericProtocolThunk<String> = GenericProtocolThunk(StringMagic())
        print(genericThunk.magic())
 
//示例2，解决
        let magicians : [GenericProtocolThunk<String>] = [GenericProtocolThunk(StringMagic())]
        print(magicians.first!.magic())
        
//示例3，解决
        let stringMagicThunk = GenericProtocolThunk(StringMagic())
        let anyArr : [Any] = [stringMagicThunk as Any]
        if let item = anyArr.first as? GenericProtocolThunk<String> {
            print(item.magic())
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

