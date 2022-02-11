#version 330 compatibility

uniform float	uTime;		// "Time", from Animate( )
uniform bool	uEndAnimate;
uniform bool	uAnimate_vert;
uniform bool	uchange_vert;
out vec2  	vST;		// texture coords, defined per vertes, rasterizer interprets throughout polygon
const float PI	= 	3.14159265;

//lighting
out  vec3  vN;		// normal vector
out  vec3  vL;		// vector from point to light
out  vec3  vE;		// vector from point to eye

vec3 LightPosition = vec3(  2.0, 4.0, 2.0);
vec3 vert;


void
main( )
{ 
	vST = gl_MultiTexCoord0.st; //variable that holds S and T, Vec4

	vec3 vert = gl_Vertex.xyz;
	float vx = gl_Vertex.x;
	float vz = gl_Vertex.z;
	float speed = -50.0;
	vec3 vNorm = gl_Normal;
	float distance	= sqrt(vx * vx + vz * vz);

	//if the animation needs to end
	if (uEndAnimate){
		if (uAnimate_vert && distance > (2.0 * (1.0 - 0.99) + 0.2) && distance > (7.0 * uTime)){
			float AMP = 	1.0 * uTime / (uTime * distance);			// amplitude
			float W	= 	5.0;		// frequency
			float y = AMP*sin(uTime * speed + distance * W); //dependant on angle atan(y,x) gives angle from origin
			vert[1] = y;
			vNorm =  normalize(vec3(distance*AMP*cos(uTime * speed + distance * W),1.0, distance*AMP*cos(uTime * speed + distance * W)));
		}
		else if (uAnimate_vert && distance < (2.0 * (1.0 - 0.99) + 0.2)){
			const float AMP = 	0.1;		// amplitude
			float W			= 	1.5 * 0.99;		// frequency
			float y = (distance * distance - 5.) / distance;
			vert[1] = y;
			vNorm =  normalize(vec3(-distance*AMP*cos(PI*distance*W+0.99) / (distance * distance),1.0, -distance*AMP*cos(PI*distance*W+0.99) / (distance * distance)));
		}
	}
	//normal animation pre-collision
	else{
		if (uAnimate_vert && distance > (2.0 * (1.0 - uTime) + 0.2)){
			float AMP = 	1.0 * uTime / (uTime * distance);			// amplitude
			float W	= 	5.0 * uTime;		// frequency
			float y = AMP*sin(uTime * speed + distance * W); //dependant on angle atan(y,x) gives angle from origin
			vert[1] = y;
			vNorm =  normalize(vec3(distance*AMP*cos(uTime * speed + distance * W),1.0, distance*AMP*cos(uTime * speed + distance * W)));
		}
		else if (uAnimate_vert && distance < (2.0 * (1.0 - uTime) + 0.2)){
			const float AMP = 	0.1;		// amplitude
			float W			= 	1.5 * uTime;		// frequency
			float y = (distance * distance - 5.) / distance;
			vert[1] = y;
			vNorm =  normalize(vec3(-distance*AMP*cos(PI*distance*W+uTime) / (distance * distance),1.0, -distance*AMP*cos(PI*distance*W+uTime) / (distance * distance)));;
		}
	}


	vec4 ECposition = gl_ModelViewMatrix * vec4( vert, 1. );
	vN = normalize( gl_NormalMatrix * vNorm );	// normal vector
	vL = LightPosition - ECposition.xyz;			// vector from the point to the light position
	vE = vec3( 0., 0., 0. ) - ECposition.xyz;		// vector from the point to the eye position
	gl_Position = gl_ModelViewProjectionMatrix * vec4( vert, 1. );
}