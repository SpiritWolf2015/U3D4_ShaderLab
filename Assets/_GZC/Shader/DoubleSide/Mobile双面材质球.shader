/*
	SurfaceShader
	支持透明通道阴影

*/


Shader "双面材质/Transparent/Cutout/MobileBumpedSpecular" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 0)
		_Shininess ("Shininess", Range (0.01, 1)) = 0.078125
		_MainTex ("Base (RGB) Trans(A)", 2D) = "white" {}
		_GlossMap ("Gloss",2D) = "white" {}
		_BumpMap ("Normalmap", 2D) = "bump" {}
		_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
	}

	SubShader {
		Tags {"Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout"}
		LOD 400
		Cull Off
	
		CGPROGRAM
		#pragma surface surf SimpleLambert exclude_path:prepass noforwardadd halfasview alphatest:_Cutoff

		sampler2D _MainTex;
		sampler2D _GlossMap;
		sampler2D _BumpMap;
		fixed4 _Color;
		half _Shininess;

		struct Input {
			half2 uv_MainTex;		
		};

		inline fixed4 LightingSimpleLambert (SurfaceOutput s, fixed3 lightDir, fixed atten) {  
			fixed diff = max (0, dot (s.Normal, lightDir));  
          
			fixed4 c;  
			c.rgb = s.Albedo * _LightColor0.rgb * (diff * atten * 2);  
			c.a = s.Alpha;  
			return c;  
		}  

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = tex.rgb * _Color.rgb;
			fixed4 gls = tex2D(_GlossMap, IN.uv_MainTex);
			o.Gloss = gls.rgb;
			o.Alpha = tex.a * _Color.a;
			o.Specular = _Shininess;
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_MainTex));
		}
		ENDCG
	}

	FallBack "Transparent/Diffuse"
}
