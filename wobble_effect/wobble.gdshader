shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform sampler2D flowMap; //Displacement map
uniform float strength;    //Force of the effect
uniform float speed;       //Speed of the effect
uniform int frames : hint_range(1, 10); //Frames of the effect

//Returns a value between 0 and 1 depending of the frames -> exemple: frames = 4, frame 1 = 0.25
float clock(float time){
	float fframes = float(frames);
	return floor(mod(time * speed, fframes)) / fframes;
}

void fragment(){
	float c = clock(TIME); //Get clock frame
	vec2 uv_offset = mod(vec2(UV.x+c, UV.y+c), 1.0);
    vec4 offset = texture(flowMap, uv_offset) * strength * 0.001; //Get offset
	//COLOR = texture(TEXTURE, vec2(UV.x,UV.y) + normal.xy); //Apply offset
	COLOR = texture(screen_texture, vec2(UV.x,UV.y) + offset.xy - vec2(0.5,0.5)*strength * 0.001); //We need to remove the displacement
}


// TEST CLOCK
/*
void fragment(){
	float c = clock(TIME);
	COLOR = vec4( c, c, c, 1);
}
*/