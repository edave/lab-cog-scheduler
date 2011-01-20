              var g = new Bluff.Line('graph', "1000x600");
      g.theme_37signals();
      g.tooltips = true;
      g.title_font_size = "24px"
      g.legend_font_size = "12px"
      g.marker_font_size = "10px"

        g.title = 'Flog: code complexity';
        g.data('average', [12.9740830191815,12.3245675189144]);
        g.data('top 5% average', [60.712698054413,60.4803174129807])
        g.labels = {"0":"12/19","1":"1/13"};
        g.draw();
