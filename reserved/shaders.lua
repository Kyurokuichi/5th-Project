--fish eye lens with position

[[
#ifdef VERTEX
  vec4 position(mat4 transform_projection, vec4 vertex_position)
  {
    return transform_projection * vertex_position;
  }
#endif



#ifdef PIXEL
  uniform vec2 mouse_position;

  float lens_size = 0.2;

  vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
  {
    vec2 pos = screen_coords.xy / vec2(1280,1024);
    vec2 mouse_pos = mouse_position.xy / vec2(1280,1024);

    vec2 d = pos - mouse_pos;
    float r = sqrt(dot(d,d));

    vec2 uv;

    if (r > lens_size)
    {
      uv = pos;
      return Texel(tex, uv);
    }
    else if (r < lens_size)
    {
      // SQUAREXY:
      // uv = mouse_pos + vec2(d.x * abs(d.x), d.y * abs(d.y));
      // SQUARER:
      // uv = mouse_pos + d * r * 5; // a.k.a. m + normalize(d) * r * r
      // SINER:
      // uv = (mouse_pos + normalize(d) * sin(r * 3.14159 * 0.5));
      // ASINR:
      // uv = mouse_pos + normalize(d) * asin(r) / (3.14159 * 0.5);

      return Texel(tex, uv);
    }

  }
#endif
]]
