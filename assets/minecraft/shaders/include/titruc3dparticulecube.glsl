vec4 sBox(vec3 ro, vec3 rd, vec3 size, out vec3 outNormal, float id) // raycast box
{
    vec3 m = 1.0 / rd;
    vec3 n = m * ro;
    vec3 k = abs(m) * size;
    vec3 t1 = -n - k;
    vec3 t2 = -n + k;
    float tN = max( max( t1.x, t1.y ), t1.z );
    float tF = min( min( t2.x, t2.y ), t2.z );
    if( tN > tF || tF < 0.0){ return vec4(vec3(-1),id);}

    outNormal = -sign(rd)*step(t1.yzx,t1.xyz)*step(t1.zxy,t1.xyz);
    
    vec3 pos = (ro + rd * tN) / size;
    vec2 tex = vec2(0);
    if (abs(outNormal.x) > 0.9)
        tex = pos.zy;
    else if (abs(outNormal.y) > 0.9)
        tex = pos.xz;
    else if (abs(outNormal.z) > 0.9)
        tex = pos.xy;

    return vec4(tex / 4 + 0.5, tN, id);
}

vec3 getsBoxRo(vec4 sBox) {
    vec3 ro = sBox.xyz * 2.0 - 1.0;

    vec3 rd = normalize(cross(vec3(0.0, 1.0, 0.0), ro));

    return ro * cos(sBox.z) + rd * sin(sBox.z);
}

vec3 getSBoxRd(vec4 sBox) {
    vec3 ro = sBox.xyz * 2.0 - 1.0;

    vec3 rd = normalize(cross(vec3(0.0, 1.0, 0.0), ro));

    return rd * cos(sBox.z) + cross(ro, rd) * sin(sBox.z);
}

vec3 getSBoxSize(vec4 sBox) {
    vec3 size = vec3(1.0);
    float halfSize = 0.25;

    if (abs(sBox.x) > 0.5) {
        size.x = halfSize;
    }
    else if (abs(sBox.y) > 0.5) {
        size.y = halfSize;
    }
    else if (abs(sBox.z) > 0.5) {
        size.z = halfSize;
    }

    return size;
}
