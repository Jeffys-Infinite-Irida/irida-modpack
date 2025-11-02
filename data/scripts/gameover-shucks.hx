//
import openfl.display.BlendMode;

var music:FlxSound = FlxG.sound.play(Paths.music("gameover-shucks"));
var retry:FunkinSprite = new FunkinSprite(438, 370, Paths.image("menus/gameover/shucks/boner"));

function create(e) {
    e.cancel();
    music.play();

    music.volume = music.pitch = 0;

    var vig:CustomShader = new CustomShader("coloredVignette");

    FlxG.cameras.add(camera = dieCam = new FlxCamera(), false).addShader(vig);
    vig.color = [0, 0, 0];
    vig.amount = 1.0;
    vig.strength = 1.0;

    dieCam.flash(FlxColor.BLACK, 2);

    add(new FunkinSprite(0, 0, Paths.image("menus/gameover/shucks/table"))).antialiasing = Options.antialiasing;

    var glow:FunkinSprite = new FunkinSprite(0, 0, Paths.image("menus/gameover/shucks/table"));
    glow.antialiasing = Options.antialiasing;
    add(glow).blend = BlendMode.ADD;

    add(retry).blend = BlendMode.MUTLIPLY;
}

function update() {
    music.volume = music.pitch = lerp(music.volume, 1, 0.04);

    if (controls.ACCEPT || controls.BACK) {
        FlxG.switchState(controls.ACCEPT ? new PlayState() : new MainMenuState());
    }
}