$("input[value='expert']").click();
$("input[value='advanced']").click();
$("table input").each(function(){
  $(this).after($("<div style='color:red;'>"+$(this).attr("name")+" : "+$(this).attr("value")+"</div>"));
});