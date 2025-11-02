import flixel.addons.display.FlxBackdrop;
import openfl.display.BlendMode;

var entered:Bool = false;

var spikeU:FlxBackdrop = new FlxBackdrop(Paths.image("menus/title/spikes"), FlxAxes.X);
var spikeD:FlxBackdrop = new FlxBackdrop(Paths.image("menus/title/spikes"), FlxAxes.X);

var bloom:CustomShader;
var logosmall:FunkinSprite = new FunkinSprite(0, 0, Paths.image("menus/title/logosmallfortheintro"));

var text:FunkinText = new FunkinText(0, 0, 300, "This is the demo for:", 20, true);
static var intros:Array<String> = [
    "Due to this being a demo, there may be some performance issues present which we aim to fix over time for full release.",
    "Additionally, some content seen here may be changed and improved between now and the final version.\n\nRespectful feedback can help out a lot!",
    "nvm the mods cancelled no final version </3",
    "If your device is struggling, please try turning off shaders and/or turning on low memory mode in the options menu.\n\nThis will improve performance at the sacrifice of visuals.",
    "This mod is powered by Codename Engine. Please do not take any assets from the mod and put it in any other engines.\n\nIt makes our coders sad.\n\n:( - Care after seeing the 50th unoptimized psych engine port",
    "We hope you enjoy the mod!"
];
static var introCount:Int = 0;

function create() {
    if (FlxG.sound.music == null)
        CoolUtil.playMusic(Paths.music("menu"), true, 1, true);

    for (num => a in [
        new FunkinSprite(0, 0, Paths.image("menus/title/bg")),
        new FunkinSprite(0, 0, Paths.image("menus/title/pillar-3")),
        new FunkinSprite(0, 0, Paths.image("menus/title/pillar-2")),
        new FunkinSprite(0, 0, Paths.image("menus/title/pillar-1")),
        new FunkinSprite(0, 0, Paths.image("menus/title/pillar-mid")),
        new FunkinSprite(0, 0, Paths.image("menus/title/pillar-edge")),
        spikeU,
        spikeD
    ]) {
        add(a).screenCenter();
        var scroll:Float = switch (num) {
            case 0: 0.2;
            case 1: 0.3;
            case 2: 0.4;
            case 3: 0.5;
            default: 1;
        }
        a.scrollFactor.set(scroll, scroll);
        a.antialiasing = Options.antialiasing;
    }

    for (a in 0...2) {
        var spike:FlxBackdrop = [spikeU, spikeD][a];
        spike.scrollFactor.set();
        spike.velocity.x = a == 0 ? -30 : 30;
        spike.setPosition(FlxG.width / 2 - spike.width / 2, a == 0 ? 0 : FlxG.height - spike.height);
        spike.scrollFactor.x = 0;
        spike.flipY = a == 1;
        spike.antialiasing = Options.antialiasing;
    }

    var vig:FunkinSprite = new FunkinSprite(0, 0, Paths.image("menus/title/vignette"));
    add(vig).screenCenter();
    vig.scrollFactor.set();

    insert(5, logosmall).screenCenter();
    logosmall.y += FlxG.height;

    text.alignment = "center";
    text.font = Paths.font("SuperMario256.ttf");
    text.y = FlxG.height + logosmall.y - text.height - 5;
    insert(5, text).screenCenter(FlxAxes.X);

    logosmall.antialiasing = text.antialiasing = Options.antialiasing;
    logosmall.alpha = text.alpha = 0;

    FlxTween.tween(text, {alpha: 1, y: (FlxG.height - logosmall.height) / 2 - text.height - 5}, 2, {ease: FlxEase.circInOut});
    FlxTween.tween(logosmall, {alpha: 1, y: (FlxG.height - logosmall.height) / 2}, 2, {ease: FlxEase.circInOut, startDelay: 2});
}

function update(elapsed:Float) {
    FlxG.camera.scroll.x = FlxMath.lerp(FlxG.camera.scroll.x, entered ? 0 : (FlxG.mouse.screenX-(FlxG.width/2)) * 0.015, (1/30)*240*elapsed);
    FlxG.camera.scroll.y = FlxMath.lerp(FlxG.camera.scroll.y, entered ? 0 : (FlxG.mouse.screenY-6-(FlxG.height/2)) * 0.015, (1/30)*240*elapsed);

    if (logosmall.alpha != 0) logosmall.scale.set(lerp(logosmall.scale.x, 1, 0.11), lerp(logosmall.scale.y , 1, 0.1));
 
    if (controls.ACCEPT && !entered && text.alpha == 1 && logosmall.alpha == (introCount == 0 ? 1 : 0)) {
        FlxTween.tween(logosmall, {alpha: 0}, 0.5);
        FlxTween.tween(text, {alpha: 0}, 0.5, {onComplete: () -> {
                if (introCount == intros.length) {
                    entered = true;
                    FlxG.save.data.iridaSeenIntro = true;
                    FlxG.camera.fade(FlxColor.BLACK, 1, false, () -> FlxG.switchState(new ModState("irida/title")));
                    return;
                }
                text.text = intros[introCount++];
                text.screenCenter();
             FlxTween.tween(text, {alpha: 1}, 1, {onComplete: () -> {
            }});
        }});
    }

    FlxG.camera.zoom = lerp(FlxG.camera.zoom, entered ? 1.25 : 1, 0.04);
}

function beatHit()
    if (logosmall.alpha != 0) logosmall.scale.set(1.05, 1.05);