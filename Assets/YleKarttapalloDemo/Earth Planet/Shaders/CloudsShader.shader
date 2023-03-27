// Made with Amplify Shader Editor v1.9.1.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "CloudsShader"
{
	Properties
	{
		_CloudsBaseColor("Clouds BaseColor", Color) = (1,1,1,1)
		_OpacityMap("OpacityMap", 2D) = "white" {}
		_Size("Size", Range( 0 , 10)) = 1
		_CloudMult("CloudMult", Range( 0 , 5)) = 1.5
		_CloudSmoothness("Cloud Smoothness", Range( 0 , 1)) = 0.2
		_DarkSideEmission("DarkSide Emission", Color) = (0.0464,0.0667,0.203,0)
		_DarkSideContrast("DarkSide Contrast", Range( 0 , 50)) = 5
		_NormalMap("NormalMap", 2D) = "bump" {}
		_NormalValue("Normal Value", Range( 0 , 1)) = 0.08
		_FlowMap("FlowMap", 2D) = "white" {}
		_FlowStrength("Flow Strength", Range( 0 , 1)) = 1
		_FlowSpeed("Flow Speed", Range( 0 , 1)) = 0.2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
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

		uniform sampler2D _NormalMap;
		uniform float _Size;
		uniform sampler2D _FlowMap;
		uniform float4 _FlowMap_ST;
		uniform float _FlowStrength;
		uniform float _FlowSpeed;
		uniform float _CloudMult;
		uniform float _NormalValue;
		uniform float4 _CloudsBaseColor;
		uniform float4 _DarkSideEmission;
		uniform float _DarkSideContrast;
		uniform float _CloudSmoothness;
		uniform sampler2D _OpacityMap;


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color252 = IsGammaSpace() ? float4(0,0,1,1) : float4(0,0,1,1);
			float2 temp_output_4_0_g4 = (( i.uv_texcoord / _Size )).xy;
			float2 uv_FlowMap = i.uv_texcoord * _FlowMap_ST.xy + _FlowMap_ST.zw;
			float4 tex2DNode275 = tex2D( _FlowMap, uv_FlowMap );
			float2 temp_cast_1 = (_FlowStrength).xx;
			float2 temp_output_17_0_g4 = temp_cast_1;
			float mulTime22_g4 = _Time.y * _FlowSpeed;
			float temp_output_27_0_g4 = frac( mulTime22_g4 );
			float2 temp_output_11_0_g4 = ( temp_output_4_0_g4 + ( -(tex2DNode275.rg*2.0 + -1.0) * temp_output_17_0_g4 * temp_output_27_0_g4 ) );
			float2 temp_output_12_0_g4 = ( temp_output_4_0_g4 + ( -(tex2DNode275.rg*2.0 + -1.0) * temp_output_17_0_g4 * frac( ( mulTime22_g4 + 0.5 ) ) ) );
			float4 lerpResult9_g4 = lerp( tex2D( _NormalMap, temp_output_11_0_g4 ) , tex2D( _NormalMap, temp_output_12_0_g4 ) , ( abs( ( temp_output_27_0_g4 - 0.5 ) ) / 0.5 ));
			float clampResult251 = clamp( _CloudMult , 0.0 , _NormalValue );
			float4 lerpResult253 = lerp( color252 , lerpResult9_g4 , clampResult251);
			o.Normal = lerpResult253.rgb;
			o.Albedo = ( _CloudsBaseColor * _CloudMult ).rgb;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float dotResult17 = dot( ase_worldlightDir , ase_worldNormal );
			float4 temp_cast_4 = (dotResult17).xxxx;
			float4 clampResult43 = clamp( CalculateContrast(_DarkSideContrast,temp_cast_4) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			o.Emission = ( _DarkSideEmission * ( 1.0 - clampResult43 ) ).rgb;
			o.Smoothness = _CloudSmoothness;
			float2 temp_output_4_0_g3 = (( i.uv_texcoord / _Size )).xy;
			float2 temp_cast_7 = (_FlowStrength).xx;
			float2 temp_output_17_0_g3 = temp_cast_7;
			float mulTime22_g3 = _Time.y * _FlowSpeed;
			float temp_output_27_0_g3 = frac( mulTime22_g3 );
			float2 temp_output_11_0_g3 = ( temp_output_4_0_g3 + ( -(tex2DNode275.rg*2.0 + -1.0) * temp_output_17_0_g3 * temp_output_27_0_g3 ) );
			float2 temp_output_12_0_g3 = ( temp_output_4_0_g3 + ( -(tex2DNode275.rg*2.0 + -1.0) * temp_output_17_0_g3 * frac( ( mulTime22_g3 + 0.5 ) ) ) );
			float4 lerpResult9_g3 = lerp( tex2D( _OpacityMap, temp_output_11_0_g3 ) , tex2D( _OpacityMap, temp_output_12_0_g3 ) , ( abs( ( temp_output_27_0_g3 - 0.5 ) ) / 0.5 ));
			float clampResult257 = clamp( _CloudMult , 0.0 , 1.0 );
			o.Alpha = ( lerpResult9_g3 * clampResult257 ).r;
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
			sampler3D _DitherMaskLOD;
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
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
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
Node;AmplifyShaderEditor.WorldNormalVector;16;3181.023,1603.131;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;15;3148.111,1446.831;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;22;3347.739,1749.554;Float;False;Property;_DarkSideContrast;DarkSide Contrast;9;0;Create;True;0;0;0;False;0;False;5;5;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;17;3416.117,1530.96;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;8;3668.854,1532.069;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;2;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;275;2775.275,777.4681;Inherit;True;Property;_FlowMap;FlowMap;12;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;280;2510.137,568.1581;Inherit;False;Property;_FlowSpeed;Flow Speed;14;0;Create;True;0;0;0;False;0;False;0.2;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;279;2525.796,469.0215;Inherit;False;Property;_FlowStrength;Flow Strength;13;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;272;2538.544,317.0116;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;273;2497.891,710.0049;Inherit;True;Property;_OpacityMap;OpacityMap;1;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;278;2543.129,46.81628;Inherit;True;Property;_NormalMap;NormalMap;10;0;Create;True;0;0;0;False;0;False;None;None;False;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;77;2955.733,-198.8176;Inherit;False;Property;_CloudMult;CloudMult;5;0;Create;True;0;0;0;False;0;False;1.5;1.5;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;250;3353.72,251.5887;Inherit;False;Property;_NormalValue;Normal Value;11;0;Create;True;0;0;0;False;0;False;0.08;0.08;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;43;3945.171,1532.766;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;252;3848.967,-53.33045;Float;False;Constant;_Color1;Color 1;0;0;Create;True;0;0;0;False;0;False;0,0,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;21;4128.392,1532.204;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;125;4070.328,1356.46;Inherit;False;Property;_DarkSideEmission;DarkSide Emission;8;0;Create;True;0;0;0;False;0;False;0.0464,0.0667,0.203,0;0.0464,0.0667,0.203,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;251;3936.411,192.4392;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;271;3213.003,654.1648;Inherit;False;Flow;2;;3;acad10cc8145e1f4eb8042bebe2d9a42;2,50,0,51,0;6;5;SAMPLER2D;;False;2;FLOAT2;0,0;False;55;FLOAT;1;False;18;FLOAT2;0,0;False;17;FLOAT2;0.02,0.02;False;24;FLOAT;0.2;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;277;3196.39,348.2198;Inherit;False;Flow;2;;4;acad10cc8145e1f4eb8042bebe2d9a42;2,50,0,51,0;6;5;SAMPLER2D;;False;2;FLOAT2;0,0;False;55;FLOAT;1;False;18;FLOAT2;0,0;False;17;FLOAT2;0.02,0.02;False;24;FLOAT;0.2;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;257;3926.227,683.7377;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;118;3222.013,-411.1812;Inherit;False;Property;_CloudsBaseColor;Clouds BaseColor;0;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;123;3588.448,-338.8952;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;253;4118.018,90.81721;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;4310.549,1441.197;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;119;4014.17,469.5331;Inherit;False;Property;_CloudSmoothness;Cloud Smoothness;7;0;Create;True;0;0;0;False;0;False;0.2;0.3;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;256;4107.003,598.7786;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;234;4970.054,289.9847;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;CloudsShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;6;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;17;0;15;0
WireConnection;17;1;16;0
WireConnection;8;1;17;0
WireConnection;8;0;22;0
WireConnection;43;0;8;0
WireConnection;21;0;43;0
WireConnection;251;0;77;0
WireConnection;251;2;250;0
WireConnection;271;5;273;0
WireConnection;271;2;272;0
WireConnection;271;18;275;0
WireConnection;271;17;279;0
WireConnection;271;24;280;0
WireConnection;277;5;278;0
WireConnection;277;2;272;0
WireConnection;277;18;275;0
WireConnection;277;17;279;0
WireConnection;277;24;280;0
WireConnection;257;0;77;0
WireConnection;123;0;118;0
WireConnection;123;1;77;0
WireConnection;253;0;252;0
WireConnection;253;1;277;0
WireConnection;253;2;251;0
WireConnection;126;0;125;0
WireConnection;126;1;21;0
WireConnection;256;0;271;0
WireConnection;256;1;257;0
WireConnection;234;0;123;0
WireConnection;234;1;253;0
WireConnection;234;2;126;0
WireConnection;234;4;119;0
WireConnection;234;9;256;0
ASEEND*/
//CHKSM=E6B99D1CE9D70CE51147E942DC9517EDA9AED8B7