void main() {
    /*
    // 中心からの位置を求める
    vec2 uv = v_tex_coord - vec2(0.5, 0.5);
    float len = length(uv);
    
    // 1秒で１周期
    float time = mod(u_time, 1.0);
    
    // sinの値から参照するテクスチャのカラーを取得
    float sinVal = 1.0 + sin( 2.0 * 3.1415 * (len / 0.1 - time)) * 0.1;
    uv *= sinVal;
    vec4 texel = texture2D( u_texture, uv + vec2(0.5, 0.5));
    
    gl_FragColor = texel;
     */

    vec4 color = texture2D(u_texture, v_tex_coord).rgba;
    
    float size_w = u_sprite_size.x;
    float size_h = u_sprite_size.y;

    float px = v_tex_coord.x * size_w;
    float py = v_tex_coord.y * size_h;
    vec2 p;
    p = vec2((px-1.0) / size_w, (py-1.0) / size_h);
    vec4 c1 = texture2D(u_texture, p);
    p = vec2((px) / size_w, (py-1.0) / size_h);
    vec4 c2 = texture2D(u_texture, p);
    p = vec2((px+1.0) / size_w, (py-1.0) / size_h);
    vec4 c3 = texture2D(u_texture, p);
    p = vec2((px-1.0) / size_w, (py) / size_h);
    vec4 c4 = texture2D(u_texture, p);
    p = vec2((px+1.0) / size_w, (py) / size_h);
    vec4 c5 = texture2D(u_texture, p);
    p = vec2((px-1.0) / size_w, (py+1.0) / size_h);
    vec4 c6 = texture2D(u_texture, p);
    p = vec2((px) / size_w, (py+1.0) / size_h);
    vec4 c7 = texture2D(u_texture, p);
    p = vec2((px+1.0) / size_w, (py+1.0) / size_h);
    vec4 c8 = texture2D(u_texture, p);
    
    float tmp_r = (color.r+c1.r+c2.r+c3.r+c4.r+c5.r+c6.r+c7.r+c8.r)*0.11;
    float tmp_g = (color.g+c1.g+c2.g+c3.g+c4.g+c5.g+c6.g+c7.g+c8.g)*0.11;
    float tmp_b = (color.b+c1.b+c2.b+c3.b+c4.b+c5.b+c6.b+c7.b+c8.b)*0.11;
    
    color = vec4(tmp_r, tmp_g, tmp_b, color.a);
    
    // 色合計
    float total_c = color.r + color.g + color.b;
    
    // 輝度の計算式
    // 0.299×R ＋ 0.587×G ＋ 0.114×B
    // 輝度算出
    float br = 0.299*color.r + 0.587*color.g + 0.114*color.b;
    
    if(total_c <= 0.0) {
        gl_FragColor = vec4(0, 0, 0, color.a);
        return;
    }
    if(br <= 0.0) {
        gl_FragColor = vec4(0, 0, 0, color.a);
        return;
    }
    
    // 輝度を丸める
    float ret_br = 0.0;
    if(br < 0.0 * 0.00392) { ret_br = 0.0 * 0.00392; }
    else if(br < 48.0 * 0.00392) { ret_br = 0.0 * 0.00392; }
    else if(br < 86.0 * 0.00392) { ret_br = 48.0 * 0.00392; }
    else if(br < 192.0 * 0.00392) { ret_br = 162.0 * 0.00392; }
    else if(br < 236.0 * 0.00392) { ret_br = 236.0 * 0.00392; }
    else if(br < 256.0 * 0.00392) { ret_br = 255.0 * 0.00392; }
    
    // 変換結果の色合計 = 変換結果の輝度 * 元の色合計 / 元の輝度
    float ret_total_c = ret_br * total_c / br;
    
    // 色合計を各色に分解
    
    // 結果の色要素 = 元の色要素 * 結果の色合計 / 元の色合計
    float ret_r = color.r * ret_total_c / total_c;
    float ret_g = color.g * ret_total_c / total_c;
    float ret_b = color.b * ret_total_c / total_c;
    
    if(ret_r < 0.0) { ret_r = 0.0; }
    if(ret_g < 0.0) { ret_g = 0.0; }
    if(ret_b < 0.0) { ret_b = 0.0; }
    if(ret_r > 1.0) { ret_r = 1.0; }
    if(ret_g > 1.0) { ret_g = 1.0; }
    if(ret_b > 1.0) { ret_b = 1.0; }

    gl_FragColor = vec4(ret_r, ret_g, ret_b, color.a);
}
