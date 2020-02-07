

// 表面着色器示例

Shader "SurfaceShader"
{
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        CGPROGRAM
        #pragma surface surf Lambert
        struct Input {
            float4 i_color : COLOR;
        };
        void surf(Input _in, inout SurfaceOutput o)
        {
            o.Albedo = float4(0.5, 0.1, 0.1, 1.0);
        }
        ENDCG
    }
    Fallback Off
}
