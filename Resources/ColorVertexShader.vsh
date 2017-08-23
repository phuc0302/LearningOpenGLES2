uniform highp mat4 modelMatrix;
uniform highp mat4 projectionMatrix;

attribute vec4 a_color;
attribute vec4 a_coord;

varying lowp vec4 frag_color;

void main(void) {
    gl_Position = projectionMatrix * modelMatrix * a_coord;
    frag_color = a_color;
}
