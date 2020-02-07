

// 固定函数着色器示例

Shader "FixedShader" {
    Properties {
        _color ("物体颜色", Color) = (0.7, 0.1, 0.9, 1.0)
    }
    SubShader {
        Pass {
            Material{
                Diffuse[_color]
            }
            Lighting On
        }
    }
    Fallback Off
}
