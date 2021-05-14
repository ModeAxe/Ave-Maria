Shader "Clouds Shader Generated"
{
    Properties
    {
        Vector4_EA3B081F("Rotate Projection", Vector) = (1, 0, 0, 0)
        Vector1_71A7FF5A("Noise Scale", Float) = 10
        Vector1_C5E85E8B("Speed", Float) = 0.1
        Vector1_A79FC1E6("Noise Height", Float) = 100
        Vector4_22211085("Noise Remap", Vector) = (0, 1, -1, 1)
        Color_9FA214E7("Color", Color) = (0, 0, 0, 0)
        Color_36BC9028("Color (1)", Color) = (0, 0, 0, 0)
        Vector1_7CF2CE30("Noise Edge 1", Float) = 0
        Vector1_5595CFA0("Noise Edge 2", Float) = 1
        Vector1_508E7203("Noise Power", Float) = 1
        Vector1_2DEB2D7D("Base Scale", Float) = 0
        Vector1_E6FEB89A("Base Speed", Float) = 0
        Vector1_DED0BDAF("Base Multiply", Float) = 0
        Vector1_D22E6486("Emission Strength", Float) = 0
        Vector1_F1F4F87E("Curvature Radius", Float) = 0
        Vector1_C62B4221("Fresnel Power", Float) = 1
        Vector1_2A342589("Fresnel Opacity", Float) = 0
        Vector1_E25D06C1("Fade Depth", Float) = 100
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "Queue"="Transparent+0"
        }
        
        Pass
        {
            Name "Pass"
            Tags 
            { 
                // LightMode: <None>
            }
           
            // Render State
            Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
            Cull Off
            ZTest LEqual
            ZWrite On
            // ColorMask: <None>
            
        
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            // Pragmas
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0
            #pragma multi_compile_fog
            #pragma multi_compile_instancing
        
            // Keywords
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #pragma shader_feature _ _SAMPLE_GI
            // GraphKeywords: <None>
            
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define VARYINGS_NEED_POSITION_WS 
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_VIEWDIRECTION_WS
            #define FEATURES_GRAPH_VERTEX
            #define SHADERPASS_UNLIT
            #define REQUIRE_DEPTH_TEXTURE
        
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
            float4 Vector4_EA3B081F;
            float Vector1_71A7FF5A;
            float Vector1_C5E85E8B;
            float Vector1_A79FC1E6;
            float4 Vector4_22211085;
            float4 Color_9FA214E7;
            float4 Color_36BC9028;
            float Vector1_7CF2CE30;
            float Vector1_5595CFA0;
            float Vector1_508E7203;
            float Vector1_2DEB2D7D;
            float Vector1_E6FEB89A;
            float Vector1_DED0BDAF;
            float Vector1_D22E6486;
            float Vector1_F1F4F87E;
            float Vector1_C62B4221;
            float Vector1_2A342589;
            float Vector1_E25D06C1;
            CBUFFER_END
        
            // Graph Functions
            
            void Unity_Distance_float3(float3 A, float3 B, out float Out)
            {
                Out = distance(A, B);
            }
            
            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }
            
            void Unity_Divide_float(float A, float B, out float Out)
            {
                Out = A / B;
            }
            
            void Unity_Power_float(float A, float B, out float Out)
            {
                Out = pow(A, B);
            }
            
            void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
            {
                Out = A * B;
            }
            
            void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
            {
                Rotation = radians(Rotation);
            
                float s = sin(Rotation);
                float c = cos(Rotation);
                float one_minus_c = 1.0 - c;
                
                Axis = normalize(Axis);
            
                float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                          one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                          one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                        };
            
                Out = mul(rot_mat,  In);
            }
            
            void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
            {
                Out = UV * Tiling + Offset;
            }
            
            
            float2 Unity_GradientNoise_Dir_float(float2 p)
            {
                // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                p = p % 289;
                float x = (34 * p.x + 1) * p.x % 289 + p.y;
                x = (34 * x + 1) * x % 289;
                x = frac(x / 41) * 2 - 1;
                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
            }
            
            void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
            { 
                float2 p = UV * Scale;
                float2 ip = floor(p);
                float2 fp = frac(p);
                float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
            }
            
            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }
            
            void Unity_Saturate_float(float In, out float Out)
            {
                Out = saturate(In);
            }
            
            void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
            {
                RGBA = float4(R, G, B, A);
                RGB = float3(R, G, B);
                RG = float2(R, G);
            }
            
            void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
            {
                Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }
            
            void Unity_Absolute_float(float In, out float Out)
            {
                Out = abs(In);
            }
            
            void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
            {
                Out = smoothstep(Edge1, Edge2, In);
            }
            
            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A + B;
            }
            
            void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
            {
                Out = lerp(A, B, T);
            }
            
            void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
            {
                Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
            }
            
            void Unity_Add_float4(float4 A, float4 B, out float4 Out)
            {
                Out = A + B;
            }
            
            void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
            
            void Unity_Subtract_float(float A, float B, out float Out)
            {
                Out = A - B;
            }
        
            // Graph Vertex
            struct VertexDescriptionInputs
            {
                float3 ObjectSpaceNormal;
                float3 WorldSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 ObjectSpacePosition;
                float3 WorldSpacePosition;
                float3 AbsoluteWorldSpacePosition;
                float3 TimeParameters;
            };
            
            struct VertexDescription
            {
                float3 VertexPosition;
                float3 VertexNormal;
                float3 VertexTangent;
            };
            
            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
            {
                VertexDescription description = (VertexDescription)0;
                float _Distance_F0F5E424_Out_2;
                Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.AbsoluteWorldSpacePosition, _Distance_F0F5E424_Out_2);
                float _Property_8A7706DD_Out_0 = Vector1_F1F4F87E;
                float _Multiply_DFA4A11_Out_2;
                Unity_Multiply_float(_Property_8A7706DD_Out_0, -1, _Multiply_DFA4A11_Out_2);
                float _Divide_80FC584A_Out_2;
                Unity_Divide_float(_Distance_F0F5E424_Out_2, _Multiply_DFA4A11_Out_2, _Divide_80FC584A_Out_2);
                float _Power_AB9D6701_Out_2;
                Unity_Power_float(_Divide_80FC584A_Out_2, 3, _Power_AB9D6701_Out_2);
                float3 _Multiply_6A2DE76C_Out_2;
                Unity_Multiply_float(IN.WorldSpaceNormal, (_Power_AB9D6701_Out_2.xxx), _Multiply_6A2DE76C_Out_2);
                float4 _Property_94F4C4FD_Out_0 = Vector4_EA3B081F;
                float _Split_87C0782E_R_1 = _Property_94F4C4FD_Out_0[0];
                float _Split_87C0782E_G_2 = _Property_94F4C4FD_Out_0[1];
                float _Split_87C0782E_B_3 = _Property_94F4C4FD_Out_0[2];
                float _Split_87C0782E_A_4 = _Property_94F4C4FD_Out_0[3];
                float3 _RotateAboutAxis_ABDA32C_Out_3;
                Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_94F4C4FD_Out_0.xyz), _Split_87C0782E_A_4, _RotateAboutAxis_ABDA32C_Out_3);
                float _Property_4FDF37D2_Out_0 = Vector1_E6FEB89A;
                float _Multiply_CA1BFBD0_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_4FDF37D2_Out_0, _Multiply_CA1BFBD0_Out_2);
                float2 _TilingAndOffset_3106F081_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_ABDA32C_Out_3.xy), float2 (1, 1), (_Multiply_CA1BFBD0_Out_2.xx), _TilingAndOffset_3106F081_Out_3);
                float _Property_D336AB24_Out_0 = Vector1_2DEB2D7D;
                float _GradientNoise_E52C846A_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_3106F081_Out_3, _Property_D336AB24_Out_0, _GradientNoise_E52C846A_Out_2);
                float _Property_1D82C75E_Out_0 = Vector1_DED0BDAF;
                float _Multiply_8F42B7FE_Out_2;
                Unity_Multiply_float(_GradientNoise_E52C846A_Out_2, _Property_1D82C75E_Out_0, _Multiply_8F42B7FE_Out_2);
                float _Property_46440021_Out_0 = Vector1_7CF2CE30;
                float _Property_252FC48E_Out_0 = Vector1_5595CFA0;
                float _Property_79D3B95A_Out_0 = Vector1_C5E85E8B;
                float _Multiply_A43E9D22_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_79D3B95A_Out_0, _Multiply_A43E9D22_Out_2);
                float2 _TilingAndOffset_727FD81C_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_ABDA32C_Out_3.xy), float2 (1, 1), (_Multiply_A43E9D22_Out_2.xx), _TilingAndOffset_727FD81C_Out_3);
                float _Property_1A5FB65E_Out_0 = Vector1_71A7FF5A;
                float _GradientNoise_8743D481_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_727FD81C_Out_3, _Property_1A5FB65E_Out_0, _GradientNoise_8743D481_Out_2);
                float2 _TilingAndOffset_BF1FF52B_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_ABDA32C_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_BF1FF52B_Out_3);
                float _GradientNoise_9ADEB057_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_BF1FF52B_Out_3, _Property_1A5FB65E_Out_0, _GradientNoise_9ADEB057_Out_2);
                float _Add_D4D5F447_Out_2;
                Unity_Add_float(_GradientNoise_8743D481_Out_2, _GradientNoise_9ADEB057_Out_2, _Add_D4D5F447_Out_2);
                float _Divide_527C5225_Out_2;
                Unity_Divide_float(_Add_D4D5F447_Out_2, 2, _Divide_527C5225_Out_2);
                float _Saturate_11D50A5B_Out_1;
                Unity_Saturate_float(_Divide_527C5225_Out_2, _Saturate_11D50A5B_Out_1);
                float _Property_35E9C15A_Out_0 = Vector1_508E7203;
                float _Power_B25FD97D_Out_2;
                Unity_Power_float(_Saturate_11D50A5B_Out_1, _Property_35E9C15A_Out_0, _Power_B25FD97D_Out_2);
                float4 _Property_B4869C3_Out_0 = Vector4_22211085;
                float _Split_A33FF8FB_R_1 = _Property_B4869C3_Out_0[0];
                float _Split_A33FF8FB_G_2 = _Property_B4869C3_Out_0[1];
                float _Split_A33FF8FB_B_3 = _Property_B4869C3_Out_0[2];
                float _Split_A33FF8FB_A_4 = _Property_B4869C3_Out_0[3];
                float4 _Combine_51C2B9E4_RGBA_4;
                float3 _Combine_51C2B9E4_RGB_5;
                float2 _Combine_51C2B9E4_RG_6;
                Unity_Combine_float(_Split_A33FF8FB_R_1, _Split_A33FF8FB_G_2, 0, 0, _Combine_51C2B9E4_RGBA_4, _Combine_51C2B9E4_RGB_5, _Combine_51C2B9E4_RG_6);
                float4 _Combine_D8E089FC_RGBA_4;
                float3 _Combine_D8E089FC_RGB_5;
                float2 _Combine_D8E089FC_RG_6;
                Unity_Combine_float(_Split_A33FF8FB_B_3, _Split_A33FF8FB_A_4, 0, 0, _Combine_D8E089FC_RGBA_4, _Combine_D8E089FC_RGB_5, _Combine_D8E089FC_RG_6);
                float _Remap_85EB9253_Out_3;
                Unity_Remap_float(_Power_B25FD97D_Out_2, _Combine_51C2B9E4_RG_6, _Combine_D8E089FC_RG_6, _Remap_85EB9253_Out_3);
                float _Absolute_97E4DBF2_Out_1;
                Unity_Absolute_float(_Remap_85EB9253_Out_3, _Absolute_97E4DBF2_Out_1);
                float _Smoothstep_40D99020_Out_3;
                Unity_Smoothstep_float(_Property_46440021_Out_0, _Property_252FC48E_Out_0, _Absolute_97E4DBF2_Out_1, _Smoothstep_40D99020_Out_3);
                float _Add_2AD089A4_Out_2;
                Unity_Add_float(_Multiply_8F42B7FE_Out_2, _Smoothstep_40D99020_Out_3, _Add_2AD089A4_Out_2);
                float _Add_71E55AC0_Out_2;
                Unity_Add_float(1, _Multiply_8F42B7FE_Out_2, _Add_71E55AC0_Out_2);
                float _Divide_D8DEA7C4_Out_2;
                Unity_Divide_float(_Add_2AD089A4_Out_2, _Add_71E55AC0_Out_2, _Divide_D8DEA7C4_Out_2);
                float3 _Multiply_8C2DA5AB_Out_2;
                Unity_Multiply_float(IN.ObjectSpaceNormal, (_Divide_D8DEA7C4_Out_2.xxx), _Multiply_8C2DA5AB_Out_2);
                float _Property_B74280B2_Out_0 = Vector1_A79FC1E6;
                float3 _Multiply_C05CC6CA_Out_2;
                Unity_Multiply_float(_Multiply_8C2DA5AB_Out_2, (_Property_B74280B2_Out_0.xxx), _Multiply_C05CC6CA_Out_2);
                float3 _Add_45F8B139_Out_2;
                Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_C05CC6CA_Out_2, _Add_45F8B139_Out_2);
                float3 _Add_66BED545_Out_2;
                Unity_Add_float3(_Multiply_6A2DE76C_Out_2, _Add_45F8B139_Out_2, _Add_66BED545_Out_2);
                description.VertexPosition = _Add_66BED545_Out_2;
                description.VertexNormal = IN.ObjectSpaceNormal;
                description.VertexTangent = IN.ObjectSpaceTangent;
                return description;
            }
            
            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float3 WorldSpaceNormal;
                float3 WorldSpaceViewDirection;
                float3 WorldSpacePosition;
                float4 ScreenPosition;
                float3 TimeParameters;
            };
            
            struct SurfaceDescription
            {
                float3 Color;
                float Alpha;
                float AlphaClipThreshold;
            };
            
            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float4 _Property_5367049E_Out_0 = Color_36BC9028;
                float4 _Property_C9E3B200_Out_0 = Color_9FA214E7;
                float4 _Property_94F4C4FD_Out_0 = Vector4_EA3B081F;
                float _Split_87C0782E_R_1 = _Property_94F4C4FD_Out_0[0];
                float _Split_87C0782E_G_2 = _Property_94F4C4FD_Out_0[1];
                float _Split_87C0782E_B_3 = _Property_94F4C4FD_Out_0[2];
                float _Split_87C0782E_A_4 = _Property_94F4C4FD_Out_0[3];
                float3 _RotateAboutAxis_ABDA32C_Out_3;
                Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_94F4C4FD_Out_0.xyz), _Split_87C0782E_A_4, _RotateAboutAxis_ABDA32C_Out_3);
                float _Property_4FDF37D2_Out_0 = Vector1_E6FEB89A;
                float _Multiply_CA1BFBD0_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_4FDF37D2_Out_0, _Multiply_CA1BFBD0_Out_2);
                float2 _TilingAndOffset_3106F081_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_ABDA32C_Out_3.xy), float2 (1, 1), (_Multiply_CA1BFBD0_Out_2.xx), _TilingAndOffset_3106F081_Out_3);
                float _Property_D336AB24_Out_0 = Vector1_2DEB2D7D;
                float _GradientNoise_E52C846A_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_3106F081_Out_3, _Property_D336AB24_Out_0, _GradientNoise_E52C846A_Out_2);
                float _Property_1D82C75E_Out_0 = Vector1_DED0BDAF;
                float _Multiply_8F42B7FE_Out_2;
                Unity_Multiply_float(_GradientNoise_E52C846A_Out_2, _Property_1D82C75E_Out_0, _Multiply_8F42B7FE_Out_2);
                float _Property_46440021_Out_0 = Vector1_7CF2CE30;
                float _Property_252FC48E_Out_0 = Vector1_5595CFA0;
                float _Property_79D3B95A_Out_0 = Vector1_C5E85E8B;
                float _Multiply_A43E9D22_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_79D3B95A_Out_0, _Multiply_A43E9D22_Out_2);
                float2 _TilingAndOffset_727FD81C_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_ABDA32C_Out_3.xy), float2 (1, 1), (_Multiply_A43E9D22_Out_2.xx), _TilingAndOffset_727FD81C_Out_3);
                float _Property_1A5FB65E_Out_0 = Vector1_71A7FF5A;
                float _GradientNoise_8743D481_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_727FD81C_Out_3, _Property_1A5FB65E_Out_0, _GradientNoise_8743D481_Out_2);
                float2 _TilingAndOffset_BF1FF52B_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_ABDA32C_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_BF1FF52B_Out_3);
                float _GradientNoise_9ADEB057_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_BF1FF52B_Out_3, _Property_1A5FB65E_Out_0, _GradientNoise_9ADEB057_Out_2);
                float _Add_D4D5F447_Out_2;
                Unity_Add_float(_GradientNoise_8743D481_Out_2, _GradientNoise_9ADEB057_Out_2, _Add_D4D5F447_Out_2);
                float _Divide_527C5225_Out_2;
                Unity_Divide_float(_Add_D4D5F447_Out_2, 2, _Divide_527C5225_Out_2);
                float _Saturate_11D50A5B_Out_1;
                Unity_Saturate_float(_Divide_527C5225_Out_2, _Saturate_11D50A5B_Out_1);
                float _Property_35E9C15A_Out_0 = Vector1_508E7203;
                float _Power_B25FD97D_Out_2;
                Unity_Power_float(_Saturate_11D50A5B_Out_1, _Property_35E9C15A_Out_0, _Power_B25FD97D_Out_2);
                float4 _Property_B4869C3_Out_0 = Vector4_22211085;
                float _Split_A33FF8FB_R_1 = _Property_B4869C3_Out_0[0];
                float _Split_A33FF8FB_G_2 = _Property_B4869C3_Out_0[1];
                float _Split_A33FF8FB_B_3 = _Property_B4869C3_Out_0[2];
                float _Split_A33FF8FB_A_4 = _Property_B4869C3_Out_0[3];
                float4 _Combine_51C2B9E4_RGBA_4;
                float3 _Combine_51C2B9E4_RGB_5;
                float2 _Combine_51C2B9E4_RG_6;
                Unity_Combine_float(_Split_A33FF8FB_R_1, _Split_A33FF8FB_G_2, 0, 0, _Combine_51C2B9E4_RGBA_4, _Combine_51C2B9E4_RGB_5, _Combine_51C2B9E4_RG_6);
                float4 _Combine_D8E089FC_RGBA_4;
                float3 _Combine_D8E089FC_RGB_5;
                float2 _Combine_D8E089FC_RG_6;
                Unity_Combine_float(_Split_A33FF8FB_B_3, _Split_A33FF8FB_A_4, 0, 0, _Combine_D8E089FC_RGBA_4, _Combine_D8E089FC_RGB_5, _Combine_D8E089FC_RG_6);
                float _Remap_85EB9253_Out_3;
                Unity_Remap_float(_Power_B25FD97D_Out_2, _Combine_51C2B9E4_RG_6, _Combine_D8E089FC_RG_6, _Remap_85EB9253_Out_3);
                float _Absolute_97E4DBF2_Out_1;
                Unity_Absolute_float(_Remap_85EB9253_Out_3, _Absolute_97E4DBF2_Out_1);
                float _Smoothstep_40D99020_Out_3;
                Unity_Smoothstep_float(_Property_46440021_Out_0, _Property_252FC48E_Out_0, _Absolute_97E4DBF2_Out_1, _Smoothstep_40D99020_Out_3);
                float _Add_2AD089A4_Out_2;
                Unity_Add_float(_Multiply_8F42B7FE_Out_2, _Smoothstep_40D99020_Out_3, _Add_2AD089A4_Out_2);
                float _Add_71E55AC0_Out_2;
                Unity_Add_float(1, _Multiply_8F42B7FE_Out_2, _Add_71E55AC0_Out_2);
                float _Divide_D8DEA7C4_Out_2;
                Unity_Divide_float(_Add_2AD089A4_Out_2, _Add_71E55AC0_Out_2, _Divide_D8DEA7C4_Out_2);
                float4 _Lerp_79DC53D3_Out_3;
                Unity_Lerp_float4(_Property_5367049E_Out_0, _Property_C9E3B200_Out_0, (_Divide_D8DEA7C4_Out_2.xxxx), _Lerp_79DC53D3_Out_3);
                float _Property_8343853D_Out_0 = Vector1_C62B4221;
                float _FresnelEffect_EC153EBC_Out_3;
                Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_8343853D_Out_0, _FresnelEffect_EC153EBC_Out_3);
                float _Multiply_35EE3023_Out_2;
                Unity_Multiply_float(_Divide_D8DEA7C4_Out_2, _FresnelEffect_EC153EBC_Out_3, _Multiply_35EE3023_Out_2);
                float _Property_556DE93C_Out_0 = Vector1_2A342589;
                float _Multiply_C4C8A7FD_Out_2;
                Unity_Multiply_float(_Multiply_35EE3023_Out_2, _Property_556DE93C_Out_0, _Multiply_C4C8A7FD_Out_2);
                float4 _Add_9DC7389_Out_2;
                Unity_Add_float4(_Lerp_79DC53D3_Out_3, (_Multiply_C4C8A7FD_Out_2.xxxx), _Add_9DC7389_Out_2);
                float _SceneDepth_C00364BD_Out_1;
                Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_C00364BD_Out_1);
                float4 _ScreenPosition_CB63B171_Out_0 = IN.ScreenPosition;
                float _Split_E096E914_R_1 = _ScreenPosition_CB63B171_Out_0[0];
                float _Split_E096E914_G_2 = _ScreenPosition_CB63B171_Out_0[1];
                float _Split_E096E914_B_3 = _ScreenPosition_CB63B171_Out_0[2];
                float _Split_E096E914_A_4 = _ScreenPosition_CB63B171_Out_0[3];
                float _Subtract_FD88142A_Out_2;
                Unity_Subtract_float(_Split_E096E914_A_4, 1, _Subtract_FD88142A_Out_2);
                float _Subtract_41F7E55C_Out_2;
                Unity_Subtract_float(_SceneDepth_C00364BD_Out_1, _Subtract_FD88142A_Out_2, _Subtract_41F7E55C_Out_2);
                float _Property_C7646A5E_Out_0 = Vector1_E25D06C1;
                float _Divide_609BD502_Out_2;
                Unity_Divide_float(_Subtract_41F7E55C_Out_2, _Property_C7646A5E_Out_0, _Divide_609BD502_Out_2);
                float _Saturate_BD4BAC2F_Out_1;
                Unity_Saturate_float(_Divide_609BD502_Out_2, _Saturate_BD4BAC2F_Out_1);
                surface.Color = (_Add_9DC7389_Out_2.xyz);
                surface.Alpha = _Saturate_BD4BAC2F_Out_1;
                surface.AlphaClipThreshold = 0;
                return surface;
            }
        
            // --------------------------------------------------
            // Structs and Packing
        
            // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
        
            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 positionWS;
                float3 normalWS;
                float3 viewDirectionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_POSITION;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                float3 interp00 : TEXCOORD0;
                float3 interp01 : TEXCOORD1;
                float3 interp02 : TEXCOORD2;
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output = (PackedVaryings)0;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionWS;
                output.interp01.xyz = input.normalWS;
                output.interp02.xyz = input.viewDirectionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
            
            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output = (Varyings)0;
                output.positionCS = input.positionCS;
                output.positionWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                output.viewDirectionWS = input.interp02.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
                output.ObjectSpaceTangent =          input.tangentOS;
                output.ObjectSpacePosition =         input.positionOS;
                output.WorldSpacePosition =          TransformObjectToWorld(input.positionOS);
                output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(TransformObjectToWorld(input.positionOS));
                output.TimeParameters =              _TimeParameters.xyz;
            
                return output;
            }
            
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
            	// must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            	float3 unnormalizedNormalWS = input.normalWS;
                const float renormFactor = 1.0 / length(unnormalizedNormalWS);
            
            
                output.WorldSpaceNormal =            renormFactor*input.normalWS.xyz;		// we want a unit length Normal Vector node in shader graph
            
            
                output.WorldSpaceViewDirection =     input.viewDirectionWS; //TODO: by default normalized in HD, but not in universal
                output.WorldSpacePosition =          input.positionWS;
                output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
                output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
            #else
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            #endif
            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            
                return output;
            }
            
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/UnlitPass.hlsl"
        
            ENDHLSL
        }
        
        Pass
        {
            Name "ShadowCaster"
            Tags 
            { 
                "LightMode" = "ShadowCaster"
            }
           
            // Render State
            Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
            Cull Off
            ZTest LEqual
            ZWrite On
            // ColorMask: <None>
            
        
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            // Pragmas
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0
            #pragma multi_compile_instancing
        
            // Keywords
            #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            // GraphKeywords: <None>
            
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define VARYINGS_NEED_POSITION_WS 
            #define FEATURES_GRAPH_VERTEX
            #define SHADERPASS_SHADOWCASTER
            #define REQUIRE_DEPTH_TEXTURE
        
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
            float4 Vector4_EA3B081F;
            float Vector1_71A7FF5A;
            float Vector1_C5E85E8B;
            float Vector1_A79FC1E6;
            float4 Vector4_22211085;
            float4 Color_9FA214E7;
            float4 Color_36BC9028;
            float Vector1_7CF2CE30;
            float Vector1_5595CFA0;
            float Vector1_508E7203;
            float Vector1_2DEB2D7D;
            float Vector1_E6FEB89A;
            float Vector1_DED0BDAF;
            float Vector1_D22E6486;
            float Vector1_F1F4F87E;
            float Vector1_C62B4221;
            float Vector1_2A342589;
            float Vector1_E25D06C1;
            CBUFFER_END
        
            // Graph Functions
            
            void Unity_Distance_float3(float3 A, float3 B, out float Out)
            {
                Out = distance(A, B);
            }
            
            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }
            
            void Unity_Divide_float(float A, float B, out float Out)
            {
                Out = A / B;
            }
            
            void Unity_Power_float(float A, float B, out float Out)
            {
                Out = pow(A, B);
            }
            
            void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
            {
                Out = A * B;
            }
            
            void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
            {
                Rotation = radians(Rotation);
            
                float s = sin(Rotation);
                float c = cos(Rotation);
                float one_minus_c = 1.0 - c;
                
                Axis = normalize(Axis);
            
                float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                          one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                          one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                        };
            
                Out = mul(rot_mat,  In);
            }
            
            void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
            {
                Out = UV * Tiling + Offset;
            }
            
            
            float2 Unity_GradientNoise_Dir_float(float2 p)
            {
                // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                p = p % 289;
                float x = (34 * p.x + 1) * p.x % 289 + p.y;
                x = (34 * x + 1) * x % 289;
                x = frac(x / 41) * 2 - 1;
                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
            }
            
            void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
            { 
                float2 p = UV * Scale;
                float2 ip = floor(p);
                float2 fp = frac(p);
                float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
            }
            
            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }
            
            void Unity_Saturate_float(float In, out float Out)
            {
                Out = saturate(In);
            }
            
            void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
            {
                RGBA = float4(R, G, B, A);
                RGB = float3(R, G, B);
                RG = float2(R, G);
            }
            
            void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
            {
                Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }
            
            void Unity_Absolute_float(float In, out float Out)
            {
                Out = abs(In);
            }
            
            void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
            {
                Out = smoothstep(Edge1, Edge2, In);
            }
            
            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A + B;
            }
            
            void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
            
            void Unity_Subtract_float(float A, float B, out float Out)
            {
                Out = A - B;
            }
        
            // Graph Vertex
            struct VertexDescriptionInputs
            {
                float3 ObjectSpaceNormal;
                float3 WorldSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 ObjectSpacePosition;
                float3 WorldSpacePosition;
                float3 AbsoluteWorldSpacePosition;
                float3 TimeParameters;
            };
            
            struct VertexDescription
            {
                float3 VertexPosition;
                float3 VertexNormal;
                float3 VertexTangent;
            };
            
            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
            {
                VertexDescription description = (VertexDescription)0;
                float _Distance_F0F5E424_Out_2;
                Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.AbsoluteWorldSpacePosition, _Distance_F0F5E424_Out_2);
                float _Property_8A7706DD_Out_0 = Vector1_F1F4F87E;
                float _Multiply_DFA4A11_Out_2;
                Unity_Multiply_float(_Property_8A7706DD_Out_0, -1, _Multiply_DFA4A11_Out_2);
                float _Divide_80FC584A_Out_2;
                Unity_Divide_float(_Distance_F0F5E424_Out_2, _Multiply_DFA4A11_Out_2, _Divide_80FC584A_Out_2);
                float _Power_AB9D6701_Out_2;
                Unity_Power_float(_Divide_80FC584A_Out_2, 3, _Power_AB9D6701_Out_2);
                float3 _Multiply_6A2DE76C_Out_2;
                Unity_Multiply_float(IN.WorldSpaceNormal, (_Power_AB9D6701_Out_2.xxx), _Multiply_6A2DE76C_Out_2);
                float4 _Property_94F4C4FD_Out_0 = Vector4_EA3B081F;
                float _Split_87C0782E_R_1 = _Property_94F4C4FD_Out_0[0];
                float _Split_87C0782E_G_2 = _Property_94F4C4FD_Out_0[1];
                float _Split_87C0782E_B_3 = _Property_94F4C4FD_Out_0[2];
                float _Split_87C0782E_A_4 = _Property_94F4C4FD_Out_0[3];
                float3 _RotateAboutAxis_ABDA32C_Out_3;
                Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_94F4C4FD_Out_0.xyz), _Split_87C0782E_A_4, _RotateAboutAxis_ABDA32C_Out_3);
                float _Property_4FDF37D2_Out_0 = Vector1_E6FEB89A;
                float _Multiply_CA1BFBD0_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_4FDF37D2_Out_0, _Multiply_CA1BFBD0_Out_2);
                float2 _TilingAndOffset_3106F081_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_ABDA32C_Out_3.xy), float2 (1, 1), (_Multiply_CA1BFBD0_Out_2.xx), _TilingAndOffset_3106F081_Out_3);
                float _Property_D336AB24_Out_0 = Vector1_2DEB2D7D;
                float _GradientNoise_E52C846A_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_3106F081_Out_3, _Property_D336AB24_Out_0, _GradientNoise_E52C846A_Out_2);
                float _Property_1D82C75E_Out_0 = Vector1_DED0BDAF;
                float _Multiply_8F42B7FE_Out_2;
                Unity_Multiply_float(_GradientNoise_E52C846A_Out_2, _Property_1D82C75E_Out_0, _Multiply_8F42B7FE_Out_2);
                float _Property_46440021_Out_0 = Vector1_7CF2CE30;
                float _Property_252FC48E_Out_0 = Vector1_5595CFA0;
                float _Property_79D3B95A_Out_0 = Vector1_C5E85E8B;
                float _Multiply_A43E9D22_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_79D3B95A_Out_0, _Multiply_A43E9D22_Out_2);
                float2 _TilingAndOffset_727FD81C_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_ABDA32C_Out_3.xy), float2 (1, 1), (_Multiply_A43E9D22_Out_2.xx), _TilingAndOffset_727FD81C_Out_3);
                float _Property_1A5FB65E_Out_0 = Vector1_71A7FF5A;
                float _GradientNoise_8743D481_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_727FD81C_Out_3, _Property_1A5FB65E_Out_0, _GradientNoise_8743D481_Out_2);
                float2 _TilingAndOffset_BF1FF52B_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_ABDA32C_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_BF1FF52B_Out_3);
                float _GradientNoise_9ADEB057_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_BF1FF52B_Out_3, _Property_1A5FB65E_Out_0, _GradientNoise_9ADEB057_Out_2);
                float _Add_D4D5F447_Out_2;
                Unity_Add_float(_GradientNoise_8743D481_Out_2, _GradientNoise_9ADEB057_Out_2, _Add_D4D5F447_Out_2);
                float _Divide_527C5225_Out_2;
                Unity_Divide_float(_Add_D4D5F447_Out_2, 2, _Divide_527C5225_Out_2);
                float _Saturate_11D50A5B_Out_1;
                Unity_Saturate_float(_Divide_527C5225_Out_2, _Saturate_11D50A5B_Out_1);
                float _Property_35E9C15A_Out_0 = Vector1_508E7203;
                float _Power_B25FD97D_Out_2;
                Unity_Power_float(_Saturate_11D50A5B_Out_1, _Property_35E9C15A_Out_0, _Power_B25FD97D_Out_2);
                float4 _Property_B4869C3_Out_0 = Vector4_22211085;
                float _Split_A33FF8FB_R_1 = _Property_B4869C3_Out_0[0];
                float _Split_A33FF8FB_G_2 = _Property_B4869C3_Out_0[1];
                float _Split_A33FF8FB_B_3 = _Property_B4869C3_Out_0[2];
                float _Split_A33FF8FB_A_4 = _Property_B4869C3_Out_0[3];
                float4 _Combine_51C2B9E4_RGBA_4;
                float3 _Combine_51C2B9E4_RGB_5;
                float2 _Combine_51C2B9E4_RG_6;
                Unity_Combine_float(_Split_A33FF8FB_R_1, _Split_A33FF8FB_G_2, 0, 0, _Combine_51C2B9E4_RGBA_4, _Combine_51C2B9E4_RGB_5, _Combine_51C2B9E4_RG_6);
                float4 _Combine_D8E089FC_RGBA_4;
                float3 _Combine_D8E089FC_RGB_5;
                float2 _Combine_D8E089FC_RG_6;
                Unity_Combine_float(_Split_A33FF8FB_B_3, _Split_A33FF8FB_A_4, 0, 0, _Combine_D8E089FC_RGBA_4, _Combine_D8E089FC_RGB_5, _Combine_D8E089FC_RG_6);
                float _Remap_85EB9253_Out_3;
                Unity_Remap_float(_Power_B25FD97D_Out_2, _Combine_51C2B9E4_RG_6, _Combine_D8E089FC_RG_6, _Remap_85EB9253_Out_3);
                float _Absolute_97E4DBF2_Out_1;
                Unity_Absolute_float(_Remap_85EB9253_Out_3, _Absolute_97E4DBF2_Out_1);
                float _Smoothstep_40D99020_Out_3;
                Unity_Smoothstep_float(_Property_46440021_Out_0, _Property_252FC48E_Out_0, _Absolute_97E4DBF2_Out_1, _Smoothstep_40D99020_Out_3);
                float _Add_2AD089A4_Out_2;
                Unity_Add_float(_Multiply_8F42B7FE_Out_2, _Smoothstep_40D99020_Out_3, _Add_2AD089A4_Out_2);
                float _Add_71E55AC0_Out_2;
                Unity_Add_float(1, _Multiply_8F42B7FE_Out_2, _Add_71E55AC0_Out_2);
                float _Divide_D8DEA7C4_Out_2;
                Unity_Divide_float(_Add_2AD089A4_Out_2, _Add_71E55AC0_Out_2, _Divide_D8DEA7C4_Out_2);
                float3 _Multiply_8C2DA5AB_Out_2;
                Unity_Multiply_float(IN.ObjectSpaceNormal, (_Divide_D8DEA7C4_Out_2.xxx), _Multiply_8C2DA5AB_Out_2);
                float _Property_B74280B2_Out_0 = Vector1_A79FC1E6;
                float3 _Multiply_C05CC6CA_Out_2;
                Unity_Multiply_float(_Multiply_8C2DA5AB_Out_2, (_Property_B74280B2_Out_0.xxx), _Multiply_C05CC6CA_Out_2);
                float3 _Add_45F8B139_Out_2;
                Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_C05CC6CA_Out_2, _Add_45F8B139_Out_2);
                float3 _Add_66BED545_Out_2;
                Unity_Add_float3(_Multiply_6A2DE76C_Out_2, _Add_45F8B139_Out_2, _Add_66BED545_Out_2);
                description.VertexPosition = _Add_66BED545_Out_2;
                description.VertexNormal = IN.ObjectSpaceNormal;
                description.VertexTangent = IN.ObjectSpaceTangent;
                return description;
            }
            
            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float3 WorldSpacePosition;
                float4 ScreenPosition;
            };
            
            struct SurfaceDescription
            {
                float Alpha;
                float AlphaClipThreshold;
            };
            
            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float _SceneDepth_C00364BD_Out_1;
                Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_C00364BD_Out_1);
                float4 _ScreenPosition_CB63B171_Out_0 = IN.ScreenPosition;
                float _Split_E096E914_R_1 = _ScreenPosition_CB63B171_Out_0[0];
                float _Split_E096E914_G_2 = _ScreenPosition_CB63B171_Out_0[1];
                float _Split_E096E914_B_3 = _ScreenPosition_CB63B171_Out_0[2];
                float _Split_E096E914_A_4 = _ScreenPosition_CB63B171_Out_0[3];
                float _Subtract_FD88142A_Out_2;
                Unity_Subtract_float(_Split_E096E914_A_4, 1, _Subtract_FD88142A_Out_2);
                float _Subtract_41F7E55C_Out_2;
                Unity_Subtract_float(_SceneDepth_C00364BD_Out_1, _Subtract_FD88142A_Out_2, _Subtract_41F7E55C_Out_2);
                float _Property_C7646A5E_Out_0 = Vector1_E25D06C1;
                float _Divide_609BD502_Out_2;
                Unity_Divide_float(_Subtract_41F7E55C_Out_2, _Property_C7646A5E_Out_0, _Divide_609BD502_Out_2);
                float _Saturate_BD4BAC2F_Out_1;
                Unity_Saturate_float(_Divide_609BD502_Out_2, _Saturate_BD4BAC2F_Out_1);
                surface.Alpha = _Saturate_BD4BAC2F_Out_1;
                surface.AlphaClipThreshold = 0;
                return surface;
            }
        
            // --------------------------------------------------
            // Structs and Packing
        
            // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
        
            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 positionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_POSITION;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                float3 interp00 : TEXCOORD0;
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output = (PackedVaryings)0;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
            
            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output = (Varyings)0;
                output.positionCS = input.positionCS;
                output.positionWS = input.interp00.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
                output.ObjectSpaceTangent =          input.tangentOS;
                output.ObjectSpacePosition =         input.positionOS;
                output.WorldSpacePosition =          TransformObjectToWorld(input.positionOS);
                output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(TransformObjectToWorld(input.positionOS));
                output.TimeParameters =              _TimeParameters.xyz;
            
                return output;
            }
            
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
            
            
            
            
                output.WorldSpacePosition =          input.positionWS;
                output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
            #else
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            #endif
            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            
                return output;
            }
            
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
            ENDHLSL
        }
        
        Pass
        {
            Name "DepthOnly"
            Tags 
            { 
                "LightMode" = "DepthOnly"
            }
           
            // Render State
            Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
            Cull Off
            ZTest LEqual
            ZWrite On
            ColorMask 0
            
        
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            // Pragmas
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0
            #pragma multi_compile_instancing
        
            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>
            
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define VARYINGS_NEED_POSITION_WS 
            #define FEATURES_GRAPH_VERTEX
            #define SHADERPASS_DEPTHONLY
            #define REQUIRE_DEPTH_TEXTURE
        
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
            float4 Vector4_EA3B081F;
            float Vector1_71A7FF5A;
            float Vector1_C5E85E8B;
            float Vector1_A79FC1E6;
            float4 Vector4_22211085;
            float4 Color_9FA214E7;
            float4 Color_36BC9028;
            float Vector1_7CF2CE30;
            float Vector1_5595CFA0;
            float Vector1_508E7203;
            float Vector1_2DEB2D7D;
            float Vector1_E6FEB89A;
            float Vector1_DED0BDAF;
            float Vector1_D22E6486;
            float Vector1_F1F4F87E;
            float Vector1_C62B4221;
            float Vector1_2A342589;
            float Vector1_E25D06C1;
            CBUFFER_END
        
            // Graph Functions
            
            void Unity_Distance_float3(float3 A, float3 B, out float Out)
            {
                Out = distance(A, B);
            }
            
            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }
            
            void Unity_Divide_float(float A, float B, out float Out)
            {
                Out = A / B;
            }
            
            void Unity_Power_float(float A, float B, out float Out)
            {
                Out = pow(A, B);
            }
            
            void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
            {
                Out = A * B;
            }
            
            void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
            {
                Rotation = radians(Rotation);
            
                float s = sin(Rotation);
                float c = cos(Rotation);
                float one_minus_c = 1.0 - c;
                
                Axis = normalize(Axis);
            
                float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                          one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                          one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                        };
            
                Out = mul(rot_mat,  In);
            }
            
            void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
            {
                Out = UV * Tiling + Offset;
            }
            
            
            float2 Unity_GradientNoise_Dir_float(float2 p)
            {
                // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                p = p % 289;
                float x = (34 * p.x + 1) * p.x % 289 + p.y;
                x = (34 * x + 1) * x % 289;
                x = frac(x / 41) * 2 - 1;
                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
            }
            
            void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
            { 
                float2 p = UV * Scale;
                float2 ip = floor(p);
                float2 fp = frac(p);
                float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
            }
            
            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }
            
            void Unity_Saturate_float(float In, out float Out)
            {
                Out = saturate(In);
            }
            
            void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
            {
                RGBA = float4(R, G, B, A);
                RGB = float3(R, G, B);
                RG = float2(R, G);
            }
            
            void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
            {
                Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }
            
            void Unity_Absolute_float(float In, out float Out)
            {
                Out = abs(In);
            }
            
            void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
            {
                Out = smoothstep(Edge1, Edge2, In);
            }
            
            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A + B;
            }
            
            void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
            
            void Unity_Subtract_float(float A, float B, out float Out)
            {
                Out = A - B;
            }
        
            // Graph Vertex
            struct VertexDescriptionInputs
            {
                float3 ObjectSpaceNormal;
                float3 WorldSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 ObjectSpacePosition;
                float3 WorldSpacePosition;
                float3 AbsoluteWorldSpacePosition;
                float3 TimeParameters;
            };
            
            struct VertexDescription
            {
                float3 VertexPosition;
                float3 VertexNormal;
                float3 VertexTangent;
            };
            
            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
            {
                VertexDescription description = (VertexDescription)0;
                float _Distance_F0F5E424_Out_2;
                Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.AbsoluteWorldSpacePosition, _Distance_F0F5E424_Out_2);
                float _Property_8A7706DD_Out_0 = Vector1_F1F4F87E;
                float _Multiply_DFA4A11_Out_2;
                Unity_Multiply_float(_Property_8A7706DD_Out_0, -1, _Multiply_DFA4A11_Out_2);
                float _Divide_80FC584A_Out_2;
                Unity_Divide_float(_Distance_F0F5E424_Out_2, _Multiply_DFA4A11_Out_2, _Divide_80FC584A_Out_2);
                float _Power_AB9D6701_Out_2;
                Unity_Power_float(_Divide_80FC584A_Out_2, 3, _Power_AB9D6701_Out_2);
                float3 _Multiply_6A2DE76C_Out_2;
                Unity_Multiply_float(IN.WorldSpaceNormal, (_Power_AB9D6701_Out_2.xxx), _Multiply_6A2DE76C_Out_2);
                float4 _Property_94F4C4FD_Out_0 = Vector4_EA3B081F;
                float _Split_87C0782E_R_1 = _Property_94F4C4FD_Out_0[0];
                float _Split_87C0782E_G_2 = _Property_94F4C4FD_Out_0[1];
                float _Split_87C0782E_B_3 = _Property_94F4C4FD_Out_0[2];
                float _Split_87C0782E_A_4 = _Property_94F4C4FD_Out_0[3];
                float3 _RotateAboutAxis_ABDA32C_Out_3;
                Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_94F4C4FD_Out_0.xyz), _Split_87C0782E_A_4, _RotateAboutAxis_ABDA32C_Out_3);
                float _Property_4FDF37D2_Out_0 = Vector1_E6FEB89A;
                float _Multiply_CA1BFBD0_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_4FDF37D2_Out_0, _Multiply_CA1BFBD0_Out_2);
                float2 _TilingAndOffset_3106F081_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_ABDA32C_Out_3.xy), float2 (1, 1), (_Multiply_CA1BFBD0_Out_2.xx), _TilingAndOffset_3106F081_Out_3);
                float _Property_D336AB24_Out_0 = Vector1_2DEB2D7D;
                float _GradientNoise_E52C846A_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_3106F081_Out_3, _Property_D336AB24_Out_0, _GradientNoise_E52C846A_Out_2);
                float _Property_1D82C75E_Out_0 = Vector1_DED0BDAF;
                float _Multiply_8F42B7FE_Out_2;
                Unity_Multiply_float(_GradientNoise_E52C846A_Out_2, _Property_1D82C75E_Out_0, _Multiply_8F42B7FE_Out_2);
                float _Property_46440021_Out_0 = Vector1_7CF2CE30;
                float _Property_252FC48E_Out_0 = Vector1_5595CFA0;
                float _Property_79D3B95A_Out_0 = Vector1_C5E85E8B;
                float _Multiply_A43E9D22_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_79D3B95A_Out_0, _Multiply_A43E9D22_Out_2);
                float2 _TilingAndOffset_727FD81C_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_ABDA32C_Out_3.xy), float2 (1, 1), (_Multiply_A43E9D22_Out_2.xx), _TilingAndOffset_727FD81C_Out_3);
                float _Property_1A5FB65E_Out_0 = Vector1_71A7FF5A;
                float _GradientNoise_8743D481_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_727FD81C_Out_3, _Property_1A5FB65E_Out_0, _GradientNoise_8743D481_Out_2);
                float2 _TilingAndOffset_BF1FF52B_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_ABDA32C_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_BF1FF52B_Out_3);
                float _GradientNoise_9ADEB057_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_BF1FF52B_Out_3, _Property_1A5FB65E_Out_0, _GradientNoise_9ADEB057_Out_2);
                float _Add_D4D5F447_Out_2;
                Unity_Add_float(_GradientNoise_8743D481_Out_2, _GradientNoise_9ADEB057_Out_2, _Add_D4D5F447_Out_2);
                float _Divide_527C5225_Out_2;
                Unity_Divide_float(_Add_D4D5F447_Out_2, 2, _Divide_527C5225_Out_2);
                float _Saturate_11D50A5B_Out_1;
                Unity_Saturate_float(_Divide_527C5225_Out_2, _Saturate_11D50A5B_Out_1);
                float _Property_35E9C15A_Out_0 = Vector1_508E7203;
                float _Power_B25FD97D_Out_2;
                Unity_Power_float(_Saturate_11D50A5B_Out_1, _Property_35E9C15A_Out_0, _Power_B25FD97D_Out_2);
                float4 _Property_B4869C3_Out_0 = Vector4_22211085;
                float _Split_A33FF8FB_R_1 = _Property_B4869C3_Out_0[0];
                float _Split_A33FF8FB_G_2 = _Property_B4869C3_Out_0[1];
                float _Split_A33FF8FB_B_3 = _Property_B4869C3_Out_0[2];
                float _Split_A33FF8FB_A_4 = _Property_B4869C3_Out_0[3];
                float4 _Combine_51C2B9E4_RGBA_4;
                float3 _Combine_51C2B9E4_RGB_5;
                float2 _Combine_51C2B9E4_RG_6;
                Unity_Combine_float(_Split_A33FF8FB_R_1, _Split_A33FF8FB_G_2, 0, 0, _Combine_51C2B9E4_RGBA_4, _Combine_51C2B9E4_RGB_5, _Combine_51C2B9E4_RG_6);
                float4 _Combine_D8E089FC_RGBA_4;
                float3 _Combine_D8E089FC_RGB_5;
                float2 _Combine_D8E089FC_RG_6;
                Unity_Combine_float(_Split_A33FF8FB_B_3, _Split_A33FF8FB_A_4, 0, 0, _Combine_D8E089FC_RGBA_4, _Combine_D8E089FC_RGB_5, _Combine_D8E089FC_RG_6);
                float _Remap_85EB9253_Out_3;
                Unity_Remap_float(_Power_B25FD97D_Out_2, _Combine_51C2B9E4_RG_6, _Combine_D8E089FC_RG_6, _Remap_85EB9253_Out_3);
                float _Absolute_97E4DBF2_Out_1;
                Unity_Absolute_float(_Remap_85EB9253_Out_3, _Absolute_97E4DBF2_Out_1);
                float _Smoothstep_40D99020_Out_3;
                Unity_Smoothstep_float(_Property_46440021_Out_0, _Property_252FC48E_Out_0, _Absolute_97E4DBF2_Out_1, _Smoothstep_40D99020_Out_3);
                float _Add_2AD089A4_Out_2;
                Unity_Add_float(_Multiply_8F42B7FE_Out_2, _Smoothstep_40D99020_Out_3, _Add_2AD089A4_Out_2);
                float _Add_71E55AC0_Out_2;
                Unity_Add_float(1, _Multiply_8F42B7FE_Out_2, _Add_71E55AC0_Out_2);
                float _Divide_D8DEA7C4_Out_2;
                Unity_Divide_float(_Add_2AD089A4_Out_2, _Add_71E55AC0_Out_2, _Divide_D8DEA7C4_Out_2);
                float3 _Multiply_8C2DA5AB_Out_2;
                Unity_Multiply_float(IN.ObjectSpaceNormal, (_Divide_D8DEA7C4_Out_2.xxx), _Multiply_8C2DA5AB_Out_2);
                float _Property_B74280B2_Out_0 = Vector1_A79FC1E6;
                float3 _Multiply_C05CC6CA_Out_2;
                Unity_Multiply_float(_Multiply_8C2DA5AB_Out_2, (_Property_B74280B2_Out_0.xxx), _Multiply_C05CC6CA_Out_2);
                float3 _Add_45F8B139_Out_2;
                Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_C05CC6CA_Out_2, _Add_45F8B139_Out_2);
                float3 _Add_66BED545_Out_2;
                Unity_Add_float3(_Multiply_6A2DE76C_Out_2, _Add_45F8B139_Out_2, _Add_66BED545_Out_2);
                description.VertexPosition = _Add_66BED545_Out_2;
                description.VertexNormal = IN.ObjectSpaceNormal;
                description.VertexTangent = IN.ObjectSpaceTangent;
                return description;
            }
            
            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float3 WorldSpacePosition;
                float4 ScreenPosition;
            };
            
            struct SurfaceDescription
            {
                float Alpha;
                float AlphaClipThreshold;
            };
            
            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float _SceneDepth_C00364BD_Out_1;
                Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_C00364BD_Out_1);
                float4 _ScreenPosition_CB63B171_Out_0 = IN.ScreenPosition;
                float _Split_E096E914_R_1 = _ScreenPosition_CB63B171_Out_0[0];
                float _Split_E096E914_G_2 = _ScreenPosition_CB63B171_Out_0[1];
                float _Split_E096E914_B_3 = _ScreenPosition_CB63B171_Out_0[2];
                float _Split_E096E914_A_4 = _ScreenPosition_CB63B171_Out_0[3];
                float _Subtract_FD88142A_Out_2;
                Unity_Subtract_float(_Split_E096E914_A_4, 1, _Subtract_FD88142A_Out_2);
                float _Subtract_41F7E55C_Out_2;
                Unity_Subtract_float(_SceneDepth_C00364BD_Out_1, _Subtract_FD88142A_Out_2, _Subtract_41F7E55C_Out_2);
                float _Property_C7646A5E_Out_0 = Vector1_E25D06C1;
                float _Divide_609BD502_Out_2;
                Unity_Divide_float(_Subtract_41F7E55C_Out_2, _Property_C7646A5E_Out_0, _Divide_609BD502_Out_2);
                float _Saturate_BD4BAC2F_Out_1;
                Unity_Saturate_float(_Divide_609BD502_Out_2, _Saturate_BD4BAC2F_Out_1);
                surface.Alpha = _Saturate_BD4BAC2F_Out_1;
                surface.AlphaClipThreshold = 0;
                return surface;
            }
        
            // --------------------------------------------------
            // Structs and Packing
        
            // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
        
            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 positionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_POSITION;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                float3 interp00 : TEXCOORD0;
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output = (PackedVaryings)0;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
            
            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output = (Varyings)0;
                output.positionCS = input.positionCS;
                output.positionWS = input.interp00.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
                output.ObjectSpaceTangent =          input.tangentOS;
                output.ObjectSpacePosition =         input.positionOS;
                output.WorldSpacePosition =          TransformObjectToWorld(input.positionOS);
                output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(TransformObjectToWorld(input.positionOS));
                output.TimeParameters =              _TimeParameters.xyz;
            
                return output;
            }
            
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
            
            
            
            
                output.WorldSpacePosition =          input.positionWS;
                output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
            #else
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            #endif
            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            
                return output;
            }
            
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"
        
            ENDHLSL
        }
        
    }
    FallBack "Hidden/Shader Graph/FallbackError"
}
