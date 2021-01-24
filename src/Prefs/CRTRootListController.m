#include "CRTRootListController.h"

@implementation CRTRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)respring {
	NSTask *task = [[NSTask alloc] init];
    task.launchPath = @"/usr/bin/sbreload";
    task.arguments = @[];
    [task launch];
}

@end
