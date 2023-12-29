package options;

class MobileOptionsSubState extends BaseOptionsMenu
{
	var mafaka:Float;
	public function new()
	{
		title = 'Mobile Options';
		rpcTitle = 'Mobile Options Menu'; //for Discord Rich Presence, fuck it

                #if !web
		var option:Option = new Option('Extra Controls', //Name
			'Select how many extra buttons you prefere to have\nThey can be used for mechanics with LUA or HScript.', //Description
			'extraButtons', //Save data variable name
			'string',
			["NONE", "ONE", "TWO"]); //Variable type
		addOption(option);

        var option:Option = new Option('Hitbox Position', //Name
			'If checked, the hitbox will be put at the bottom of the screen, otherwise will stay at the top.', //Description
			'hitbox2', //Save data variable name
			'bool'); //Variable type
		addOption(option);
                #end

		var option:Option = new Option('Dynamic Controls Color',
		'If checked, the mobile controls color will be set to the notes color in your settings.\n(have effect during gameplay only)',
		'dynamicColors',
		'bool');
		addOption(option);

		var option:Option = new Option('Mobile Controls Opacity',
			'How much transparent should the Mobile Controls be.',
			'controlsAlpha',
			'percent');
		option.scrollSpeed = 1;
		option.minValue = 0.001;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		option.onChange = setAlpha;
		addOption(option);

		super();
	}
	public function setAlpha():Void {
		if (curOption.getValue() != mafaka)
			mafaka = curOption.getValue();

		virtualPad.alpha = mafaka;
	}
}
