//  Created by p0ch1ta on 24/03/2023 for project VSkipper

#import "ServerCallback.h"
#import "VSkipperAgent-Swift.h"

/// Calls Server.handleMessageWithID(,data:)
static CFDataRef ServerCallback(CFMessagePortRef local, SInt32 msgid, CFDataRef data, void *info) {
    Server *server = (__bridge Server *)info;
    NSData *responseData = [server handleMessageWithID:msgid data:(__bridge NSData *)(data)];
    if (responseData != NULL) {
        CFDataRef cfdata = CFDataCreate(nil, responseData.bytes, responseData.length);
        return cfdata;
    }
    else {
        return NULL;
    }
}

CFMessagePortCallBack GetServerCallback(void) {
    return ServerCallback;
}

void *GetServerCallbackInfo(Server *server) {
    return (__bridge void *)server;
}
