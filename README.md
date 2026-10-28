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
Color grading was achieved via shader graph and has a script to toggle look up tables to change the look of the scene. The color grading was attempted to make the scene have more warm colors to enhance our environment's orange tinted light, but it did not look good since the environment looked good before color grading was applied.
<img width="163" height="118" alt="image" src="https://github.com/user-attachments/assets/eeb84c2c-8713-43eb-b2f3-7af532fc52eb" /> 
<img width="272" height="330" alt="image" src="https://github.com/user-attachments/assets/debbe4f3-56c9-4211-a60f-147d198c09a4" />

Liam Toews

Metal Shader
The metal shader was made using shader graph. The added piece that makes metal different was I added some noise piece so that it makes the metal look worn and tarnished as this room would be a little kids meaning mess and damage should be expected. It adds a level of difference and also most handles are not wood so we wanted a more unique look for the environment. This metal texture was added to the cabinet handles, door handles, and the roof fan.

<img width="475" height="137" alt="image" src="https://github.com/user-attachments/assets/3b486944-0e62-4d8b-9a13-51d52a57beb6" />

<img width="251" height="185" alt="image" src="https://github.com/user-attachments/assets/dc17b3b8-3b27-477a-b09c-661b29de6a1c" />

<img width="494" height="255" alt="image" src="https://github.com/user-attachments/assets/983b1b74-3a04-4932-8d15-2f3447c0b6e5" />

Glass Shader
The glass shader, also made with shader graph was my second of two shader contributions. For this shader I started with it taking the alpha value for transparency from the color so it can be modified incase any of the glass we used needed to be not as clear seen. I also added more noise with a slider to add some depth and warp to the glass without the need for bump maps. This glass was added one to the fish tank and another to the light on the fan and there will be an addition to a window once we add one in. This is beneficial to the scene as it adds some more levels of realism and true to the idea of the room. We wanted to show off the water shader as well which needed the glass to allow to water to even be seen in the fish tank.

<img width="377" height="284" alt="image" src="https://github.com/user-attachments/assets/a7ab75eb-2a53-439f-8161-a3a0a395d8c0" />

<img width="332" height="218" alt="image" src="https://github.com/user-attachments/assets/bd6b3614-d13c-4d75-a212-1740e3d7ed23" />

Color Grading Look Up Tables
Finally I was in charge of the warm and cool versions of our color grading. These were not super necessary specifically the warm as we designed the room with a warm lighting design to begin with so adding a warm color grading tint to everything did not look too good.

Rob Poidevin

Plane
The plane has two main components, it's movement physics and it's propeller. For the physics, I used a rigid body to make the plane realistically rotate from side to side and up and down, as well as moving the plane forward. However just adding force was not enough, as the plane would just keep spinning and not stop. To fix this, I made the angular velocity lerp back to 0 constantly, so that when the plane is not actively spinning, the plane would slowly stop rotating. You control the player with WASD to rotate, and SPACE to move. As for the propeller, i made a simple script for rotation, but the origin was being super weird and the axis wasn't working. To fix this, I had to rotate it in a weird way and attach it to a parent game object and rotate the parent in order for it to work.

<img width="392" height="549" alt="image" src="https://github.com/user-attachments/assets/26b069ed-7862-44f0-bbeb-14c2d9bb21e9" />

<img width="785" height="311" alt="image" src="https://github.com/user-attachments/assets/d21c549e-a680-4a62-8cf0-35548ddf0a78" />

<img width="885" height="403" alt="image" src="https://github.com/user-attachments/assets/aa0ac383-f034-439a-87a5-acc7c2888dde" />


Movable objects
The moveable objects are objects in the scene with physics, we used a rigid body to make a couple of building blocks the player can knock into, as well as a ball that the player can knock off the toybox. Crashing into these objects is intended and will not cause the player to lose and restart the game.

<img width="713" height="216" alt="image" src="https://github.com/user-attachments/assets/7bb88610-2ad0-4f51-b1ef-eda728d1eaf6" />

<img width="503" height="259" alt="image" src="https://github.com/user-attachments/assets/1bcbe385-c8f3-44ad-867b-b488eba10e8c" />

Win Condition
The win condition for the time being is to fly the plane into the pot. Since we did not have time to implement combat as of right now, we decided to make the win condition temporarily about flying to a certain location. If you hit the pot, you win, but if you hit anything else that isn't one of the moveable objects, then you lose and the game resets. To exit the game after you win, press escape.

<img width="402" height="217" alt="image" src="https://github.com/user-attachments/assets/bb231a46-3f48-45f9-8d59-9e4384a0fce9" />

<img width="590" height="349" alt="image" src="https://github.com/user-attachments/assets/a8335acc-f545-4bbd-9630-d0f2d675f3dc" />

Gameplay Showcase:
https://youtu.be/-Rg9p9Dj1a4
