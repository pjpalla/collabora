// // This is a manifest file that'll be compiled into application.js, which will include all the files
// // listed below.
// //
// // Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// // or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
// //
// // It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// // compiled file.
// //
// // Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// // about supported directives.
// //
// //= require jquery
// //= require jquery_ujs
// //= require_tree

// //= require chartkick

// $(document).ready(function() {

//   //al click sul bottone del form
//   $("#locations").change(function(){

//     //associo variabili
//     var location = $("#locations").val();
//     var url = "/users";
 

//   //chiamata ajax
//     $.ajax({

//     //imposto il tipo di invio dati (GET O POST)
//       type: "GET",

//       //Dove devo inviare i dati recuperati dal form?
//       url: "/users",

//       //Quali dati devo inviare?
//       data: "location=" + location,
//       dataType: "html",

//       //Inizio visualizzazione errori
//       success: function(msg)
//       {
        
//         //window.location = url;
//         //$("input#category_textbox").val("Ciao Lollo");
//         //$('#area').append("<%= j render partial: 'users/by_area', locals: {:pippo: 'ciao' %>");
//         //$("#area").html("#{escape_javascript( render partial: '/users/by_area', locals: {pippo: 'ciao'})}")
//         // messaggio di avvenuta aggiunta valori al db (preso dal file risultato_aggiunta.php) potete impostare anche un alert("Aggiunto, grazie!");
//       },
//       error: function()
//       {
//         alert("Chiamata fallita, si prega di riprovare..."); //sempre meglio impostare una callback in caso di fallimento
//       }
//     });
//   });
// });
