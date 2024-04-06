//draw the right particule
float particleId = findParticuleType(texCoord0,textureSize(Sampler0, 0), vec2(8.0), Sampler0); //found the particule id (store in alpha of the first pixel)



//basicly the block and item particule
if (particleId == 3)
{
    #moj_import <titruc3dparticuleflame.glsl>
}
else if (particleId == -1)
{
    #moj_import <titruc3dparticuleblockanditem.glsl>
}