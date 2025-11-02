import openfl.display.BlendMode;

if (!PlayState.instance.inCutscene) {
    var greyscale:CustomShader = new CustomShader("greyscale");
    var red:FunkinSprite = new FunkinSprite().makeSolid(FlxG.width, FlxG.height, 0xffcc0062);

    var camPause:FlxCamera;

    var render:FunkinSprite;

    var leftShit:FlxGroup = new FlxGroup();
    var rightShit:FlxGroup = new FlxGroup();
    var glowers:FlxGroup = new FlxGroup();

    var curPause:Int = 0;
    var selectedYeah:Bool = false;

    function create(e) {
        e.music = Assets.exists(Paths.music("pause-" + PlayState.SONG.meta.name.toLowerCase())) ? "pause-" + PlayState.SONG.meta.name.toLowerCase() : "breakfast";
        e.cancel();

        greyscale.amt = 1;
        for (a in FlxG.cameras.list)
            a.addShader(greyscale);

        FlxG.cameras.add(camera = camPause = new FlxCamera(), false).bgColor = FlxColor.TRANSPARENT;
        camPause.alpha = 0;
        camPause.zoom = 1.25;
        FlxTween.tween(camPause, {alpha: 1, zoom: 1}, 0.5, {ease: FlxEase.cubeOut});

        add(red).blend = BlendMode.MULTIPLY;

        // left side shit
        var barl:FunkinSprite = new FunkinSprite(-300, 0, Paths.image("menus/pause/barl"));
        leftShit.add(barl).antialiasing = Options.antialiasing;
        FlxTween.tween(barl, {x: 0},  1.3, {ease: FlxEase.expoOut});

        for (a in 0...3) {
            var buttonThing:FunkinSprite = new FunkinSprite(-300, [5, 197, 462][a], Paths.image("menus/pause/" + ["resume", "restart", "exit"][a]));
            leftShit.add(buttonThing).antialiasing = Options.antialiasing;
            FlxTween.tween(buttonThing, {x: 0}, a + 3, {ease: FlxEase.expoOut});

            var glower:FunkinSprite = new FunkinSprite(-300, [0, 131, 472][a], Paths.image("menus/pause/" + ["resume", "restart", "exit"][a] + "-glow"));
            glowers.add(glower).antialiasing = Options.antialiasing;
            glower.ID = a;
            glower.blend = BlendMode.ADD;
            FlxTween.tween(glower, {x: 0}, a + 3, {ease: FlxEase.expoOut});
        }
        // right side shit
        var barr:FunkinSprite = new FunkinSprite(FlxG.width - 641 + 300, 0, Paths.image("menus/pause/barr"));
        rightShit.add(barr).antialiasing = Options.antialiasing;
        FlxTween.tween(barr, {x: FlxG.width - 641},  1.2, {ease: FlxEase.expoOut});

        var renderOffset:Array<Float> = switch (PlayState.SONG.meta.name.toLowerCase()) { // ok so due to me trimming transparent space we need to offset the render ok? ok
    //      case "song name": [x offset, y offset];
            case "shucks": [-25, 0];
            default: [-100, 0];
        }

        rightShit.add(render = new FunkinSprite(0, 0, Paths.image("menus/pause/renders/" + switch (PlayState.SONG.meta.name.toLowerCase()) {
            case "execretion": "execretion" + (Conductor.curPauseStep <= 864 ? "-1" : "-2");
            default: Assets.exists(Paths.image("menus/pause/renders/" + PlayState.SONG.meta.name.toLowerCase())) ? PlayState.SONG.meta.name.toLowerCase() : "null";
        }))).antialiasing = Options.antialiasing;
        render.setPosition(FlxG.width + render.width + renderOffset[0], FlxG.height / 2 - render.height / 2 + renderOffset[1]);
        FlxTween.tween(render, {x: FlxG.width - render.width + renderOffset[0]},  1.5, {ease: FlxEase.expoOut});

        var barroversmall:FunkinSprite = new FunkinSprite(FlxG.width - 442 + 300, FlxG.height - 280, Paths.image("menus/pause/barroversmall"));
        rightShit.add(barroversmall).antialiasing = Options.antialiasing;
        FlxTween.tween(barroversmall, {x: FlxG.width - 442},  2, {ease: FlxEase.expoOut});

        var barroverlong:FunkinSprite = new FunkinSprite(FlxG.width - 818 + 300, FlxG.height - 215, Paths.image("menus/pause/barroverlong"));
        rightShit.add(barroverlong).antialiasing = Options.antialiasing;
        FlxTween.tween(barroverlong, {x: FlxG.width - 818},  1.5, {ease: FlxEase.expoOut});

        var barrover:FunkinSprite = new FunkinSprite(FlxG.width - 201 + 300, 0, Paths.image("menus/pause/barrover"));
        rightShit.add(barrover).antialiasing = Options.antialiasing;
        FlxTween.tween(barrover, {x: FlxG.width - 201},  2, {ease: FlxEase.expoOut});

        add(rightShit);
        add(leftShit);
        add(glowers);
    }

    function update(elapsed:Float) {
        if (controls.ACCEPT && !selectedYeah) {
            selectedYeah = true;
            glowers.members[curPause].colorTransform.color = 0xffffccf8;
            pauseMusic.fadeOut(0.5, 0);
            CoolUtil.playMenuSFX(curPause == 2 ? 2 : 1, 0.3);
            for (a in leftShit.members) {FlxTween.cancelTweensOf(a); FlxTween.tween(a, {x: a.x - FlxG.width}, 5, {ease: FlxEase.expoOut});}
            for (a in glowers.members) {FlxTween.cancelTweensOf(a); FlxTween.tween(a, {x: a.x - FlxG.width}, 5, {ease: FlxEase.expoOut});}
            for (a in rightShit.members) {FlxTween.cancelTweensOf(a); FlxTween.tween(a, {x: a.x + FlxG.width}, 5, {ease: FlxEase.expoOut});}

            FlxTween.num(1, 0, 0.5, {onComplete: () -> switch (curPause) {
                case 1: FlxG.switchState(new PlayState());
                case 2: FlxG.switchState(new FreeplayState());
                default: close();
            }}, yep -> {greyscale.amt = yep; red.alpha = yep;});
        }

        if ((controls.UP_P || controls.DOWN_P) && !selectedYeah)
            changeSel(controls.UP_P ? -1 : 1);

        for (a in glowers.members)
            a.alpha = lerp(a.alpha, selectedYeah ? 0.1 : (curPause == a.ID ? 1 : 0.1), 0.11);
    }

    function destroy() {
        FlxTween.cancelTweensOf(camPause);
        for (a in leftShit.members) FlxTween.cancelTweensOf(a);
        for (a in rightShit.members) FlxTween.cancelTweensOf(a);

        for (a in FlxG.cameras.list)
            a.removeShader(greyscale);
    }

    function changeSel(_:Int) {
        CoolUtil.playMenuSFX(0, 0.15);
        curPause = FlxMath.wrap(curPause + _, 0, 2);
    }
} else { // copied my code from habit shout out to habit
    function create(e) e.cancel();
    function postCreate() {
        menuItems = ["Skip Cutscene"];
        selectOption();
    }
}