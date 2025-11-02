//
import hxvlc.flixel.FlxVideoSprite;
import openfl.display.BlendMode;
import StringTools;

var theStage:String;

public var forceOffsetX:Float = 0.0;
public var forceOffsetY:Float = 0.0;

function postCreate() {
    p1_light.origin.y = p1_glow.origin.y = 0;

    p1_glow2.screenCenter();
    p1_darknessred.screenCenter();
    p1_darkness.screenCenter();
    chair_glow.screenCenter();
    chair_dark.screenCenter();
    run_multi.screenCenter();
    run_dark.screenCenter();
    run_add.screenCenter();

    p1_glow3.blend = p1_glow.blend = run_add.blend = BlendMode.ADD;
    p1_glow2.blend = p1_darknessred.blend = p1_darkness.blend = chair_dark.blend = run_multi.blend = run_dark.blend = BlendMode.MULTIPLY;
    chair_glow.blend = BlendMode.OVERLAY;

    var runbg:FunkinSprite = new FunkinSprite(0, 0, Paths.image("stages/shucks/runhallway"));
    runbg.addAnim("intro", "intro");
    runbg.addAnim("loop", "loop", 24, true);
    runbg.addAnim("bodies", "bodies", 24, true);
    runbg.addAnim("end", "end");
    runbg.scale.set(1.02, 1.02);
    insert(0, stage.stageSprites["run_bg"] = runbg).antialiasing = Options.antialiasing;

    runbg.animation.finishCallback = (name:String) -> if (name == "intro") runbg.playAnim("loop");
}

var walkDown:Bool = false;
function beatHit(curBeat:Int) {
    if (curBeat % 2 == 0 && theStage == "run_")  {
            walkDown = !walkDown;
            strumLines.members[0].characters[4].y = (walkDown && StringTools.startsWith(strumLines.members[0].characters[4].getAnimName(), "sing") ? -35 : -50);
            strumLines.members[1].characters[3].y = (walkDown && StringTools.startsWith(strumLines.members[1].characters[3].getAnimName(), "sing") ? 165 : 150);
    }
}

function postUpdate() {
    if (theStage == "p1_") p1_light.angle = p1_glow.angle = Math.sin(Conductor.songPosition / 1000) * 7.5;
    if (theStage == "run_") camHUD.angle = camNotes.angle = Math.sin(Conductor.songPosition / 1000) * 2;
}

public static function setStage(_:String) {
    if (theStage == _) return;

    for (a in stage.stageSprites.keys())
        stage.getSprite(a).visible = StringTools.startsWith(a, _);

    theStage = _;
}

function onCameraMove(e) {
    if (theStage == "chair_" || theStage == "run_") {
        e.position.x = stage.getSprite(theStage == "run_" ? "run_bg" : "chair_bg").getMidpoint().x + forceOffsetX;
        e.position.y = stage.getSprite(theStage == "run_" ? "run_bg" : "chair_bg").getMidpoint().y + forceOffsetY;
    }
}