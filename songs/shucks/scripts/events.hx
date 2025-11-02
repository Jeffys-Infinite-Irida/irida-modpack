import funkin.backend.MusicBeatState;
import hxvlc.flixel.FlxVideoSprite;

var ass:CustomShader;
var bloom:CustomShader;

var camVideo:FlxCamera = new FlxCamera();

var dore:FunkinSprite = new FunkinSprite(0, 0, Paths.image("the d o r e the door"));
var doorVid:FlxVideoSprite = new FlxVideoSprite();
var lyricVid:FlxVideoSprite = new FlxVideoSprite();
var bitchVid:FlxVideoSprite = new FlxVideoSprite();

var songcard:FunkinSprite = new FunkinSprite(0, 0, Paths.image("game/cards/shucks"));

introLength = 0;

MusicBeatState.skipTransIn = true;

var playerGhost:Character;
var dadGhost:Character;

var iconP3:HealthIcon = new HealthIcon("rose-shucks", true);

function create() {
    if (FlxG.save.data.iridaSirvkoMode)
        vocals = FlxG.sound.load(Options.streamedVocals ? Assets.getMusic(Paths.voices(SONG.meta.name, "Sirvko")) : Paths.voices(SONG.meta.name, "Sirvko"));

    insert(25, playerGhost = new Character(0, 0, 'marvin-shucks', false)).scale.set(1.1, 1.1);
    playerGhost.setPosition(strumLines.members[1].characters[1].x + 445, strumLines.members[1].characters[1].y + 1090);
    playerGhost.skew.x = 40;

    insert(25, dadGhost = new Character(0, 0, 'detg', false)).scale.set(1.1, 1.1);
    dadGhost.skew.x = -40;
    dadGhost.setPosition(strumLines.members[0].characters[1].x - 850, strumLines.members[0].characters[1].y + 2224);

    playerGhost.angle = dadGhost.angle = 180;
    playerGhost.flipX = dadGhost.flipX = true;
    playerGhost.alpha = dadGhost.alpha = 0;
}

function postCreate() {
    insert(0, songcard).camera = camHUD;
    songcard.antialiasing = Options.antialiasing;
    songcard.screenCenter();
    songcard.scrollFactor.set();
    songcard.alpha = songcard.zoomFactor = 0;
    // videos
    add(doorVid).load(Assets.getPath(Paths.file('videos/shucks-door.mov')));
    doorVid.play();
    doorVid.scrollFactor.set();

    add(lyricVid).load(Assets.getPath(Paths.file('videos/shucks-lyrics.mkv')));
    lyricVid.scale.set(0.68,0.68);
    lyricVid.setPosition(-317,-180);
    lyricVid.play();
    lyricVid.scrollFactor.set();

    add(bitchVid).load(Assets.getPath(Paths.file('videos/shucks-youbitch.mkv')));
    bitchVid.play();
    bitchVid.scrollFactor.set();

    add(dore);

    doorVid.camera = lyricVid.camera = bitchVid.camera = dore.camera = camVideo;
    doorVid.antialiasing = lyricVid.antialiasing = bitchVid.antialiasing = dore.antialiasing = Options.antialiasing;
    lyricVid.visible = bitchVid.visible = false;
}

function postPostCreate() {
    FlxG.cameras.insert(camVideo, 1, false).bgColor = FlxColor.TRANSPARENT;

    setIridaBar("shadow");
    setStage("none");
    // camera shit
    camNotes.scroll.y = FlxG.height;
    camHUD.scroll.y = -FlxG.height;
    camNotes.alpha = 0;

    strumLines.members[2].characters[0].cameraOffset.set(900, 500);

    iconP1.setIcon("marvin-shucks-shadow");
    iconP2.setIcon("detg-shadow", 200, 150);

    iconP3.bump = () -> iconP3.scale.set(1, 1);
    iconP3.updateBump = () -> iconP3.scale.set(CoolUtil.fpsLerp(iconP3.scale.x, 0.8, 0.11), CoolUtil.fpsLerp(iconP3.scale.y, 0.8, 0.11));
    iconP3.alpha = 0;
    iconP3.camera = camHUD;
    iconP3.scrollFactor.set(1, 1);
    iconArray.push(iconP3);
    insert(members.indexOf(iconP1) + 1, iconP3).setPosition(1175, iconP2.y + (iconP3.camera.downscroll ? -30 : 15));
}

function stepHit(_:Int) {
    switch (_) {
        case 4:
            remove(dore);
        case 72:
            remove(doorVid);
            camHUD.alpha = 0;
            strumLines.members[1].characters[0].playAnim("anim");
            strumLines.members[1].characters[0].alpha = 1;
        case 154:
            FlxTween.tween(strumLines.members[0].characters[0], {alpha: 1}, (Conductor.stepCrochet / 1000) * 20);
            FlxTween.num(1.25, 1, (Conductor.stepCrochet / 1000) * 20, {ease: FlxEase.circInOut}, zoom -> camGame.zoom = defaultCamZoom = zoom);
            FlxTween.num(900, -875, (Conductor.stepCrochet / 1000) * 20, {ease: FlxEase.circInOut}, ex -> strumLines.members[2].characters[0].cameraOffset.x = ex);
            FlxTween.num(500, 25, (Conductor.stepCrochet / 1000) * 20, {ease: FlxEase.circInOut}, why -> strumLines.members[2].characters[0].cameraOffset.y = why);
        case 176:
            FlxTween.tween(camNotes, {alpha: 1, 'scroll.y': 0}, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.circInOut});
        case 304:
            FlxTween.tween(camHUD, {alpha: 1, 'scroll.y': 0}, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.circInOut});
            FlxTween.num(1, 0.75, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.circInOut}, zoom -> camGame.zoom = defaultCamZoom = zoom);
            FlxTween.num(-875, -25, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.circInOut}, ex -> strumLines.members[2].characters[0].cameraOffset.x = ex);
            FlxTween.num(25, 275, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.circInOut}, why -> strumLines.members[2].characters[0].cameraOffset.y = why);
        case 452:
            strumLines.members[0].characters[1].playAnim("intro", true);
            camHUD.fade(FlxColor.BLACK, (Conductor.stepCrochet / 1000) * 4, null, () -> {
                camHUD.stopFade();
                camNotes.alpha = camHUD.alpha = 0;
                camGame.visible = false;
                flicker(camGame, (Conductor.stepCrochet / 1000) * 4, Conductor.stepCrochet / 2500);
                setStrumSkin("default", [0, 1]);
                setIridaBar("default");
                setStage("p1_");

                iconP1.setIcon("marvin-shucks");
                iconP2.setIcon("detg", 200, 150);
                
                if (Options.gameplayShaders && FlxG.save.data.iridaBloom) {
                    bloom = new CustomShader('bloom');
                    camGame.addShader(bloom);
                    bloom.Threshold = 0.005;
                    bloom.Intensity = 1;
                }

                if (Options.gameplayShaders && FlxG.save.data.iridaColorCorrect) {
                    ass = new CustomShader('ColorCorrection');
                    camGame.addShader(ass);
                    ass.contrast = 30;
                    ass.hue = -10;
                    ass.saturation = -10;
                }

                healthBar.createFilledBar(0xffbf5e2b, 0xffae211b);
                healthBar.percent = health;

                strumLines.members[0].characters[0].alpha = strumLines.members[1].characters[0].alpha = 0;
                strumLines.members[0].characters[1].alpha = strumLines.members[1].characters[1].alpha = strumLines.members[2].characters[0].alpha = 1;
                strumLines.members[2].characters[0].cameraOffset.set(-25, 475);

                strumLines.members[0].characters[0].cameraOffset.set(-825, -875);
                strumLines.members[1].characters[1].cameraOffset.set(325, 675);

                camGame.zoom = defaultCamZoom = 0.4;

                playerGhost.alpha = dadGhost.alpha = 0.6;

                playerGhost.animateAtlas.colorTransform.color = dadGhost.animateAtlas.colorTransform.color = FlxColor.BLACK;
            });
        case 464 | 3616:
            vocals.volume = 1;
        case 528:
            camHUD.stopFade();
            FlxTween.tween(camNotes, {alpha: 1}, (Conductor.stepCrochet / 1000) * 16);
            FlxTween.tween(camHUD, {alpha: 1}, (Conductor.stepCrochet / 1000) * 16);
        case 544:
            coolFlash(FlxColor.WHITE, 8, 0.5);
        case 808:
            FlxTween.tween(songcard, {alpha: 1}, (Conductor.stepCrochet / 1000) * 8);
            FlxTween.tween(songcard, {alpha: 0}, (Conductor.stepCrochet / 1000) * 16, {startDelay: (Conductor.stepCrochet / 1000) * 24});
        case 1312:
            if (Options.gameplayShaders && FlxG.save.data.iridaColorCorrect) {
                FlxTween.num(0,  -50, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.quartOut}, val -> ass.brightness = val);
                FlxTween.num(-10,  -10, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.quartOut}, val -> ass.hue = val);
                FlxTween.num(-10,  50, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.quartOut}, val -> ass.saturation = val);
                FlxTween.num(30,  100, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.quartOut}, val -> ass.contrast = val);
            }
        case 1472:
            if (Options.gameplayShaders && FlxG.save.data.iridaColorCorrect) {
                FlxTween.num(-50,  0, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.quartOut}, val -> ass.brightness = val);
                FlxTween.num(-10,  -10, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.quartOut}, val -> ass.hue = val);
                FlxTween.num(50,  -10, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.quartOut}, val -> ass.saturation = val);
                FlxTween.num(100,  30, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.quartOut}, val -> ass.contrast = val);
            }
        case 1884:
            FlxTween.tween(iconP3, {alpha: 1}, 1, {ease: FlxEase.quartOut});
            FlxTween.tween(iconP3, {x: iconP1.x + 70}, 0.5, {ease: FlxEase.quartOut});
        case 2144:
            strumLines.members[2].characters[0].cameraOffset.set(-25, 875);
        case 2400:
            iconP3.health = 0;
            vocals.volume = 1;
            FlxTween.tween(iconP3, {alpha: 0, x: 1175, angle: 90}, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.circInOut});
            FlxTween.tween(camNotes, {alpha: 0}, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.circInOut});
            FlxTween.tween(camHUD, {alpha: 0, 'scroll.y': -FlxG.height}, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.circInOut});
        case 2656:
            strumLines.members[2].characters[0].alpha = 0;
            strumLines.members[2].characters[1].alpha = 1;
            iconP1.setIcon("marvin-shucks-bloody");
            camHUD.stopFade();
            FlxTween.tween(camNotes, {alpha: 1}, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.circInOut});
            FlxTween.tween(camHUD, {alpha: 1, 'scroll.y': 0}, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.circInOut});        
         case 3088:
            if (Options.gameplayShaders && FlxG.save.data.iridaColorCorrect) {
                FlxTween.num(0,  -50, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.quartOut}, val -> ass.brightness = val);
                FlxTween.num(-10,  -10, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.quartOut}, val -> ass.hue = val);
                FlxTween.num(-10,  50, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.quartOut}, val -> ass.saturation = val);
                FlxTween.num(30,  100, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.quartOut}, val -> ass.contrast = val);
            }        
        case 3568:
            camVideo.alpha = 0;
            lyricVid.visible = true;
        case 3600:
            camGame.fade(FlxColor.BLACK, (Conductor.stepCrochet / 1000) * 8, false, () -> {
                setStage("chair_");
                playerGhost.alpha = dadGhost.alpha = 0;

                strumLines.members[0].characters[1].alpha = strumLines.members[1].characters[1].alpha = strumLines.members[2].characters[1].alpha = 0;
                strumLines.members[1].characters[2].alpha = 1;
                strumLines.members[1].characters[2].visible = false;
            });
            FlxTween.tween(camNotes, {alpha: 0}, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.circInOut});
            FlxTween.tween(camHUD, {alpha: 0, 'scroll.y': -FlxG.height}, (Conductor.stepCrochet / 1000) * 8, {ease: FlxEase.circInOut});
            FlxTween.tween(camVideo, {alpha: 1}, (Conductor.stepCrochet / 1000) * 8);
        case 3872:
            camGame.zoom = defaultCamZoom = 0.4;
            camHUD.alpha = 1;
            for(a in strumLines.members[0].members) a.x = (FlxG.width * 0.25) + (Note.swagWidth * (a.ID - 2)) - 640;
            for(a in strumLines.members[1].members) {a.x = (FlxG.width * 0.25) + (Note.swagWidth * (a.ID - 2)); a.scrollFactor.set();}
            timeTitle?.alpha = timeTxt?.alpha = 0;
            FlxTween.tween(camNotes, {alpha: 1}, (Conductor.stepCrochet / 1000) * 16, {onComplete: () -> {
                strumLines.members[1].camera = camHUD;
                timeTitle?.camera = timeTxt?.camera = camHUD;
                camNotes.alpha = 0.25;
            }});
        case 3889:
            remove(lyricVid);
            camGame.stopFade();
            camGame.flash(-65536, (Conductor.stepCrochet / 1000) * 2);

            stage.getSprite("chair_introtop").animation.callback = (name:String, num:Int, index:Int) -> strumLines.members[1].characters[2].visible = index >= 8;
            stage.getSprite("chair_introtop").playAnim("intro");

            stage.getSprite("chair_text").animation.finishCallback = (name:String) -> {
                stage.getSprite("chair_text").alpha = 0;
            }
            stage.getSprite("chair_text").playAnim("ShucksText");

            stage.getSprite("chair_introbottom").animation.finishCallback = (name:String) -> {
                strumLines.members[0].characters[2].alpha = strumLines.members[0].characters[3].alpha = 1;
                stage.getSprite("chair_introbottom").alpha = stage.getSprite("chair_introtop").alpha = 0;
            }
            stage.getSprite("chair_introbottom").playAnim("intro");

            if (Options.gameplayShaders && FlxG.save.data.iridaColorCorrect) {
                ass.contrast = 50;
                ass.hue = -10;
                ass.brightness = -30;
                ass.saturation = 30;
            }
        case 3952:
            for(a in strumLines.members[0].members) FlxTween.tween(a, {x: (FlxG.width * 0.25) + (Note.swagWidth * (a.ID - 2))}, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.circInOut});
            for(a in strumLines.members[1].members) FlxTween.tween(a, {x: (FlxG.width * 0.75) + (Note.swagWidth * (a.ID - 2))}, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.circInOut});
            FlxTween.tween(camHUD, {'scroll.y': 0}, (Conductor.stepCrochet / 1000) * 16, {ease: FlxEase.circInOut});
            if (timeTitle != null && timeTxt != null) {
                FlxTween.tween(timeTitle, {alpha: 1}, (Conductor.stepCrochet / 1000) * 16, {startDelay: (Conductor.stepCrochet / 1000) * 16});
                FlxTween.tween(timeTxt, {alpha: 1}, (Conductor.stepCrochet / 1000) * 16, {startDelay: (Conductor.stepCrochet / 1000) * 16});
            }
        case 4016:
            executeEvent({
                name: "Camera Zoom",
                params: [true,0.8,"camGame",8,"expo","Out","direct",false]
            });  
            executeEvent({
                name: "Camera Position",
                params: [2050, 957,true,8,"expo","Out",false]
            }); 
        case 4024:
            executeEvent({
                name: "Camera Position",
                params: [1350, 657,true,8,"expo","Out",false]
            }); 
        case 4032:
            executeEvent({
                name: "Camera Position",
                params: [2050, 957,true,8,"expo","Out",false]
            }); 
        case 4040:
            executeEvent({
                name: "Camera Position",
                params: [1350, 657,true,8,"expo","Out",false]
            }); 
        case 4048:
            executeEvent({
                name: "Camera Position",
                params: [2050, 957,true,8,"expo","Out",false]
            }); 
        case 4056:
            executeEvent({
                name: "Camera Position",
                params: [1350, 657,true,8,"expo","Out",false]
            }); 
        case 4064:
            executeEvent({
                name: "Camera Position",
                params: [2050, 957,true,8,"expo","Out",false]
            }); 
        case 4072:
            executeEvent({
                name: "Camera Position",
                params: [1350, 657,true,8,"expo","Out",false]
            }); 
        case 4088:
            executeEvent({
                name: "Camera Position",
                params: [2050, 957,true,8,"expo","Out",false]
            }); 
        case 4096:
            executeEvent({
                name: "Camera Position",
                params: [1350, 657,true,8,"expo","Out",false]
            });   
        case 4104:
            executeEvent({
                name: "Camera Position",
                params: [2050, 957,true,8,"expo","Out",false]
            }); 
        case 4112:
            executeEvent({
                name: "Camera Position",
                params: [1350, 657,true,8,"expo","Out",false]
            });
        case 4120:
            executeEvent({
                name: "Camera Position",
                params: [2050, 957,true,8,"expo","Out",false]
            }); 
        case 4128:
            executeEvent({
                name: "Camera Position",
                params: [1350, 657,true,8,"expo","Out",false]
            });
        case 4136:
            executeEvent({
                name: "Camera Position",
                params: [2050, 957,true,8,"expo","Out",false]
            }); 

        case 4144:
            executeEvent({
                name: "Camera Zoom",
                params: [true,0.4,"camGame",8,"expo","Out","direct",false]
            });  
            executeEvent({
                name: "Camera Position",
                params: [1750, 957,true,8,"expo","Out",false]
            }); 
        case 4388:
            bitchVid.visible = true;
        case 4396:
            FlxTween.tween(camNotes, {alpha: 0}, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.circInOut});
            FlxTween.tween(camHUD, {alpha: 0, 'scroll.y': -FlxG.height}, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.circInOut, onComplete: () -> {
                strumLines.members[1].camera = camNotes;
                timeTitle?.camera = timeTxt?.camera = camNotes;
            }});

            setStage("run_");
            defaultCamZoom = camGame.zoom = 1;
            stage.getSprite("run_legsdetg").alpha = 0;
            strumLines.members[0].characters[2].alpha = strumLines.members[0].characters[3].alpha = strumLines.members[1].characters[2].alpha = 0;
            strumLines.members[1].characters[3].alpha = 1;
        case 4412:
            FlxTween.tween(camNotes, {alpha: 1}, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.circInOut});
            FlxTween.tween(camHUD, {alpha: 1, 'scroll.y': 0}, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.circInOut});
        case 4416:
            remove(bitchVid);
            executeEvent({
                name: "Camera Position",
                params: [627.5, 353,false,8,"expo","Out",false]
            }); 
            camGame.flash(-65536, (Conductor.stepCrochet / 1000) * 4);

            stage.getSprite("run_bg").animation.finishCallback = (name:String) -> if (name == "intro") stage.getSprite("run_bg").playAnim('loop');

            FlxTween.tween(strumLines.members[0].characters[4], {alpha: 1}, (Conductor.stepCrochet / 1000) * 8);
            // intro anim use shucks jx to test
            strumLines.members[0].characters[4].animation.finishCallback = (name:String) -> if (name == "intro") stage.getSprite("run_legsdetg").alpha = 1;
            strumLines.members[0].characters[4].playAnim("intro", true);
            stage.getSprite("run_bg").playAnim("intro", true);

            if (Options.gameplayShaders && FlxG.save.data.iridaColorCorrect) {
                ass.contrast = 35;
                ass.hue = -10;
                ass.brightness = 3;
                ass.saturation = 7;
            }

        case 4672:
            executeEvent({
                name: "Camera Position",
                params: [927.5, 400,true,16,"cube","InOut",false]
            });  
            executeEvent({
                name: "Camera Zoom",
                params: [true,2,"camGame",16,"cube","InOut","direct",false]
            });  

        case 4696:
            executeEvent({
                name: "Camera Position",
                params: [527.5, 300,false,16,"cube","InOut",false]
            });  
            
        case 4704:
            stage.getSprite("run_bg").playAnim('bodies');
            executeEvent({
                name: "Camera Position",
                params: [627.5, 353,true,8,"expo","Out",false]
            }); 
            executeEvent({
                name: "Camera Zoom",
                params: [true,1,"camGame",8,"expo","Out","direct",false]
            });  
        
        case 4972:
            FlxTween.tween(strumLines.members[1].characters[3], {x: 1770, y: 650, 'scale.x': 3.3, 'scale.y': 3.3}, 1, {ease: FlxEase.circInOut});
            FlxTween.tween(stage.getSprite("run_legsmarv"), {x: 1770, y: 505, 'scale.x': 3.3, 'scale.y': 3.3}, 1, {ease: FlxEase.circInOut});
        case 4976:
            FlxTween.tween(camNotes, {alpha: 0}, (Conductor.stepCrochet / 1000) * 24);
            FlxTween.tween(camHUD, {alpha: 0}, (Conductor.stepCrochet / 1000) * 24);
            // he falls or some shit
            

            
            stage.getSprite("run_bg").playAnim('end');
            stage.getSprite("run_legsdetg").alpha = 0;
            strumLines.members[0].characters[4].animation.finishCallback = (name:String) -> if (name == "fall") {
                strumLines.members[0].characters[4].alpha = 0;
                FlxTween.tween(camGame, {alpha: 0}, (Conductor.stepCrochet / 1000) * 24);
            }
            strumLines.members[0].characters[4].playAnim("fall");
            strumLines.members[0].characters[4].scale.set(0.6,0.6);
            strumLines.members[0].characters[4].x = strumLines.members[0].characters[4].x + 100;
            strumLines.members[0].characters[4].y = strumLines.members[0].characters[4].y - 80;
           
    }
}

function onSubstateOpen() {
    doorVid.pause();
    lyricVid.pause();
    bitchVid.pause();
}

function onSubstateOpen()
    if (paused) {
        doorVid.pause();
        lyricVid.pause();
        bitchVid.pause();
    }

function onSubstateClose()
    if (paused) {
        doorVid.resume();
        lyricVid.resume();
        bitchVid.resume();
    }

function onFocus() {
    if (!paused && FlxG.autoPause) {
        doorVid.resume();
        lyricVid.resume();
        bitchVid.resume();
    }
}

function onFocusLost() {
    if (!paused && FlxG.autoPause) {
        doorVid.pause();
        lyricVid.pause();
        bitchVid.pause();
    }
}


function postUpdate() {
    if (Conductor.songPosition < 0) doorVid.bitmap.time = 0;
    if (!lyricVid.visible) lyricVid.bitmap.time = 0;
    if (!bitchVid.visible) bitchVid.bitmap.time = 0;

    if (playerGhost.alpha != 0) {
        playerGhost.playAnim(strumLines.members[1].characters[1].getAnimName(), true);
        playerGhost.set_globalCurFrame(strumLines.members[1].characters[1].get_globalCurFrame());
        playerGhost.animateAtlas.colorTransform.color = FlxColor.BLACK;
    }

    if (dadGhost.alpha != 0) {
        dadGhost.playAnim(strumLines.members[0].characters[1].getAnimName(), true);
        dadGhost.set_globalCurFrame(strumLines.members[0].characters[1].get_globalCurFrame());
        dadGhost.animateAtlas.colorTransform.color = FlxColor.BLACK;
    }

    if (iconP3.alpha != 0 && curStep < 2384) iconP3.health = iconP1.health;
}

var roseLooking:Int;
function onCameraMove() {
    if (roseLooking != curCameraTarget) {
        roseLooking = curCameraTarget;
        strumLines.members[2].characters[0].idleSuffix = curCameraTarget == 1 ? "right" : "left";
        strumLines.members[2].characters[0].playAnim("look-" + strumLines.members[2].characters[0].idleSuffix);
    }
}

function onStrumCreation(e)
    e.sprite = "game/notes/shadow";

function onNoteCreation(e)
    if (e.note.strumTime <= Conductor.stepCrochet * 460) {
        e.note.splash = "shadow";
        e.noteSprite = "game/notes/shadow";
    }

function flicker(cam:FlxCamera, d:Float, i:Float) {
    cam.visible = !cam.visible;
    lol = new FlxTimer().start(i, () -> {
        cam.visible = !cam.visible;
        if (lol.loopsLeft == 0) cam.visible = true;
    }, Std.int(d / i));
}