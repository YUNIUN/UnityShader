

// ShaderLab结构示例(无法运行)

Shader "ShaderName" {
    Properties {
        my_Int("m_int", Int) = 2
        my_Float("m_float", Float) = 1.5
        my_Range("m_range", Range(0.0, 1.0)) = 0.3
        my_Color("m_color", Color) = (1, 1, 1, 1)
        my_Vector("m_vector", Vector) = (1, 1, 1, 1)
        my_2D("m_2D", 2D) = "white" {}
        my_Cube("m_cube", Cube) = "white" {}
        my_3D("m_3D", 3D) = "black" {}
    }
    SubShader {
        // 标签设置(可选的,应用到所有Pass)
        [Tags]
        // 状态设置(可选的,应用到所有Pass)
        [RenderSetup]
        Pass {
            // Pass的名字，别的shader可以通过该名字直接使用这个Pass(全大写)
            [Name]
            // 标签设置(可选的,应用到自身Pass)
            [Tags]
            // 状态设置(可选的,应用到自身Pass)
            [RenderSetup]
        }
    }
    SubShader {
        // 显卡B使用的子着色器
    }
    Fallback Off
}
