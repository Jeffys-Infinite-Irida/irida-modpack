import hxvlc.flixel.FlxVideoSprite;
import lime.system.System;
import haxe.io.Path;
import StringTools;

var vid:FlxVideoSprite = new FlxVideoSprite();

static var shit:Array<String> = Paths.getFolderContent("images/menus/gallery/content"); // .filter((_:String) -> return StringTools.endsWith(_, ".png"));
var content:FlxGroup = new FlxGroup();

var title:FunkinText = new FunkinText(0, 38, 0, "", 32, false);

var arrowpress:FunkinSprite = new FunkinSprite(0, 0, Paths.image("menus/gallery/ui"));

static var curGal:Int = 0;

function create() {
    vid.load(Assets.getPath(Paths.file('videos/gallerybg.mov')), ['input-repeat=65535']);
    vid.play();

    var multi:FunkinSprite = new FunkinSprite(0, 0, Paths.image("menus/gallery/multiply")); 
    multi.blend = 9;

    var header:FunkinSprite = new FunkinSprite(0, 0, Paths.image("menus/gallery/ui"));
    header.addAnim("category", "category");
    header.playAnim("category");

    var right:FunkinSprite = new FunkinSprite(0, 0, Paths.image("menus/gallery/ui"));
    right.flipX = true;

    for (a in [
        vid,
        multi,
        new FunkinSprite(0, 0, Paths.image("menus/gallery/border")),
        header,
        right,
        new FunkinSprite(0, 0, Paths.image("menus/gallery/ui")),
        arrowpress,
        title
    ]) {
        add(a).scrollFactor.set();
        a.antialiasing = Options.antialiasing;
    }

    arrowpress.addAnim("pressedarrow", "pressedarrow");
    arrowpress.playAnim("pressedarrow");
    arrowpress.alpha = 0;

    for (num => a in shit) content.add(newImg(a)).x += FlxG.width * num;

    content.add(newImg(shit[shit.length - 1])).x -= FlxG.width;
    content.add(newImg(shit[0])).x += FlxG.width * shit.length;

    insert(1, content);

    title.text = getDesc();
    FlxG.camera.scroll.x = FlxG.width * curGal;
}

function update() {
    FlxG.camera.scroll.x = lerp(FlxG.camera.scroll.x, FlxG.width * (curGal == shit.length ? -1 : curGal == -1 ? shit.length - 1 : curGal), 0.11);

    if (curGal == shit.length) {FlxG.camera.scroll.x = FlxG.width * -1;  curGal = 0; title.text = getDesc();}
    if (curGal == -1) {FlxG.camera.scroll.x = FlxG.width * shit.length; curGal = shit.length - 1; title.text = getDesc();}

    if (controls.LEFT_P || controls.RIGHT_P) {
        curGal = FlxMath.wrap(curGal + (controls.LEFT_P ? -1 : 1), -1, shit.length);
        arrowpress.flipX = controls.RIGHT_P;
        if (FlxMath.inBounds(curGal, 0, shit.length - 1)) title.text = getDesc();
    }

    if (controls.ACCEPT)
        System.openFile(Assets.getPath(Paths.file("images/menus/gallery/content/" + shit[curGal])));

    if (controls.BACK)
        FlxG.switchState(new ModState("irida/maindemo"));

    arrowpress.alpha = controls.LEFT || controls.RIGHT ? 1 : lerp(arrowpress.alpha, 0, 0.11);

    title.screenCenter(FlxAxes.X);
    title.scale.set(Math.min(320/title.width, 1), Math.min(320/title.width, 1));
}

function newImg(_:String, ?path:String):FunkinSprite {
    path ??= "menus/gallery/content/";
    var img:FunkinSprite = new FunkinSprite(0, 0, Paths.file("images/" + path + _));
    img.screenCenter();
    img.antialiasing = Options.antialiasing;
    img.scale.set(Math.min(1000 / img.width, 540 / img.height), Math.min(1000 / img.width, 540 / img.height));
    return img;
}

function getDesc():String {
    return StringTools.trim(StringTools.replace(Path.withoutExtension(shit[curGal]), "!", ""));
}