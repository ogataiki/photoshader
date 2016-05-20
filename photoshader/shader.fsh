void main() {

    /* 波紋
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
    
    // ---
    // ガウスフィルタ
    // u_sprite_size がバグってるらしい。。。
    //float x_flag = 1.0 / u_sprite_size.x;
    //float y_flag = 1.0 / u_sprite_size.y;
    float x_flag = 0.005;
    float y_flag = 0.005;

    float px = v_tex_coord.x;
    float py = v_tex_coord.y;
    
    vec3 destColor = color.rgb * 0.36;
    
    destColor += texture2D(u_texture, vec2(px - x_flag, py - y_flag)).rgb * 0.04;
    destColor += texture2D(u_texture, vec2(px         , py - y_flag)).rgb * 0.04;
    destColor += texture2D(u_texture, vec2(px + x_flag, py - y_flag)).rgb * 0.04;
    destColor += texture2D(u_texture, vec2(px - x_flag, py         )).rgb * 0.04;
    destColor += texture2D(u_texture, vec2(px + x_flag, py         )).rgb * 0.04;
    destColor += texture2D(u_texture, vec2(px - x_flag, py + y_flag)).rgb * 0.04;
    destColor += texture2D(u_texture, vec2(px         , py + y_flag)).rgb * 0.04;
    destColor += texture2D(u_texture, vec2(px + x_flag, py + y_flag)).rgb * 0.04;
    
    destColor += texture2D(u_texture, vec2(px - (x_flag*2.0), py - (y_flag*2.0))).rgb * 0.02;
    destColor += texture2D(u_texture, vec2(px - (x_flag*1.0), py - (y_flag*2.0))).rgb * 0.02;
    destColor += texture2D(u_texture, vec2(px               , py - (y_flag*2.0))).rgb * 0.02;
    destColor += texture2D(u_texture, vec2(px + (x_flag*1.0), py - (y_flag*2.0))).rgb * 0.02;
    destColor += texture2D(u_texture, vec2(px + (x_flag*2.0), py - (y_flag*2.0))).rgb * 0.02;
    
    destColor += texture2D(u_texture, vec2(px - (x_flag*2.0), py - y_flag)).rgb * 0.02;
    destColor += texture2D(u_texture, vec2(px + (x_flag*2.0), py - y_flag)).rgb * 0.02;

    destColor += texture2D(u_texture, vec2(px - (x_flag*2.0), py         )).rgb * 0.02;
    destColor += texture2D(u_texture, vec2(px + (x_flag*2.0), py         )).rgb * 0.02;
    
    destColor += texture2D(u_texture, vec2(px - (x_flag*2.0), py + y_flag)).rgb * 0.02;
    destColor += texture2D(u_texture, vec2(px + (x_flag*2.0), py + y_flag)).rgb * 0.02;
    
    destColor += texture2D(u_texture, vec2(px - (x_flag*2.0), py + (y_flag*2.0))).rgb * 0.02;
    destColor += texture2D(u_texture, vec2(px - (x_flag*1.0), py + (y_flag*2.0))).rgb * 0.02;
    destColor += texture2D(u_texture, vec2(px               , py + (y_flag*2.0))).rgb * 0.02;
    destColor += texture2D(u_texture, vec2(px + (x_flag*1.0), py + (y_flag*2.0))).rgb * 0.02;
    destColor += texture2D(u_texture, vec2(px + (x_flag*2.0), py + (y_flag*2.0))).rgb * 0.02;
    
    color = vec4(destColor.r, destColor.g, destColor.b, color.a);
    
    // ---
    // 輝度ベースのポスタライズ
    
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
    float unit = 1.0 / 255.0;
    float ret_br = 0.0;
    if(br < 0.0 * unit) { ret_br = 0.0 * unit; }
    else if(br < 12.0 * unit) { ret_br = 0.0 * unit; }
    else if(br < 32.0 * unit) { ret_br = 12.0 * unit; }
    else if(br < 192.0 * unit) { ret_br = 162.0 * unit; }
    else if(br < 236.0 * unit) { ret_br = 236.0 * unit; }
    else if(br < 256.0 * unit) { ret_br = 255.0 * unit; }
    
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
