// if (FlxG.save.data.iridaCombos) disableScript();
import flixel.util.FlxSort;

var camCombo:FlxCamera = new FlxCamera();

function postCreate() {
    FlxG.cameras.insert(camCombo, 1, false).bgColor = FlxColor.TRANSPARENT;
}

function postUpdate() {
    camCombo.zoom = camHUD.zoom / 2;

    for (a in comboGroup.members)
        a.camera = camCombo;
}

function onPostNoteHit() comboGroup.sort(FlxSort.byY, FlxSort.DESCENDING);