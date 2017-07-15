uniform highp mat4 modelMatrix;
uniform highp mat4 projectionMatrix;

attribute vec4 a_coord;
attribute vec2 a_texture;

varying lowp vec2 frag_texture;

void main(void) {
    gl_Position = projectionMatrix * modelMatrix * a_coord;
    frag_texture = a_texture;
}
