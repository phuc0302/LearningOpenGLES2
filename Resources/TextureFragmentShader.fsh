uniform sampler2D u_texture;

varying lowp vec2 coord_texture;

void main(void) {
    gl_FragColor = texture2D(u_texture, coord_texture);
}
