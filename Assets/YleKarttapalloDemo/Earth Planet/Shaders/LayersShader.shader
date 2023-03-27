// Made with Amplify Shader Editor v1.9.1.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "LayersShader"
{
	Properties
	{
		_CountriesTex("Countries Tex", 2D) = "white" {}
		_CountriesTexTintShadows("Countries Tex Tint Shadows", Color) = (0,0,0,0)
		_CountriesTexTintHighlights("Countries Tex Tint Highlights", Color) = (1,1,1,0)
		_CountriesTexValue("Countries Tex Value", Range( 0 , 10)) = 1
		[KeywordEnum(Color,Alpha)] _VertexChannel("Vertex Channel", Float) = 0
		_VertexChannelBlend("Vertex Channel Blend", Range( 0 , 1)) = 0
		_AlphaBlackTint("Alpha Black Tint", Color) = (0,0,0,0)
		_AlphaWhiteTint("Alpha White Tint", Color) = (1,1,1,0)
		_CountriesBordersMask("Countries Borders Mask", 2D) = "white" {}
		_BordersColor("Borders Color", Color) = (0.699,0.4468118,0.2001059,1)
		_BordersValue("Borders Value", Range( 0 , 2)) = 1
		_NormalTex("Normal Tex", 2D) = "bump" {}
		_NormalScale("Normal Scale", Range( 0 , 1)) = 0.5
		_OceansColor("Oceans Color", Color) = (0.105,0.0165,0,0)
		_OceanGridTex("Ocean Grid Tex", 2D) = "white" {}
		_Smoothness("Smoothness", Range( 0 , 1)) = 0.75
		_SelectionTexCountries("Selection Tex Countries", 2D) = "white" {}
		_SelectionTexOceans("Selection Tex Oceans", 2D) = "white" {}
		_SelectionTexTiling("Selection Tex Tiling", Float) = 20
		_StripesValue("Stripes Value", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _VERTEXCHANNEL_COLOR _VERTEXCHANNEL_ALPHA
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float eyeDepth;
			float4 screenPos;
		};

		uniform sampler2D _NormalTex;
		uniform float4 _NormalTex_ST;
		uniform float _NormalScale;
		uniform sampler2D _OceanGridTex;
		uniform float4 _OceanGridTex_ST;
		uniform float4 _OceansColor;
		uniform sampler2D _SelectionTexOceans;
		uniform float _SelectionTexTiling;
		uniform float _StripesValue;
		uniform sampler2D _SelectionTexCountries;
		uniform float4 _BordersColor;
		uniform sampler2D _CountriesBordersMask;
		uniform float4 _CountriesBordersMask_ST;
		uniform float _BordersValue;
		uniform float4 _CountriesTexTintHighlights;
		uniform float _CountriesTexValue;
		uniform sampler2D _CountriesTex;
		uniform float4 _CountriesTex_ST;
		uniform float4 _CountriesTexTintShadows;
		uniform float4 _AlphaBlackTint;
		uniform float4 _AlphaWhiteTint;
		uniform float _VertexChannelBlend;
		uniform float _Smoothness;


		float3 RGBToHSV(float3 c)
		{
			float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
			float4 p = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
			float4 q = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
			float d = q.x - min( q.w, q.y );
			float e = 1.0e-10;
			return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
		}

		float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }

		float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }

		float snoise( float3 v )
		{
			const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
			float3 i = floor( v + dot( v, C.yyy ) );
			float3 x0 = v - i + dot( i, C.xxx );
			float3 g = step( x0.yzx, x0.xyz );
			float3 l = 1.0 - g;
			float3 i1 = min( g.xyz, l.zxy );
			float3 i2 = max( g.xyz, l.zxy );
			float3 x1 = x0 - i1 + C.xxx;
			float3 x2 = x0 - i2 + C.yyy;
			float3 x3 = x0 - 0.5;
			i = mod3D289( i);
			float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
			float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
			float4 x_ = floor( j / 7.0 );
			float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
			float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 h = 1.0 - abs( x ) - abs( y );
			float4 b0 = float4( x.xy, y.xy );
			float4 b1 = float4( x.zw, y.zw );
			float4 s0 = floor( b0 ) * 2.0 + 1.0;
			float4 s1 = floor( b1 ) * 2.0 + 1.0;
			float4 sh = -step( h, 0.0 );
			float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
			float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
			float3 g0 = float3( a0.xy, h.x );
			float3 g1 = float3( a0.zw, h.y );
			float3 g2 = float3( a1.xy, h.z );
			float3 g3 = float3( a1.zw, h.w );
			float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
			g0 *= norm.x;
			g1 *= norm.y;
			g2 *= norm.z;
			g3 *= norm.w;
			float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
			m = m* m;
			m = m* m;
			float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
			return 42.0 * dot( m, px);
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			o.eyeDepth = -UnityObjectToViewPos( v.vertex.xyz ).z;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalTex = i.uv_texcoord * _NormalTex_ST.xy + _NormalTex_ST.zw;
			float3 hsvTorgb125 = RGBToHSV( i.vertexColor.rgb );
			float clampResult404 = clamp( hsvTorgb125.z , 0.0 , 0.001 );
			float VertColorValueMask141 = (0.0 + (clampResult404 - 0.0) * (1.0 - 0.0) / (0.001 - 0.0));
			o.Normal = UnpackScaleNormal( tex2D( _NormalTex, uv_NormalTex ), ( _NormalScale * VertColorValueMask141 ) );
			float4 color396 = IsGammaSpace() ? float4(0,0,0,1) : float4(0,0,0,1);
			o.Albedo = color396.rgb;
			float2 uv_OceanGridTex = i.uv_texcoord * _OceanGridTex_ST.xy + _OceanGridTex_ST.zw;
			float2 temp_cast_2 = (0.015).xx;
			float2 uv_TexCoord295 = i.uv_texcoord * float2( 2,1 );
			float2 panner303 = ( _Time.y * temp_cast_2 + uv_TexCoord295);
			float simplePerlin3D322 = snoise( float3( panner303 ,  0.0 )*15.0 );
			simplePerlin3D322 = simplePerlin3D322*0.5 + 0.5;
			float2 temp_cast_4 = (-0.015).xx;
			float2 panner298 = ( _Time.y * temp_cast_4 + uv_TexCoord295);
			float simplePerlin3D321 = snoise( float3( panner298 ,  0.0 )*7.0 );
			simplePerlin3D321 = simplePerlin3D321*0.5 + 0.5;
			float blendOpSrc323 = simplePerlin3D322;
			float blendOpDest323 = simplePerlin3D321;
			float NoiseAnimLarge325 = (0.0 + (( saturate( (( blendOpDest323 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest323 ) * ( 1.0 - blendOpSrc323 ) ) : ( 2.0 * blendOpDest323 * blendOpSrc323 ) ) )) - 0.0) * (1.5 - 0.0) / (1.0 - 0.0));
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV160 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode160 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV160, 8.0 ) );
			float cameraDepthFade270 = (( i.eyeDepth -_ProjectionParams.y - 0.2 ) / 4.0);
			float clampResult272 = clamp( cameraDepthFade270 , 0.0 , 1.0 );
			float CameraDepthFade348 = clampResult272;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float cameraDepthFade365 = (( i.eyeDepth -_ProjectionParams.y - 0.2 ) / 4.0);
			float cos332 = cos( radians( -45.0 ) );
			float sin332 = sin( radians( -45.0 ) );
			float2 rotator332 = mul( ( ( ase_screenPosNorm * _ScreenParams * 0.001 ) * _SelectionTexTiling * (0.3 + (cameraDepthFade365 - 0.0) * (0.7 - 0.3) / (1.0 - 0.0)) ).xy - float2( 0,0 ) , float2x2( cos332 , -sin332 , sin332 , cos332 )) + float2( 0,0 );
			float4 StripesMaskOceans356 = ( CameraDepthFade348 * tex2D( _SelectionTexOceans, rotator332 ) * 0.22 );
			float4 OceansEmission197 = ( ( tex2D( _OceanGridTex, uv_OceanGridTex ) * _OceansColor * 2.0 * NoiseAnimLarge325 ) + ( _OceansColor + ( _OceansColor * fresnelNode160 ) ) + ( StripesMaskOceans356 * _OceansColor * 7.0 * _StripesValue ) );
			float4 StripesMaskCountries335 = ( 0.22 * tex2D( _SelectionTexCountries, rotator332 ) * CameraDepthFade348 );
			float2 uv_CountriesBordersMask = i.uv_texcoord * _CountriesBordersMask_ST.xy + _CountriesBordersMask_ST.zw;
			float4 color421 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			float4 ifLocalVar420 = 0;
			if( tex2D( _CountriesBordersMask, uv_CountriesBordersMask ).r > 0.15 )
				ifLocalVar420 = color421;
			float4 BordersMask144 = ( ( 1.0 - ifLocalVar420 ) * VertColorValueMask141 );
			float simplePerlin3D302 = snoise( float3( panner303 ,  0.0 )*20.0 );
			simplePerlin3D302 = simplePerlin3D302*0.5 + 0.5;
			float simplePerlin3D201 = snoise( float3( panner298 ,  0.0 )*10.0 );
			simplePerlin3D201 = simplePerlin3D201*0.5 + 0.5;
			float blendOpSrc306 = simplePerlin3D302;
			float blendOpDest306 = simplePerlin3D201;
			float NoiseAnimSmall300 = (0.2 + (( saturate( (( blendOpDest306 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest306 ) * ( 1.0 - blendOpSrc306 ) ) : ( 2.0 * blendOpDest306 * blendOpSrc306 ) ) )) - 0.0) * (1.2 - 0.2) / (1.0 - 0.0));
			float2 uv_CountriesTex = i.uv_texcoord * _CountriesTex_ST.xy + _CountriesTex_ST.zw;
			float4 temp_output_374_0 = ( _CountriesTexValue * tex2D( _CountriesTex, uv_CountriesTex ) );
			float4 temp_output_372_0 = ( ( _CountriesTexTintHighlights * temp_output_374_0 ) + ( _CountriesTexTintShadows * ( 1.0 - temp_output_374_0 ) ) );
			float4 lerpResult417 = lerp( _AlphaBlackTint , _AlphaWhiteTint , i.vertexColor.a);
			#if defined(_VERTEXCHANNEL_COLOR)
				float4 staticSwitch413 = i.vertexColor;
			#elif defined(_VERTEXCHANNEL_ALPHA)
				float4 staticSwitch413 = lerpResult417;
			#else
				float4 staticSwitch413 = i.vertexColor;
			#endif
			float4 lerpResult392 = lerp( temp_output_372_0 , staticSwitch413 , _VertexChannelBlend);
			float4 CountriesEmission152 = ( ( StripesMaskCountries335 * _BordersColor * 5.0 * _StripesValue ) + ( BordersMask144 * ( _BordersColor * 2.0 ) * NoiseAnimSmall300 * _BordersValue ) + lerpResult392 );
			float4 lerpResult163 = lerp( OceansEmission197 , CountriesEmission152 , VertColorValueMask141);
			o.Emission = lerpResult163.rgb;
			o.Smoothness = ( (0.85 + (( 1.0 - VertColorValueMask141 ) - 0.0) * (1.0 - 0.85) / (1.0 - 0.0)) * _Smoothness );
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float3 customPack1 : TEXCOORD1;
				float4 screenPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack1.z = customInputData.eyeDepth;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
				o.color = v.color;
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				surfIN.eyeDepth = IN.customPack1.z;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.screenPos = IN.screenPos;
				surfIN.vertexColor = IN.color;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19102
Node;AmplifyShaderEditor.CommentaryNode;307;-1138.931,-624.1154;Inherit;False;1765.486;497.3564;Comment;16;201;303;298;295;297;304;305;302;306;300;319;321;322;323;324;325;Noise Anim;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;140;-1144.126,-1278.904;Inherit;False;2185.191;579.4362;Comment;9;33;144;142;271;122;12;349;420;421;Borders Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.VertexColorNode;124;1101.417,-23.37861;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;345;1084.924,-931.9846;Inherit;False;2641.294;822.0859;Comment;19;356;354;355;335;346;350;347;330;332;334;344;343;333;259;207;230;268;365;366;Selection Stripes;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScreenParams;230;1134.924,-756.6797;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;304;-1065.021,-241.759;Inherit;False;Constant;_Float12;Float 12;13;0;Create;True;0;0;0;False;0;False;0.015;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;268;1417.732,-628.1473;Inherit;False;Constant;_Float11;Float 11;14;0;Create;True;0;0;0;False;0;False;0.001;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;207;1386.021,-881.9844;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RGBToHSVNode;125;1332.401,-7.761456;Inherit;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CameraDepthFade;365;1222.404,-466.3128;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;4;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;366;1524.698,-412.2835;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.3;False;4;FLOAT;0.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;151;-1449.65,-30.61272;Inherit;False;2523.521;1143.546;Comment;30;360;138;372;339;338;351;309;109;368;376;149;108;110;367;375;379;370;374;105;373;174;152;390;391;393;392;408;409;413;418;Countries;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;295;-1072.754,-416.2649;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;2,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;404;1611.154,20.99545;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.001;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;333;1817.315,-490.5949;Inherit;False;Constant;_TexAngle;TexAngle;14;0;Create;True;0;0;0;False;0;False;-45;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;305;-843.0208,-252.759;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;343;1719.21,-643.6947;Inherit;False;Property;_SelectionTexTiling;Selection Tex Tiling;18;0;Create;True;0;0;0;False;0;False;20;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;259;1727.051,-876.169;Inherit;True;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CameraDepthFade;270;1072.079,172.3632;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;4;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;297;-1034.891,-512.8198;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;298;-680.0644,-324.8069;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.03;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RadiansOpNode;334;2009.275,-514.6038;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;344;1975.911,-756.6948;Inherit;True;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TexturePropertyNode;174;-1416.779,195.016;Inherit;True;Property;_CountriesTex;Countries Tex;0;0;Create;True;0;0;0;False;0;False;230e7f2732dacf24787709062cfe0185;286b6e6f63cf3dc479d05fdb0cb7a020;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TFHCRemapNode;405;1866.855,-34.90456;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.001;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;272;1346.381,185.5257;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;303;-694.1341,-481.8082;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;201;-452.5877,-257.5071;Inherit;False;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;348;1614.696,195.0202;Inherit;False;CameraDepthFade;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;302;-449.2847,-356.9603;Inherit;False;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;321;-464.7348,-490.736;Inherit;False;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;7;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;141;2138.671,9.66049;Inherit;False;VertColorValueMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;373;-1165.705,38.55666;Inherit;False;Property;_CountriesTexValue;Countries Tex Value;3;0;Create;True;0;0;0;False;0;False;1;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;332;2222.526,-580.2037;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;322;-452.3801,-588.2707;Inherit;False;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;15;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;105;-1175.416,207.8413;Inherit;True;Property;_Countries1;Countries 1;0;0;Create;True;0;0;0;False;0;False;-1;4231cf4121c2cfd4da17ef384679922a;4231cf4121c2cfd4da17ef384679922a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;306;-202.8441,-338.9701;Inherit;True;Overlay;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;142;-5.066296,-763.0921;Inherit;False;141;VertColorValueMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;347;2742.713,-554.5275;Inherit;False;Constant;_SelectionTexValue;Selection Tex Value;15;0;Create;True;0;0;0;False;0;False;0.22;0.22;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;354;2450.718,-354.3075;Inherit;True;Property;_SelectionTexOceans;Selection Tex Oceans;17;0;Create;True;0;0;0;False;0;False;-1;4d3fd44a40f3d2744897941f39f86a72;4d3fd44a40f3d2744897941f39f86a72;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;374;-819.4702,243.4832;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;350;2743.607,-474.172;Inherit;False;348;CameraDepthFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;323;-193.9691,-566.2632;Inherit;True;Overlay;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;330;2449.711,-665.6104;Inherit;True;Property;_SelectionTexCountries;Selection Tex Countries;16;0;Create;True;0;0;0;False;0;False;-1;7c841689d19131e49bc256a326d00430;7c841689d19131e49bc256a326d00430;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;319;90.41457,-322.0911;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.2;False;4;FLOAT;1.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;346;3062.635,-734.0692;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;379;-462.3918,746.0015;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;196;-1273.835,1299.673;Inherit;False;2221.759;704.2475;Comment;14;197;162;157;165;357;199;310;166;160;135;158;362;401;406;Oceans;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;367;-833.7161,39.28157;Inherit;False;Property;_CountriesTexTintShadows;Countries Tex Tint Shadows;1;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;355;3100.307,-362.0728;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;375;-501.0825,43.63276;Inherit;False;Property;_CountriesTexTintHighlights;Countries Tex Tint Highlights;2;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;370;-660.2112,349.03;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;324;111.3529,-545.3613;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;419;-536.9729,1127.239;Inherit;False;Property;_AlphaWhiteTint;Alpha White Tint;7;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;418;-546.6605,941.9642;Inherit;False;Property;_AlphaBlackTint;Alpha Black Tint;6;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;144;698.8781,-921.9711;Inherit;False;BordersMask;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;356;3352.781,-363.195;Inherit;False;StripesMaskOceans;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;335;3376.653,-635.3471;Inherit;False;StripesMaskCountries;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;160;-1138.672,1773.999;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;8;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;158;-1192.556,1552.418;Inherit;False;Property;_OceansColor;Oceans Color;13;0;Create;True;0;0;0;False;0;False;0.105,0.0165,0,0;0,0.04310255,0.1509434,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;368;-482.4481,271.0108;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;325;348.5269,-518.6819;Inherit;False;NoiseAnimLarge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;300;345.4054,-292.6109;Inherit;False;NoiseAnimSmall;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;110;-1349.646,680.0757;Inherit;False;Constant;_cccc;cccc;9;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;108;-1394.395,451.6395;Inherit;False;Property;_BordersColor;Borders Color;9;0;Create;True;0;0;0;False;0;False;0.699,0.4468118,0.2001059,1;0.2735216,0.5771737,0.7372549,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;417;-173.6896,1018.254;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;376;-291.0849,223.4241;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;135;-619.6576,1344.311;Inherit;True;Property;_OceanGridTex;Ocean Grid Tex;14;0;Create;True;0;0;0;False;0;False;-1;8ff7c8146fd10a24189196fa88e129fd;8ff7c8146fd10a24189196fa88e129fd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;338;-664.2085,446.1136;Inherit;False;335;StripesMaskCountries;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;166;-816.6217,1774.378;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;149;-1061.563,415.0827;Inherit;False;144;BordersMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;309;-1146.727,773.3535;Inherit;False;300;NoiseAnimSmall;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;310;-544.2524,1688.355;Inherit;False;325;NoiseAnimLarge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;372;-156.8279,291.3963;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;-1102.105,545.0667;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;393;87.5452,813.8551;Inherit;False;Property;_VertexChannelBlend;Vertex Channel Blend;5;0;Create;True;0;0;0;False;0;False;0;1.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;413;106.0394,922.5573;Inherit;False;Property;_VertexChannel;Vertex Channel;4;0;Create;True;0;0;0;False;0;False;0;0;0;True;;KeywordEnum;2;Color;Alpha;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;351;-751.27,771.2965;Inherit;False;Property;_StripesValue;Stripes Value;19;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;408;-628.9651,576.4359;Inherit;False;Constant;_Float3;Float 3;8;0;Create;True;0;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;409;-1064.385,885.6768;Inherit;False;Property;_BordersValue;Borders Value;10;0;Create;True;0;0;0;False;0;False;1;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;406;-68.78277,1481.186;Inherit;False;Constant;_Float1;Float 1;19;0;Create;True;0;0;0;False;0;False;7;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;357;-123.8485,1366.453;Inherit;False;356;StripesMaskOceans;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;401;-515.2426,1590.074;Inherit;False;Constant;_Float0;Float 0;19;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;392;446.2851,617.4337;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;362;126.764,1389.875;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;165;-561.4553,1780.721;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;157;-264.7137,1531.516;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;339;-391.7779,473.907;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;138;-795.0018,627.1418;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;360;637.7825,450.3459;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;154;1163.049,768.6363;Inherit;False;141;VertColorValueMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;162;369.2401,1621.438;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;115;1489.801,637.4957;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;188;1730.806,472.4738;Float;False;Property;_NormalScale;Normal Scale;12;0;Create;True;0;0;0;False;0;False;0.5;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;152;810.5037,357.5188;Inherit;False;CountriesEmission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;197;603.679,1633.734;Inherit;False;OceansEmission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;132;2176,848;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.85;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;198;1984,688;Inherit;False;197;OceansEmission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;191;2176,1040;Inherit;False;Property;_Smoothness;Smoothness;15;0;Create;True;0;0;0;False;0;False;0.75;0.45;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;153;1982,773;Inherit;False;152;CountriesEmission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;318;2066.238,565.5725;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;163;2386.079,708.2837;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;199;-930.3312,1451.647;Inherit;False;OceansColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;187;2344.665,486.619;Inherit;True;Property;_NormalTex;Normal Tex;11;0;Create;True;0;0;0;False;0;False;-1;1db77afdc9b714c49a4728890de35977;1db77afdc9b714c49a4728890de35977;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;349;76.5326,-1116.593;Inherit;False;348;CameraDepthFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RGBToHSVNode;390;-120.4577,578.4521;Inherit;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;396;2685.425,340.3779;Inherit;False;Constant;_Color2;Color 2;20;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;190;2528,928;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.HSVToRGBNode;391;125.459,651.1411;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;76;3145.377,626.6297;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;LayersShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;271;417.2643,-901.439;Inherit;False;2;2;0;COLOR;1,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;122;181.2977,-985.0943;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-980.2511,-1065.995;Inherit;False;Constant;_BorderWidth;Border Width;6;0;Create;True;0;0;0;False;0;False;0.15;0.21;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;421;-665.7146,-1199.701;Inherit;False;Constant;_Color0;Color 0;20;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ConditionalIfNode;420;-188.5135,-997.2581;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;12;-798.2573,-914.1164;Inherit;True;Property;_CountriesBordersMask;Countries Borders Mask;8;0;Create;True;0;0;0;False;0;False;-1;6dffa14c4682cad4e9beffcac1027790;6dffa14c4682cad4e9beffcac1027790;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;125;0;124;0
WireConnection;366;0;365;0
WireConnection;404;0;125;3
WireConnection;305;0;304;0
WireConnection;259;0;207;0
WireConnection;259;1;230;0
WireConnection;259;2;268;0
WireConnection;298;0;295;0
WireConnection;298;2;305;0
WireConnection;298;1;297;0
WireConnection;334;0;333;0
WireConnection;344;0;259;0
WireConnection;344;1;343;0
WireConnection;344;2;366;0
WireConnection;405;0;404;0
WireConnection;272;0;270;0
WireConnection;303;0;295;0
WireConnection;303;2;304;0
WireConnection;303;1;297;0
WireConnection;201;0;298;0
WireConnection;348;0;272;0
WireConnection;302;0;303;0
WireConnection;321;0;298;0
WireConnection;141;0;405;0
WireConnection;332;0;344;0
WireConnection;332;2;334;0
WireConnection;322;0;303;0
WireConnection;105;0;174;0
WireConnection;306;0;302;0
WireConnection;306;1;201;0
WireConnection;354;1;332;0
WireConnection;374;0;373;0
WireConnection;374;1;105;0
WireConnection;323;0;322;0
WireConnection;323;1;321;0
WireConnection;330;1;332;0
WireConnection;319;0;306;0
WireConnection;346;0;347;0
WireConnection;346;1;330;0
WireConnection;346;2;350;0
WireConnection;355;0;350;0
WireConnection;355;1;354;0
WireConnection;355;2;347;0
WireConnection;370;0;374;0
WireConnection;324;0;323;0
WireConnection;144;0;271;0
WireConnection;356;0;355;0
WireConnection;335;0;346;0
WireConnection;368;0;367;0
WireConnection;368;1;370;0
WireConnection;325;0;324;0
WireConnection;300;0;319;0
WireConnection;417;0;418;0
WireConnection;417;1;419;0
WireConnection;417;2;379;4
WireConnection;376;0;375;0
WireConnection;376;1;374;0
WireConnection;166;0;158;0
WireConnection;166;1;160;0
WireConnection;372;0;376;0
WireConnection;372;1;368;0
WireConnection;109;0;108;0
WireConnection;109;1;110;0
WireConnection;413;1;379;0
WireConnection;413;0;417;0
WireConnection;392;0;372;0
WireConnection;392;1;413;0
WireConnection;392;2;393;0
WireConnection;362;0;357;0
WireConnection;362;1;158;0
WireConnection;362;2;406;0
WireConnection;362;3;351;0
WireConnection;165;0;158;0
WireConnection;165;1;166;0
WireConnection;157;0;135;0
WireConnection;157;1;158;0
WireConnection;157;2;401;0
WireConnection;157;3;310;0
WireConnection;339;0;338;0
WireConnection;339;1;108;0
WireConnection;339;2;408;0
WireConnection;339;3;351;0
WireConnection;138;0;149;0
WireConnection;138;1;109;0
WireConnection;138;2;309;0
WireConnection;138;3;409;0
WireConnection;360;0;339;0
WireConnection;360;1;138;0
WireConnection;360;2;392;0
WireConnection;162;0;157;0
WireConnection;162;1;165;0
WireConnection;162;2;362;0
WireConnection;115;0;154;0
WireConnection;152;0;360;0
WireConnection;197;0;162;0
WireConnection;132;0;115;0
WireConnection;318;0;188;0
WireConnection;318;1;154;0
WireConnection;163;0;198;0
WireConnection;163;1;153;0
WireConnection;163;2;154;0
WireConnection;199;0;158;0
WireConnection;187;5;318;0
WireConnection;390;0;372;0
WireConnection;190;0;132;0
WireConnection;190;1;191;0
WireConnection;391;1;390;2
WireConnection;391;2;390;3
WireConnection;76;0;396;0
WireConnection;76;1;187;0
WireConnection;76;2;163;0
WireConnection;76;4;190;0
WireConnection;271;0;122;0
WireConnection;271;1;142;0
WireConnection;122;0;420;0
WireConnection;420;0;12;1
WireConnection;420;1;33;0
WireConnection;420;2;421;0
ASEEND*/
//CHKSM=464C330F23219BFC78FCD8AB49D85453B7E55D17