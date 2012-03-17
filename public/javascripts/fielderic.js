/*
 * fielderic JS - makes use of JQuery library
 * (C)2012
 * 
 * author: JP <jp@fielderic.com>
 */

$(document).ready(function() {

    // do the following after DOM is loaded
    
    // register any join link to do something "special"
    $("#joinss").click(function(event){  
      
      // dont do any of the usual behaviour
      event.preventDefault();
      
      $.ajax({
        type  : "GET",
        url   : $(this).prop("href"),
        cache : false,
        success: function(data, textStatus) {
            .html(data);
            alert(textStatus);
            /*if (data.redirect) {
                // data.redirect contains the string URL to redirect to
                window.location.href = data.redirect;
            }
            else {
                // data.form contains the HTML for the replacement form
                $("#myform").replaceWith(data.form);
            }*/
        }
      });
      
    });
    
});
