var transTop:FunkinSprite = new FunkinSprite(0, newState != null ? -403 : 0, Paths.image("menus/transtop"));
var transBottom:FunkinSprite = new FunkinSprite(0, newState != null ? FlxG.height : 720 - 403, Paths.image("menus/transbottom")); // breaking rule 11 of the dev server smh

function create() {
    transitionTween.cancel();
    remove(blackSpr);
    remove(transitionSprite);

    for (a in [transTop, transBottom]) {
        add(a).antialiasing = Options.antialiasing;
        a.scrollFactor.set();
        a.screenCenter(FlxAxes.X);
    }

    transitionCamera.flipY = false;

	FlxTween.tween(transTop, {y: newState != null ? 0 : -403}, 1, {ease: FlxEase.circInOut});
	FlxTween.tween(transBottom, {y: newState != null ? 720 - 403 : FlxG.height}, 1, {ease: FlxEase.circInOut, onComplete: (z) ->
        if (newState != null) {
            FlxG.switchState(newState);
            FlxTween.tween(transTop, {y: -403}, 1, {ease: FlxEase.circInOut});
            FlxTween.tween(transBottom, {y: FlxG.height}, 1, {ease: FlxEase.circInOut});
        } else finish()
    });
}