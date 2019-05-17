shader_type canvas_item;

void fragment()
{
	vec2 waves;
	waves.x = -TIME * 0.1;
	waves.y = 0.0;
	
	COLOR = texture(TEXTURE, UV + waves);
}