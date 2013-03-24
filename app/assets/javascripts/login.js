
/*
 * JavaScript pertaining to the login form  
 * 
 * Author: JP
 */

$(document).ready(function() {
    $('#passwordStuff').hide(); // hide it
    $('#email').keyup(function() {
        var email = $('#email').val();
        // only consider after @ sign - less http calls
        var atIdx = email.indexOf("@");        
        if (atIdx > -1) {
            var domain = email.substring(atIdx);
            if (domain.indexOf(".") > -1) {
                $.ajax({
                    type: "POST",
                    dataType: "html",
                    url:  "/password",
                    data: { email: $('#email').val() },
                    success: function (data) {
                        //console.log(data); // <========= remove in production
                        if (data == "true") {
                            $('#passwordStuff').show();
                        } else {
                            $('#passwordStuff').hide();
                        }
                    }
                });
            }
        }
    });
});

