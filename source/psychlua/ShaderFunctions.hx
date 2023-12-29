package psychlua;

#if (!flash && sys)
import openfl.filters.ShaderFilter;
import flixel.addons.display.FlxRuntimeShader;
#end
#if !flash
import shaders.CustomShaders;
#end

class ShaderFunctions
{
	#if (!flash && MODS_ALLOWED && sys)
        private static var storedFilters:Map<String, ShaderFilter> = [];
        #end
		public static function implement(funk:FunkinLua)
			{
				// shader shit
		funk.addLocalCallback("initLuaShader", function(name:String) {
			if(!ClientPrefs.data.shaders) return false;

			#if (!flash && MODS_ALLOWED && sys)
			return funk.initLuaShader(name);
			#else
			FunkinLua.luaTrace("initLuaShader: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
			#end
			return false;
		});
		
		funk.addLocalCallback("setSpriteShader", function(obj:String, shader:String) {
			if(!ClientPrefs.data.shaders) return false;

			#if (!flash && MODS_ALLOWED && sys)
			if(!funk.runtimeShaders.exists(shader) && !funk.initLuaShader(shader))
			{
				FunkinLua.luaTrace('setSpriteShader: Shader $shader is missing!', false, false, FlxColor.RED);
				return false;
			}

			funk.addLocalCallback("addShaderToCam", function(cam:String, shader:String, ?index:String) {
			if (!ClientPrefs.data.shaders) return false;

			if (index == null || index.length < 1)
			    index = shader;

			#if (!flash && MODS_ALLOWED && sys)
			if (!funk.runtimeShaders.exists(shader) && !funk.initLuaShader(shader)) {
			    FunkinLua.luaTrace('addShaderToCam: Shader $shader is missing!', false, false, FlxColor.RED);
			    return false;
			}

                        var arr:Array<String> = funk.runtimeShaders.get(shader);
			// Both FlxGame and FlxCamera has a _filters array and a setFilters function
			// We should maybe make an interface for that?
                        var camera = getCam(cam);
                        @:privateAccess {
                                if (camera._filters == null)
                                    camera._filters = [];

                                var filter = new ShaderFilter(new FlxRuntimeShader(arr[0], arr[1]));
                                storedFilters.set(index, filter);
                                camera._filters.push(filter);
                        }
                        return true;
			#else
                        FunkinLua.luaTrace("addShaderToCam: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
			#end
			return false;
		});

                funk.addLocalCallback("removeCamShader", function(cam:String, shader:String) {
                        #if (!flash && MODS_ALLOWED && sys)
                        var camera = getCam(cam);
                        @:privateAccess {
                                if (!storedFilters.exists(shader)) {
                                        FunkinLua.luaTrace('removeCamShader: $shader does not exist!', false, false, FlxColor.YELLOW);
                                        return false;
                                }

                                if (camera._filters == null) {
                                        FunkinLua.luaTrace('removeCamShader: camera $cam does not have any shaders!', false, false, FlxColor.YELLOW);
                                        return false;
                                }

                                camera._filters.remove(storedFilters.get(shader));
                                storedFilters.remove(shader);
                                return true;
                        }
                        #else
                        FunkinLua.luaTrace('removeCamShader: Platform unsupported for Runtime Shaders!', false, false, FlxColor.RED);
                        #end
                        return false;
                });

                funk.addLocalCallback("clearCamShaders", function(cam:String) getCam(cam).setFilters([]));

			var split:Array<String> = obj.split('.');
			var leObj:FlxSprite = LuaUtils.getObjectDirectly(split[0]);
			if(split.length > 1) {
				leObj = LuaUtils.getVarInArray(LuaUtils.getPropertyLoop(split), split[split.length-1]);
			}

			if(leObj != null) {
				var arr:Array<String> = funk.runtimeShaders.get(shader);
				leObj.shader = new FlxRuntimeShader(arr[0], arr[1]);
				return true;
			}
			#else
			FunkinLua.luaTrace("setSpriteShader: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
			#end
			return false;

		});
		funk.set("removeSpriteShader", function(obj:String) {
			var split:Array<String> = obj.split('.');
			var leObj:FlxSprite = LuaUtils.getObjectDirectly(split[0]);
			if(split.length > 1) {
				leObj = LuaUtils.getVarInArray(LuaUtils.getPropertyLoop(split), split[split.length-1]);
			}

			if(leObj != null) {
				leObj.shader = null;
				return true;
			}
			return false;
		});

		funk.set("getShaderBool", function(obj:String, prop:String) {
			#if (!flash && MODS_ALLOWED && sys)
			var shader:FlxRuntimeShader = getShader(obj);
			if (shader == null)
			{
				FunkinLua.luaTrace("getShaderBool: Shader is not FlxRuntimeShader!", false, false, FlxColor.RED);
				return null;
			}
			return shader.getBool(prop);
			#else
			FunkinLua.luaTrace("getShaderBool: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
			return null;
			#end
		});
		funk.set("getShaderBoolArray", function(obj:String, prop:String) {
			#if (!flash && MODS_ALLOWED && sys)
			var shader:FlxRuntimeShader = getShader(obj);
			if (shader == null)
			{
				FunkinLua.luaTrace("getShaderBoolArray: Shader is not FlxRuntimeShader!", false, false, FlxColor.RED);
				return null;
			}
			return shader.getBoolArray(prop);
			#else
			FunkinLua.luaTrace("getShaderBoolArray: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
			return null;
			#end
		});
		funk.set("getShaderInt", function(obj:String, prop:String) {
			#if (!flash && MODS_ALLOWED && sys)
			var shader:FlxRuntimeShader = getShader(obj);
			if (shader == null)
			{
				FunkinLua.luaTrace("getShaderInt: Shader is not FlxRuntimeShader!", false, false, FlxColor.RED);
				return null;
			}
			return shader.getInt(prop);
			#else
			FunkinLua.luaTrace("getShaderInt: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
			return null;
			#end
		});
		funk.set("getShaderIntArray", function(obj:String, prop:String) {
			#if (!flash && MODS_ALLOWED && sys)
			var shader:FlxRuntimeShader = getShader(obj);
			if (shader == null)
			{
				FunkinLua.luaTrace("getShaderIntArray: Shader is not FlxRuntimeShader!", false, false, FlxColor.RED);
				return null;
			}
			return shader.getIntArray(prop);
			#else
			FunkinLua.luaTrace("getShaderIntArray: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
			return null;
			#end
		});
		funk.set("getShaderFloat", function(obj:String, prop:String) {
			#if (!flash && MODS_ALLOWED && sys)
			var shader:FlxRuntimeShader = getShader(obj);
			if (shader == null)
			{
				FunkinLua.luaTrace("getShaderFloat: Shader is not FlxRuntimeShader!", false, false, FlxColor.RED);
				return null;
			}
			return shader.getFloat(prop);
			#else
			FunkinLua.luaTrace("getShaderFloat: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
			return null;
			#end
		});
		funk.set("getShaderFloatArray", function(obj:String, prop:String) {
			#if (!flash && MODS_ALLOWED && sys)
			var shader:FlxRuntimeShader = getShader(obj);
			if (shader == null)
			{
				FunkinLua.luaTrace("getShaderFloatArray: Shader is not FlxRuntimeShader!", false, false, FlxColor.RED);
				return null;
			}
			return shader.getFloatArray(prop);
			#else
			FunkinLua.luaTrace("getShaderFloatArray: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
			return null;
			#end
		});


		funk.set("setShaderBool", function(obj:String, prop:String, value:Bool) {
			#if (!flash && MODS_ALLOWED && sys)
			var shader:FlxRuntimeShader = getShader(obj);
			if(shader == null)
			{
				FunkinLua.luaTrace("setShaderBool: Shader is not FlxRuntimeShader!", false, false, FlxColor.RED);
				return false;
			}
			shader.setBool(prop, value);
			return true;
			#else
			FunkinLua.luaTrace("setShaderBool: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
			return false;
			#end
		});
		funk.set("setShaderBoolArray", function(obj:String, prop:String, values:Dynamic) {
			#if (!flash && MODS_ALLOWED && sys)
			var shader:FlxRuntimeShader = getShader(obj);
			if(shader == null)
			{
				FunkinLua.luaTrace("setShaderBoolArray: Shader is not FlxRuntimeShader!", false, false, FlxColor.RED);
				return false;
			}
			shader.setBoolArray(prop, values);
			return true;
			#else
			FunkinLua.luaTrace("setShaderBoolArray: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
			return false;
			#end
		});
		funk.set("setShaderInt", function(obj:String, prop:String, value:Int) {
			#if (!flash && MODS_ALLOWED && sys)
			var shader:FlxRuntimeShader = getShader(obj);
			if(shader == null)
			{
				FunkinLua.luaTrace("setShaderInt: Shader is not FlxRuntimeShader!", false, false, FlxColor.RED);
				return false;
			}
			shader.setInt(prop, value);
			return true;
			#else
			FunkinLua.luaTrace("setShaderInt: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
			return false;
			#end
		});
		funk.set("setShaderIntArray", function(obj:String, prop:String, values:Dynamic) {
			#if (!flash && MODS_ALLOWED && sys)
			var shader:FlxRuntimeShader = getShader(obj);
			if(shader == null)
			{
				FunkinLua.luaTrace("setShaderIntArray: Shader is not FlxRuntimeShader!", false, false, FlxColor.RED);
				return false;
			}
			shader.setIntArray(prop, values);
			return true;
			#else
			FunkinLua.luaTrace("setShaderIntArray: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
			return false;
			#end
		});
		funk.set("setShaderFloat", function(obj:String, prop:String, value:Float) {
			#if (!flash && MODS_ALLOWED && sys)
			var shader:FlxRuntimeShader = getShader(obj);
			if(shader == null)
			{
				FunkinLua.luaTrace("setShaderFloat: Shader is not FlxRuntimeShader!", false, false, FlxColor.RED);
				return false;
			}
			shader.setFloat(prop, value);
			return true;
			#else
			FunkinLua.luaTrace("setShaderFloat: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
			return false;
			#end
		});
		funk.set("setShaderFloatArray", function(obj:String, prop:String, values:Dynamic) {
			#if (!flash && MODS_ALLOWED && sys)
			var shader:FlxRuntimeShader = getShader(obj);
			if(shader == null)
			{
				FunkinLua.luaTrace("setShaderFloatArray: Shader is not FlxRuntimeShader!", false, false, FlxColor.RED);
				return false;
			}

			shader.setFloatArray(prop, values);
			return true;
			#else
			FunkinLua.luaTrace("setShaderFloatArray: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
			return true;
			#end
		});

		funk.set("setShaderSampler2D", function(obj:String, prop:String, bitmapdataPath:String) {
			#if (!flash && MODS_ALLOWED && sys)
			var shader:FlxRuntimeShader = getShader(obj);
			if(shader == null)
			{
				FunkinLua.luaTrace("setShaderSampler2D: Shader is not FlxRuntimeShader!", false, false, FlxColor.RED);
				return false;
			}

			// trace('bitmapdatapath: $bitmapdataPath');
			var value = Paths.image(bitmapdataPath);
			if(value != null && value.bitmap != null)
			{
				// trace('Found bitmapdata. Width: ${value.bitmap.width} Height: ${value.bitmap.height}');
				shader.setSampler2D(prop, value.bitmap);
				return true;
			}
			return false;
			#else
			FunkinLua.luaTrace("setShaderSampler2D: Platform unsupported for Runtime Shaders!", false, false, FlxColor.RED);
			return false;
			#end
		});

                // SHADER SHIT
                #if !flash
                funk.set("addChromaticAbberationEffect", function(camera:String,chromeOffset:Float = 0.005) {

                        PlayState.instance.addShaderToCamera(camera, new ChromaticAberrationEffect(chromeOffset));

                });

                funk.set("addScanlineEffect", function(camera:String,lockAlpha:Bool=false) {

                        PlayState.instance.addShaderToCamera(camera, new ScanlineEffect(lockAlpha));

                });
                funk.set("addGrainEffect", function(camera:String,grainSize:Float,lumAmount:Float,lockAlpha:Bool=false) {

                        PlayState.instance.addShaderToCamera(camera, new GrainEffect(grainSize,lumAmount,lockAlpha));

                });
                funk.set("addTiltshiftEffect", function(camera:String,blurAmount:Float,center:Float) {

                        PlayState.instance.addShaderToCamera(camera, new TiltshiftEffect(blurAmount,center));

                });
                funk.set("addVCREffect", function(camera:String,glitchFactor:Float = 0.0,distortion:Bool=true,perspectiveOn:Bool=true,vignetteMoving:Bool=true) {

                        PlayState.instance.addShaderToCamera(camera, new VCRDistortionEffect(glitchFactor,distortion,perspectiveOn,vignetteMoving));

                });

                funk.set("addGlitchEffect", function(camera:String,waveSpeed:Float = 0.1,waveFrq:Float = 0.1,waveAmp:Float = 0.1) {

                        PlayState.instance.addShaderToCamera(camera, new GlitchEffect(waveSpeed,waveFrq,waveAmp));

                });
                funk.set("addPulseEffect", function(camera:String,waveSpeed:Float = 0.1,waveFrq:Float = 0.1,waveAmp:Float = 0.1) {

                        PlayState.instance.addShaderToCamera(camera, new PulseEffect(waveSpeed,waveFrq,waveAmp));

                });
                funk.set("addDistortionEffect", function(camera:String,waveSpeed:Float = 0.1,waveFrq:Float = 0.1,waveAmp:Float = 0.1) {

                        PlayState.instance.addShaderToCamera(camera, new DistortBGEffect(waveSpeed,waveFrq,waveAmp));

                });
                funk.set("addInvertEffect", function(camera:String,lockAlpha:Bool=false) {

                        PlayState.instance.addShaderToCamera(camera, new InvertColorsEffect(lockAlpha));

                });
                funk.set("addGreyscaleEffect", function(camera:String) { //for dem funkies

                        PlayState.instance.addShaderToCamera(camera, new GreyscaleEffect());

                });
                funk.set("addGrayscaleEffect", function(camera:String) { //for dem funkies

                        PlayState.instance.addShaderToCamera(camera, new GreyscaleEffect());

                });
                funk.set("add3DEffect", function(camera:String,xrotation:Float=0,yrotation:Float=0,zrotation:Float=0,depth:Float=0) { //for dem funkies

                        PlayState.instance.addShaderToCamera(camera, new ThreeDEffect(xrotation,yrotation,zrotation,depth));

                });
                funk.set("addBloomEffect", function(camera:String,intensity:Float = 0.35,blurSize:Float=1.0) {

                        PlayState.instance.addShaderToCamera(camera, new BloomEffect(blurSize/512.0,intensity));

                });
                funk.set("clearEffects", function(camera:String) {
                        PlayState.instance.clearShaderFromCamera(camera);
                });
                #end
	}
	
	#if (!flash && sys)
	public static function getShader(obj:String):FlxRuntimeShader
	{
		if (storedFilters.exists(obj))
		    return cast (storedFilters[obj].shader, FlxRuntimeShader);

		var split:Array<String> = obj.split('.');
		var target:FlxSprite = null;
		if(split.length > 1) target = LuaUtils.getVarInArray(LuaUtils.getPropertyLoop(split), split[split.length-1]);
		else target = LuaUtils.getObjectDirectly(split[0]);

		if(target == null)
		{
			FunkinLua.luaTrace('Error on getting shader: Object $obj not found', false, false, FlxColor.RED);
			return null;
		}
		return cast (target.shader, FlxRuntimeShader);
	}

	public static function getCam(obj:String):Dynamic {
               	if (obj.toLowerCase().trim() == "global")
		    return FlxG.game;
	        return LuaUtils.cameraFromString(obj);
        }
	#end
}
