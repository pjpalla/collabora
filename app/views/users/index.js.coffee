$('#area').empty();
html = "<%= escape_javascript(render 'by_area', :locals => {:zone => @location}) %>"
$('#area').append(html);