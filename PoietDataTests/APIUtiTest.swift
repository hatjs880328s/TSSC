//
//  *******************************************
//  
//  APIUtiTest.swift
//  PoietDataTests
//
//  Created by Noah_Shan on 2019/12/27.
//  Copyright © 2018 Inpur. All rights reserved.
//  
//  *******************************************
//


import XCTest
@testable import PoietData

class APIUtiTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBase64Test() {
        let uti = NormalUti.base64Decode(base64Str: NormalConfig.bearer)
        XCTAssert(uti != "-----------", "base64转换失败")
    }

    func testTSRootFilesAndDirs() {
        let exp = expectation(description: "获取唐诗的根目录")
        let timeOut = 10 as TimeInterval
        TangshiUti.getAllDirAndFiles { (models) in
            XCTAssert(models.count != 0, "个数不对")
            exp.fulfill()
        }
        waitForExpectations(timeout: timeOut, handler: nil)
    }

}
