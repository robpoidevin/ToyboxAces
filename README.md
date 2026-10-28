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
The environment was made entirely by me and was done in blender and then was textured inside of substance painter to get normal maps for each model. The scene complements the lighting and explains the player being a toy plane by taking place inside a kids bedroom. The open window was an intentional decision to make the room have more contrast than without. <img width="653" height="395" alt="image" src="https://github.com/user-attachments/assets/d1cd2cc3-1e86-4f6d-83a1-45b79dac0d24" />


simple diffuse 
The simple diffuse shader is built into the "master shader (LightToggle)" since it needs to be switched between light modes in the project. Simple diffuse is also complemented by added bump map effect created for all the models. This is very similar to the initial diffuse and bump map shader introduced in lecture 6, but the LightToggle version of simple diffuse is slightly different by having a lowest possible value to not create harsh shadows in the scene by rounding up to a minimum of 0.1 or another small value. This shader also differs by having a multiplier variable applied to the diffuse to further customize the feeling of lighting in the scene. <img width="649" height="195" alt="image" src="https://github.com/user-attachments/assets/057c0238-c830-40e0-8177-4807fa92e92c" /> 


diffuse + ambient
The diffuse and ambient shader is the same as above except it also has ambient which like the diffuse shader has a multiplier to modify ambient color harshness to emphasize the lighting in the scene and give contrast. This shader is also contained within the LightToggle master shader. <img width="555" height="338" alt="image" src="https://github.com/user-attachments/assets/bf4d9cdf-e28d-4a36-ae7a-86218e43098c" />


simple specular
The specular shader is also contained within the LightToggle master shader, and is very similar to the class specular example but is combined with normal modification from the bump map in the same shader, which was not shown off in the class. <img width="281" height="298" alt="image" src="https://github.com/user-attachments/assets/2b899a9d-b7a5-47ad-9927-5178fccb8d24" />


toggleable light modes
As mentioned the light shaders are toggleable by being in the LightToggle master shader which has a number value to determine the light mode checked inside the fragment shader and is only changed by the lightmanager script that listens for player input. <img width="357" height="63" alt="image" src="https://github.com/user-attachments/assets/277c91fd-b5b8-45d7-ad35-54a41a71779d" /> <img width="587" height="333" alt="image" src="https://github.com/user-attachments/assets/6a95aaa5-fb24-4502-bdb8-eca139ecac3e" />



2 added effects 
 - bump map
The LightToggle shader also has a bump map applied to every lightmode creating the illusion of texture and depth in the scene and makes the contrast and lighting of the scene pop much more. The bump part of the shader also has a bumpscale to modify how much emphasis and contrast is needed for certain objects.
<img width="646" height="414" alt="image" src="https://github.com/user-attachments/assets/89911ce6-a1bc-4dc3-885b-561e4ab1edde" />

 - diffuse map
The diffuse map is more of a new concept and is used instead of a base color alongside a texture. This was done because when making the textures my software gives diffuse maps which were more convenient for the project and scene purposes.<img width="269" height="163" alt="image" src="https://github.com/user-attachments/assets/b7e570ec-6dc5-4b48-8e04-c735fc6d60aa" />


water shader
The water shader was achieved by applying a sin function in the vertex shader and giving it a wave scale and frequency to give some customization in the look of the water inside the fishtank. <img width="420" height="370" alt="image" src="https://github.com/user-attachments/assets/cfed2d34-99ca-4350-ba6b-0c69fc83befd" />

tv HDR shader
The tv HDR color shader is very similar to the default shader Unity provides but this adds a glow modifier and an HDR color that is used to give a glowing effect in the scene that used the post processing bloom effect to add some interesting colors to the scene. <img width="234" height="201" alt="image" src="https://github.com/user-attachments/assets/50328477-4fa0-44b7-b16b-83e0f655a6fe" />


color grading implementation
Color grading was achieved via shader graph and has a script to toggle look up tables to change the look of the scene. The color grading was attempted to make the scene have more warm colors to enhance our environment's orange tinted light, but it did not look good since the environment looked good before color grading was applied. <img width="163" height="118" alt="image" src="https://github.com/user-attachments/assets/eeb84c2c-8713-43eb-b2f3-7af532fc52eb" /> <img width="272" height="330" alt="image" src="https://github.com/user-attachments/assets/debbe4f3-56c9-4211-a60f-147d198c09a4" />


