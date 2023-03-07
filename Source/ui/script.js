var reportList = []
var currentState = "closed"
window.addEventListener('message', function(event) {

    switch (event.data.action) {
        case 'startReportForm':
            currentState = "reportForm";
			$("#reportForm").show();
            break
        case 'openReportList':
            $(".reportSelected").hide();
            currentState = "reportList";
			$("#reportContainer").fadeIn("fast");
            $(".reportList").show();
            break
        case 'updateReportList':
            reportList = event.data.reportList
			reloadReportList() 
            break
		 case 'notification':
			showNewReportNotification()
            break
    }
});

$(document).on('click', ".closebutton", function() { 
    currentState = "closed"
    $("#reportContainer").fadeOut("fast");
    $.post('https://Seasons_EMSAlert/action', JSON.stringify({
        action: "close",
    }));
});

$(document).on('click', ".reportSelected .screenshot-handler", function() {
    currentState = "fullscreen"
	$("#fullsize").attr("src", currentReport.screenshotLink || "test.png");
    $("#fullsize-screenshot").fadeIn();
});

$(document).on('click', "#fullsize-screenshot .closeicon", function() { 
    $("#fullsize-screenshot").fadeOut();
});

/* reportList[0] = {
       id : 1,
       playername : "jonny_sins",
       playerid: 10,
       title : "Found bug",
       description : "I found a bug here in the police hq",
       solved: false,
       screenshotLink: "test.png",
   }

   reportList[1] = {
       id : 1,
       playername : "Matif",
       title : "Anti RP",
       description : "Player id 87 killed me with no motive",
       solved: false,
       screenshotLink: "test.png",
   }*/

$(document).on('click', "#load", function() { 
    reloadReportList()
});

function reloadReportList() {
    var wrapper = $(".reportList").find(".reports-wrapper")
	reportList.sort((a, b) => b.id - a.id)
    wrapper.html("");
    $.each(reportList, function(index, value) {
        var solved = "รอช่วยเหลือ"
        var sColor = "red"
        if (value.solved === true) {
            solved = "ช่วยเหลือแล้ว"
            sColor = "green"
        } else if (value.solved === "kinda") {
            solved = "กำลังช่วยเหลือ"
            sColor = "yellow"
        }
        wrapper.append(`<div class="item" data-reportId="${index}">
        <div class="firstcolumn column"><div class="player-id"><b>รายที่ : </b> ${value.id}</div></div>
        <div class="secondcolumn column"><div class="report-title">${value.title}</div></div>
        <div class="thirdcolumn column"><div class="solved" style="color: ${sColor};" onclick="SolvedReport(${value.id},true)">${solved}</div></div>
        <div class="forthcolumn column"> <div class="morebutton">ข้อมูลเพิ่มเติม</div></div>               
        </div>`)
    });
}

$(document).on('click', ".item .morebutton", function() { 
    var id = $(this).parent().parent().attr("data-reportId")
    openReportPage(id)
    currentState = "reportDetails"
});

$(document).on('click', ".reportSelected .backicon", function() { 
    $(".reportSelected").hide();
    $(".reportList").show();
    currentState = "reportList"
});

var currentReportId, currentReport

function openReportPage(id) {
    currentReportId = id
    $(".reportList").hide();
    var thisPage = $(".reportSelected");
    var data = reportList[id]
    currentReport = data
    thisPage.show();
    thisPage.find(".playerId").html(`รายที่: ${data.id}`)
    var datawrapper = thisPage.find(".data-wrapper")
    datawrapper.find(".pid").html(`<b>ไอดี:</b> ${data.playerid}`)
    datawrapper.find(".pname").html(`<b>ชื่อ:</b> ${data.playername}`)
    datawrapper.find(".title").html(`<b>หัวข้อ:</b> ${data.title}`)
    datawrapper.find(".description").html(`<b>ตำแหน่ง:</b> ${data.description}`)
}

$(document).on('click', ".setwaypoint", function() { 
    $("#reportContainer").fadeOut("fast");
    $.post('https://Seasons_EMSAlert/action', JSON.stringify({
        action: "setwaypoint",
        id: currentReport.id
    }));
    currentState = "closed"
});

$(document).on('click', ".check", function() { 
    //$("#reportContainer").fadeOut("fast");
	SolvedReport(currentReport.id,false)
	$(".reportSelected").hide();
	$(".reportList").show();
	currentState = "reportList"
    //currentState = "closed"
});

function SolvedReport(id,can) {
    $.post('https://Seasons_EMSAlert/action', JSON.stringify({
        action: "solvedreport",
        id: id,
		can: can
    }));
}

$(document).ready(function(){
    document.onkeyup = function (data) {
        if (data.which == 27) {
            switch (currentState) {
                case 'reportDetails' :
                    $(".reportSelected").fadeOut("fast");
                    $(".reportList").show();
                    currentState = "reportList"
                break
                case 'reportList' : 
                    $("#reportContainer").fadeOut("fast");
                    currentState = "closed"
                    $.post('https://Seasons_EMSAlert/action', JSON.stringify({
                        action: "close",
                    }));
                break
            }
            
        }
    };
});

const sound = new Howl({
	src: ['sound.mp3'],
	volume: 0.5,
});

function showNewReportNotification() {
	sound.play();
    $("#reportNotification").fadeIn(400);
    setTimeout(function () {
        $("#reportNotification").fadeOut(400);
    }, 3000)
}
