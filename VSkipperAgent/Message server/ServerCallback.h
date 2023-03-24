//  Created by p0ch1ta on 24/03/2023 for project VSkipper

#import <Foundation/Foundation.h>

/// CFMessagePortCreateLocal requires a C function pointer for the
/// callback parameter.  These functions, implemented in Objective-C,
/// provide that callback function pointer and related context info
/// in a way that can be consumed by the Swift `Server` class.

@class Server;

/// Return the callback function to be passed to CFMessagePortCreateLocal()
extern CFMessagePortCallBack GetServerCallback(void);

/// Return the value to be used as the `info` field in CFMessagePortContext
extern void *GetServerCallbackInfo(Server *server);
