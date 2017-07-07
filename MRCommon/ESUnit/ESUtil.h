//
//  ESUtil.h
//  01 OpenGL ES 构建三角形
//
//  Created by shiyuanqi on 2017/5/16.
//  Copyright © 2017年 lrz. All rights reserved.
//

#ifndef ESUtil_h
#define ESUtil_h

///
//  Includes
//
#include <stdlib.h>

#ifdef __APPLE__
#include <OpenGLES/ES3/gl.h>
#else
#include <GLES3/gl3.h>
#include <EGL/egl.h>
#include <EGL/eglext.h>
#endif
#ifdef __cplusplus

extern "C" {
#endif
    
    
    ///
    //  Macros
    //
#ifdef WIN32
#define ESUTIL_API  __cdecl
#define ESCALLBACK  __cdecl
#else
#define ESUTIL_API
#define ESCALLBACK
#endif
    
    
    /// esCreateWindow flag - RGB color buffer
#define ES_WINDOW_RGB           0
    /// esCreateWindow flag - ALPHA color buffer
#define ES_WINDOW_ALPHA         1
    /// esCreateWindow flag - depth buffer
#define ES_WINDOW_DEPTH         2
    /// esCreateWindow flag - stencil buffer
#define ES_WINDOW_STENCIL       4
    /// esCreateWindow flat - multi-sample buffer
#define ES_WINDOW_MULTISAMPLE   8
    
    
    ///
    // Types
    //
#ifndef FALSE
#define FALSE 0
#endif
#ifndef TRUE
#define TRUE 1
#endif
    
    typedef struct{
        
        GLfloat m[4][4];
    }ESMatrix;
    
    typedef struct ESContext ESContext;
    
    struct ESContext{
        
        /// Put platform specific data here
        void       *platformData;
        
        /// Put your user data here...
        void       *userData;
        
        /// Window width
        GLint       width;
        
        /// Window height
        GLint       height;
        
#ifndef __APPLE__
        /// Display handle
        EGLNativeDisplayType eglNativeDisplay;
        
        /// Window handle
        EGLNativeWindowType  eglNativeWindow;
        
        /// EGL display
        EGLDisplay  eglDisplay;
        
        /// EGL context
        EGLContext  eglContext;
        
        /// EGL surface
        EGLSurface  eglSurface;
#endif
        
        /// 回调函数
        /// 绘图
        void (ESCALLBACK *drawFunc)(ESContext *);
        /// 关闭
        void (ESCALLBACK *shutdownFunc)(ESContext *);
        /// 键盘输入处理
        void (ESCALLBACK *keyFunc)(ESContext *, unsigned char, int, int);
        /// 每个时间步长更新
        void (ESCALLBACK *updateFunc)(ESContext *, float deltaTime);
    };
    
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
    GLboolean ESUTIL_API esCreateWindow(ESContext *esContext, const char *title, GLint width, GLint height, GLuint flags);
    
    /// MARK: 注册用于渲染每帧的绘图回调函数
    /**
     注册用于渲染每帧的绘图回调函数
     @param esContext 应用程序上下文
     @param drawFunc  用于渲染场景的绘图回调函数
     */
    void ESUTIL_API esRegisterDrawFunc(ESContext *esContext, void(ESCALLBACK *drawFunc)(ESContext *));
    
    /// MARK: 注册在关闭时调用的回调函数
    /**
     注册在关闭时调用的回调函数
     @param esContext       应用程序上下文
     @param shutdownFunc    应用程序关闭时调用的函数
     */
    void ESUTIL_API esRegisterShutdownFunc(ESContext *esContext, void(ESCALLBACK *shutdownFunc)(ESContext *));
    
    /// MARK: 注册在用于每个时间步长上更新的更新回调函数
    /**
     注册在用于每个时间步长上更新的更新回调函数
     @param esContext       应用程序上下文
     @param updateFunc      用于渲染场景的更新回调函数
     */
    void ESUTIL_API esRegisterUpdateFunc(ESContext *esContext, void(ESCALLBACK *updateFunc)( ESContext *, float));
    
    /// MARK: 注册键盘输入处理回调函数
    /**
     注册键盘输入处理回调函数
     @param esContext       应用程序上下文
     @param keyFunc         应用程序处理键盘输入的回调函数
     */
    void ESUTIL_API esRegisterKeyFunc(ESContext *esContext, void(ESCALLBACK *keyFunc)(ESContext *, unsigned char, int, int));
 
    /// MARK: 记录平台调试输出信息
    /**
     记录平台调试输出信息
     @param formatStr 错误日志格式串
     */
    void ESUTIL_API esLogMessage(const char *formatStr, ...);
    
    /// MARK: 加载一个着色器, 检查编译错误, 将错误消息打印到输出日志
    /**
     加载一个着色器, 检查编译错误, 将错误消息打印到输出日志
     @param type        着色器类型(GL_VERTEX_SHADER 或 GL_FRAGMENT_SHADER)
     @param shaderSrc   着色器源字符串
     @return            成功时返回新着色器对象, 失败时返回 0
     */
    GLuint ESUTIL_API esLoadShader(GLenum type, const char *shaderSrc);
    
    /// MARK: 加载一个顶点和片段着色器, 创建程序对象, 链接程序, 错误输出到日志
    /**
     加载一个顶点和片段着色器, 创建程序对象, 链接程序, 错误输出到日志
     @param vertShaderSrc 顶点着色器源代码
     @param fragShaderSrc 片段着色器源代码
     @return              用顶点 / 片段着色器对链接的新程序对象, 失败时返回 0
     */
    GLuint ESUTIL_API esLoadProgram(const char *vertShaderSrc, const char *fragShaderSrc);
    
    /// MARK: 为一个球体生成几何形状, 为顶点数据分配内存并将结果保存在数组中, 为 GL_TRIANGLE_STRIP 生成索引列表
    
    /**
     为一个球体生成几何形状, 为顶点数据分配内存并将结果保存在数组中, 为 GL_TRIANGLE_STRIP 生成索引列表
     @param numSlices   球体中的垂直和水平切片数量
     @param radius      弧度
     @param vertices    如果不为 NULL, 则包含 float3 位置数组
     @param normals     如果不为 NULL, 则包含 float3 法线数组
     @param texCoords   如果不为 NULL, 则包含 float2 textCoords 数组
     @param indices     如果不为 NULL, 则包含三角形条带索引数组
     @return            以 GL_TRIANGLE_STRIP 的形式渲染缓冲区时需要的索引数组(如果索引数组不为 NULL, 则为其中保存的索引数量)
     */
    int ESUTIL_API esGenSphere(int numSlices, float radius, GLfloat **vertices, GLfloat **normals, GLfloat **texCoords, GLuint **indices );
    
    /// MARK: 为立方体生成几何形状, 为顶点数据分配内存并将结果保存在数组中, 为 GL_TRIANGLES 生成索引列表
    /**
     为立方体生成几何形状, 为顶点数据分配内存并将结果保存在数组中, 为 GL_TRIANGLES 生成索引列表
     @param scale       立方体的大小, 单位立方体为 1.0
     @param vertices    如果不为 NULL, 则包含 float3 位置数组
     @param normals     如果不为 NULL, 则包含 float3 法线数组
     @param texCoords   如果不为 NULL, 则包含 float2 textCoords 数组
     @param indices     如果不为 NULL, 则包含三角形列表索引数组
     @return            以 GL_TRIANGLES 形式渲染缓冲区所需的索引数量(如果索引数组不为NULL, 则为其中保存的索引数组)
     */
    int ESUTIL_API esGenCube(float scale, GLfloat **vertices, GLfloat **normals,
                              GLfloat **texCoords, GLuint **indices);
    
    /// MARK: 生成由三角形组成的方格网, 为顶点数据分配内存并将结果保存在数组中, 为 GL_TRIANGLES 生成索引列表
    /**
     生成由三角形组成的方格网, 为顶点数据分配内存并将结果保存在数组中, 为 GL_TRIANGLES 生成索引列表
     @param size        立方体大小, 单位立方体为 1.0
     @param vertices    如果不为 NULL, 则包含 float3 位置数组
     @param indices     如果不为 NULL, 则包含三角形列表索引数组
     @return            以 GL_TRIANGLES 形式渲染缓冲区所需的索引数量(如果索引数组不为 NULL, 则为其中保存的索引数量)
     */
    int ESUTIL_API esGenSquareGrid(int size, GLfloat **vertices, GLuint **indices);
    
    /// MARK: 从文件中加载一个 8 位, 24 位或者 32 位 TGA 图像
    /**
     从文件中加载一个 8 位, 24 位或者 32 位 TGA 图像
     @param ioContext   上下文
     @param fileName    磁盘上的文件名
     @param width       以像素表示的加载图像宽度
     @param height      以像素表示的加载图像高度
     @return            指向加载图像的指针, 失败时返回 NULL
     */
    char *ESUTIL_API esLoadTGA(void *ioContext, const char *fileName, int *width, int *height);
    
    /// MARK: 将 result 指定的矩阵乘以比例缩放矩阵, 并在 result 中返回新矩阵
    /**
     将 result 指定的矩阵乘以比例缩放矩阵, 并在 result 中返回新矩阵
     @param result      输入矩阵
     @param sx          x 轴比例缩放因子
     @param sy          y 轴比例缩放因子
     @param sz          z 轴比例缩放因子
     */
    void ESUTIL_API esScale(ESMatrix *result, GLfloat sx, GLfloat sy, GLfloat sz);
    
    /// MARK: 将 result 指定的矩阵乘以平移矩阵, 并在 result 中返回新矩阵
    /**
     将 result 指定的矩阵乘以平移矩阵, 并在 result 中返回新矩阵
     @param result      输入矩阵
     @param tx          x 轴平移因子
     @param ty          y 轴平移因子
     @param tz          z 轴平移因子
     */
    void ESUTIL_API esTranslate(ESMatrix *result, GLfloat tx, GLfloat ty, GLfloat tz);
    
    /// MARK: 将 result 指定矩阵乘以旋转矩阵, 并在 result 中返回新矩阵
    /**
     将 result 指定矩阵乘以旋转矩阵, 并在 result 中返回新矩阵
     @param result      输入矩阵
     @param angle       指定旋转角度, 以度数表示
     @param x           指定向量的 x 坐标
     @param y           指定向量的 y 坐标
     @param z           指定向量的 z 坐标
     */
    void ESUTIL_API esRotate(ESMatrix *result, GLfloat angle, GLfloat x, GLfloat y, GLfloat z);
    
    /// MARK: 将 result 表示的矩阵乘以透视投影矩阵, 并在 result 中返回新矩阵
    /**
     将 result 表示的矩阵乘以透视投影矩阵, 并在 result 中返回新矩阵
     @param result      输入矩阵
     @param left        指定左右裁剪平面坐标
     @param right       指定左右裁剪平面坐标
     @param bottom      指定上下裁剪平面坐标
     @param top         指定上下裁剪平面坐标
     @param nearZ       指定到近裁剪平面的距离, 必须为正
     @param farZ        指定到远裁剪平面的距离, 必须为正
     */
    void ESUTIL_API esFrustum(ESMatrix *result, float left, float right, float bottom, float top, float nearZ, float farZ);
    
    /// MARK: 将 result 指定的矩阵乘以透视投影矩阵, 并在 result 中返回新的矩阵, 提供该函数是为了比直接使用 esFrustum 更简单第创建透视矩阵
    /**
     将 result 指定的矩阵乘以透视投影矩阵, 并在 result 中返回新的矩阵, 提供该函数是为了比直接使用 esFrustum 更简单第创建透视矩阵
     @param result      输入矩阵
     @param fovy        指定以度数表示的视野, 应该在 0 - 180 之间
     @param aspect      渲染窗口的纵横比(宽度 / 高度)
     @param nearZ       指定到近裁剪平面的距离, 必须为正
     @param farZ        指定到远裁剪平面的距离, 必须为正
     */
    void ESUTIL_API esPerspective(ESMatrix *result, float fovy, float aspect, float nearZ, float farZ);
    
    /// MARK: 将 result 指定的矩阵乘以正交投影矩阵, 并在 result 中返回新矩阵
    /**
     将 result 指定的矩阵乘以正交投影矩阵, 并在 result 中返回新矩阵
     @param result      输入矩阵
     @param left        指定左右裁剪平面坐标
     @param right       指定左右裁剪平面坐标
     @param bottom      指定上下裁剪平面坐标
     @param top         指定上下裁剪平面坐标
     @param nearZ       指定到近裁剪平面的距离, 可正可负
     @param farZ        指定到远裁剪平面的距离, 可正可负
     */
    void ESUTIL_API esOrtho(ESMatrix *result, float left, float right, float bottom, float top, float nearZ, float farZ);
    
    /// MARK: 这个函数将 srcA 和 srcB 矩阵相乘, 并在 result 中返回结果 result = srcA x srcB
    /**
     这个函数将 srcA 和 srcB 矩阵相乘, 并在 result 中返回结果 result = srcA x srcB
     @param result      指定返回相乘后矩阵的内存的指针
     @param srcA        进行乘法运算的输入矩阵
     @param srcB        进行乘法运算的输入矩阵
     */
    void ESUTIL_API esMatrixMultiply(ESMatrix *result, ESMatrix *srcA, ESMatrix *srcB);
    
    /// MARK: 返回一个单位矩阵
    /**
     返回一个单位矩阵
     @param result  指向返回单位矩阵的内存的指针
     */
    void ESUTIL_API esMatrixLoadIdentity(ESMatrix *result);
    
    /// MARK: 用眼睛位置, 实现向量和上向量生成一个视图变换矩阵
    /**
     用眼睛位置, 实现向量和上向量生成一个视图变换矩阵

     @param result      输出矩阵
     @param posX        指定眼睛位置的 X 坐标
     @param posY        指定眼睛位置的 Y 坐标
     @param posZ        指定眼睛位置的 Z 坐标
     @param lookAtX     指定视线向量
     @param lookAtY     指定视线向量
     @param lookAtZ     指定视线向量
     @param upX         指定上向量
     @param upY         指定上向量
     @param upZ         指定上向量
     */
    void ESUTIL_API esMatrixLookAt(ESMatrix *result,
                   float posX,    float posY,    float posZ,
                   float lookAtX, float lookAtY, float lookAtZ,
                   float upX,     float upY,     float upZ );
    
#ifdef __cplusplus
}
#endif


#endif /* ESUtil_h */
