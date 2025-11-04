import funkin.backend.MusicBeatState;
import hxvlc.flixel.FlxVideoSprite;
import funkin.editors.EditorPicker;
import funkin.options.OptionsMenu;
import funkin.menus.ModSwitchMenu;

var buttons:Array<FunkinSprite> = [];
static var curMain:Int = 0;

var trans:Bool = false;

var sfx:FlxSound = FlxG.sound.load(Paths.sound("menu/confirm"));

function create() {
    if (FlxG.sound.music == null)
        CoolUtil.playMusic(Paths.music("menu"), true, 1, true);

    add(new FunkinSprite(0, 0, Paths.image("the d o r e the door"))).antialiasing = Options.antialiasing;

    for (num => a in ["play", "codemenu", "gallery", "options", "credits"]) {
        buttons.push(new FunkinSprite(0, 0, Paths.image("menus/maindemo/" + a)));
        buttons[num].setPosition(FlxG.width / 2 - buttons[num].width / 2, FlxG.height / 8 * (num + 2) - buttons[num].height / 2);
        add(buttons[num]).antialiasing = Options.antialiasing;
    }
}

function update() {
    for (a in 0...buttons.length)
        buttons[a].alpha = lerp(buttons[a].alpha, !trans ? (curMain == a ? 1 : 0.25) : (curMain == a ? curMain == 0 ? 0 : 1 : 0), !trans ? 0.11 : (curMain != a ? 0.11 : 0.04));

    if (!trans)
        curMain = FlxMath.wrap(curMain + ((controls.UP_P ? -1 : 0) + (controls.DOWN_P ? 1 : 0) + -FlxG.mouse.wheel), 0, 4);

    if (controls.SWITCHMOD || (controls.DEV_ACCESS && Options.devMode) && !trans) {
        persistentUpdate = !(persistentDraw = true);
        openSubState(controls.SWITCHMOD ? new ModSwitchMenu() : new EditorPicker());
    }

    if (controls.BACK && !trans)
        FlxG.switchState(new ModState("irida/title"));

    if ((controls.ACCEPT || FlxG.keys.justPressed) && !trans) {
        trans = true;
        sfx.play(true);
        new FlxTimer().start(sfx.length / 4750, () -> switch (curMain) {
            case 0:
                MusicBeatState.skipTransOut = true;
                PlayState.loadSong("shucks");
                FlxG.switchState(new PlayState());
            case 1 | 2 | 4: FlxG.switchState(new ModState("irida/" + ["codes", "gallery", null, "credits"][curMain - 1]));
            case 3: FlxG.switchState(new OptionsMenu());
            default: trace("end");
        });
    }

    if (trans) {
        buttons[curMain].y = lerp(buttons[curMain].y, FlxG.height / 2 - buttons[curMain].height / 2, 0.11);
        if (curMain == 0) FlxG.sound.music.volume = FlxG.sound.music.pitch = lerp(FlxG.sound.music.volume, 0, 0.11);
    }
}