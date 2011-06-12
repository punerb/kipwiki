/* comment */
//for slider
jQuery(function(){
    $("#slider").easySlider({
        auto: true,
        continuous: true,
        numeric: true
    });

    $(".edit").colorbox({
        innerHeight:285,
        innerWidth:420,
        html:$("#suggestion_box").html(),
        onOpen: function(){
            $(".lightboxSuccess").hide();
            $(".lightboxFailure").hide();
            $(".lightboxContent").hide();
        },
        onComplete:function(){
            $(".fieldInput").val($(this).attr("rel"));
        }
    });

    $(".closeColorbox").live("click",
            function(event){
                event.preventDefault();
                $.colorbox.close();
            });

    $(".submitSuggestion").live("click",
            function(event){
                event.preventDefault();
                if($(".fieldSummary").val()){
                    form = $("#addSuggestionForm");
                    $.post(form.attr("action"), form.serialize(), function(data){
                        if(data.success){
                            $(".lightboxContent").hide();
                            $(".lightboxSuccess").show();
                        }else{
                            $(".lightboxContent").hide();
                            $(".lightboxError").show();
                        }
                    }, "json")
                }else{
                    $(".fieldSummary").after("<h2>Suggestion Can't be blank!</h2>")
                }
            })

});
//for slider End