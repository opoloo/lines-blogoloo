//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require autocomplete-rails
//= require jquery-fileupload/basic
//= require jquery-fileupload/vendor/tmpl
//= require pictures
//= require bootstrap
//= require autosize.min

// Function to insert images into the content at cursor position
jQuery.fn.extend({
  insertAtCaret: function(myValue){
    return this.each(function(i) {
      if (document.selection) {
        //For browsers like Internet Explorer
        this.focus();
        sel = document.selection.createRange();
        sel.text = myValue;
        this.focus();
      }
      else if (this.selectionStart || this.selectionStart == '0') {
        //For browsers like Firefox and Webkit based
        var startPos = this.selectionStart;
        var endPos = this.selectionEnd;
        var scrollTop = this.scrollTop;
        this.value = this.value.substring(0, startPos)+myValue+this.value.substring(endPos,this.value.length);
        this.focus();
        this.selectionStart = startPos + myValue.length;
        this.selectionEnd = startPos + myValue.length;
        this.scrollTop = scrollTop;
      } else {
        this.value += myValue;
        this.focus();
      }
    })
  }
});

$(document).ready(function() {
  // Autogrow copy box
  $('#article_content').autosize();

  // Close error notification
  $('#error_explanation, .close').on('click', function(e){
    $('#error_explanation').slideUp();
  })
  
  // Insert image into content of the post
  $(".insert-image").live('click', function(e){
    var url = $(this).attr( 'data-url' );
    var value = '\n![Alt text](' + url + ')\n';
    $('#article_content').insertAtCaret(value);
    e.preventDefault();
  });

  $('#article_preview').click(function (){
    $.get('/admin/articles/preview.js', $('.simple_form').serialize(), null, "script");
    return false;
  });

  // Show datepicker
  $(document).on("focus", "[data-behaviour~='datepicker']", function(e){
    var altFormat = $(this).datepicker( "option", "altFormat" );
    $(this).datepicker({dateFormat: "yy-mm-dd"});
  });

  // Select hero image
  $(".select_image").live('click', function(e){
    e.preventDefault();
    
    bg_url = $(this).attr('src');
    
    $('.hero-image').css('background-image', 'url(' + bg_url + ')');
    
    if ($(this).hasClass('selected_image')) { // deselect selected short_hero image
      $(".selected_image").removeClass('selected_image');
      $("#article_short_hero_image, #article_hero_image_file").val('');      
    } else if ($(this).hasClass('uploaded_image')) { // select former uploaded hero_image
      $(".selected_image").removeClass('selected_image');
      //TODO: How to get the selected value?
      $('#article_hero_image, #article_hero_image_cache, #article_short_hero_image').val('');
      $('#article_hero_image_file').val(bg_url);
    } else { // select short_hero_image image
      var value = $(this).attr('src');
      $('#article_hero_image_file, #article_hero_image, #article_hero_image_cache').val('');
      $(".selected_image").removeClass('selected_image');
      $(this).addClass("selected_image");
      $("#article_short_hero_image").val(value);      
    }
    $('#hero_image_name').text('');
    $('.choose-file').html("Change Image");
  });

  // Unselect hero image on upload
  $('#article_hero_image').on('change', function(e){
    $(".selected_image").removeClass('selected_image');
    $("#article_short_hero_image").val('');      
  });

  // Scroll to the top of the page
  $('.top_link').click(function(){
    $("html, body").animate({ scrollTop: 0 }, 600);
    return false;
  });

  // Preview Hero Image if selected
  // Check File API support
  if(window.File && window.FileList && window.FileReader) {
      var filesInput = document.getElementById("article_hero_image");
      filesInput.addEventListener("change", function(event) {
        var files = event.target.files;
        if (files.length > 0) {
            var file = files[0];

            //Only pics
            if(!file.type.match('image'))
              return false;
            var picReader = new FileReader();
            
            picReader.addEventListener("load",function(event){
              var picFile = event.target;

              $('.hero-image').css("background-image","url("+picFile.result+")");
              $('.hero-image').css("background-size","cover");

              $('.choose-file').html("Change Image");
              $('.short-hero-images').append("<div class=\"short-hero-image-box\"><img src=\""+picFile.result+"\" width=\"115\" class=\"select_image uploaded_image\" /></div>");
            });
            
            // Read the image
            picReader.readAsDataURL(file);
        } else {
          $('.choose-file').html("Choose Image");
          $('.hero-image').css("background-image","none");
        }
      });
  } else {
      alert("Your browser does not support File API");
  }

  // File upload
  if(window.File && window.FileList && window.FileReader) {
      var filesInput = document.getElementById("article_document");
      filesInput.addEventListener("change", function(event) {
        var files = event.target.files;
        if (files.length > 0) {
          var file = files[0];
          
          var picReader = new FileReader();
          
          picReader.addEventListener("load",function(event){
            var picFile = event.target;
            $('.choose-files').html(file.name);
          });
          
          // Read the image
          picReader.readAsDataURL(file);                             
        } else {
          $('.choose-files').html("Choose File");
        }
      });
  } else {
      alert("Your browser does not support File API");
  }


  // Formatting Help
  $('.btn-close-formatting').click(function() {
    $('#formatting_guide').fadeOut();
  });
  $('.btn-close-formatting-small').click(function() {
    $('#formatting_guide').fadeOut();
  });
  $('.btn-formatting-help').click(function() {
    $('#formatting_guide').fadeIn();
  });
});