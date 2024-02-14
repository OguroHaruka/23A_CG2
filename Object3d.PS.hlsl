#include "Object3d.hlsli"

struct Material {
	float32_t4 color;
	int32_t enableLighting;
	float32_t shininess;
};

struct DirectionalLight{
    float32_t4 color;
	float32_t3 direction;
	float intensity;
};

 struct PixelShaderOutput {
	float32_t4 color : SV_TARGET0;
};

struct Camera {
	float32_t3 worldPosition;
};

ConstantBuffer<Material> gMaterial : register(b0);
ConstantBuffer<DirectionalLight> gDirectionalLight : register(b1);
ConstantBuffer<Camera> gCamera : register(b2);
Texture2D<float32_t4> gTexture : register(t0);
SamplerState gSampler : register(s0);

PixelShaderOutput main(VertexShaderOutput input) {
	PixelShaderOutput output;
    float32_t4 textureColor = gTexture.Sample(gSampler,input.texcoord);
	float32_t3 toEye = normalize(gCamera.worldPosition - input.worldPosition);
	float32_t3 reflectLight = reflect(normalize(gDirectionalLight.direction), normalize(input.normal));
	if(gMaterial.enableLighting != 0)
	{

	    float NdotL = dot(normalize(input.normal), normalize(-gDirectionalLight.direction));
		float cos =pow(NdotL * 0.5f + 0.5f,2.0f);
	    float RdotE = dot(reflectLight,toEye);
	    float specularPow = pow(saturate(RdotE),gMaterial.shininess);

	    //float cos = saturate(dot(normalize(input.normal), -gDirectionalLight.direction));
		
		//output.color = gMaterial.color * textureColor * gDirectionalLight.color * cos * gDirectionalLight.intensity;

		float32_t3 diffuse = gMaterial.color.rgb *textureColor.rgb* gDirectionalLight.color.rgb * cos * gDirectionalLight.intensity;
		float32_t3 specular = gDirectionalLight.color.rgb * gDirectionalLight.intensity * specularPow * float32_t3(1.0f,1.0f,1.0f);
		output.color.rgb = diffuse + specular;
		output.color.a = gMaterial.color.a * textureColor.a;
    } else {
	    output.color.rgb = gMaterial.color.rgb * textureColor.rgb;
		output.color.a = gMaterial.color.a*textureColor.a;
    }
	return output;
}

