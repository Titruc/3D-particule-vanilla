#version 150

#moj_import <fog.glsl>

in vec3 Position;
in vec2 UV0;
in vec4 Color;
in ivec2 UV2;

uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform int FogShape;

out vec4 Pos;
out vec4 glPos;

out float vertexDistance;
out vec2 texCoord0;
out vec4 vertexColor;


void main() {
    const vec2[4] corners = vec2[4](vec2(0), vec2(0, 20), vec2(20, 20), vec2(20, 0));
    int id = gl_VertexID % 4;
    vec2 inCoords = (corners[id] - 10.0) / 4 * vec2(1, -1);
    Pos = vec4(0);
    Pos = vec4(Position + vec3(0, 0.0625, 0.0), 1);
    glPos = Pos - vec4(inCoords * 1.6, 0, 0) * ModelViewMat;
    gl_Position = ProjMat * (ModelViewMat * Pos - vec4(inCoords, 0, 0)); 

    vertexDistance = fog_distance(ModelViewMat, Position, FogShape);
    texCoord0 = UV0;
    vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
}
