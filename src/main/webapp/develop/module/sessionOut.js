

function sessionCheckOut(){

    var dialog = $.ligerDialog.open({
        content: "<div style='margin-left: 30px; margin-top: 10px;margin-bottom: 10px'>" +
        "您太久没操作，请重新登录，<br><span id='secondMsg'>3</span>秒后自动跳转！<div>",
        allowClose: false,
        title: "提示",
        buttons: [{
            text: '确定',
            onclick: function (e) {
                top.location.href = $.Context.PATH + "/login";
//                    dialog.close();
            }
        }]
    });

    var sec = 2;
    setInterval(function () {
        $('#secondMsg').html(sec);
        sec--;
        if(sec==-1)
            top.location.href = $.Context.PATH + "/login";
    },1000);

}