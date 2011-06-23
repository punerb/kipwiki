/* comment */
//for slider
jQuery(function(){
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
                close_lightbox();
            });

    $(".submitSuggestion").live("click",
            function(event){
                event.preventDefault();
                if($("#suggestion_text").val()){
                    form = $("#addSuggestionForm");
                    $.post(form.attr("action"), form.serialize(), function(data){
                        if(data.success){
                            $(".lightboxContent").hide();
                            $(".lightboxSuccess").show();
                            setTimeout("close_lightbox()", 2000)
                        }else{
                            $(".lightboxContent").hide();
                            $(".lightboxError").show();
                        }
                    }, "json")
                }else{
                    $("#suggestion_text").after("<h2>Suggestion Can't be blank!</h2>")
                }
            })

    $(".addSubObjectiveLink").click(function(event){
        event.preventDefault();
        $(this).parents("li").find(".subobjectiveContent").toggle();
    })

    $(".deleteObjective").click(function(event){
        event.preventDefault();
        $.post($(this).attr("href"), {"_method" : "delete"});
        location.reload();
    })

});


function close_lightbox(){
    $.colorbox.close();
}
//for slider End
