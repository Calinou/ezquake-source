#version 120

#ezquake-definitions

attribute float flags;

varying vec2 fsTextureCoord;
varying vec4 fsBaseColor;
uniform vec3 angleVector;        // normalized
uniform float shadelight;        // divided by 256 in C
uniform float ambientlight;      // divided by 256 in C
uniform float lerpFraction;      // 0 to 1

#define AM_VERTEX_NOLERP 1

void main()
{
	float lerpFrac = lerpFraction;
#ifdef EZQ_ALIASMODEL_MUZZLEHACK
	lerpFrac = sign(lerpFrac) * max(lerpFrac, mod(flags, 2));
#endif

	gl_Position = gl_ModelViewProjectionMatrix * (gl_Vertex + lerpFrac * vec4(gl_MultiTexCoord1.xyz, 0));
	fsTextureCoord = gl_MultiTexCoord0.st;

	// Lighting: this is rough approximation
	//   Credit to mh @ http://forums.insideqc.com/viewtopic.php?f=3&t=2983
	float l = (1 - step(1000, shadelight)) * min((dot(gl_Normal, angleVector) + 1) * shadelight + ambientlight, 1);

	fsBaseColor = vec4(gl_Color.rgb * l, gl_Color.a);
}
