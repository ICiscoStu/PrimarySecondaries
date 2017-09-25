class X2Ability_PrimarySecondaries extends X2Ability
	dependson (XComGameStateContext_Ability) config(PrimarySecondaries);

var config int PISTOL_MOVEMENT_BONUS;
var config int PISTOL_DETECTIONRADIUS_MODIFER;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(QuickDrawPrimary());
	Templates.AddItem(PrimaryPistolsBonus('PrimaryPistolsBonus', default.PISTOL_MOVEMENT_BONUS, default.PISTOL_DETECTIONRADIUS_MODIFER));
	Templates.AddItem(PrimaryAnimSet());

	return Templates;
}

static function X2AbilityTemplate QuickDrawPrimary()
{
	local X2AbilityTemplate			Template;

	Template = PurePassive('QuickDrawPrimary', "img:///UILibrary_PerkIcons.UIPerk_quickdraw");

	return Template;
}

static function X2AbilityTemplate PrimaryPistolsBonus(name TemplateName, int Bonus, float DetectionModifier)
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_item_nanofibervest";

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false, , Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, Bonus);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_DetectionModifier, DetectionModifier);
	Template.AddTargetEffect(PersistentStatChangeEffect);
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	
	return Template;
}

static function X2AbilityTemplate PrimaryAnimSet()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_AdditionalAnimSets		AnimSets;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'PrimaryAnimSet');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_item_nanofibervest";

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	AnimSets = new class'X2Effect_AdditionalAnimSets';
	AnimSets.AddAnimSetWithPath("PrimaryPistols_ANIM.Anims.AS_Primary");
	AnimSets.BuildPersistentEffect(1, true, false, false);
	Template.AddTargetEffect(AnimSets);
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;
	
	return Template;
}