var Plants;
var Plant;
var type;
var amount;
var inventory;


function closeMenu() {
    $.post('https://core_drugs/close', JSON.stringify({}));

    $("#main_container").fadeOut(400);
    timeout = setTimeout(function() {
        $("#main_container").html("");
        $("#main_container").fadeIn();
    }, 400);


}

$(document).keyup(function(e) {
    if (e.keyCode === 27) {


        closeMenu();

    }

});

function playClickSound() {
    var audio = document.getElementById("clickaudio");
    audio.volume = 0.05;
    audio.play();
}

function setProgress(field, p, textField) {

    var prog = (196 / 100) * p;


    $(field).animate({
        width: prog
    }, 400, function() {



    });

    p = Math.round(p * 100) / 100
    $(textField).text(p + "%");

}

function feedPlant() {
    playClickSound();
    $.post('https://core_drugs/feed', JSON.stringify({}));

}

function waterPlant() {
    playClickSound();
    $.post('https://core_drugs/water', JSON.stringify({}));

}

function destroyPlant() {
    playClickSound();
    $.post('https://core_drugs/destroy', JSON.stringify({}));

}

function harvestPlant() {
    playClickSound();
    $.post('https://core_drugs/harvest', JSON.stringify({}));

}

function openInformation(alive) {

    var color;

    if (alive) {
        color = Plants[type].Color;
    } else {
        color = '217, 39, 60';
    }


    var base = '<div class="clearfix slide-right" id="information"><!-- column -->' +
        '   <div class="clearfix colelem" id="pu817"><!-- group -->' +
        '    <img class="grpelem" id="u817" alt="" width="80" height="80" src="img/' + Plants[type].Image + '"/><!-- rasterized frame -->' +
        '    <div class="clearfix grpelem" id="pu894-4"><!-- column -->' +
        '     <div class="clearfix colelem" id="u894-4"><!-- content -->' +
        '      <p>' + Plants[type].Type.toUpperCase() + '</p>' +
        '     </div>' +
        '     <div class="clearfix colelem" style=" color:rgb(' + color + '); text-shadow:0 0 8px rgba(' + color + ',.5),0 0 8px rgba(' + color + ',.5),1px 1px 1px rgba(0,0,0,.5);" id="u793-4"><!-- content -->' +
        '      <p>' + Plants[type].Label.toUpperCase() + '</p>' +
        '     </div>' +
        '    </div>' +
        '   </div>' +

        '   <div class="colelem" id="u851"><!-- simple frame --></div>' +
        '   <div class="clearfix colelem" id="pu798-4"><!-- group -->' +
        '    <div class="clearfix grpelem" id="u798-4"><!-- content -->' +
        '     <p>GROWTH</p>' +
        '    </div>' +
        '    <div class="clearfix grpelem" style=" color:rgb(' + color + '); text-shadow:0 0 8px rgba(' + color + ',.5),0 0 8px rgba(' + color + ',.5),1px 1px 1px rgba(0,0,0,.5);" id="u836-4"><!-- content -->' +
        '     0%' +
        '    </div>' +
        '    <div class="grpelem" id="u879"><!-- simple frame --></div>' +
        '    <div class="shadow rounded-corners grpelem" style=" background: rgb(' + color + ') -webkit-linear-gradient(left, rgb(' + color + '), rgba(255, 255, 255, 0.5)) no-repeat 0 0 / 30px; box-shadow:0 0 6px rgba(' + color + ',.36),0 0 6px rgba(' + color + ',.36);" id="u882"><!-- simple frame --></div>' +
        '   </div>' +
        '   <div class="clearfix colelem" id="pu801-4"><!-- group -->' +
        '    <div class="clearfix grpelem" id="u801-4"><!-- content -->' +
        '     <p>RATE</p>' +
        '    </div>' +
        '    <div class="grpelem" id="u857"><!-- simple frame --></div>' +
        '    <div class="clearfix grpelem" style=" color:rgb(' + color + '); text-shadow:0 0 8px rgba(' + color + ',.5),0 0 8px rgba(' + color + ',.5),1px 1px 1px rgba(0,0,0,.5);" id="u866-4"><!-- content -->' +
        '     <p>0%</p>' +
        '    </div>' +
        '    <div class="shadow rounded-corners grpelem" style=" background: rgb(' + color + ') -webkit-linear-gradient(left, rgb(' + color + '), rgba(255, 255, 255, 0.5)) no-repeat 0 0 / 30px; box-shadow:0 0 6px rgba(' + color + ',.36),0 0 6px rgba(' + color + ',.36);" id="u885"><!-- simple frame --></div>' +
        '   </div>' +
        '   <div class="clearfix colelem" id="pu804-4"><!-- group -->' +
        '    <div class="clearfix grpelem" id="u804-4"><!-- content -->' +
        '     <p>WATER</p>' +
        '    </div>' +
        '    <div class="grpelem" id="u860"><!-- simple frame --></div>' +
        '    <div class="clearfix grpelem" style=" color:rgb(' + color + '); text-shadow:0 0 8px rgba(' + color + ',.5),0 0 8px rgba(' + color + ',.5),1px 1px 1px rgba(0,0,0,.5);" id="u869-4"><!-- content -->' +
        '     <p>0%</p>' +
        '    </div>' +
        '    <div class="shadow rounded-corners grpelem" style=" background: rgb(' + color + ') -webkit-linear-gradient(left, rgb(' + color + '), rgba(255, 255, 255, 0.5)) no-repeat 0 0 / 30px; box-shadow:0 0 6px rgba(' + color + ',.36),0 0 6px rgba(' + color + ',.36);" id="u888"><!-- simple frame --></div>' +
        '   </div>' +
        '   <div class="clearfix colelem" id="pu839-4"><!-- group -->' +
        '    <div class="clearfix grpelem" id="u839-4"><!-- content -->' +
        '     <p>FOOD</p>' +
        '    </div>' +
        '    <div class="grpelem" id="u863"><!-- simple frame --></div>' +
        '    <div class="clearfix grpelem" style=" color:rgb(' + color + '); text-shadow:0 0 8px rgba(' + color + ',.5),0 0 8px rgba(' + color + ',.5),1px 1px 1px rgba(0,0,0,.5);" id="u872-4"><!-- content -->' +
        '     <p>0%</p>' +
        '    </div>' +
        '    <div class="shadow rounded-corners grpelem" style=" background: rgb(' + color + ') -webkit-linear-gradient(left, rgb(' + color + '), rgba(255, 255, 255, 0.5)) no-repeat 0 0 / 30px; box-shadow:0 0 6px rgba(' + color + ',.36),0 0 6px rgba(' + color + ',.36);" id="u891"><!-- simple frame --></div>' +
        '   </div>' +
        '   <div id="buttons">';

    /*if (alive) {
        base = base + '   <div id="button" onclick="feedPlant()">FEED</div>' +
            '   <div id="button" onclick="waterPlant()">WATER</div>' +
            '   <div id="button" onclick="harvestPlant()">HARVEST</div>';
    }


    base = base + '   <div id="button" onclick="destroyPlant()">DESTROY</div>' +
        '   </div>' +
        '  </div>';*/

    $("#main_container").html(base);



}



function updateInformation(info) {


    if (info.rate == 0 && $('#u866-4').text() != "0%") {
        $("#information").remove();
        openInformation(false)

    }


    setProgress("#u882", info.growth, '#u836-4');
    setProgress("#u885", info.rate, '#u866-4');
    setProgress("#u888", info.water, '#u869-4');
    setProgress("#u891", info.food, '#u872-4');

}

window.addEventListener('message', function(event) {


    var edata = event.data;

    if (edata.type == 'showPlant') {
        Plants = edata.plants;
        Plant = edata.plant;
        type = edata.plantType;
        openInformation(true)
    } else if (edata.type == 'updatePlant') {
        updateInformation(edata.info);
    } else if (edata.type == 'hidePlant') {
        $("#information").fadeOut();
        setTimeout(() => {
            $("#information").remove();
        }, 200);

    }

});