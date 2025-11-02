var AHHH:CustomShader = new CustomShader("bwoutline");

var songcard:FunkinSprite = new FunkinSprite(0, 0, Paths.image("game/cards/squcks"));

function postCreate() {
    camGame.zoom = defaultCamZoom = 1;
    camZooming = true;

    AHHH.lowerBound = 0.01;
    AHHH.upperBound = 0.2;
    AHHH.invert = true;
    camGame.addShader(AHHH);

    camNotes.scroll.y = FlxG.height;
    camHUD.scroll.y = -FlxG.height;
    camNotes.alpha = 0;
}

function postPostCreate() {
    insert(0, songcard).camera = camNotes;
    songcard.zoomFactor = 0;
    songcard.antialiasing = Options.antialiasing;
    songcard.screenCenter();
    songcard.scrollFactor.set();
    songcard.alpha = 1;
}

function stepHit(_:Int) {
    switch (_) {
        case 12:
            camGame.visible = false;
            camGame.removeShader(AHHH);
        case 16:
            camGame.visible = true;
            FlxTween.tween(camNotes, {alpha: 1, 'scroll.y': 0}, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.circInOut});
            FlxTween.tween(camHUD, {alpha: 1, 'scroll.y': 0}, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.circInOut});
            FlxTween.tween(songcard, {alpha: 0}, (Conductor.stepCrochet / 1000) * 16, {startDelay: (Conductor.stepCrochet / 1000) * 64, onComplete: (z) -> remove(songcard)});
        case 398:
            Conductor.songPosition = 0;
            Conductor.setupSong(SONG);
            vocals.stop();
            generateSong(SONG);
            for(str in strumLines)
                str.generate(str.data, 0);
            startSong();
            postCreate();
            postPostCreate();
    }
}

function update(elapsed:Float) {
    iconP2.angle = Conductor.songPosition;

    if (songcard.alpha != 0)
        songcard.scale.set((2 + Math.sin(Conductor.songPosition / 500)) / 2, (2 + -Math.sin(Conductor.songPosition / 500)) / 2);
}

function onSongEnd(e) e.cancel();