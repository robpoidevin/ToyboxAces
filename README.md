Proposal Link: https://docs.google.com/document/d/1rLOpRcoI3tGZ0R_yEIqI-pBnMhZXnYxZDDIrKRrfSYg/edit?tab=t.0

Ryan Jolly

**Contributions** 
- Wrote the proposal
  
Rob Poidevin 

**Contributions** 
- Wrote the proposal
  
Liam Toews 

**Contributions** 
- Wrote the proposal
- Update ReadME

**Project Progression Reflections**
Ryan Jolly

making an appropriate scene
The environment was made entirely by me and was done in blender and then was textured inside of substance painter to get normal maps for each model. The scene complements the lighting and explains the player being a toy plane by taking place inside a kids bedroom. The open window was an intentional decision to make the room have more contrast than without.

simple diffuse 
The simple diffuse shader is built into the "master shader (LightToggle)" since it needs to be switched between light modes in the project. Simple diffuse is also complemented by added bump map effect created for all the models. This is very similar to the initial diffuse and bump map shader introduced in lecture 6, but the LightToggle version of simple diffuse is slightly different by having a lowest possible value to not create harsh shadows in the scene by rounding up to a minimum of 0.1 or another small value. This shader also differs by having a multiplier variable applied to the diffuse to further customize the feeling of lighting in the scene.

diffuse + ambient
The diffuse and ambient shader is the same as above except it also has ambient which like the diffuse shader has a multiplier to modify ambient color harshness to emphasize the lighting in the scene and give contrast. This shader is also contained within the LightToggle master shader.

simple specular
The specular shader is also contained within the LightToggle master shader, and is very similar to the class specular example but is combined with normal modification from the bump map in the same shader, which was not shown off in the class.

toggleable light modes
As mentioned the light shaders are toggleable by being in the LightToggle master shader which has a number value to determine the light mode checked inside the fragment shader and is only changed by the lightmanager script that listens for player input.

2 added effects 
 - bump map
The LightToggle shader also has a bump map applied to every lightmode creating the illusion of texture and depth in the scene and makes the contrast and lighting of the scene pop much more. The bump part of the shader also has a bumpscale to modify how much emphasis and contrast is needed for certain objects. 
 - diffuse map
The diffuse map is more of a new concept and is used instead of a base color alongside a texture. This was done because when making the textures my software gives diffuse maps which were more convenient for the project and scene purposes.

water shader
The water shader was achieved by applying a sin function in the vertex shader and giving it a wave scale and frequency to give some customization in the look of the water inside the fishtank.

tv HDR shader
The tv HDR color shader is very similar to the default shader Unity provides but this adds a glow modifier and an HDR color that is used to give a glowing effect in the scene that used the post processing bloom effect to add some interesting colors to the scene.

color grading implmentation
Color grading was achieved via shader graph and has a script to toggle look up tables to change the look of the scene. The color grading was attempted to make the scene have more warm colors to enhance our environment's orange tinted light, but it did not look good since the environment looked good before color grading was applied.
