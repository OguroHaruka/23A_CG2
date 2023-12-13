#include "Object3d.hlsli"

struct TransformationMatrix {
	float32_t4x4 WVP;
};
StructuredBuffer<TransformationMatrix> gTransformationMatrices : register(t0);
struct VertexShaderInput {
	float32_t4 position : POSITION0;
	float32_t2 texcoord : TEXCOORD0;
};
VertexShaderOutput main(VertexShaderInput inputuint32_t instanceId : SV_InstanceID) {

	VertexShaderOutput output;
	output.position = Mul(input.position,gTransformationMatrices[instanceId].WVP);
	output.texcoord = input.texcoord;
	output.normal = normalize(mul(input.normal,(float32_t3x3)gTransformationMatrices[instanceId].World));
	
	return output;
}

