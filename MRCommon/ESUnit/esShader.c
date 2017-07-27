
// ESShader.c
//
//    Utility functions for loading shaders and creating program objects.
//

///
//  Includes
//
#include "ESUtil.h"
#include <stdlib.h>

/// MARK: 处理着色器的文件


/// MARK: 加载一个着色器, 检查编译错误, 将错误消息打印到输出日志
/**
 加载一个着色器, 检查编译错误, 将错误消息打印到输出日志
 @param type        着色器类型(GL_VERTEX_SHADER 或 GL_FRAGMENT_SHADER)
 @param shaderSrc   着色器源字符串
 @return            成功时返回新着色器对象, 失败时返回 0
 */
GLuint ESUTIL_API esLoadShader(GLenum type, const char *shaderSrc){
    
    GLuint shader;          /// 着色器对象
    GLint compiled;         /// 判断编译成功字段

    // 创建着色器
    shader = glCreateShader(type);
    if(shader == 0){
        return 0;
    }

    // 给着色器指定源码
    glShaderSource(shader, 1, &shaderSrc, NULL);
    // 编译着色器
    glCompileShader(shader);
    // 判断编译状态
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);

    if(!compiled){          /// 编译失败
       
        GLint infoLen = 0;
        glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLen);

        if(infoLen > 1){        /// 打印错误信息
          
            char *infoLog = malloc(sizeof(char) * infoLen);
            glGetShaderInfoLog(shader, infoLen, NULL, infoLog);
            esLogMessage("编译着色器失败:\n%s\n", infoLog);
            free(infoLog);
        }
        glDeleteShader(shader);
        return 0;
    }
    return shader;
}

/// MARK: 加载一个顶点和片段着色器, 创建程序对象, 链接程序, 错误输出到日志
/**
 加载一个顶点和片段着色器, 创建程序对象, 链接程序, 错误输出到日志
 @param vertShaderSrc 顶点着色器源代码
 @param fragShaderSrc 片段着色器源代码
 @return              用顶点 / 片段着色器对链接的新程序对象, 失败时返回 0
 */
GLuint ESUTIL_API esLoadProgram(const char *vertShaderSrc, const char *fragShaderSrc){
    
    GLuint vertexShader;                /// 顶点着色器
    GLuint fragmentShader;            /// 片段着色器
    GLuint programObject;              /// 程序对象
    GLint  linked;                             /// 判断是否链接成功字段

    // 加载一个着色器, 检查编译错误, 将错误消息打印到输出日志
    /// 加载顶点着色器
    vertexShader = esLoadShader(GL_VERTEX_SHADER, vertShaderSrc);

    if(vertexShader == 0){      /// 加载失败
        return 0;
    }
    
    /// 加载片段着色器
    fragmentShader = esLoadShader(GL_FRAGMENT_SHADER, fragShaderSrc);
    if(fragmentShader == 0){        /// 如果片段着色器加载失败, 删除顶点着色器
        glDeleteShader(vertexShader);
        return 0;
    }

    // 创建程序对象
    programObject = glCreateProgram();

    if(programObject == 0){
        return 0;
    }

    /// 给程序附加着色器
    glAttachShader(programObject, vertexShader);
    glAttachShader(programObject, fragmentShader);

    // 链接程序
    glLinkProgram(programObject);

    // 检查链接状态
    glGetProgramiv(programObject, GL_LINK_STATUS, &linked);

    if(!linked){            /// 链接失败
       
        GLint infoLen = 0;
        glGetProgramiv(programObject, GL_INFO_LOG_LENGTH, &infoLen);

        if(infoLen > 1){        /// 打印错误信息
            char *infoLog = malloc(sizeof(char) * infoLen);
            glGetProgramInfoLog(programObject, infoLen, NULL, infoLog);
            esLogMessage("链接程序失败:\n%s\n", infoLog);
            free(infoLog);
        }
        glDeleteProgram(programObject);
        return 0;
    }

    // 释放资源
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);

    return programObject;
}



