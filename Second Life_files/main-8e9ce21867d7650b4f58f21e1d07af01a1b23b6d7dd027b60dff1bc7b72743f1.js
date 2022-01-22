jQuery(document).ready(function($) {

//*
//* Preloader
//*

if ($('.so-preloader').length) {

  var width = 100,
  perfData = window.performance.timing,
  EstimatedTime = -(perfData.loadEventEnd - perfData.navigationStart),
  time = parseInt((EstimatedTime/2500)%60)*10;

  $('body').css('overlay' , 'hidden');

  // Loadbar Animation
  $(".so-preloader-bar-inner").animate({
    width: width + "%"
  }, time);

  if (time < 3000) {
    time = 3000;
  }

  setTimeout(function(){
    $('.so-preloader-content').fadeOut(300);
  }, time);

}

//*
//* Slider
//*

// if ($('.test').length) {

//  $('.test').slick({
//   infinite: true,
//   slidesToShow: 1,
//   slidesToScroll: 1,
//   autoplay: true,
//   autoplaySpeed: 2000,
//   speed: 800,
//   arrows: false,
//   dots: false,
//   draggable:false,
//   fade:true
// });

// }

//---------//

//*
//* Header
//*

var can_animate_header = true;
$('.so-trigger').on('click touch', function(event) {
  event.preventDefault();

  if (!can_animate_header) {
    return;
  }

  if ($(this).hasClass('active')) {
    $(this).removeClass('active');
    $('.so-header-mobile-menu').removeClass('active');
    $('#so-wrapper').removeClass('active');
    $('.so-header').removeClass('active');
  }
  else {
    $(this).addClass('active');
    $('.so-header-mobile-menu').addClass('active');
    $('#so-wrapper').addClass('active');
    $('.so-header').addClass('active');
  }

})



//---------//

//*
//* Footer
//*


if ($('.menu-item-has-children').length && $(window).width() <= 720) {

  $('.menu-item-has-children > h6').each(function(index, el) {
    $(this).append('<div class="so-plus"><span></span><span></span></div>');
  });

  $(document.body).on('click touch', '.menu-item-has-children ', function(event) {
    event.preventDefault();

    if ($(this).closest('li').hasClass('active')) {
      $(this).find('.so-plus').removeClass('active');
      $(this).closest('li').removeClass('active');
      $(this).removeClass('active');
      $(this).closest('li').find('.sub-menu').slideUp(400);
    }
    else {
      $(this).closest('li').addClass('active');
      $(this).find('.so-plus').addClass('active');
      $(this).addClass('active');
      $(this).closest('li').find('.sub-menu').slideDown(400);
    }

  });

}

//---------//

//*
//* Languages
//*

if ($('.so-languages').length) {

  $('.so-languages > a').each(function(index, el) {
    // $(this).append('<div class="so-plus"></i></div>');
  });

  $(document.body).on('click touch', '.so-languages .sub-menu a', function(event) {
    // Let the sub-menu links work by stopping upward propagation of the event
    // to the .so-languages menu handler below. The a's default (follow the
    // link to the different language) will occur.
    event.stopPropagation();
  });
  $(document.body).on('click touch', '.so-languages', function(event) {
    event.preventDefault();

    // Toggle the activation & submenu of the Languages entry.
    if ($(this).closest('li').hasClass('active')) {
      $(this).closest('li').removeClass('active');
      $(this).removeClass('active');
      $(this).closest('li').find('.sub-menu').slideUp(400);
    }
    else {
      $(this).closest('li').addClass('active');
      $(this).addClass('active');
      $(this).closest('li').find('.sub-menu').slideDown(400);
    }

  });

}

//-------//

//*
//* End JQuery
//*

});

//*
//* JavaScript
//*


if ($(window).width() > 768) {

  var matchHeight = (function() {

    return {
      match: function() {

        console.log('matching height');

        var groupName = Array.prototype.slice.call(document.querySelectorAll("[data-match-height]"));
        var groupHeights = {};

        for (var item of groupName) {

          var data = item.getAttribute("data-match-height");

          item.style.minHeight = "auto";

          if (groupHeights.hasOwnProperty(data)) {
            Object.defineProperty(groupHeights, data, {
              value: Math.max(groupHeights[data], item.offsetHeight),
              configurable: true,
              writable: true,
              enumerable: true
            });
          } else {
            groupHeights[data] = item.offsetHeight;
          }
        }

        var groupHeightsMax = groupHeights;

        Object.getOwnPropertyNames(groupHeightsMax).forEach(function(value) {

          var elementsToChange = document.querySelectorAll("[data-match-height='" + value + "']");

          for (var i = 0; i < elementsToChange.length; i++) {
            elementsToChange[i].style.height = Object.getOwnPropertyDescriptor(groupHeightsMax, value).value + "px";
          }
        });
      },

      eventListeners: function() {
        window.addEventListener("resize", () => {
          this.match();
        });
      },

      init: function() {
        this.eventListeners();
        this.match();
      }
    }
  })();

  document.addEventListener("DOMContentLoaded", function() {
    matchHeight.init();
  });

  document.addEventListener("DOMresize", function() {
    matchHeight.init();
  });

}

;
