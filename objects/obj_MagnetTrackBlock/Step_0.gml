
var glowMin = 0,
	glowMax = 0.3,
	glowRate = 0.005;
glowAlpha = clamp(glowAlpha + glowRate*glowNum, glowMin, glowMax);
if(glowAlpha <= glowMin)
{
	glowNum = 1;
}
if(glowAlpha >= glowMax)
{
	glowNum = -1;
}