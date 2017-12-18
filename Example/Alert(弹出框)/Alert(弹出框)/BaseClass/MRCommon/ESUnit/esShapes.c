
// ESShapes.c
//
//    Utility functions for generating shapes
//

///
//  Includes
//
#include "ESUtil.h"
#include <stdlib.h>
#include <string.h>
#include <math.h>

/// MARK: 处理形状的文件

///
// Defines
//
#define ES_PI (3.14159265f)


/// MARK: 为一个球体生成几何形状, 为顶点数据分配内存并将结果保存在数组中, 为 GL_TRIANGLE_STRIP 生成索引列表
/**
 @param numSlices       球体中的垂直和水平切片数量
 @param radius              弧度
 @param vertices           如果不为 NULL, 则包含 float3 位置数组
 @param normals           如果不为 NULL, 则包含 float3 法线数组
 @param texCoords       如果不为 NULL, 则包含 float2 textCoords 数组
 @param indices             如果不为 NULL, 则包含三角形条带索引数组
 @return  以 GL_TRIANGLE_STRIP 的形式渲染缓冲区时需要的索引数组(如果索引数组不为 NULL, 则为其中保存的索引数量)
 */
int ESUTIL_API esGenSphere(int numSlices, float radius, GLfloat **vertices, GLfloat **normals, GLfloat **texCoords, GLuint **indices){
    
    int   i;
    int   j;
    int   numParallels = numSlices / 2;
    int   numVertices = (numParallels + 1) * (numSlices + 1);
    int   numIndices = numParallels * numSlices * 6;
    float angleStep = (2.0f * ES_PI) / ((float)numSlices);

    // 分配内存空间
    if(vertices != NULL){
        *vertices = malloc(sizeof(GLfloat) * 3 * numVertices);
    }

    if(normals != NULL){
        *normals = malloc(sizeof(GLfloat ) * 3 * numVertices);
    }

    if(texCoords != NULL){
        *texCoords = malloc(sizeof(GLfloat ) * 2 * numVertices);
    }

    if(indices != NULL){
        *indices = malloc(sizeof (GLuint) * numIndices);
    }

    for(i = 0; i < numParallels + 1; i++){
       
        for(j = 0; j < numSlices + 1; j++){
          
            int vertex = (i * (numSlices + 1) + j) * 3;

            if(vertices){
                (*vertices)[vertex + 0] = radius * sinf(angleStep * (float)i) * sinf(angleStep * (float)j);
                (*vertices)[vertex + 1] = radius * cosf(angleStep * (float)i);
                (*vertices)[vertex + 2] = radius * sinf(angleStep * ( float )i) * cosf(angleStep * (float)j);
            }

            if(normals){
                (*normals)[vertex + 0] = (*vertices)[vertex + 0] / radius;
                (*normals)[vertex + 1] = (*vertices)[vertex + 1] / radius;
                (*normals)[vertex + 2] = (*vertices)[vertex + 2] / radius;
            }

            if(texCoords){
                int texIndex = (i * (numSlices + 1) + j) * 2;
                (*texCoords)[texIndex + 0] = (float)j / (float )numSlices;
                (*texCoords)[texIndex + 1] = (1.0f - (float)i) / (float)(numParallels - 1);
            }
        }
    }

    // Generate the indices
    if(indices != NULL){
       
        GLuint *indexBuf = (*indices);

        for(i = 0; i < numParallels; i++){
          
            for(j = 0; j < numSlices; j++){
             
                *indexBuf++ = i * (numSlices + 1) + j;
                *indexBuf++ = (i + 1) * (numSlices + 1) + j;
                *indexBuf++ = (i + 1) * (numSlices + 1) + (j + 1);

                *indexBuf++ = i * (numSlices + 1) + j;
                *indexBuf++ = (i + 1) * (numSlices + 1) + (j + 1);
                *indexBuf++ = i * (numSlices + 1) + (j + 1);
            }
        }
    }
    return numIndices;
}

/// MARK: 为立方体生成几何形状, 为顶点数据分配内存并将结果保存在数组中, 为 GL_TRIANGLES 生成索引列表
/**
 @param scale               立方体的大小, 单位立方体为 1.0
 @param vertices           如果不为 NULL, 则包含 float3 位置数组
 @param normals           如果不为 NULL, 则包含 float3 法线数组
 @param texCoords       如果不为 NULL, 则包含 float2 textCoords 数组
 @param indices            如果不为 NULL, 则包含三角形列表索引数组
 @return   以 GL_TRIANGLES 形式渲染缓冲区所需的索引数量(如果索引数组不为NULL, 则为其中保存的索引数组)
 */
int ESUTIL_API esGenCube(float scale, GLfloat **vertices, GLfloat **normals, GLfloat **texCoords, GLuint **indices){
    
    int i;
    int numVertices = 24;
    int numIndices  = 36;

    GLfloat cubeVerts[] =
    {
      -0.5f, -0.5f, -0.5f,
      -0.5f, -0.5f,  0.5f,
       0.5f, -0.5f,  0.5f,
       0.5f, -0.5f, -0.5f,
      -0.5f,  0.5f, -0.5f,
      -0.5f,  0.5f,  0.5f,
       0.5f,  0.5f,  0.5f,
       0.5f,  0.5f, -0.5f,
      -0.5f, -0.5f, -0.5f,
      -0.5f,  0.5f, -0.5f,
       0.5f,  0.5f, -0.5f,
       0.5f, -0.5f, -0.5f,
      -0.5f, -0.5f,  0.5f,
      -0.5f,  0.5f,  0.5f,
       0.5f,  0.5f,  0.5f,
       0.5f, -0.5f,  0.5f,
      -0.5f, -0.5f, -0.5f,
      -0.5f, -0.5f,  0.5f,
      -0.5f,  0.5f,  0.5f,
      -0.5f,  0.5f, -0.5f,
       0.5f, -0.5f, -0.5f,
       0.5f, -0.5f,  0.5f,
       0.5f,  0.5f,  0.5f,
       0.5f,  0.5f, -0.5f,
    };

    GLfloat cubeNormals[] =
    {
      0.0f, -1.0f,  0.0f,
      0.0f, -1.0f,  0.0f,
      0.0f, -1.0f,  0.0f,
      0.0f, -1.0f,  0.0f,
      0.0f,  1.0f,  0.0f,
      0.0f,  1.0f,  0.0f,
      0.0f,  1.0f,  0.0f,
      0.0f,  1.0f,  0.0f,
      0.0f,  0.0f, -1.0f,
      0.0f,  0.0f, -1.0f,
      0.0f,  0.0f, -1.0f,
      0.0f,  0.0f, -1.0f,
      0.0f,  0.0f,  1.0f,
      0.0f,  0.0f,  1.0f,
      0.0f,  0.0f,  1.0f,
      0.0f,  0.0f,  1.0f,
     -1.0f,  0.0f,  0.0f,
     -1.0f,  0.0f,  0.0f,
     -1.0f,  0.0f,  0.0f,
     -1.0f,  0.0f,  0.0f,
      1.0f,  0.0f,  0.0f,
      1.0f,  0.0f,  0.0f,
      1.0f,  0.0f,  0.0f,
      1.0f,  0.0f,  0.0f,
    };

    GLfloat cubeTex[] =
    {
      0.0f, 0.0f,
      0.0f, 1.0f,
      1.0f, 1.0f,
      1.0f, 0.0f,
      1.0f, 0.0f,
      1.0f, 1.0f,
      0.0f, 1.0f,
      0.0f, 0.0f,
      0.0f, 0.0f,
      0.0f, 1.0f,
      1.0f, 1.0f,
      1.0f, 0.0f,
      0.0f, 0.0f,
      0.0f, 1.0f,
      1.0f, 1.0f,
      1.0f, 0.0f,
      0.0f, 0.0f,
      0.0f, 1.0f,
      1.0f, 1.0f,
      1.0f, 0.0f,
      0.0f, 0.0f,
      0.0f, 1.0f,
      1.0f, 1.0f,
      1.0f, 0.0f,
    };

    // 分配内存
    if(vertices != NULL){
       
        *vertices = malloc(sizeof(GLfloat) * 3 * numVertices);
        memcpy(*vertices, cubeVerts, sizeof(cubeVerts));

        for(i = 0; i < numVertices * 3; i++){
            (*vertices)[i] *= scale;
        }
    }

    if(normals != NULL){
        *normals = malloc(sizeof (GLfloat) * 3 * numVertices);
        memcpy(*normals, cubeNormals, sizeof(cubeNormals));
    }

    if(texCoords != NULL){
        *texCoords = malloc(sizeof(GLfloat) * 2 * numVertices);
        memcpy(*texCoords, cubeTex, sizeof(cubeTex)) ;
    }


    // Generate the indices
    if(indices != NULL){
       
        GLuint cubeIndices[] =
        {
            0,  2,  1,
            0,  3,  2,
            4,  5,  6,
            4,  6,  7,
            8,  9,  10,
            8,  10, 11,
            12, 15, 14,
            12, 14, 13,
            16, 17, 18,
            16, 18, 19,
            20, 23, 22,
            20, 22, 21
        };
        
        *indices = malloc(sizeof(GLuint) * numIndices);
        memcpy(*indices, cubeIndices, sizeof(cubeIndices));
    }
    return numIndices;
}

/// MARK: 生成由三角形组成的方格网, 为顶点数据分配内存并将结果保存在数组中, 为 GL_TRIANGLES 生成索引列表
/**
 @param size          立方体大小, 单位立方体为 1.0
 @param vertices    如果不为 NULL, 则包含 float3 位置数组
 @param indices     如果不为 NULL, 则包含三角形列表索引数组
 @return     以 GL_TRIANGLES 形式渲染缓冲区所需的索引数量(如果索引数组不为 NULL, 则为其中保存的索引数量)
 */
int ESUTIL_API esGenSquareGrid(int size, GLfloat **vertices, GLuint **indices){
    
    int i, j;
    int numIndices = (size - 1) * (size - 1) * 2 * 3;

    // 分配内存
    if(vertices != NULL){
       
        int numVertices = size * size;
        float stepSize  = (float) size - 1;
        *vertices = malloc(sizeof(GLfloat) * 3 * numVertices);

        for(i = 0; i < size; ++i){       // row
          
            for( j = 0; j < size; ++j ){  // column
             
                (*vertices)[3 * (j + i * size)]      = i / stepSize;
                (*vertices)[3 * (j + i * size) + 1 ] = j / stepSize;
                (*vertices)[3 * (j + i * size) + 2 ] = 0.0f;
            }
        }
    }

   // Generate the indices
    if(indices != NULL){
       
        *indices = malloc(sizeof(GLuint) * numIndices);

        for(i = 0; i < size - 1; ++i){
            
            for(j = 0; j < size - 1; ++j){
             
                // two triangles per quad
                (*indices)[6 * (j + i * (size - 1))]     = j + i * size;
                (*indices)[6 * (j + i * (size - 1)) + 1] = j + i * size + 1;
                (*indices)[6 * (j + i * (size - 1)) + 2] = j + (i + 1) * size + 1;
                (*indices)[6 * (j + i * (size - 1)) + 3] = j + i * size;
                (*indices)[6 * (j + i * (size - 1)) + 4] = j + (i + 1) * size + 1;
                (*indices)[6 * (j + i * (size - 1)) + 5] = j + (i + 1) * size;
            }
        }
    }
    return numIndices;
}
