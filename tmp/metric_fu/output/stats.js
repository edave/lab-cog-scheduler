              var g = new Bluff.Line('graph', "1000x600");
      g.theme_37signals();
      g.tooltips = true;
      g.title_font_size = "24px"
      g.legend_font_size = "12px"
      g.marker_font_size = "10px"

        g.title = 'Stats: LOC & LOT';
        g.data('LOC', [1573,1531]);
        g.data('LOT', [117,292])
        g.labels = {"0":"12/19","1":"1/13"};
        g.draw();
