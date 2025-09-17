var fullpage;

$(function() {
  var main_visual = new Swiper("#main_visual > .swiper-container", {
    loop: true,
    // centeredSlides: true,
    speed: 700,
    // slidesPerView: 1,
    spaceBetween: 20,
    autoplay: {
      delay: 4000,
      // disableOnInteraction: false
    },
    navigation: {
      nextEl: "#main_visual > .swiper-container .swiper-button-next",
      prevEl: "#main_visual > .swiper-container .swiper-button-prev"
    },
    pagination: {
      el: "#main_visual > .swiper-container .swiper-pagination-dot",
      type: "bullets",
      clickable: true
    }
  });

  // main_visual.controller.control = main_visual_paging;

  // var main_visual_paging = new Swiper("#main_visual > .swiper-container", {
  //   pagination: {
  //     el: ".swiper-pagination-num",
  //     type: "fraction",
  //   },
  // });

  $("#main_visual > .swiper-container .swiper-button-playpause").on("click", function(e) {
    var c = $("#main_visual > .swiper-container .swiper-button-playpause").hasClass("on");
    if (!c) {
      main_visual.autoplay.stop();
      $("#main_visual > .swiper-container .swiper-button-playpause").addClass("on");
    } else {
      main_visual.autoplay.stop();
      main_visual.autoplay.start();
      $("#main_visual > .swiper-container .swiper-button-playpause").removeClass("on");
    }
  });



  
  // var pop_zone = new Swiper("#pop_zone .swiper-container", {
  //   loop: true,
  //   centeredSlides: true,
  //   speed: 700,
  //   autoplay: {
  //     delay: 4000,
  //     disableOnInteraction: false
  //   },
  //   navigation: {
  //     nextEl: "#pop_zone .swiper-button-next",
  //     prevEl: "#pop_zone .swiper-button-prev"
  //   },
  //   pagination: {
  //     el: "#pop_zone .pop_zone-pagination-num",
  //     type: "fraction",
  //   },
  // });

  // $("#pop_zone .swiper-button-playpause").on("click", function(e) {
  //   var b = $("#pop_zone .swiper-button-playpause").hasClass("on");
  //   if (!b) {
  //     pop_zone.autoplay.stop();
  //     $("#pop_zone .swiper-button-playpause").addClass("on");
  //   } else {
  //     pop_zone.autoplay.stop();
  //     pop_zone.autoplay.start();
  //     $("#pop_zone .swiper-button-playpause").removeClass("on");
  //   }
  // });



  const notic_swiper_count = document.querySelectorAll('#notic_swiper .swiper-slide');

  var notic_swiper = new Swiper("#notic_swiper .swiper-container", {
    loop: notic_swiper_count.length > 5,
    speed: 700,
    slidesPerView: 5,
    spaceBetween: 20,
    navigation: {
      nextEl: ".swiper-button-next",
      prevEl: ".swiper-button-prev"
    },
    pagination: {
      el: ".notic_pagination_num",
      type: "fraction",
    },
    breakpoints: {
      1120: {
        slidesPerView: 4,
        spaceBetween: 14
      },
      900: {
        slidesPerView: 3,
        spaceBetween: 14
      },
      768: {
        slidesPerView: 3,
        spaceBetween: 14
      },
      600: {
        slidesPerView: 2,
        spaceBetween: 14
      },
      500: {
        slidesPerView: 2,
        spaceBetween: 10
      },
      400: {
        slidesPerView: 1,
        spaceBetween: 10
      }
    }
  });

  // notic_swiper.controller.control = notic_swiper_paging;


  // var notic_swiper_paging = new Swiper("#notic_swiper .swiper-container", {
  //   pagination: {
  //     el: ".notic_pagination_num",
  //     type: "fraction",
  //   },
  // });


  $(window).on("resize", function() {
    // notic_swiper.destroy();
    // notic_swiper();
    // resizeFn();
  });
  // function resizeFn() {}
  // resizeFn();
});


$(document).ready(function(){
  $(window).resize(function(){
    // location.reload();
    notic_swiper.destroy();
    notic_swiper();
  })
})

