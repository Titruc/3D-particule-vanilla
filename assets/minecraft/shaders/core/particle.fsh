#version 150

#moj_import <fog.glsl>
#moj_import <titruc3dparticuleutils.glsl>
#moj_import <titruc3dparticulecube.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;
uniform mat4 ProjMat;
uniform mat4 ModelViewMat;

in float vertexDistance;
in vec2 texCoord0;
in vec4 vertexColor;

in vec4 Pos;
in vec4 glPos;


out vec4 fragColor;
vec3 dir;

in float isBreaking;

void main() {
    //remove bad texture
    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
    

    //check texture
    vec2 texSize = textureSize(Sampler0, 0);
    vec2 uv = (texCoord0 * texSize);

    //breaking block particule
    if (isBreaking == 1.0){
        color = vec4(-1);
        #moj_import <titruc3dparticulemain.glsl>
    }
    else
    {
        color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
    }
    
    if(color == vec4(-1) || color.a == 0){
        discard;
    }
    
    
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
    
}
