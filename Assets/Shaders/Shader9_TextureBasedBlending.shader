Shader "RonjaTutorial/09_Interpolar/TextureBasedBlending"{
    Properties{
        _MainTex ("Texture", 2D) = "white" {} //the base texture
        _SecondaryTex ("Secondary Texture", 2D) = "black" {} //the texture to blend to
        _BlendTex ("Blend Texture", 2D) = "grey" //black is the first color, white the second
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

            //the value that's used to blend between the colors
            sampler2D _BlendTex;
            float4 _BlendTex_ST;

			//the colors to blend between
			sampler2D _MainTex;
			float4 _MainTex_ST;

			sampler2D _SecondaryTex;
			float4 _SecondaryTex_ST;

            struct appdata{
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f{
                float4 position : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert(appdata v){
                v2f o;
                o.position = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET{
                //calculate UV coordinates including tiling and offset
                float2 main_uv = TRANSFORM_TEX(i.uv, _MainTex);
                float2 secondary_uv = TRANSFORM_TEX(i.uv, _SecondaryTex);
                float2 blend_uv = TRANSFORM_TEX(i.uv, _BlendTex);

                //read colors from textures
                fixed4 main_color = tex2D(_MainTex, main_uv);
                fixed4 secondary_color = tex2D(_SecondaryTex, secondary_uv);
                fixed4 blend_color = tex2D(_BlendTex, blend_uv);

                fixed blend_value = blend_color.r;

                //interpolate between the colors
                fixed4 col = lerp(main_color, secondary_color, blend_value);
                return col;
            }



            ENDCG

        }
    }
}
