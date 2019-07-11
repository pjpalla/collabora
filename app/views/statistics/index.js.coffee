$('#issues').empty();
html = "<%= escape_javascript(render 'issues', :locals => {:zone => @location}) %>"
$('#issues').append(html);