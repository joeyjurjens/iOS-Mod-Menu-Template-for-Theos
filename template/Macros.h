//
//  Macros.h
//  ModMenu
//
//  Created by Joey on 4/2/19.
//  Copyright © 2019 Joey. All rights reserved.
//

#include "Menu.h"
#import "KittyMemory/writeData.hpp"

#include <substrate.h>
#include <mach-o/dyld.h>

// definition at Menu.h
extern Menu *menu;
extern Switches *switches;

// thanks to shmoo for the usefull stuff under this comment.
#define timer(sec) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, sec * NSEC_PER_SEC), dispatch_get_main_queue(), ^
#define HOOK(offset, ptr, orig) MSHookFunction((void *)getRealOffset(offset), (void *)ptr, (void **)&orig)
#define HOOK_NO_ORIG(offset, ptr) MSHookFunction((void *)getRealOffset(offset), (void *)ptr, NULL)

// Convert hex color to UIColor, usage: For the color #BD0000 you'd use: UIColorFromHex(0xBD0000)
#define UIColorFromHex(hexColor) [UIColor colorWithRed:((float)((hexColor & 0xFF0000) >> 16))/255.0 green:((float)((hexColor & 0xFF00) >> 8))/255.0 blue:((float)(hexColor & 0xFF))/255.0 alpha:1.0]

uint64_t getRealOffset(uint64_t offset){
	return _dyld_get_image_vmaddr_slide(0) + offset;
}

// Patching a offset without switch.
void patchOffset(uint64_t offset, std::string hexBytes) {
    if(isValidHexString(hexBytes)) {
        std::vector<uint32_t> hexBytesVector = getHexBytesVector(hexBytes); 
        for(int i = 0; i < hexBytesVector.size(); i++) {
            if(!writeData32(offset + (i * 4), hexBytesVector[i])) {
                [menu showPopup:@"Something went wrong!" description:[NSString stringWithFormat:@"Something went wrong while patching this offset: %llu", offset]];
            }
        }           
    } else {
        [menu showPopup:@"Invalid Hex" description:[NSString stringWithFormat:@"Failing offset: 0x%llx, please re-check the hex you entered.", offset]];
    }
}
