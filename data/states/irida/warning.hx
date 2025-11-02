var entered:Bool = false;

function create() {
    FlxG.camera.fade(FlxColor.BLACK, 1.5, true);

    var text1:FunkinText = new FunkinText(0, 125, FlxG.width, "WARNING", 128, false);
    var text2:FunkinText = new FunkinText(125, 250, FlxG.width - 250, "This mod contains content that may not be suitable for all players. Only mature audiences should view this mod. Please check the download page for further details when available. And as always...", 48, false);
    var text3:FunkinText = new FunkinText(0, 475, FlxG.width, "Viewer discretion is advised.\nThank you.", 64, false);

    add(text1).color = FlxColor.RED;
    add(text2);
    add(text3);

    text1.font = text2.font = text3.font = Paths.font("times.ttf");
    text1.alignment = text2.alignment = text3.alignment = "center";
    text1.antialiasing = text2.antialiasing = text3.antialiasing = Options.antialiasing;
}

function update() {
    if (controls.ACCEPT && !entered) {
        entered = true;
        FlxG.camera.stopFade();
        FlxG.camera.fade(FlxColor.BLACK, 0.5, false, () -> FlxG.switchState(new ModState("irida/" + (FlxG.save.data.iridaSeenIntro ? "title" : "introdemo"))));
    }
}