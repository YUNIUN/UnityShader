Shader " PhongLightShader" {
    Properties {
        _Emissive ("自发光颜色", Color) = (0.0, 0.0, 0.0, 1.0)
        _Kd ("漫反射光强度", Color) = (1.0, 1.0, 1.0, 1.0)
        _Ks ("高光反射颜色", Color) = (1.0, 1.0, 1.0, 1.0)
        _Shininess ("光滑程度", Range(1.0, 256)) = 20.0
    }
    SubShader {
        Pass {
            Tags {"LightMode" = "ForwardBase"}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "Lighting.cginc"

            fixed4 _Emissive;
            fixed4 _Kd;
            fixed4 _Ks;
            float _Shininess;

            struct a2v {
                float4 position : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f {
                float4 position : SV_POSITION;
                float3 worldnormal : TEXCOORD0;
                float3 worldPosition : TEXCOORD1;
            };

            v2f vert (a2v v) {
                v2f o;
                o.position = UnityObjectToClipPos(v.position);
                //o.worldnormal = normalize(mul(unity_ObjectToWorld, v.normal).xyz);
                o.worldnormal = UnityObjectToWorldNormal(v.normal);
                o.worldPosition = mul(unity_ObjectToWorld, v.position).xyz;
                return o;
            }

            fixed4 frag (v2f i) : SV_TARGET0 {
                fixed3 worldnormal = normalize(i.worldnormal);
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz; //环境光

                //fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);//在只有一个平行光源时正确
                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPosition.xyz));
                fixed  halfLambert = saturate(dot(worldnormal, worldLightDir)) * 0.5 + 0.5;
                fixed3 diffuse = _LightColor0.rgb * _Kd.rgb * halfLambert; //漫反射光

                //fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPosition.xyz);
                fixed3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPosition.xyz));
                fixed3 halfDir = normalize(worldLightDir + viewDir);
                fixed facing = halfLambert * 2 - 1.0;
                fixed3 secular = facing * _LightColor0.rgb * _Ks.rgb * pow(max(dot(worldnormal ,halfDir), 0), _Shininess);

                return fixed4(_Emissive + ambient + diffuse + secular, 1.0);
            }
            ENDCG
        }
    }
    FallBack Off
}
