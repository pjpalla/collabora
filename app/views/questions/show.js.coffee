$('#qarea').empty();
html = "<%= escape_javascript(render 'qshow', :locals => {:zone => @location, :uids => @uids}) %>"
$('#qarea').append(html);