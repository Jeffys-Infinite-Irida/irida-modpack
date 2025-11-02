import funkin.backend.system.framerate.Framerate;
import openfl.text.TextFormat;

var green:CustomShader = new CustomShader("purple");
var greenLerp:Float;

var addedFPSshit:Bool = false;

function new() {
    FlxG.save.data.iridaSeenIntro ??= false;
    FlxG.save.data.iridaCutscenes ??= true;

    FlxG.save.data.iridaFPS ??= false;
    FlxG.save.data.iridaTimer ??= false;
    FlxG.save.data.iridaCombos ??= true;
    FlxG.save.data.iridaGreen ??= false;
    FlxG.save.data.iridaSirvkoMode ??= false;

    FlxG.save.data.iridaBloom ??= true;
    FlxG.save.data.iridaColorCorrect ??= true;

    if (FlxG.save.data.iridaForced != true) {
        Options.streamedMusic = Options.streamedVocals = true;
        Options.downscroll = false; // didnt test for downscroll ok

        FlxG.save.data.iridaForced = true;
    }

    green.g = 1.0;
    green.threshold = 0.15;
    greenLerp = FlxG.save.data.iridaGreen ? 0 : 1;
    green.intensity = greenLerp;
    FlxG.game.addShader(green);

    FlxG.mouse.useSystemCursor = FlxG.mouse.visible = false;
    FlxG.mouse.load(Assets.getBitmapData(Paths.image("cursor")), 0.75);
}

function update() {
    if (FlxG.keys.justPressed.F3) FlxG.save.data.iridaFPS = !FlxG.save.data.iridaFPS;
    if (Framerate.debugMode != (FlxG.save.data.iridaFPS ? 1 : 0))
        Framerate.debugMode = (FlxG.save.data.iridaFPS ? 1 : 0);

    if (greenLerp != (FlxG.save.data.iridaGreen ? 0 : 1)) {
        greenLerp = FlxMath.lerp(greenLerp, FlxG.save.data.iridaGreen ? 0 : 1, 0.11);
        green.intensity = greenLerp;
    }
}

function preStateSwitch() {
    FlxG.mouse.visible = false;
}

function postStateSwitch() {
    if (!addedFPSshit) {
        Framerate.fpsCounter.fpsNum.defaultTextFormat = new TextFormat(Paths.getFontName(Paths.font('SuperMario256.ttf')), 18, -1);
        Framerate.fpsCounter.fpsLabel.defaultTextFormat = Framerate.memoryCounter.memoryText.defaultTextFormat = Framerate.memoryCounter.memoryPeakText.defaultTextFormat = Framerate.codenameBuildField.defaultTextFormat = new TextFormat(Paths.getFontName(Paths.font('SuperMario256.ttf')), 12, -1);
        addedFPSshit = true;
    }
}

function destroy() {
    FlxG.game.removeShader(green);
    Framerate.fpsCounter.fpsNum.defaultTextFormat = new TextFormat(Framerate.fontName, 18, -1);
    Framerate.fpsCounter.fpsLabel.defaultTextFormat = Framerate.memoryCounter.memoryText.defaultTextFormat = Framerate.memoryCounter.memoryPeakText.defaultTextFormat = Framerate.codenameBuildField.defaultTextFormat = Framerate.textFormat;
}