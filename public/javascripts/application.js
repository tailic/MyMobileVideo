// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults<script>
        
          csrf_param = "authenticity_token";
          csrf_token = "PanR5/iznyMAbo287q2qZ0r5SsjXnW4J1UL4CnPJU2s=";

          // Always send the authenticity_token with ajax
          $(document).ajaxSend(function(event, request, settings) {
            if ( settings.type == 'post' ) {
              settings.data = (settings.data ? settings.data + "&" : "")
                + encodeURIComponent( csrf_param ) + "=" + encodeURIComponent( csrf_token );
            }
          });
        

        $(document).ready(function(){
          $('.ajaxful-rating a').bind('click',function(event){
            event.preventDefault();
            $.ajax({
              type: $(this).attr('data-method'),
              url: $(this).attr('href'),
              data: {
                      stars: $(this).attr('data-stars'),
                      dimension: $(this).attr('data-dimension'),
                      size: $(this).attr('data-size'),
                      show_user_rating: $(this).attr('data-show_user_rating')
                    },
              success: function(response){
                $('#' + response.id + ' .show-value').css('width', response.width + '%');
              }
            });
          });
        });
        



