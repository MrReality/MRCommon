//
//  ESUtil.c
//  01 OpenGL ES 构建三角形
//
//  Created by shiyuanqi on 2017/5/16.
//  Copyright © 2017年 lrz. All rights reserved.
//


#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include "ESUtil.h"
//#include "esUtil_win.h"

#ifdef ANDROID
#include <android/log.h>
#include <android_native_app_glue.h>
#include <android/asset_manager.h>
typedef AAsset esFile;
#else
typedef FILE esFile;
#endif

#ifdef __APPLE__
#include "FileWrapper.h"
#endif

///
//  Macros
//
#define INVERTED_BIT            (1 << 5)

///
//  Types
//
#ifndef __APPLE__
#pragma pack(push,x1)                            // Byte alignment (8-bit)
#pragma pack(1)
#endif

typedef struct
#ifdef __APPLE__
__attribute__ ((packed))
#endif
{
    unsigned char  IdSize,
    MapType,
    ImageType;
    unsigned short PaletteStart,
    PaletteSize;
    unsigned char  PaletteEntryDepth;
    unsigned short X,
    Y,
    Width,
    Height;
    unsigned char  ColorDepth,
    Descriptor;
    
} TGA_HEADER;

#ifndef __APPLE__
#pragma pack(pop,x1)
#endif

#ifndef __APPLE__

///
// GetContextRenderableType()
//
//    Check whether EGL_KHR_create_context extension is supported.  If so,
//    return EGL_OPENGL_ES3_BIT_KHR instead of EGL_OPENGL_ES2_BIT
//
EGLint GetContextRenderableType(EGLDisplay eglDisplay){
#ifdef EGL_KHR_create_context
    const char *extensions = eglQueryString(eglDisplay, EGL_EXTENSIONS);
    
    // check whether EGL_KHR_create_context is in the extension string
    if(extensions != NULL && strstr(extensions, "EGL_KHR_create_context")){
        // extension is supported
        return EGL_OPENGL_ES3_BIT_KHR;
    }
#endif
    // extension is not supported
    return EGL_OPENGL_ES2_BIT;
}
#endif

/// MARK: 用指定参数创建一个窗口
/**
 用指定参数创建一个窗口
 @param esContext   应用上下文
 @param title       窗口标题栏名称
 @param width       要创建窗口的像素宽度
 @param height      要创建窗口的像素高度
 @param flags       窗口创建标志所用的位域
    ES_WINDOW_RGB           --   指定颜色缓冲区应该有 R, G, B 通道
    ES_WINDOW_ALPHA         --   指定颜色缓冲区应该有 Alpha
    ES_WINDOW_DEPTH         --   指定应该创建深度缓冲区
    ES_WINDOW_STENCIL       --   指定应该创建模板缓冲区
    ES_WINDOW_MULTISAMPLE   --   制动应该创建多重采样缓冲区
 @return 如果创建成功 返回 GL_TRUE, 否则返回 GL_FALSE
 */
GLboolean ESUTIL_API esCreateWindow(ESContext *esContext, const char *title, GLint width, GLint height, GLuint flags){
    
#ifndef __APPLE__
    EGLConfig config;
    EGLint majorVersion;
    EGLint minorVersion;
    EGLint contextAttribs[] = {EGL_CONTEXT_CLIENT_VERSION, 3, EGL_NONE};
    
    if(esContext == NULL){
        return GL_FALSE;
    }
    
#ifdef ANDROID
    // For Android, get the width/height from the window rather than what the
    // application requested.
    esContext -> width = ANativeWindow_getWidth(esContext -> eglNativeWindow);
    esContext -> height = ANativeWindow_getHeight (esContext -> eglNativeWindow);
#else
    esContext -> width = width;
    esContext -> height = height;
#endif
    
    if(!WinCreate(esContext, title)){
        return GL_FALSE;
    }
    
    esContext -> eglDisplay = eglGetDisplay(esContext -> eglNativeDisplay);
    
    if(esContext -> eglDisplay == EGL_NO_DISPLAY){
        return GL_FALSE;
    }
    
    // Initialize EGL
    if(!eglInitialize(esContext -> eglDisplay, &majorVersion, &minorVersion)){
        return GL_FALSE;
    }
    
    {
        EGLint numConfigs = 0;
        EGLint attribList[] =
        {
            EGL_RED_SIZE,       5,
            EGL_GREEN_SIZE,     6,
            EGL_BLUE_SIZE,      5,
            EGL_ALPHA_SIZE,     (flags & ES_WINDOW_ALPHA)       ? 8 : EGL_DONT_CARE,
            EGL_DEPTH_SIZE,     (flags & ES_WINDOW_DEPTH)       ? 8 : EGL_DONT_CARE,
            EGL_STENCIL_SIZE,   (flags & ES_WINDOW_STENCIL)     ? 8 : EGL_DONT_CARE,
            EGL_SAMPLE_BUFFERS, (flags & ES_WINDOW_MULTISAMPLE) ? 1 : 0,
            // if EGL_KHR_create_context extension is supported, then we will use
            // EGL_OPENGL_ES3_BIT_KHR instead of EGL_OPENGL_ES2_BIT in the attribute list
            EGL_RENDERABLE_TYPE, GetContextRenderableType(esContext -> eglDisplay),
            EGL_NONE
        };
        
        // Choose config
        if(!eglChooseConfig(esContext -> eglDisplay, attribList, &config, 1, &numConfigs)){
            return GL_FALSE;
        }
        
        if(numConfigs < 1){
            return GL_FALSE;
        }
    }
    
    
#ifdef ANDROID
    // For Android, need to get the EGL_NATIVE_VISUAL_ID and set it using ANativeWindow_setBuffersGeometry
    {
        EGLint format = 0;
        eglGetConfigAttrib(esContext -> eglDisplay, config, EGL_NATIVE_VISUAL_ID, &format);
        ANativeWindow_setBuffersGeometry(esContext -> eglNativeWindow, 0, 0, format);
    }
#endif // ANDROID
    
    // Create a surface
    esContext -> eglSurface = eglCreateWindowSurface(esContext -> eglDisplay, config, esContext -> eglNativeWindow, NULL );
    
    if(esContext -> eglSurface == EGL_NO_SURFACE){
        return GL_FALSE;
    }
    
    // Create a GL context
    esContext -> eglContext = eglCreateContext(esContext -> eglDisplay, config, EGL_NO_CONTEXT, contextAttribs);
    
    if(esContext -> eglContext == EGL_NO_CONTEXT){
        return GL_FALSE;
    }
    
    // Make the context current
    if(!eglMakeCurrent(esContext -> eglDisplay, esContext -> eglSurface, esContext -> eglSurface, esContext -> eglContext)){
        return GL_FALSE;
    }
    
#endif // #ifndef __APPLE__
    return GL_TRUE;
}

/// MARK: 注册用于渲染每帧的绘图回调函数
/**
 注册用于渲染每帧的绘图回调函数
 @param esContext 应用程序上下文
 @param drawFunc  用于渲染场景的绘图回调函数
 */
void ESUTIL_API esRegisterDrawFunc(ESContext *esContext, void(ESCALLBACK *drawFunc)(ESContext *)){
    esContext -> drawFunc = drawFunc;
}

/// MARK: 注册在关闭时调用的回调函数
/**
 注册在关闭时调用的回调函数
 @param esContext       应用程序上下文
 @param shutdownFunc    应用程序关闭时调用的函数
 */
void ESUTIL_API esRegisterShutdownFunc(ESContext *esContext, void(ESCALLBACK *shutdownFunc)( ESContext *)){
    esContext -> shutdownFunc = shutdownFunc;
}

/// MARK: 注册在用于每个时间步长上更新的更新回调函数
/**
 注册在用于每个时间步长上更新的更新回调函数
 @param esContext       应用程序上下文
 @param updateFunc      用于渲染场景的更新回调函数
 */
void ESUTIL_API esRegisterUpdateFunc(ESContext *esContext, void(ESCALLBACK *updateFunc)( ESContext *, float)){
    esContext -> updateFunc = updateFunc;
}

/// MARK: 注册键盘输入处理回调函数
/**
 注册键盘输入处理回调函数
 @param esContext       应用程序上下文
 @param keyFunc         应用程序处理键盘输入的回调函数
 */
void ESUTIL_API esRegisterKeyFunc(ESContext *esContext, void(ESCALLBACK *keyFunc)(ESContext *, unsigned char, int, int)){
    esContext -> keyFunc = keyFunc;
}

/// MARK: 记录平台调试输出信息
/**
 记录平台调试输出信息
 @param formatStr 错误日志格式串
 */
void ESUTIL_API esLogMessage(const char *formatStr, ...){
    va_list params;
    char buf[BUFSIZ];
    
    va_start (params, formatStr);
    vsprintf (buf, formatStr, params);
    
#ifdef ANDROID
    __android_log_print(ANDROID_LOG_INFO, "esUtil" , "%s", buf);
#else
    printf ("%s", buf);
#endif
    va_end(params);
}

///
// esFileRead()
//
//    Wrapper for platform specific File open
//
static esFile *esFileOpen(void *ioContext, const char *fileName){
    esFile *pFile = NULL;
    
#ifdef ANDROID
    
    if(ioContext != NULL){
        
        AAssetManager *assetManager = (AAssetManager *)ioContext;
        pFile = AAssetManager_open(assetManager, fileName, AASSET_MODE_BUFFER);
    }
#else
#ifdef __APPLE__
    // iOS: Remap the filename to a path that can be opened from the bundle.
    fileName = GetBundleFileName(fileName);
#endif
    
    pFile = fopen(fileName, "rb");
#endif
    return pFile;
}

///
// esFileRead()
//
//    Wrapper for platform specific File close
//
static void esFileClose(esFile *pFile){
    if (pFile != NULL){
#ifdef ANDROID
        AAsset_close(pFile);
#else
        fclose(pFile);
        pFile = NULL;
#endif
    }
}

///
// esFileRead()
//
//    Wrapper for platform specific File read
//
static int esFileRead(esFile *pFile, int bytesToRead, void *buffer){
    
    int bytesRead = 0;
    if(pFile == NULL){
        return bytesRead;
    }
    
#ifdef ANDROID
    bytesRead = AAsset_read(pFile, buffer, bytesToRead);
#else
    bytesRead = (int)fread(buffer, bytesToRead, 1, pFile);
#endif
    return bytesRead;
}

/// MARK: 从文件中加载一个 8 位, 24 位或者 32 位 TGA 图像
/**
 从文件中加载一个 8 位, 24 位或者 32 位 TGA 图像
 @param ioContext   上下文
 @param fileName    磁盘上的文件名
 @param width       以像素表示的加载图像宽度
 @param height      以像素表示的加载图像高度
 @return            指向加载图像的指针, 失败时返回 NULL
 */
char *ESUTIL_API esLoadTGA(void *ioContext, const char *fileName, int *width, int *height){
    
    char        *buffer;
    esFile      *fp;
    TGA_HEADER   Header;
    int          bytesRead;
    
    // 打开的文件进行读取
    fp = esFileOpen(ioContext, fileName);
    
    if(fp == NULL){
        // 打印错误信息
        esLogMessage("esLoadTGA FAILED to load : { %s }\n", fileName);
        return NULL;
    }
    
    bytesRead = esFileRead(fp, sizeof(TGA_HEADER), &Header);
    
    *width  = Header.Width;
    *height = Header.Height;
    
    if(Header.ColorDepth == 8 || Header.ColorDepth == 24 || Header.ColorDepth == 32){
        
        int bytesToRead = sizeof(char) * (*width) * (*height) * Header.ColorDepth / 8;
        
        // 分配图像数据缓存
        buffer = (char *)malloc(bytesToRead);
        
        if(buffer){
            
            bytesRead = esFileRead(fp, bytesToRead, buffer);
            esFileClose(fp);
            
            return buffer;
        }
    }
    return NULL;
}



