

#import "FileWrapper.h"
#import <Foundation/Foundation.h>

///
/// \brief Given a fileName, convert into a path that can be used to open from
/// the mainBundle
/// \param fileName Name of file to convert to mainBundle path
/// \return Path that can be used to fopen() from the mainBundle
///
const char *GetBundleFileName(const char *fileName){
    
    NSString* fileNameNS = [NSString stringWithUTF8String:fileName];
    NSString* baseName   = [fileNameNS stringByDeletingPathExtension];
    NSString* extension  = [fileNameNS pathExtension];
    NSString *path = [[NSBundle mainBundle] pathForResource: baseName ofType: extension];
    fileName = [path cStringUsingEncoding:NSUTF8StringEncoding];

    return fileName;
}
