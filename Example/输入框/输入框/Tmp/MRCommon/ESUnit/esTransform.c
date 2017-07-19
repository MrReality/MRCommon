
// ESUtil.c
//
//    A utility library for OpenGL ES.  This library provides a
//    basic common framework for the example applications in the
//    OpenGL ES 3.0 Programming Guide.
//

///
//  Includes
//
#include "ESUtil.h"
#include <math.h>
#include <string.h>

#define PI 3.1415926535897932384626433832795f

/// MARK: 将 result 指定的矩阵乘以比例缩放矩阵, 并在 result 中返回新矩阵
/**
 将 result 指定的矩阵乘以比例缩放矩阵, 并在 result 中返回新矩阵
 @param result      输入矩阵
 @param sx          x 轴比例缩放因子
 @param sy          y 轴比例缩放因子
 @param sz          z 轴比例缩放因子
 */
void ESUTIL_API esScale(ESMatrix *result, GLfloat sx, GLfloat sy, GLfloat sz){
    
    result -> m[0][0] *= sx;
    result -> m[0][1] *= sx;
    result -> m[0][2] *= sx;
    result -> m[0][3] *= sx;

    result -> m[1][0] *= sy;
    result -> m[1][1] *= sy;
    result -> m[1][2] *= sy;
    result -> m[1][3] *= sy;

    result -> m[2][0] *= sz;
    result -> m[2][1] *= sz;
    result -> m[2][2] *= sz;
    result -> m[2][3] *= sz;
}

/// MARK: 将 result 指定的矩阵乘以平移矩阵, 并在 result 中返回新矩阵
/**
 将 result 指定的矩阵乘以平移矩阵, 并在 result 中返回新矩阵
 @param result      输入矩阵
 @param tx          x 轴平移因子
 @param ty          y 轴平移因子
 @param tz          z 轴平移因子
 */
void ESUTIL_API esTranslate(ESMatrix *result, GLfloat tx, GLfloat ty, GLfloat tz){
    
    result -> m[3][0] += (result -> m[0][0] * tx + result -> m[1][0] * ty + result -> m[2][0] * tz);
    result -> m[3][1] += (result -> m[0][1] * tx + result -> m[1][1] * ty + result -> m[2][1] * tz);
    result -> m[3][2] += (result -> m[0][2] * tx + result -> m[1][2] * ty + result -> m[2][2] * tz);
    result -> m[3][3] += (result -> m[0][3] * tx + result -> m[1][3] * ty + result -> m[2][3] * tz);
}

/// MARK: 将 result 指定矩阵乘以旋转矩阵, 并在 result 中返回新矩阵
/**
 将 result 指定矩阵乘以旋转矩阵, 并在 result 中返回新矩阵
 @param result      输入矩阵
 @param angle       指定旋转角度, 以度数表示
 @param x           指定向量的 x 坐标
 @param y           指定向量的 y 坐标
 @param z           指定向量的 z 坐标
 */
void ESUTIL_API esRotate(ESMatrix *result, GLfloat angle, GLfloat x, GLfloat y, GLfloat z){
    
    GLfloat sinAngle, cosAngle;
    GLfloat mag = sqrtf(x * x + y * y + z * z);

    sinAngle = sinf(angle * PI / 180.0f);
    cosAngle = cosf(angle * PI / 180.0f);

    if(mag > 0.0f){
       
        GLfloat   xx, yy, zz, xy, yz, zx, xs, ys, zs;
        GLfloat   oneMinusCos;
        ESMatrix  rotMat;

        x /= mag;
        y /= mag;
        z /= mag;

        xx = x * x;
        yy = y * y;
        zz = z * z;
        xy = x * y;
        yz = y * z;
        zx = z * x;
        xs = x * sinAngle;
        ys = y * sinAngle;
        zs = z * sinAngle;
        oneMinusCos = 1.0f - cosAngle;

        rotMat.m[0][0] = (oneMinusCos * xx) + cosAngle;
        rotMat.m[0][1] = (oneMinusCos * xy) - zs;
        rotMat.m[0][2] = (oneMinusCos * zx) + ys;
        rotMat.m[0][3] = 0.0F;

        rotMat.m[1][0] = (oneMinusCos * xy) + zs;
        rotMat.m[1][1] = (oneMinusCos * yy) + cosAngle;
        rotMat.m[1][2] = (oneMinusCos * yz) - xs;
        rotMat.m[1][3] = 0.0F;

        rotMat.m[2][0] = (oneMinusCos * zx) - ys;
        rotMat.m[2][1] = (oneMinusCos * yz) + xs;
        rotMat.m[2][2] = (oneMinusCos * zz) + cosAngle;
        rotMat.m[2][3] = 0.0F;

        rotMat.m[3][0] = 0.0F;
        rotMat.m[3][1] = 0.0F;
        rotMat.m[3][2] = 0.0F;
        rotMat.m[3][3] = 1.0F;

        esMatrixMultiply(result, &rotMat, result);
    }
}

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
void ESUTIL_API esFrustum(ESMatrix *result, float left, float right, float bottom, float top, float nearZ, float farZ){
    
    float       deltaX = right - left;
    float       deltaY = top - bottom;
    float       deltaZ = farZ - nearZ;
    ESMatrix    frust;

    if((nearZ <= 0.0f) || (farZ <= 0.0f) || (deltaX <= 0.0f) || (deltaY <= 0.0f) || (deltaZ <= 0.0f)){
        return;
    }

    frust.m[0][0] = 2.0f * nearZ / deltaX;
    frust.m[0][1] = frust.m[0][2] = frust.m[0][3] = 0.0f;

    frust.m[1][1] = 2.0f * nearZ / deltaY;
    frust.m[1][0] = frust.m[1][2] = frust.m[1][3] = 0.0f;
    
    frust.m[2][0] = (right + left) / deltaX;
    frust.m[2][1] = (top + bottom) / deltaY;
    frust.m[2][2] = -(nearZ + farZ) / deltaZ;
    frust.m[2][3] = -1.0f;
    
    frust.m[3][2] = -2.0f * nearZ * farZ / deltaZ;
    frust.m[3][0] = frust.m[3][1] = frust.m[3][3] = 0.0f;

    esMatrixMultiply(result, &frust, result);
}

/// MARK: 将 result 指定的矩阵乘以透视投影矩阵, 并在 result 中返回新的矩阵, 提供该函数是为了比直接使用 esFrustum 更简单第创建透视矩阵
/**
 将 result 指定的矩阵乘以透视投影矩阵, 并在 result 中返回新的矩阵, 提供该函数是为了比直接使用 esFrustum 更简单第创建透视矩阵
 @param result      输入矩阵
 @param fovy        指定以度数表示的视野, 应该在 0 - 180 之间
 @param aspect      渲染窗口的纵横比(宽度 / 高度)
 @param nearZ       指定到近裁剪平面的距离, 必须为正
 @param farZ        指定到远裁剪平面的距离, 必须为正
 */
void ESUTIL_API esPerspective(ESMatrix *result, float fovy, float aspect, float nearZ, float farZ){
    
    GLfloat frustumW, frustumH;

    frustumH = tanf(fovy / 360.0f * PI) * nearZ;
    frustumW = frustumH * aspect;

    esFrustum(result, -frustumW, frustumW, -frustumH, frustumH, nearZ, farZ);
}

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
void ESUTIL_API esOrtho(ESMatrix *result, float left, float right, float bottom, float top, float nearZ, float farZ){
    
    float       deltaX = right - left;
    float       deltaY = top - bottom;
    float       deltaZ = farZ - nearZ;
    ESMatrix    ortho;

    if((deltaX == 0.0f) || (deltaY == 0.0f) || (deltaZ == 0.0f)){
        return;
    }

    esMatrixLoadIdentity(&ortho);
    ortho.m[0][0] = 2.0f / deltaX;
    ortho.m[3][0] = -(right + left) / deltaX;
    ortho.m[1][1] = 2.0f / deltaY;
    ortho.m[3][1] = - (top + bottom) / deltaY;
    ortho.m[2][2] = -2.0f / deltaZ;
    ortho.m[3][2] = -(nearZ + farZ) / deltaZ;

    esMatrixMultiply(result, &ortho, result);
}

/// MARK: 这个函数将 srcA 和 srcB 矩阵相乘, 并在 result 中返回结果 result = srcA x srcB
/**
 这个函数将 srcA 和 srcB 矩阵相乘, 并在 result 中返回结果 result = srcA x srcB
 @param result      指定返回相乘后矩阵的内存的指针
 @param srcA        进行乘法运算的输入矩阵
 @param srcB        进行乘法运算的输入矩阵
 */
void ESUTIL_API esMatrixMultiply(ESMatrix *result, ESMatrix *srcA, ESMatrix *srcB){
    
    ESMatrix    tmp;
    int         i;

    for(i = 0; i < 4; i++){
        
        tmp.m[i][0] = srcA->m[i][0] * srcB->m[0][0] + srcA->m[i][1] * srcB->m[1][0] + srcA->m[i][2] * srcB->m[2][0] + srcA->m[i][3] * srcB->m[3][0];

        tmp.m[i][1] = srcA->m[i][0] * srcB->m[0][1] + srcA->m[i][1] * srcB->m[1][1] + srcA->m[i][2] * srcB->m[2][1] + srcA->m[i][3] * srcB->m[3][1];

        tmp.m[i][2] = srcA->m[i][0] * srcB->m[0][2] + srcA->m[i][1] * srcB->m[1][2] + srcA->m[i][2] * srcB->m[2][2] + srcA->m[i][3] * srcB->m[3][2];

        tmp.m[i][3] = srcA->m[i][0] * srcB->m[0][3] + srcA->m[i][1] * srcB->m[1][3] + srcA->m[i][2] * srcB->m[2][3] + srcA->m[i][3] * srcB->m[3][3];
    }

    memcpy(result, &tmp, sizeof(ESMatrix));
}

/// MARK: 返回一个单位矩阵
/**
 返回一个单位矩阵
 @param result  指向返回单位矩阵的内存的指针
 */
void ESUTIL_API esMatrixLoadIdentity(ESMatrix *result){
    
    memset(result, 0x0, sizeof(ESMatrix));
    result -> m[0][0] = 1.0f;
    result -> m[1][1] = 1.0f;
    result -> m[2][2] = 1.0f;
    result -> m[3][3] = 1.0f;
}

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
               float upX,     float upY,     float upZ){
    
    float axisX[3], axisY[3], axisZ[3];
    float length;

    // axisZ = lookAt - pos
    axisZ[0] = lookAtX - posX;
    axisZ[1] = lookAtY - posY;
    axisZ[2] = lookAtZ - posZ;

    // normalize axisZ
    length = sqrtf(axisZ[0] * axisZ[0] + axisZ[1] * axisZ[1] + axisZ[2] * axisZ[2]);

    if(length != 0.0f){
        
        axisZ[0] /= length;
        axisZ[1] /= length;
        axisZ[2] /= length;
    }

    // axisX = up X axisZ
    axisX[0] = upY * axisZ[2] - upZ * axisZ[1];
    axisX[1] = upZ * axisZ[0] - upX * axisZ[2];
    axisX[2] = upX * axisZ[1] - upY * axisZ[0];

    // normalize axisX
    length = sqrtf(axisX[0] * axisX[0] + axisX[1] * axisX[1] + axisX[2] * axisX[2]);

    if(length != 0.0f){
        
        axisX[0] /= length;
        axisX[1] /= length;
        axisX[2] /= length;
    }

    // axisY = axisZ x axisX
    axisY[0] = axisZ[1] * axisX[2] - axisZ[2] * axisX[1];
    axisY[1] = axisZ[2] * axisX[0] - axisZ[0] * axisX[2];
    axisY[2] = axisZ[0] * axisX[1] - axisZ[1] * axisX[0];

    // normalize axisY
    length = sqrtf(axisY[0] * axisY[0] + axisY[1] * axisY[1] + axisY[2] * axisY[2]);

    if(length != 0.0f){
        
        axisY[0] /= length;
        axisY[1] /= length;
        axisY[2] /= length;
    }

    memset(result, 0x0, sizeof(ESMatrix ));

    result -> m[0][0] = -axisX[0];
    result -> m[0][1] =  axisY[0];
    result -> m[0][2] = -axisZ[0];

    result -> m[1][0] = -axisX[1];
    result -> m[1][1] =  axisY[1];
    result -> m[1][2] = -axisZ[1];

    result -> m[2][0] = -axisX[2];
    result -> m[2][1] =  axisY[2];
    result -> m[2][2] = -axisZ[2];

    // translate (-posX, -posY, -posZ)
    result -> m[3][0] =  axisX[0] * posX + axisX[1] * posY + axisX[2] * posZ;
    result -> m[3][1] = -axisY[0] * posX - axisY[1] * posY - axisY[2] * posZ;
    result -> m[3][2] =  axisZ[0] * posX + axisZ[1] * posY + axisZ[2] * posZ;
    result -> m[3][3] = 1.0f;
}
