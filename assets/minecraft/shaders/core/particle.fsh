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
uniform mat3 IViewRotMat;

in float vertexDistance;
in vec2 texCoord0;
in vec4 vertexColor;

in vec4 Pos;
in vec4 glPos;


out vec4 fragColor;
vec3 dir;

void main() {
    //remove bad texture
    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
    

    //check texture
    vec2 texSize = textureSize(Sampler0, 0);
    vec2 uv = (texCoord0 * texSize);

    //breaking block particule
    if (floor(uv) != uv && texSize.y / texSize.x != 4){
    color = vec4(-1);
    
    #moj_import <titruc3dparticulecubemodelreader.glsl>
    }
    if(color == vec4(-1)){
        discard;
    }
    
    
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
    
}
