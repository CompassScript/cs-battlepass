$(document).ready(function() {
	window.addEventListener('message', function(event) {
		let data = event.data;
		switch (data.event) {
			case 'show':
                $("body").show();
                $(".rewardsArea").empty();
                setupDatas(data);
			break

            case 'fetchData':
                $(".rewardsArea").empty();
                fetchDatas(data);
            break;
	
			case 'hide':
				$("body").hide();
			break;

            case 'callbackMessage':
               
            break;
		}
	});
})

  document.addEventListener('keyup', (e) => {
    if (e.code === "Escape" || e.code === "Backspace") $.post('http://cs-battlepass/onClosing'); 
  });

function fetchDatas(data){
    var isPassHas = JSON.parse(data.sql).claimed
    var index = 0;
    $('#userSteam').empty().append(data.player);
    if(JSON.parse(data.sql).isPremium == 1) {
        $('#userState').empty().append(`Premium User`);
    } else {
        $('#userState').empty().append(`Standard User`);
    }
    $('#userPoints').empty().append(JSON.parse(data.sql).totalBalance);
    $(".rewardsArea").empty();
    data.data.forEach(element => {
        index = index + 1;
        $(".rewardsArea").append(`<div class="reward-slot">
            <div class="reward-number">
                <p>`+index+`</p>
            </div>
            <div class="reward-image">
                <img src="`+element.img+`" alt="">
            </div>
            <div class="">
                <p>Reward</p>
            </div>
            <div class="desc-awards">
                <p>`+element.desc+`</p>
                <p>Earnings : `+element.item+`</p>
            </div>
            <div class="getOrClaimed">`+(isPassHas.indexOf(index) !== -1 ? '<button class="btn btn-award" onclick="getBattlePass('+index+')" disable>Claimed</button>' : '<button class="btn btn-award" onclick="getBattlePass('+index+')">Get</button>')+`</div>
        </div>`); 
    });
}

function setupDatas(data) {
    var isPassHas = JSON.parse(data.sql).claimed
    var index = 0;
    $('#userSteam').empty().append(data.player);
    if(JSON.parse(data.sql).isPremium == 1) {
        $('#userState').empty().append(`Premium User`);
    } else {
        $('#userState').empty().append(`Standard User`);
    }
    $('#userPoints').empty().append(JSON.parse(data.sql).totalBalance);
    data.data.forEach(element => {
        index = index + 1;
        $(".rewardsArea").append(`<div class="reward-slot">
            <div class="reward-number">
                <p>`+index+`</p>
            </div>
            <div class="reward-image">
                <img src="`+element.img+`" alt="">
            </div>
            <div class="">
                <p>Reward</p>
            </div>
            <div class="desc-awards">
                <p>`+element.desc+`</p>
                <p>Earnings : `+element.item+`</p>
            </div>
            <div class="getOrClaimed">`+(isPassHas.indexOf(index) !== -1 ? '<button class="btn btn-award" onclick="getBattlePass('+index+')" disable>Claimed</button>' : '<button class="btn btn-award" onclick="getBattlePass('+index+')">Get</button>')+`</div>
        </div>`); 
    });
}
 
function getBattlePass(element) {
    $.post('http://cs-battlepass/buyBattlePass', JSON.stringify({id: element})); 
}

$(document).on('mousewheel', '.rewardsArea', function (e) {
    var delta = e.originalEvent.wheelDelta;
   this.scrollLeft += (delta < 0 ? 1 : -1) * 50;
   e.preventDefault();
});

const slider = document.querySelector('.rewardsArea');
let isDown = false;
let startX;
let scrollLeft;
slider.addEventListener('mousedown', (e) => {
    isDown = true;
    slider.classList.add('clickedItem');
    startX = e.pageX - slider.offsetLeft;
    scrollLeft = slider.scrollLeft;
});
slider.addEventListener('mouseleave', () => {
    isDown = false;
    slider.classList.remove('clickedItem');
});
slider.addEventListener('mouseup', () => {
    isDown = false;
    slider.classList.remove('clickedItem');
});
slider.addEventListener('mousemove', (e) => {
    if (!isDown) return;
    e.preventDefault();
    const x = e.pageX - slider.offsetLeft;
    const walk = (x - startX) * 1;
    slider.scrollLeft = scrollLeft - walk;
});