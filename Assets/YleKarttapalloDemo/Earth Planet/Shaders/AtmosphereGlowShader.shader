// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AtmosphereGlowShader"
{
	Properties
	{
		_GlowScaleOutside("GlowScale Outside", Range( 0 , 1)) = 0.6
		_GlowScaleInside("GlowScale Inside", Range( 0 , 1)) = 0.12
		_DarkSideMult("DarkSideMult", Range( 0 , 1)) = 0.022
		_DayNightContrast("DayNight Contrast", Range( 0 , 50)) = 4
		_AtmosphereColor("AtmosphereColor", Color) = (0.319749,0.5665256,0.7137255,1)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha noshadow 
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float4 _AtmosphereColor;
		uniform float _GlowScaleOutside;
		uniform float _GlowScaleInside;
		uniform float _DayNightContrast;
		uniform float _DarkSideMult;


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 temp_output_144_0 = _AtmosphereColor;
			o.Albedo = temp_output_144_0.rgb;
			o.Emission = temp_output_144_0.rgb;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV57 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode57 = ( 0.0 + ( ( 1.0 - _GlowScaleOutside ) * 20.0 ) * pow( 1.0 - fresnelNdotV57, 10.0 ) );
			float clampResult103 = clamp( fresnelNode57 , 0.0 , 1.0 );
			float fresnelNdotV101 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode101 = ( 0.0 + ( _GlowScaleInside * 20.0 ) * pow( 1.0 - fresnelNdotV101, 3.0 ) );
			float clampResult104 = clamp( fresnelNode101 , 0.0 , 1.0 );
			float temp_output_102_0 = ( ( 1.0 - clampResult103 ) * clampResult104 );
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult17 = dot( ase_worldlightDir , ase_worldNormal );
			float4 temp_cast_2 = (dotResult17).xxxx;
			float4 clampResult96 = clamp( CalculateContrast(_DayNightContrast,temp_cast_2) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float4 temp_cast_3 = (temp_output_102_0).xxxx;
			float4 lerpResult111 = lerp( ( temp_output_102_0 * clampResult96 ) , temp_cast_3 , _DarkSideMult);
			o.Alpha = lerpResult111.r;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
-2048;-184;2048;1099;-2499.121;95.9052;1.3;True;True
Node;AmplifyShaderEditor.RangedFloatNode;59;2593.541,788.6711;Inherit;False;Property;_GlowScaleOutside;GlowScale Outside;1;0;Create;True;0;0;0;False;0;False;0.6;0.6;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;107;2939.976,836.796;Inherit;False;Constant;_Float0;Float 0;5;0;Create;True;0;0;0;False;0;False;20;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;105;2943.876,714.5966;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;100;2610.099,1150.79;Inherit;False;Property;_GlowScaleInside;GlowScale Inside;2;0;Create;True;0;0;0;False;0;False;0.12;0.12;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;2866.942,972.3615;Inherit;False;Constant;_PowerAtmoOutside;PowerAtmoOutside;3;0;Create;True;0;0;0;False;0;False;10;10;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;3145.375,722.3966;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;108;3093.376,1146.196;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;57;3394.001,771.0703;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;15;3133.276,272.3289;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;16;3142.187,460.6284;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;99;2886.97,1317.595;Inherit;False;Constant;_PowerAtmoInside;PowerAtmoInside;2;0;Create;True;0;0;0;False;0;False;3;3;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;109;3354.339,601.6622;Float;False;Property;_DayNightContrast;DayNight Contrast;4;0;Create;True;0;0;0;False;0;False;4;4;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;101;3423.126,1099.402;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;103;3778.864,786.9008;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;17;3452.234,278.4997;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;94;3716.161,343.5614;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;97;4000.344,751.6274;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;104;3746.327,1121.234;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;96;4034.596,392.6775;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;4258.202,927.6207;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;4520.44,698.1922;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;112;4295.957,1228.718;Float;False;Property;_DarkSideMult;DarkSideMult;3;0;Create;True;0;0;0;False;0;False;0.022;0.22;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;111;4714.579,881.2089;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;144;4759.039,438.6942;Inherit;False;Property;_AtmosphereColor;AtmosphereColor;5;0;Create;True;0;0;0;False;0;False;0.319749,0.5665256,0.7137255,1;0.319749,0.5665256,0.7137255,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;154;5252.762,562.9863;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;AtmosphereGlowShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;105;0;59;0
WireConnection;106;0;105;0
WireConnection;106;1;107;0
WireConnection;108;0;100;0
WireConnection;108;1;107;0
WireConnection;57;2;106;0
WireConnection;57;3;60;0
WireConnection;101;2;108;0
WireConnection;101;3;99;0
WireConnection;103;0;57;0
WireConnection;17;0;15;0
WireConnection;17;1;16;0
WireConnection;94;1;17;0
WireConnection;94;0;109;0
WireConnection;97;0;103;0
WireConnection;104;0;101;0
WireConnection;96;0;94;0
WireConnection;102;0;97;0
WireConnection;102;1;104;0
WireConnection;110;0;102;0
WireConnection;110;1;96;0
WireConnection;111;0;110;0
WireConnection;111;1;102;0
WireConnection;111;2;112;0
WireConnection;154;0;144;0
WireConnection;154;2;144;0
WireConnection;154;9;111;0
ASEEND*/
//CHKSM=11E4312511AD86FA91E32DDBF085A9D3DCC7FB5C