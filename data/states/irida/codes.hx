import StringTools;

var computer:FunkinSprite = new FunkinSprite(0, 0, Paths.image("menus/codes/computer"));
var pc:FunkinSprite = new FunkinSprite(0, 0, Paths.image("menus/codes/peecee"));

var hitbox:FunkinSprite = new FunkinSprite(405, 120).makeSolid(470, 260, FlxColor.PURPLE);

var typing:Bool = false;

var spikes:FunkinSprite = new FunkinSprite(0, 0, Paths.image("menus/codes/spikes"));

var typeText:FunkinText = new FunkinText(410, 240, 460, "|", 24, false);
var resultText:FunkinText = new FunkinText(410, 280, 460, "Code: DENIED", 24, false);

var shuckies:FlxGroup = new FlxGroup();
var shuckscribe:FunkinSprite = new FunkinSprite(0, 0, Paths.image("likeandshuckscribe"));
var sirvko:FunkinSprite = new FunkinSprite(335, 380, Paths.image("menus/codes/sirvko"));
var sirvkoAlpha:Float = 0;
var squcksCount:Int = 0;

var codeImg:FunkinSprite = new FunkinSprite(405, 120);

function create() {
    add(new FunkinSprite(0, 0, Paths.image("menus/codes/bg"))).antialiasing = Options.antialiasing;

    add(codeImg).antialiasing = Options.antialiasing;

    add(new FunkinSprite(0, 0, Paths.image("menus/codes/screenglow"))).antialiasing = Options.antialiasing;

    add(typeText).alignment = "center";
    typeText.color = FlxColor.BLACK;

    add(resultText).alignment = "center";
    resultText.color = FlxColor.BLACK;
    resultText.alpha = 0;

    add(sirvko).alpha = sirvkoAlpha;
    add(computer).antialiasing = Options.antialiasing;
    add(pc).antialiasing = Options.antialiasing;
    computer.visible = typeText.visible = codeImg.visible = false;

    var multi:FunkinSprite = new FunkinSprite(0, 0, Paths.image("menus/codes/screenglow"));
    multi.antialiasing = Options.antialiasing;
    add(multi).blend = 0;

    add(shuckies);

    add(spikes).antialiasing = typeText.antialiasing = shuckscribe.antialiasing = Options.antialiasing;

    add(shuckscribe).addAnim("anim", "anim");
    shuckscribe.zoomFactor = shuckscribe.alpha = 0;
    shuckscribe.scrollFactor.set();
    shuckscribe.setPosition((FlxG.width - shuckscribe.width) / 2, FlxG.height - shuckscribe.height);

    add(hitbox).alpha = 0;

    FlxG.mouse.visible = true;
}

function update() {
    FlxG.camera.zoom = lerp(FlxG.camera.zoom, typing ? 1.75 : 1, 0.04);
    FlxG.camera.scroll.y = lerp(FlxG.camera.scroll.y, typing ? -112.5 : 0, 0.04);
    spikes.alpha = lerp(spikes.alpha, typing ? 0 : 1, 0.11);

    sirvko.y = lerp(sirvko.y, sirvkoAlpha == 1 ? 200 : 380, 0.11);
    sirvko.alpha = lerp(sirvko.alpha, sirvkoAlpha, 0.11);

    if (FlxG.mouse.overlaps(hitbox) && FlxG.mouse.justPressed) {
        typing = !typing;
        computer.visible = !(codeImg.visible = false);
    }

    if (FlxG.keys.justPressed.ANY && typing && ((FlxG.keys.firstJustPressed() >= 65 && FlxG.keys.firstJustPressed() <= 90) || (FlxG.keys.firstJustPressed() >= 48 && FlxG.keys.firstJustPressed() <= 57) || FlxG.keys.firstJustPressed() == 32 || FlxG.keys.firstJustPressed() == 8)) {
        if (typeText.text == "|") typeText.text = "";
        typeText.visible = true;
    
        if (FlxG.keys.justPressed.BACKSPACE && typeText.text != "|" && typeText.text != "")
            typeText.text = typeText.text.substr(0, typeText.text.length - 1);
        else if (typeText.text.length < 32)
            typeText.text += idk(CoolUtil.keyToString(FlxG.keys.firstJustPressed()));

        if (typeText.text == "") typeText.text = "|";
    }

    if (FlxG.keys.justPressed.ENTER && typing) {
        FlxTween.cancelTweensOf(resultText);
        switch (StringTools.trim(typeText.text)) {
            case "8813":
                resultText.text = ((FlxG.save.data.iridaSirvkoMode = !FlxG.save.data.iridaSirvkoMode) == true ? "(Go back\nto Shucks?)" : "W BIAST");
                var uhhmm:FlxSound = FlxG.sound.load(Paths.sound("menu/" + (FlxG.save.data.iridaSirvkoMode ? "toggle" : "sad")));
                sirvkoAlpha = 1;
                uhhmm.onComplete = () -> sirvkoAlpha = 0;
                uhhmm.play();
            case "SHUCKIES":
                resultText.text = "Go my shucklings";
                triggerShuckies();
                typing = false;
            case "LIKE AND SHUCKSCRIBE":
                shuckscribe.alpha = 1;
                shuckscribe.playAnim("anim");
                typing = false;
            case "GREEN" | "GREEN MODE" | "GREEN SHUCKS" | "IM GREENING": resultText.text = "Green Mode: " + ((FlxG.save.data.iridaGreen = !FlxG.save.data.iridaGreen) == true ? "Enabled" : "Disabled");
            case "SHUCKS JX": resultText.text = "sorry i didnt manage to code that in time";
            case "SQUCKS":
                squcksCount++;
                resultText.text = "Code: DENIED";
                if (squcksCount >= 10) {
                    resultText.text = "Squidward yell in 2025 wilted rose";
                    new FlxTimer().start(2, () -> {
                        PlayState.loadSong("squcks");
                        FlxG.switchState(new PlayState());
                    });
                }
            default:
                resultText.text =  "Code: DENIED";
                if (Assets.exists(Paths.image("menus/codes/content/" + typeText.text.toLowerCase()))) {
                    codeImg.loadGraphic(Paths.image("menus/codes/content/" + typeText.text.toLowerCase()));
                    codeImg.scale.set(470 / codeImg.width, 260 / codeImg.height);
                    codeImg.updateHitbox();
                    pc.visible = codeImg.visible = !(computer.visible = typeText.visible = typing = false);
                    resultText.text =  "";
                }
        }
        typeText.text = "|";
        resultText.alpha = 1;
        FlxTween.tween(resultText, {alpha: 0}, 2, {startDelay: 0.5});
    }

    if (controls.BACK && !typing)
        FlxG.switchState(new ModState("irida/maindemo"));

    if (controls.BACK && typing && typeText.text == "|")
        typing = false;
}

function beatHit(_:Int) typeText.visible = typeText.text == "|" && computer.visible ? !typeText.visible : computer.visible;

function idk(_:String) {
    return switch (_) {
        case "SPACE": " ";
        case "[←]": "";
        default: _;
    }
}

function triggerShuckies() {
    shuckies.clear();
    FlxG.sound.play(Paths.sound("shuckies"));
    for (a in 0...FlxG.random.int(5, 15)) {
        var shucky:FunkinSprite = new FunkinSprite(0, 0, Paths.image("game/shuckies"));
        shucky.addAnim("shuckyrun", "shuckyrun", 72, true);
        shucky.playAnim("shuckyrun");
        shucky.antialiasing = Options.antialiasing;
        shucky.scale.x = shucky.scale.y = FlxG.random.float(0.5, 0.5);
        shuckies.add(shucky).velocity.x = -FlxG.random.int(500, 1000);
        shucky.moves = true;
        shucky.updateHitbox();
        shucky.setPosition(FlxG.width + (200 * a), FlxG.height - shucky.height - 50);
    }
}