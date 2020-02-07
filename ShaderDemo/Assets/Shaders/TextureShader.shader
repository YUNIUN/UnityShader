Shader " TextureShader" {
    Properties {
        _MainTex ("纹理贴图", 2D) = "white" {}
        _NormalMap ("法线贴图", 2D) = "bump" {}
        _Emissive ("自发光颜色", Color) = (0.0, 0.0, 0.0, 1.0)
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

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _NormalMap;
            float4 _NormalMap_ST;
            fixed4 _Emissive;
            fixed4 _Ks;
            float _Shininess;

            // 在纹理坐标下计算
            //struct a2v {
            //    float4 position : POSITION;
            //    float3 normal : NORMAL;
            //    float4 tangent : TANGENT;
            //    float2 texcoord : TEXCOORD0;
            //};

            //struct v2f {
            //    float4 position : SV_POSITION;
            //    fixed3 lightDir : TEXCOORD0;
            //    float3 viewDir : TEXCOORD1;
            //    float4 uv : TEXCOORD2;
            //};

            //v2f vert (a2v v) {
            //    v2f o;
            //    o.position = UnityObjectToClipPos(v.position);
            //    //float3 binormal = cross(normalize(v.normal), normalize(v.tangent.xyz)) * v.tangent.w;
            //    //float3x3 rotation = float3x3(v.tangent.xyz, binormal, v.normal);
            //    TANGENT_SPACE_ROTATION;
            //    // 获取纹理空间下顶点到光源方向
            //    o.lightDir = mul(rotation, ObjSpaceLightDir(v.position)).xyz;
            //    // 获取纹理空间下顶点到相机方向
            //    o.viewDir = mul(rotation, ObjSpaceViewDir(v.position)).xyz;
            //    o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
            //    o.uv.zw = TRANSFORM_TEX(v.texcoord, _NormalMap);
            //    return o;
            //}
            //fixed4 frag (v2f i) : SV_TARGET0 {
            //    fixed3 lightDir = normalize(i.lightDir);
            //    fixed3 viewDir = normalize(i.viewDir);
            //    fixed4 packedNormal = tex2D(_NormalMap, i.uv.zw);
            //    fixed3 tangentNormal = UnpackNormal(packedNormal);
            //    fixed3 albedo = tex2D(_MainTex, i.uv.xy).rgb;
            //    fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
            //    fixed3 diffuse = _LightColor0.rgb * albedo * saturate(dot(tangentNormal, lightDir));
            //    fixed3 halfDir = normalize(lightDir + viewDir);
            //    fixed facing = ceil(saturate(dot(tangentNormal, viewDir)));
            //    fixed3 secular = facing * _LightColor0.rgb * _Ks.rgb * pow(max(dot(tangentNormal ,halfDir), 0), _Shininess);
            //    return fixed4(_Emissive + ambient + diffuse + secular, 1.0);
            //}

            //在世界坐标下计算
            struct a2v {
                float4 position : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f {
                float4 position : SV_POSITION;
                float4 uv : TEXCOORD0;
                float3 worldPosition : TEXCOORD1;
                float3x3 worldRotation : TEXCOORD2;
            };

            v2f vert (a2v v) {
                v2f o;
                o.position = UnityObjectToClipPos(v.position);
                o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.uv.zw = TRANSFORM_TEX(v.texcoord, _NormalMap);
                o.worldPosition = mul(unity_ObjectToWorld, v.position).xyz;

                float3 worldNormal = normalize(UnityObjectToWorldNormal(v.normal));
                float3 worldTangent = normalize(UnityObjectToWorldDir(v.tangent.xyz));
                float3 worldBiNormal = cross(worldNormal, worldTangent) * v.tangent.w;
                o.worldRotation = float3x3(worldTangent.x, worldBiNormal.x, worldNormal.x,
                                            worldTangent.y, worldBiNormal.y, worldNormal.y,
                                            worldTangent.z, worldBiNormal.z, worldNormal.z);

                return o;
            }
            fixed4 frag (v2f i) : SV_TARGET0 {
                fixed4 packedNormal = tex2D(_NormalMap, i.uv.zw);
                fixed3 tangentNormal = UnpackNormal(packedNormal);
                tangentNormal = mul(i.worldRotation, tangentNormal);

                fixed3 albedo = tex2D(_MainTex, i.uv.xy).rgb;
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPosition.xyz));
                fixed3 diffuse = _LightColor0.rgb * albedo * saturate(dot(tangentNormal, worldLightDir));

                fixed3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPosition.xyz));
                fixed3 halfDir = normalize(worldLightDir + viewDir);
                fixed facing = ceil(saturate(dot(tangentNormal, worldLightDir)));
                fixed3 secular = facing * _LightColor0.rgb * _Ks.rgb * pow(max(dot(tangentNormal, halfDir), 0), _Shininess);

                return fixed4(_Emissive + ambient + diffuse + secular, 1.0);
            }
            ENDCG
        }
    }
    FallBack Off
}
