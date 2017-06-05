
// ESShader.c
//
//    Utility functions for loading shaders and creating program objects.
//

///
//  Includes
//
#include "ESUtil.h"
#include <stdlib.h>


/// MARK: 加载一个着色器, 检查编译错误, 将错误消息打印到输出日志
/**
 加载一个着色器, 检查编译错误, 将错误消息打印到输出日志
 @param type        着色器类型(GL_VERTEX_SHADER 或 GL_FRAGMENT_SHADER)
 @param shaderSrc   着色器源字符串
 @return            成功时返回新着色器对象, 失败时返回 0
 */
GLuint ESUTIL_API esLoadShader(GLenum type, const char *shaderSrc){
    
    GLuint shader;
    GLint compiled;

    // Create the shader object
    shader = glCreateShader(type);

    if(shader == 0){
        return 0;
    }

    // Load the shader source
    glShaderSource(shader, 1, &shaderSrc, NULL);

    // Compile the shader
    glCompileShader(shader);

    // Check the compile status
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);

    if(!compiled){
       
        GLint infoLen = 0;

        glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLen);

        if(infoLen > 1){
          
            char *infoLog = malloc(sizeof(char) * infoLen);

            glGetShaderInfoLog(shader, infoLen, NULL, infoLog);
            esLogMessage("Error compiling shader:\n%s\n", infoLog);

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
    
    GLuint vertexShader;
    GLuint fragmentShader;
    GLuint programObject;
    GLint  linked;

    // Load the vertex/fragment shaders
    vertexShader = esLoadShader(GL_VERTEX_SHADER, vertShaderSrc);

    if(vertexShader == 0){
        return 0;
    }

    fragmentShader = esLoadShader(GL_FRAGMENT_SHADER, fragShaderSrc);

    if(fragmentShader == 0){
       
        glDeleteShader(vertexShader);
        return 0;
    }

    // Create the program object
    programObject = glCreateProgram();

    if(programObject == 0){
        return 0;
    }

    glAttachShader(programObject, vertexShader);
    glAttachShader(programObject, fragmentShader);

    // Link the program
    glLinkProgram(programObject);

    // Check the link status
    glGetProgramiv(programObject, GL_LINK_STATUS, &linked);

    if(!linked){
       
        GLint infoLen = 0;

        glGetProgramiv(programObject, GL_INFO_LOG_LENGTH, &infoLen);

        if(infoLen > 1){
          
            char *infoLog = malloc(sizeof(char) * infoLen);

            glGetProgramInfoLog(programObject, infoLen, NULL, infoLog);
            esLogMessage("Error linking program:\n%s\n", infoLog);

            free(infoLog);
        }

        glDeleteProgram(programObject);
        return 0;
    }

    // Free up no longer needed shader resources
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);

    return programObject;
}



