
/*
 * JavaScript pertaining to the login form  
 * 
 * Author: JP
 */

$(document).ready(function() {
    $('#passwordStuff').hide(); // hide it
    $('#email').keyup(function() {
        $.ajax({
            type: "POST",
            dataType: "html",
            url:  "/password",
            data: { email: $('#email').val() },
            success: function (data) {
                console.log(data); // <==============================
                if (data == "true") {
                    $('#passwordStuff').show();
                } else {
                    $('#passwordStuff').hide();
                }
                //alert(data);
            }
        });
    });
});

