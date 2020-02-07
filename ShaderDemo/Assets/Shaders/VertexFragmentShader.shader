

// 顶点/片元着色器示例

Shader "VertexFragmentShader"
{
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            float4 vert(float4 v: POSITION): SV_POSITION {
                // return float4(v.x, v.y, 0.0, 1.0);
                return UnityObjectToClipPos(v);
            }
            float4 frag(): SV_TARGET0 {
                return float4(0.1, 0.1, 0.5, 1.0);
            }
            ENDCG
        }
    }
    FallBack Off
}
