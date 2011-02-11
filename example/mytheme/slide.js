$(function(){
    // Cached jQuery objects
    var jqwindow = $(window);
    var slides = $(".slide");
    var viewport = $("#slides");
    var help = $("#help");

    // Screen size
    var screenw = jqwindow.width();
    var screenh = jqwindow.height();

    // Current state
    var expose = false;
    var showhelp = false;
    var current = 0;

    // debug
    slides.each(function(i,e) {
        var hue = 'rgb(' + (Math.floor((256-199)*Math.random()) + 200) + ','
                         + (Math.floor((256-199)*Math.random()) + 200) + ','
                         + (Math.floor((256-199)*Math.random()) + 200) + ')';
        $(this).css("background-color", hue); 
    });

    // Apply a set of css transformation properties to a jQuery object
    function transform(jq, trans) {
        jq.css({
            "-webkit-transform": "translateZ(0) "+trans, // Apply translateZ hack to prevent texture subloading delay
            "-moz-transform": trans,
            "-ms-transform": trans,
            "-o-transform": trans,
            "transform": trans
        });
    }

    // Immediately apply a set of css transition properties to a jQuery object
    function transition(jq, trans) {
        jq.css({
            "-webkit-transition": trans,
            "-moz-transition": trans,
            "-o-transition": trans,
            "transition": trans
        });

        // Trigger a reflow so the transition gets applied immediately
        var tmp=jq.outerWidth(); // TODO: Find a function with less computational overhead
    }

    // Reflow the layout to expose mode
    function exposeflow() {
        var num = slides.length;
        var a = Math.ceil(Math.sqrt(num));
        var sx = 1.0/a;
        var sy = 1.0/Math.ceil(num/a);
        var dx = screenw*sx;
        var dy = screenh*sy;

        // Prepare transition
        transition(viewport, "2s ease all");
        transition(slides, "2s ease all");

        slides.each(function(i,e) {
            var x = i%a;
            var y = Math.floor(i/a);
            transform($(this), "translate("+(x*dx)+"px,"+(y*dy)+"px) scale("+sx+","+sy+")");
        });
        transform(viewport,"translateX(0)");
    }

    // Set the top-left coordinates of the viewport window
    function setviewport(x,y) {
        transform(viewport,"translateX(-"+x+"px) translateY(-"+y+"px)");
    }

    // Scroll to the currently active slide
    function scrolltocurrent() {
        setviewport(current*screenw,0);
    }

    // Reflow the layout to a horizontal strip
    function normalflow() {
        transition(viewport, "1s ease all");
        transition(slides, "1s ease all");
        slides.each(function(i,e) {
            transform($(this),"translateX("+(i*screenw)+"px) scale(1.0,1.0)");
        });
        scrolltocurrent();
    }

    // Reflow the slide layout to the current mode
    function reflow() {
        if (expose) {
            exposeflow();
        } else {
            normalflow();
        }
    }

    // Go to the next slide
    function nextslide() {
        if (current<slides.length-1 && !expose) {
            transition(viewport, ".3s ease all");
            current++;
            scrolltocurrent();
        }
    }

    // Go to the previous slide
    function prevslide() {
        if (current>0 && !expose) {
            transition(viewport, ".3s ease all");
            current--;
            scrolltocurrent();
        }
    }

    // Go to the first slide
    function firstslide() {
        if (!expose) {
            transition(viewport, ".3s ease all");
            current=0;
            scrolltocurrent();
        }
    }

    // Go to the last slide
    function lastslide() {
        if (!expose) {
            transition(viewport, ".3s ease all");
            current=slides.length-1;
            scrolltocurrent();
        }
    }

    // Toggle the help panel
    function togglehelp() {
        showhelp=!showhelp;
        help.css("opacity",showhelp?"1":"0.0");
    }

    // Toggle expose mode
    function togglexpose() {
        expose = !expose;
        reflow();
    }

    // Resize hook to maintain correct slide dimensions
    jqwindow.resize(function(e) {
        screenw = jqwindow.width();
        screenh = jqwindow.height();
        reflow();
    });

    // Keyboard hook
    $(document).keydown(function(e) {
        keymap = {
            33: prevslide,   // pgup
            37: prevslide,   // left
            38: prevslide,   // up
            13: nextslide,   // enter
            32: nextslide,   // space
            34: nextslide,   // pgdn
            39: nextslide,   // right
            40: nextslide,   // down
            36: firstslide,  // home
            35: lastslide,   // end
            72: togglehelp,  // h
            101: togglexpose // e
        };
        keymap[e.which]();
    });

    // DEBUG
    $("#expose").click(function(e) {
        if (!expose) {
            exposeflow();
            expose = true;
        }
    });

    // Slide click hook
    slides.click(function(e) {
        if (expose) {
            var this_slide = $(this).get()[0];
            slides.each(function(i,e) {
                if (this_slide == e) {
                    current = i;
                }
            });

            expose = false;
            normalflow();
        }
    });

    // Initialization
    normalflow();
});
