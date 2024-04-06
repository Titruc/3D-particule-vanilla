vec4 findTextureCoordinates(vec2 position, vec2 alphaTextureSize, vec2 textureSize) { // trouve la coordoner de la position haut gauche des texture, position = texcoord0, alphaTextureSize = taille de toute la texture alpha, alphaTextureSize = taille de la subtexture 
    vec2 textureIndex = floor(position * alphaTextureSize / textureSize);
    
    vec2 topLeft = textureIndex * textureSize / alphaTextureSize;
    vec2 bottomRight = (textureIndex + vec2(1.0)) * textureSize / alphaTextureSize;
    
    return vec4(topLeft, bottomRight);
}


vec2 adjustUVForPixel(vec2 uv, vec2 textureSize, vec2 pixelCoord) { // ajuste l'uv a une surface, uv = coin haut gauche de la tyexture, textureSize = taille de la texture (11.33,8) pour une texture 16x16, pixelcoord = uv de la texture a appliquer
    vec2 pixelUV = fract(pixelCoord / textureSize); 
    return uv + pixelUV / textureSize;
}

vec2 normalizeTextureCoord(vec2 textureCoord, float subTextureSize) { // normalise des surface des cube, textureCoord = uv de la surface, subTextureSize = min de l'uv de la texture / 256.0
    return (textureCoord - vec2(subTextureSize)) * (1.0 / subTextureSize);
}

bool textureAsAlpha(vec2 textureSize, vec2 alphaTextureSize, vec2 subTextureTopLeft, sampler2D Sampler0) {// lot of if because for is lagy :/ look if a texture is not a full block: textureSize = size of the subtexture [0:+infinity[, alphaTextureSize = size of the alpha texture,subTextureTopLeft= corner of the texture (can be calculate with findTextureCoordinates), Sampler0 = Sampler0
    vec4 color = vec4(0);

    // Coin supérieur gauche
    vec2 currentPixel = (subTextureTopLeft * alphaTextureSize) / alphaTextureSize;
    color = texture(Sampler0, currentPixel);
    if (color.a > 0.01) {
        return false;
    }

    // Coin inférieur gauche
    currentPixel = ((subTextureTopLeft + vec2(0.0, textureSize.y - 1.0)) * alphaTextureSize) / alphaTextureSize;
    color = texture(Sampler0, currentPixel);
    if (color.a > 0.01) {
        return false;
    }

    

    // Aucun pixel transparent trouvé
    return true;
}

vec4 findNearestNonTransparentPixel(vec2 startPoint, vec2 subTextureTopLeft, vec2 subTextureSize, vec2 alphaTextureSize, sampler2D Sampler0) {
    
    for (float y = startPoint.y; y <= subTextureSize.y - startPoint.y; y++) {
        for (float x = 0; x < subTextureSize.x - startPoint.x; x++) {
            vec2 currentPixelUV = ((subTextureTopLeft * alphaTextureSize) + vec2(x, y)) / alphaTextureSize;
            vec4 color = texture(Sampler0, currentPixelUV);

            if (color.a > 0.1) {
                return color;
            }
        }
    }
    vec2 currentPixelUV = ((subTextureTopLeft * alphaTextureSize) + vec2(1, 0)) / alphaTextureSize;
    vec4 color = texture(Sampler0, currentPixelUV);
    return vec4(color);
}


float findParticuleType(vec2 position, vec2 alphaTextureSize, vec2 textureSize, sampler2D Sampler0){ // find the id of the particle, basicly the alpha store in the pixel at 0, 0 coord ; vec2 position = textcoord0, vec2 alphaTextureSize = size of the alpha texture, vec2 textureSize = sub texture size, sampler2D Sampler0 = sampler0
    vec4 idPixelPos = findTextureCoordinates(position, alphaTextureSize, textureSize);
    float idPixelColor = texture(Sampler0,vec2(idPixelPos.x,idPixelPos.y)).a;
    if (idPixelColor != 0.0 && idPixelColor != 1.0) {
        return idPixelColor * 255.0;
    }
    else{
        return -1.0;
    }
}