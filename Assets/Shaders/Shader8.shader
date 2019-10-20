﻿Shader "RonjaTutorial/08_Planar_Mapping"{
    Properties{
        _Color("Color", Color) = (0, 0, 0, 1)
        _MainTex ("Texture", 2D) = "white" {}

    }
    Subshader{
        Tags{
            "RenderType"="Opaque"
            "Queue"="Geometry"
        }
        Pass{

            CGPROGRAM
            #include "unityCG.cginc"

            #pragma vertex vert
            #pragma fragment frag

            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;

            struct appdata{
                float4 vertex : POSITION;
            };

            struct v2f{
                float4 position : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert(appdata v){
                v2f o;
                o.position = UnityObjectToClipPos(v.vertex);
                float4 worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.uv = TRANSFORM_TEX(worldPos.xz, _MainTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET{
                fixed4 col = tex2D(_MainTex, i.uv);
                col *= _Color;
                return col;
            }



            ENDCG

        }
    }
}
