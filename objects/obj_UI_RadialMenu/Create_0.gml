
//TODO: Rewrite when UI framework is done.
// Is functional and fairly flexible for now, however.

global.weaponRadial = ds_list_create();
global.weaponRadial[| 0] = Weapon.Missile;
global.weaponRadial[| 1] = -1;
global.weaponRadial[| 2] = Weapon.SuperMissile;
global.weaponRadial[| 3] = -1;
global.weaponRadial[| 4] = Weapon.PowerBomb;
global.weaponRadial[| 5] = -1;
global.weaponRadial[| 6] = Weapon.GrappleBeam;
global.weaponRadial[| 7] = -1;

global.beamRadial = ds_list_create();
global.beamRadial[| 0] = Beam.Charge;
global.beamRadial[| 1] = undefined;
global.beamRadial[| 2] = Beam.Ice;
global.beamRadial[| 3] = Beam.Wave;
global.beamRadial[| 4] = undefined;
global.beamRadial[| 5] = Beam.Spazer;
global.beamRadial[| 6] = Beam.Plasma;
global.beamRadial[| 7] = undefined;

global.visorRadial = ds_list_create();
global.visorRadial[| 0] = Visor.Scan;
global.visorRadial[| 1] = Visor.XRay;
global.visorRadial[| 2] = -1;

InitControlVars("menu radial");

radialSize = 48;
radialMin = 32;

paused = false;
pauseAnim = 0;
prevPauseState = PauseState.None;

enum RadialState
{
	WeaponMenu,
	BeamMenu,
	VisorMenu
}
state = -1;
stateAnim[RadialState.WeaponMenu] = 0;
stateAnim[RadialState.BeamMenu] = 0;
stateAnim[RadialState.VisorMenu] = 0;

slotAnim = 0;
cursorAnim = 0;

beamIndex = -1;


changeMenuText_L = "${MenuL1}/${MenuL2}\nVISORS";
changeMenuScrib_L = scribble(changeMenuText_L);
changeMenuScrib_L.starting_format("fnt_GUI",c_white);
changeMenuScrib_L.align(fa_right,fa_middle);

changeMenuText_R = "${MenuR1}/${MenuR2}\nBEAMS";
changeMenuScrib_R = scribble(changeMenuText_R);
changeMenuScrib_R.starting_format("fnt_GUI",c_white);
changeMenuScrib_R.align(fa_left,fa_middle);

beamToggleText = "Toggle ${MenuAccept} / ${MenuTertiary}";
beamToggleScrib = scribble(beamToggleText);
beamToggleScrib.starting_format("fnt_GUI_Small2",c_white);
beamToggleScrib.align(fa_center,fa_middle);

// temp
weapName[Weapon.Missile] = "MISSILE";
weapName[Weapon.SuperMissile] = "SUPER MISSILE";
weapName[Weapon.PowerBomb] = "POWER BOMB";
weapName[Weapon.GrappleBeam] = "GRAPPLE BEAM";

beamName[Beam.Charge] = "CHARGE BEAM";
beamName[Beam.Ice] = "ICE BEAM";
beamName[Beam.Wave] = "WAVE BEAM";
beamName[Beam.Spazer] = "SPAZER";
beamName[Beam.Plasma] = "PLASMA BEAM";

visorName[Visor.Scan] = "SCAN VISOR";
visorName[Visor.XRay] = "X-RAY VISOR";

curWeap = -1;
curBeam = -1;
curVisor = -1;