              var g = new Bluff.Line('graph', "1000x600");
      g.theme_37signals();
      g.tooltips = true;
      g.title_font_size = "24px"
      g.legend_font_size = "12px"
      g.marker_font_size = "10px"

        g.title = 'Reek: code smells';
        g.data('ClassVariable', [4,4])
g.data('Duplication', [109,106])
g.data('IrresponsibleModule', [32,33])
g.data('LongMethod', [44,39])
g.data('LowCohesion', [13,15])
g.data('NestedIterators', [41,35])
g.data('SimulatedPolymorphism', [7,6])
g.data('UncommunicativeName', [13,13])

        g.labels = {"0":"12/19","1":"1/13"};
        g.draw();
