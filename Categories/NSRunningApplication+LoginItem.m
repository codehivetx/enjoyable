//
//  NSApplication+LoginItem.m
//  Enjoyable
//
//  Created by Joe Wreschnig on 3/13/13.
//
//

#import "NSRunningApplication+LoginItem.h"

#import <ServiceManagement/ServiceManagement.h>
#include <libproc.h>
#include <string.h>
#include <sys/proc_info.h>
#include <unistd.h>

// Executable name of the login window, which launches apps when logging in.
static const char *const kLoginWindowProcessName = "loginwindow";

@implementation NSRunningApplication (LoginItem)

- (BOOL)isLoginItem {
    return [SMAppService mainAppService].status == SMAppServiceStatusEnabled;
}

- (void)addToLoginItems {
    if (!self.isLoginItem) {
        NSError *error = nil;
        [[SMAppService mainAppService] registerAndReturnError:&error];
    }
}

- (void)removeFromLoginItems {
    NSError *error = nil;
    [[SMAppService mainAppService] unregisterAndReturnError:&error];
}

- (BOOL)wasLaunchedAsLoginItemOrResume {
    // Modern replacement for the deprecated ProcessInformationCopyDictionary:
    // ask the kernel via proc_pidinfo for this process's parent and check
    // whether it is the login window.
    struct proc_bsdinfo info = {0};
    if (proc_pidinfo(getpid(), PROC_PIDTBSDINFO, 0, &info, sizeof(info)) <= 0)
        return NO;
    const pid_t parent = (pid_t)info.pbi_ppid;
    if (parent <= 0)
        return NO;
    char parentName[32] = {0};
    if (proc_name(parent, parentName, sizeof(parentName)) <= 0)
        return NO;
    return strcmp(parentName, kLoginWindowProcessName) == 0;
}

@end
