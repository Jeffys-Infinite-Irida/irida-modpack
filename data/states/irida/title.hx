import flixel.addons.display.FlxBackdrop;
import openfl.display.BlendMode;

var logo:FunkinSprite = new FunkinSprite(0, 0, Paths.image("menus/title/logo"));
var start:FunkinSprite = new FunkinSprite(0, 0, Paths.image("menus/title/start"));
var glow:FunkinSprite = new FunkinSprite(FlxG.width / 2 - 1164 / 2, FlxG.height, Paths.image("menus/title/start-glow"));

var entered:Bool = false;

var spikeU:FlxBackdrop = new FlxBackdrop(Paths.image("menus/title/spikes"), FlxAxes.X);
var spikeD:FlxBackdrop = new FlxBackdrop(Paths.image("menus/title/spikes"), FlxAxes.X);

var bloom:CustomShader;

function create() {
    if (FlxG.sound.music == null)
        CoolUtil.playMusic(Paths.music("menu"), true, 1, true);

    if (Options.gameplayShaders && FlxG.save.data.iridaBloom) {
        FlxG.camera.addShader(bloom = new CustomShader("altbloom"));
        bloom.size = 0;
        bloom.brightness = 5;
        bloom.directions = 8;
        bloom.quality = 10;
    }

    for (num => a in [
        new FunkinSprite(0, 0, Paths.image("menus/title/bg")),
        new FunkinSprite(0, 0, Paths.image("menus/title/pillar-3")),
        new FunkinSprite(0, 0, Paths.image("menus/title/pillar-2")),
        new FunkinSprite(0, 0, Paths.image("menus/title/pillar-1")),
        new FunkinSprite(0, 0, Paths.image("menus/title/pillar-mid")),
        new FunkinSprite(0, 0, Paths.image("menus/title/pillar-edge")),
        spikeU,
        spikeD,
        logo
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

    insert(members.indexOf(logo), start).setPosition(glow.x + 382, glow.y + 114);
    add(glow).blend = BlendMode.ADD;
    glow.color = 0xfff2004c;

    start.antialiasing = glow.antialiasing = Options.antialiasing;

    for (a in 0...2) {
        var spike:FlxBackdrop = [spikeU, spikeD][a];
        spike.scrollFactor.set();
        spike.velocity.x = a == 0 ? -30 : 30;
        spike.setPosition(FlxG.width / 2 - spike.width / 2, a == 0 ? -spikeU.height : 720);
        spike.scrollFactor.x = 0;
        spike.flipY = a == 1;
        spike.antialiasing = Options.antialiasing;
    }

    var vig:FunkinSprite = new FunkinSprite(0, 0, Paths.image("menus/title/vignette"));
    add(vig).screenCenter();
    vig.scrollFactor.set();

    FlxG.camera.zoom = 1.25;
    spikeU.alpha = spikeD.alpha = 0;
}

function update(elapsed:Float) {
    FlxG.camera.scroll.x = FlxMath.lerp(FlxG.camera.scroll.x, entered ? 0 : (FlxG.mouse.screenX-(FlxG.width/2)) * 0.015, (1/30)*240*elapsed);
    FlxG.camera.scroll.y = FlxMath.lerp(FlxG.camera.scroll.y, entered ? 0 : (FlxG.mouse.screenY-6-(FlxG.height/2)) * 0.015, (1/30)*240*elapsed);

    if ((controls.ACCEPT || FlxG.mouse.justPressed) && !entered) {
        entered = true;
        glow.color = FlxColor.WHITE;
        var sfx:FlxSound = FlxG.sound.load(Paths.sound("menu/confirm"));
        sfx.play(true);
        FlxG.camera.fade(FlxColor.BLACK, sfx.length / 7500);
        if (Options.gameplayShaders && FlxG.save.data.iridaBloom)
            FlxTween.num(1, 0, sfx.length / 3750, {ease: FlxEase.quintOut, onComplete: (z) -> FlxG.switchState(new MainMenuState())}, (_) -> {
                bloom.size = 10 * _;
                bloom.brightness = 7.5 * _;
            });
        else new FlxTimer().start(sfx.length / 3750, () -> FlxG.switchState(new MainMenuState()));
    }

    FlxG.camera.zoom = lerp(FlxG.camera.zoom, entered ? 1.25 : 1, 0.04);
    logo.y = lerp(logo.y, FlxG.height / 2 - logo.height / 2 + (entered ? 0 : -50), 0.04);

    glow.y = lerp(glow.y, entered ? 720 : FlxG.height - 316, 0.04);
    start.setPosition(glow.x + 382, glow.y + 114);

    spikeU.alpha = spikeD.alpha = lerp(spikeU.alpha, entered ? 0 : 1, 0.04);
    spikeU.y = lerp(spikeU.y, entered ? -spikeU.height : 0, 0.04);
    spikeD.y = lerp(spikeD.y, entered ? 720 : FlxG.height - spikeD.height, 0.04);

    if (entered)
        glow.alpha = lerp(glow.alpha, 0.1, 0.04);
}