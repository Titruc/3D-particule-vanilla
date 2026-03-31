// variables for 3D stuff
dir = normalize((-glPos).xyz);
vec3 normal = vec3(0);
vec2 texSize = textureSize(Sampler0, 0);
vec4 corner = findTextureCoordinates(texCoord0, texSize, vec2(16.0));

// define variables to prevent from crash
vec4[] tex = vec4[](sBox(vec3(Pos.x, Pos.y + 2 / 16.0, Pos.z), dir, vec3(1 / 8.0), normal, 0.5), vec4(-1));

// handle model
tex = vec4[](sBox(vec3(Pos.x, Pos.y + 2 / 16.0, Pos.z), dir, vec3(1 / 8.0), normal, 0.5), vec4(-1));

// model reader
for (int i = 0; i < 2; i++) {
    if (tex[i].y != -1) // if the pixel is on the reading cube
    {
        // Use texture coordinates to retrieve the color from the texture
        vec2 texCubeUV = normalizeTextureCoord(tex[i].xy, 64.0 / 256.0);
        vec4 texColor = vec4(-1);
        
        texColor = texture(Sampler0, adjustUVForPixel(vec2(corner.x, corner.y), vec2(16, 11.5), texCubeUV)); // apply texture
        
        // Adjust the color based on the retrieved texture
        color = texColor;
        
        bool isOnTop = false;
        for (int j = 0; j < 2; j++) 
        {
            if (tex[i].z > tex[j].z) { isOnTop = true; }
        }
        if (isOnTop == false)
        {
            break;
        }
        // color = vec4(color.xyz, 1.0);
        
        color = color * vec4(vertexColor.xyz * 1.6, 1.0) * (ColorModulator);
    }
}
