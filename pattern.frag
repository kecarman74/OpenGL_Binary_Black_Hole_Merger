#version 330 compatibility

uniform float	uTime;		// "Time", from Animate( )
in vec2  	vST;		// texture coords
in vec4 gl_FragCoord;

//lighting
in  vec3  vN;			// normal vector
in  vec3  vL;			// vector from point to light
in  vec3  vE;			// vector from point to eye
uniform float   uKa, uKd, uKs;		// coefficients of each type of lighting
uniform vec3  uSpecularColor;		// light color
uniform float   uShininess;		// specular exponent

//color animation
uniform bool uchange_frag;
float dec_time = uTime / 10.0;


void
main( )
{
	//normalize light vectors
	vec3 Normal = normalize(vN);
	vec3 Light     = normalize(vL);
	vec3 Eye        = normalize(vE);

	vec3 myColor = vec3( 0.2, 0.2, 0.7);
	for (float i=1; i<10.0; i++){
		if (vST[0] >= i/10 && vST[0] <= i/10 + 0.005){
			myColor = vec3( 0.7, 0.7, 0.7);
		}
		if (vST[1] >= i/10 && vST[1] <= i/10 + 0.005){
			myColor = vec3( 0.7, 0.7, 0.7);
		}
	}


	vec3 ambient = uKa * myColor;

	float d = max( dot(Normal,Light), 0. );       // only do diffuse if the light can see the point
	vec3 diffuse = uKd * d * myColor;

	float s = 0.;
	if( dot(Normal,Light) > 0. )	          // only do specular if the light can see the point
	{
		vec3 ref = normalize(  reflect( -Light, Normal )  );
		s = pow( max( dot(Eye,ref),0. ), uShininess );
	}
	vec3 specular = uKs * s * uSpecularColor;
	gl_FragColor = vec4( ambient + diffuse + specular,  0.5 );	//builtin variable is sent to framebuffer, check transparency notes and enable transparency, setup blending function.
	
}