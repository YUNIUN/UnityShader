Shader "PropertiesDemoShader" {
    Properties {
        _Color ("传入的颜色", Color) = (1.0, 1.0, 1.0, 1.0)
    }
    SubShader {
        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            struct appdata { // 声明顶点着色器从寄存器获取的变量
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };
            struct v2f { // 声明顶点着色器输出到寄存器的变量
                float3 clr : COLOR0;
                float4 vertex : SV_POSITION;
            };
            fixed4 _Color; // 声明存储输入属性的变量
            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.clr = v.normal * 0.5 + fixed3(0.5, 0.5, 0.5);
                return o;
            }
            fixed4 frag (v2f i) : SV_TARGET0 {
                fixed4 clr = fixed4(i.clr, 1.0);
                clr *= _Color;
                return clr;
            }
            ENDCG
        }
    }
}
