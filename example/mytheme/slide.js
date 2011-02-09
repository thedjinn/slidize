function nearestpow2(x){
    return Math.pow(2,Math.round(Math.log(x)/Math.log(2))); 
}

$(function(){
    var jqwindow = $(window);
    var slides = $(".slide");
    var viewport = $("#slides");
    var screenw = jqwindow.width();
    var screenh = jqwindow.height();
    var expose = false;
    var current = 0;

    // debug
    slides.each(function(i,e) {
        var hue = 'rgb(' + (Math.floor((256-199)*Math.random()) + 200) + ','
                         + (Math.floor((256-199)*Math.random()) + 200) + ','
                         + (Math.floor((256-199)*Math.random()) + 200) + ')';
        $(this).css("background-color", hue); 
    });

    function transform(jq, trans) {
        jq.css({
            "-webkit-transform": "translateZ(0) "+trans, // Apply translateZ hack to prevent texture subloading delay
            "-moz-transform": trans,
            "-o-transform": trans,
            "transform": trans
        });
    }

    function exposeflow() {
        var num = slides.length;
        var a = Math.ceil(Math.sqrt(num));
        var sx = 1.0/a;
        var sy = 1.0/Math.ceil(num/a);
        var dx = screenw*sx;
        var dy = screenh*sy;
        slides.each(function(i,e) {
            var x = i%a;
            var y = Math.floor(i/a);
            transform($(this), "translate("+(x*dx)+"px,"+(y*dy)+"px) scale("+sx+","+sy+")");
        });
        transform(viewport,"translateX(0)");
    }

    function normalflow() {
        slides.each(function(i,e) {
            transform($(this),"translateX("+(i*screenw)+"px) scale(1.0,1.0)");
        });
        transform(viewport,"translateX(-"+(current*screenw)+"px)");
    }

    function reflow() {
        if (expose) {
            exposeflow();
        } else {
            normalflow();
        }
    }

    function nextslide() {
        // TODO: bounds checking, different animation
        current++;
        normalflow();
    }

    function prevslide() {
        // TODO: bounds checking, different animation
        current--;
        normalflow();
    }

    function firstslide() {
        // TODO: different animation
        current=0;
        normalflow();
    }

    function lastslide() {
        // TODO: different animation
        current=slides.length-1;
        normalflow();
    }

    function togglehelp() {

    }

    function togglexpose() {
        expose = !expose;
        reflow();
    }

    jqwindow.resize(function(e) {
        screenw = jqwindow.width();
        screenh = jqwindow.height();
        reflow();
    });

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

    $("#expose").click(function(e) {
        if (!expose) {
            exposeflow();
            expose = true;
        }
    });

    slides.click(function(e) {
        if (expose) {
            var t = $(this).get()[0];
            slides.each(function(i,e) {
                if (t == e) {
                    current = i;
                }
            });

            expose = false;
            normalflow();
        }
    });

    normalflow();
});
