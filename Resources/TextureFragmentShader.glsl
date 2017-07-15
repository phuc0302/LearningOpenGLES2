uniform sampler2D u_texture;

varying lowp vec2 frag_texture;

void main(void) {
    gl_FragColor = texture2D(u_texture, frag_texture);
}
