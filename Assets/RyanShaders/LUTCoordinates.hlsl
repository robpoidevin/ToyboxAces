#ifndef LUT_COORDINATES_INCLUDED
#define LUT_COORDINATES_INCLUDED
void LUTCoordinates_float(
float3 Color,
float2 LUTSize,
out float2 LUTUV)
{
const float COLORS = 32.0;
float maxColor = COLORS - 1.0;
float halfColX = 0.5 / LUTSize.x;
float halfColY = 0.5 / LUTSize.y;
float threshold = maxColor / COLORS;
    
    
float xOffset = halfColX + Color.r * threshold / COLORS;
float yOffset = halfColY + Color.g * threshold;
float cell = floor(Color.b * maxColor);
LUTUV = float2( cell / COLORS + xOffset, yOffset );
}
#endif