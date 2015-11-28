//
//  OZLModelUser.m
//  RedmineMobile
//
//  Created by lizhijie on 7/15/13.

// This code is distributed under the terms and conditions of the MIT license.

// Copyright (c) 2013 Zhijie Lee(onezeros.lee@gmail.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "OZLModelUser.h"

@implementation OZLModelUser

- (id)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        _index = [[dic objectForKey:@"id"] intValue];
        _login = [dic objectForKey:@"login"];
        _firstname = [dic objectForKey:@"firstname"];
        _lastname = [dic objectForKey:@"lastname"];
        _mail = [dic objectForKey:@"mail"];
        _createdOn = [dic objectForKey:@"created_on"];
        _lastLoginIn = [dic objectForKey:@"last_login_on"];

        _name = [dic objectForKey:@"name"];
        
        if (_name == nil) {
            _name = _login;
        }
    }

    return  self;
}

@end