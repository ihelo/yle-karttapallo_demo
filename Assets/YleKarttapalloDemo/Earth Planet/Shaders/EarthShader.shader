// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "EarthShader"
{
	Properties
	{
		_EarthMap("EarthMap", 2D) = "white" {}
		_NightMap("NightMap", 2D) = "white" {}
		_NightMapMult("NightMapMult", Range( 0 , 10)) = 0.85
		_NightLightsMap("NightLightsMap", 2D) = "white" {}
		_NightLightsMult("NightLightsMult", Range( 0 , 10)) = 1
		_DayNightContrast("DayNight Contrast", Range( 0 , 50)) = 7
		_WaterMask("WaterMask", 2D) = "white" {}
		_EarthNormalMap("EarthNormalMap", 2D) = "bump" {}
		_WaterNormal("WaterNormal", Range( 0 , 1)) = 0.03
		_LandNormal("LandNormal", Range( 0 , 1)) = 0.1
		_WaterSmoothness("WaterSmoothness", Range( 0 , 1)) = 0.7
		_LandSmoothness("LandSmoothness", Range( 0 , 1)) = 0.4
		_AtmosphereColor("AtmosphereColor", Color) = (0.2392157,0.6392158,1,1)
		_AtmospherePower("AtmospherePower", Range( 0 , 10)) = 1.2
		_AtmosphereScale("AtmosphereScale", Range( 0 , 10)) = 1.75
		_AtmosphereDarkSide("AtmosphereDarkSide", Range( 0 , 1)) = 0.423
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
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
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _EarthNormalMap;
		uniform float4 _EarthNormalMap_ST;
		uniform float _LandNormal;
		uniform float _WaterNormal;
		uniform sampler2D _WaterMask;
		uniform float4 _WaterMask_ST;
		uniform sampler2D _NightMap;
		uniform float4 _NightMap_ST;
		uniform float _NightMapMult;
		uniform sampler2D _EarthMap;
		uniform float4 _EarthMap_ST;
		uniform float _DayNightContrast;
		uniform float _AtmosphereScale;
		uniform float _AtmospherePower;
		uniform float4 _AtmosphereColor;
		uniform float _AtmosphereDarkSide;
		uniform sampler2D _NightLightsMap;
		uniform float4 _NightLightsMap_ST;
		uniform float _NightLightsMult;
		uniform float _LandSmoothness;
		uniform float _WaterSmoothness;


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color3 = IsGammaSpace() ? float4(0,0,1,1) : float4(0,0,1,1);
			float2 uv_EarthNormalMap = i.uv_texcoord * _EarthNormalMap_ST.xy + _EarthNormalMap_ST.zw;
			float3 tex2DNode23 = UnpackNormal( tex2D( _EarthNormalMap, uv_EarthNormalMap ) );
			float4 lerpResult49 = lerp( color3 , float4( tex2DNode23 , 0.0 ) , _LandNormal);
			float4 lerpResult47 = lerp( color3 , float4( tex2DNode23 , 0.0 ) , _WaterNormal);
			float2 uv_WaterMask = i.uv_texcoord * _WaterMask_ST.xy + _WaterMask_ST.zw;
			float4 tex2DNode24 = tex2D( _WaterMask, uv_WaterMask );
			float4 lerpResult51 = lerp( lerpResult49 , lerpResult47 , tex2DNode24);
			o.Normal = lerpResult51.rgb;
			float2 uv_NightMap = i.uv_texcoord * _NightMap_ST.xy + _NightMap_ST.zw;
			float4 temp_output_18_0 = ( tex2D( _NightMap, uv_NightMap ) * _NightMapMult );
			float2 uv_EarthMap = i.uv_texcoord * _EarthMap_ST.xy + _EarthMap_ST.zw;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float dotResult17 = dot( ase_worldlightDir , ase_worldNormal );
			float4 temp_cast_3 = (dotResult17).xxxx;
			float4 clampResult43 = clamp( CalculateContrast(_DayNightContrast,temp_cast_3) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float4 lerpResult4 = lerp( temp_output_18_0 , tex2D( _EarthMap, uv_EarthMap ) , clampResult43);
			o.Albedo = lerpResult4.rgb;
			float4 temp_output_21_0 = ( 1.0 - clampResult43 );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float fresnelNdotV57 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode57 = ( 0.0 + _AtmosphereScale * pow( 1.0 - fresnelNdotV57, _AtmospherePower ) );
			float4 temp_output_63_0 = ( fresnelNode57 * _AtmosphereColor );
			float fresnelNdotV96 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode96 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV96, 1.0 ) );
			float4 lerpResult65 = lerp( ( temp_output_63_0 * fresnelNode96 ) , ( dotResult17 * temp_output_63_0 ) , ( 1.0 - _AtmosphereDarkSide ));
			float4 clampResult92 = clamp( lerpResult65 , float4( 0,0,0,1 ) , float4( 1,1,1,1 ) );
			float2 uv_NightLightsMap = i.uv_texcoord * _NightLightsMap_ST.xy + _NightLightsMap_ST.zw;
			o.Emission = ( ( temp_output_21_0 * temp_output_18_0 ) + clampResult92 + ( tex2D( _NightLightsMap, uv_NightLightsMap ) * _NightLightsMult * temp_output_21_0 ) ).rgb;
			o.Metallic = 0.0;
			float lerpResult54 = lerp( _LandSmoothness , _WaterSmoothness , tex2DNode24.r);
			o.Smoothness = lerpResult54;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

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
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
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
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
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
Version=18935
0;676;2560;697;102.9505;2342.485;1.647915;True;True
Node;AmplifyShaderEditor.RangedFloatNode;59;964.7723,-354.7121;Inherit;False;Property;_AtmosphereScale;AtmosphereScale;14;0;Create;True;0;0;0;False;0;False;1.75;1.75;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;16;-185.1312,-555.8136;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;15;-195.0422,-744.1138;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;60;966.2259,-224.6997;Inherit;False;Property;_AtmospherePower;AtmospherePower;13;0;Create;True;0;0;0;False;0;False;1.2;1.2;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;62;1154.534,-105.8389;Inherit;False;Property;_AtmosphereColor;AtmosphereColor;12;0;Create;True;0;0;0;False;0;False;0.2392157,0.6392158,1,1;0.2392157,0.6392158,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;57;1297.078,-352.563;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;17;77.87811,-665.0692;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-0.2740768,-411.0257;Float;False;Property;_DayNightContrast;DayNight Contrast;5;0;Create;True;0;0;0;False;0;False;7;7;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;96;1629.283,-505.2598;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;1606.177,-250.7995;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;66;1455.66,43.70599;Inherit;False;Property;_AtmosphereDarkSide;AtmosphereDarkSide;15;0;Create;True;0;0;0;False;0;False;0.423;0.423;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;8;385.9743,-672.3835;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;2;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;19;522.2213,-786.718;Float;False;Property;_NightMapMult;NightMapMult;2;0;Create;True;0;0;0;False;0;False;0.85;0.85;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;2159.76,-297.7076;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;67;1749.704,36.71761;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;43;704.0178,-675.6144;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;1875.871,-93.69704;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;9;507.6846,-1018.299;Inherit;True;Property;_NightMap;NightMap;1;0;Create;True;0;0;0;False;0;False;-1;14abb0596b07d1f41b3c28fc41d0b5a7;14abb0596b07d1f41b3c28fc41d0b5a7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;3;764.3363,126.7477;Float;False;Constant;_Color0;Color 0;0;0;Create;True;0;0;0;False;0;False;0,0,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;65;2466.467,-87.0418;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;101;2046.119,-656.0468;Float;False;Property;_NightLightsMult;NightLightsMult;4;0;Create;True;0;0;0;False;0;False;1;0.85;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;587.9959,367.6404;Float;False;Property;_WaterNormal;WaterNormal;8;0;Create;True;0;0;0;False;0;False;0.03;0.03;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;910.967,-945.2384;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;21;1015.843,-616.2991;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;100;1713.291,-857.7559;Inherit;True;Property;_NightLightsMap;NightLightsMap;3;0;Create;True;0;0;0;False;0;False;-1;c8c1a91fede64ee41a274aa301724539;14abb0596b07d1f41b3c28fc41d0b5a7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;23;571.0692,444.9096;Inherit;True;Property;_EarthNormalMap;EarthNormalMap;7;0;Create;True;0;0;0;False;0;False;-1;1db77afdc9b714c49a4728890de35977;1db77afdc9b714c49a4728890de35977;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;50;596.3315,638.3582;Float;False;Property;_LandNormal;LandNormal;9;0;Create;True;0;0;0;False;0;False;0.1;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;47;1017.316,358.902;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.567;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;53;1001.935,719.7249;Float;False;Property;_LandSmoothness;LandSmoothness;11;0;Create;True;0;0;0;False;0;False;0.4;0.4;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;10;616.6603,-1265.538;Inherit;True;Property;_EarthMap;EarthMap;0;0;Create;True;0;0;0;False;0;False;-1;286b6e6f63cf3dc479d05fdb0cb7a020;286b6e6f63cf3dc479d05fdb0cb7a020;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;25;999.311,796.8622;Float;False;Property;_WaterSmoothness;WaterSmoothness;10;0;Create;True;0;0;0;False;0;False;0.7;0.7;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;1414.003,-620.4317;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;49;1009.415,540.4409;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;2482.935,-656.1248;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;92;2763.585,-203.7076;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,1;False;2;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;24;985.348,868.2402;Inherit;True;Property;_WaterMask;WaterMask;6;0;Create;True;0;0;0;False;0;False;-1;cf3f504ff7142c74bb1a1cff47525087;cf3f504ff7142c74bb1a1cff47525087;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;226;2521.718,-1879.409;Inherit;True;0;0;1;0;5;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;13.8;False;2;FLOAT;20;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.BreakToComponentsNode;213;1727.858,-1835.152;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TextureCoordinatesNode;164;699.8689,-1812.11;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;2,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;221;1953.613,-2007.121;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;212;2256.138,-1844.937;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;222;1944.513,-1777.021;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;209;1457.637,-2009.437;Inherit;True;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;7;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;218;1445.68,-1761.154;Inherit;True;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;8;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;223;1071.357,-2019.656;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.02,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;225;1095.358,-1763.655;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.02;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;224;768.8575,-1967.655;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;114;2592.557,-1420.7;Inherit;True;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;7;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;140;3180.098,-1187.612;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;113;2266.02,-1405.146;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.02,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;79;2857.215,-31.25269;Inherit;False;Constant;_Metallic;Metallic;14;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;206;2885.474,-1297.035;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;0.7;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCPixelate;204;1937.746,-1451.197;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT;16;False;2;FLOAT;16;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;54;1431.687,725.0565;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;111;1945.687,-1172.015;Inherit;False;1;0;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;4;1406.623,-1091.592;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;61;2956.865,-380.9125;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;51;1418.806,322.2994;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;196;480.9731,-359.3508;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;227;2733.136,-1866.853;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;0.9;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;98;3595.439,-347.0145;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;EarthShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;57;2;59;0
WireConnection;57;3;60;0
WireConnection;17;0;15;0
WireConnection;17;1;16;0
WireConnection;63;0;57;0
WireConnection;63;1;62;0
WireConnection;8;1;17;0
WireConnection;8;0;22;0
WireConnection;97;0;63;0
WireConnection;97;1;96;0
WireConnection;67;0;66;0
WireConnection;43;0;8;0
WireConnection;64;0;17;0
WireConnection;64;1;63;0
WireConnection;65;0;97;0
WireConnection;65;1;64;0
WireConnection;65;2;67;0
WireConnection;18;0;9;0
WireConnection;18;1;19;0
WireConnection;21;0;43;0
WireConnection;47;0;3;0
WireConnection;47;1;23;0
WireConnection;47;2;48;0
WireConnection;20;0;21;0
WireConnection;20;1;18;0
WireConnection;49;0;3;0
WireConnection;49;1;23;0
WireConnection;49;2;50;0
WireConnection;102;0;100;0
WireConnection;102;1;101;0
WireConnection;102;2;21;0
WireConnection;92;0;65;0
WireConnection;226;0;212;0
WireConnection;213;0;164;0
WireConnection;221;0;213;0
WireConnection;221;1;209;0
WireConnection;212;0;221;0
WireConnection;212;1;222;0
WireConnection;222;0;213;1
WireConnection;222;1;218;0
WireConnection;209;0;223;0
WireConnection;218;0;225;0
WireConnection;223;0;164;0
WireConnection;223;1;224;0
WireConnection;225;0;164;0
WireConnection;225;1;224;0
WireConnection;114;0;204;0
WireConnection;140;0;206;0
WireConnection;113;0;164;0
WireConnection;113;1;111;0
WireConnection;206;0;114;0
WireConnection;204;0;164;0
WireConnection;54;0;53;0
WireConnection;54;1;25;0
WireConnection;54;2;24;0
WireConnection;4;0;18;0
WireConnection;4;1;10;0
WireConnection;4;2;43;0
WireConnection;61;0;20;0
WireConnection;61;1;92;0
WireConnection;61;2;102;0
WireConnection;51;0;49;0
WireConnection;51;1;47;0
WireConnection;51;2;24;0
WireConnection;196;0;17;0
WireConnection;227;0;226;0
WireConnection;98;0;4;0
WireConnection;98;1;51;0
WireConnection;98;2;61;0
WireConnection;98;3;79;0
WireConnection;98;4;54;0
ASEEND*/
//CHKSM=07A8FE78C36E78F08736DA991559204A6B0425C5