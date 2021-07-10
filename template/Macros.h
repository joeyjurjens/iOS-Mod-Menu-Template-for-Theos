//
//  Macros.h
//  ModMenu
//
//  Created by Joey on 4/2/19.
//  Copyright © 2019 Joey. All rights reserved.
//

#import "Menu.h"
#import "obfuscate.h"
#import "KittyMemory/writeData.hpp"

#include <substrate.h>
#include <mach-o/dyld.h>

// definition at Menu.h
extern Menu *menu;
extern Switches *switches;

// thanks to shmoo for the usefull stuff under this comment.
#define timer(sec) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, sec * NSEC_PER_SEC), dispatch_get_main_queue(), ^
#define HOOK(offset, ptr, orig) MSHookFunction((void *)getRealOffset(strtoull(OBFUSCATE(offset), NULL, 0)), (void *)ptr, (void **)&orig)
#define HOOK_NO_ORIG(offset, ptr) MSHookFunction((void *)getRealOffset(strtoull(OBFUSCATE(offset), NULL, 0)), (void *)ptr, NULL)

// Note to not prepend an underscore to the symbol. See Notes on the Apple manpage (https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man3/dlsym.3.html)
#define HOOKSYM(sym, ptr, org) MSHookFunction((void*)dlsym((void *)RTLD_DEFAULT, OBFUSCATE(sym)), (void *)ptr, (void **)&org)
#define HOOKSYM_NO_ORIG(sym, ptr)  MSHookFunction((void*)dlsym((void *)RTLD_DEFAULT, OBFUSCATE(sym)), (void *)ptr, NULL)
#define getSym(symName) dlsym((void *)RTLD_DEFAULT, OBFUSCATE(symName))

// Convert hex color to UIColor, usage: For the color #BD0000 you'd use: UIColorFromHex(0xBD0000)
#define UIColorFromHex(hexColor) [UIColor colorWithRed:((float)((hexColor & 0xFF0000) >> 16))/255.0 green:((float)((hexColor & 0xFF00) >> 8))/255.0 blue:((float)(hexColor & 0xFF))/255.0 alpha:1.0]

// getRealOffset("0x123456")
#define getAbsoluteOffset(offset) getRealOffset(strtoull(OBFUSCATE(offset), NULL, 0))
uint64_t getRealOffset(uint64_t offset);
uint64_t getRealOffset(uint64_t offset){
	return KittyMemory::getAbsoluteAddress([menu getFrameworkName], offset);
}

// Patching a offset without switch.
void patchOffset(const char * offset, const char * hexBytes) {
	MemoryPatch patch = MemoryPatch::createWithHex([menu getFrameworkName], strtoull(offset, NULL, 0), std::string(hexBytes));
	if(!patch.isValid()){
		[menu showPopup:@"Invalid patch" description:[NSString stringWithFormat:@"Failing offset: 0x%s, please re-check the hex you entered.", offset]];
		return;
	}
	if(!patch.Modify()) {
      [menu showPopup:@"Something went wrong!" description:[NSString stringWithFormat:@"Something went wrong while patching this offset: %s", offset]];
    }
}
