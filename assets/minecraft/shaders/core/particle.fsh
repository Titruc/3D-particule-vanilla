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

in vec2 UV0;
in float vertexDistance;
in vec2 texCoord0;
in vec4 vertexColor;

in vec4 Pos;
in vec4 glPos;

// variable for telling vsh what to do with the size of the vertex
out float is3D;


out vec4 fragColor;
vec3 dir;

void main() {
    //calculate color of the pixel
    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
    
    //check texture (useless but still here or test)
    vec2 texSize = textureSize(Sampler0, 0);
    vec2 uv = (UV0 * texSize);

    //the texture is a breaking one ?
    bool isABreakingParticle = (texSize.x == 1024 && texSize.y == 512);

    //get particle type
    float particleId = findParticuleType(texCoord0,textureSize(Sampler0, 0), vec2(8.0), Sampler0, isABreakingParticle); //found the particule id (store in alpha of the first pixel)

    //telling vertex about the 3-dimensionnal-state of the texture to prevent making an episode of villager news (you know the one with giant mob but this time with particle)
    is3D = particleId;

    //3D particule
    if (particleId != 0.0)
    {
        color = vec4(-1);
        #moj_import <titruc3dparticulemain.glsl>
    }
    else //normal particle
    {
        color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
    }

    //discard stuff
    if(color == vec4(-1) || color.a == 0.0){
        discard;
    }
    
    
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
    
}
