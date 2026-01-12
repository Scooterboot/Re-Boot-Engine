
//TODO: 
//- Rewrite when UI framework is done.
//- Implement "proper" keyboard support (keyboard is functional, but weird).
//- Mouse support as well?

// The radial is functional and fairly flexible for now, however.

global.equipRadial = ds_list_create();
ds_list_add(global.equipRadial, Equipment.Missile);
ds_list_add(global.equipRadial, -1);
ds_list_add(global.equipRadial, Equipment.SuperMissile);
ds_list_add(global.equipRadial, -1);
ds_list_add(global.equipRadial, Equipment.PowerBomb);
ds_list_add(global.equipRadial, -1);
ds_list_add(global.equipRadial, Equipment.GrappleBeam);
ds_list_add(global.equipRadial, Equipment.GravGrapple);

global.beamRadial = ds_list_create();
ds_list_add(global.beamRadial, Beam.Charge);
ds_list_add(global.beamRadial, undefined);
ds_list_add(global.beamRadial, Beam.Ice);
ds_list_add(global.beamRadial, Beam.Wave);
ds_list_add(global.beamRadial, undefined);
ds_list_add(global.beamRadial, Beam.Spazer);
ds_list_add(global.beamRadial, Beam.Plasma);
ds_list_add(global.beamRadial, undefined);

global.visorRadial = ds_list_create();
ds_list_add(global.visorRadial, Visor.Scan);
ds_list_add(global.visorRadial, Visor.XRay);
ds_list_add(global.visorRadial, -1);

InitControlVars("menu radial");

radialSize = 48;
radialMin = 32;

paused = false;
pauseAnim = 0;
prevPauseState = PauseState.None;

enum RadialState
{
	EquipMenu,
	BeamMenu,
	VisorMenu
}
state = -1;
stateAnim[RadialState.EquipMenu] = 0;
stateAnim[RadialState.BeamMenu] = 0;
stateAnim[RadialState.VisorMenu] = 0;

slotAnim = 0;
cursorAnim = 0;

beamIndex = -1;


changeMenuText_L = "${MenuL1} / ${MenuL2}\nVISORS";
changeMenuScrib_L = scribble(changeMenuText_L);
changeMenuScrib_L.starting_format("fnt_GUI",c_white);
changeMenuScrib_L.align(fa_center,fa_middle);

changeMenuText_R = "${MenuR1} / ${MenuR2}\nBEAMS";
changeMenuScrib_R = scribble(changeMenuText_R);
changeMenuScrib_R.starting_format("fnt_GUI",c_white);
changeMenuScrib_R.align(fa_center,fa_middle);

beamToggleText = "Toggle ${MenuAccept} / ${MenuTertiary}";
beamToggleScrib = scribble(beamToggleText);
beamToggleScrib.starting_format("fnt_GUI_Small2",c_white);
beamToggleScrib.align(fa_center,fa_middle);

equipName[Equipment.Missile] = "MISSILE";
equipName[Equipment.SuperMissile] = "SUPER MISSILE";
equipName[Equipment.PowerBomb] = "POWER BOMB";
equipName[Equipment.GrappleBeam] = "GRAPPLE BEAM";
equipName[Equipment.GravGrapple] = "GRAVITY COIL";

beamName[Beam.Charge] = "CHARGE BEAM";
beamName[Beam.Ice] = "ICE BEAM";
beamName[Beam.Wave] = "WAVE BEAM";
beamName[Beam.Spazer] = "SPAZER";
beamName[Beam.Plasma] = "PLASMA BEAM";

visorName[Visor.Scan] = "SCAN VISOR";
visorName[Visor.XRay] = "X-RAY VISOR";

curEquip = -1;
curBeam = -1;
curVisor = -1;