// Basic bezier and polygon drawing pen tool
Fred.tools.pen = new Fred.Tool('draw polygons',{
	polygon: false,
	dragging_point: false,
	creating_bezier: false,
	keys: $H({
		'esc': function() { Fred.tools.pen.cancel() }
	}),
	deselect: function() {
		Fred.stop_observing('fred:postdraw',this.draw)
	},
	select: function() {
		Fred.observe('fred:postdraw',this.draw.bindAsEventListener(this))
		Fred.keys.load(this.keys,this)
	},
	on_mousedown: function(e) {
		// are we clicking an existing polygon? Should that happen here or in another tool?
		// ...
		// are we in the middle of making a polygon?
		if (!this.polygon) {
			this.polygon = new Fred.Polygon
			this.polygon.selected = true
		}
		// are we editing a point?
		// clicked_pt could be lost if the mouse leaves the point. 
		// better save it in the tool
		this.clicked_point = this.polygon.in_point()
		// unless it's the FIRST point, allow tool to drag it instead:
		if (this.clicked_point != false && this.clicked_point != this.polygon.points[0]) {
			// if option key is down, start a bezier!
			if (Fred.keys.modifiers.get('control') && this.clicked_point != this.polygon.points.last()){
				this.creating_bezier = true
				this.clicked_point.bezier = { prev: { x:0, y:0 }, next: { x:0, y:0 } }
			} else {
				// allow point dragging
				this.dragging_point = true
			}
		} else {
			// close polygon if you click on first point
			var on_final = (this.polygon.points.length > 1 && ((Math.abs(this.polygon.points[0].x - Fred.pointer_x) < Fred.click_radius) && (Math.abs(this.polygon.points[0].y - Fred.pointer_y) < Fred.click_radius)))
			if (on_final && this.polygon.points.length > 1) {
				this.polygon.closed = true
				this.complete_polygon()
			} else if (!on_final) this.polygon.points.push(new Fred.Point(Fred.pointer_x,Fred.pointer_y))
		}
	},
	on_dblclick: function() {
		if (this.polygon && this.polygon.points.length > 1) {
			this.complete_polygon()
		}
	},
	on_mousemove: function() {
		// if in mid-poly-drawing, you grab a control point and drag:
		if (this.dragging_point) {
			// move the control point to follow the mouse
			this.clicked_point.x = Fred.pointer_x
			this.clicked_point.y = Fred.pointer_y
		// the modifier check shouldn't be necessary
		} else if (this.creating_bezier && Fred.keys.modifiers.get('control')) {
			console.log('editbez')
			// if control key, draw beziers
			// if you're not dragging the bz control points themselves,
			// you prob. want to start over
			this.clicked_point.bezier.prev.x = -Fred.pointer_x + this.clicked_point.x
			this.clicked_point.bezier.prev.y = -Fred.pointer_y + this.clicked_point.y
			this.clicked_point.bezier.next.x = Fred.pointer_x - this.clicked_point.x
			this.clicked_point.bezier.next.y = Fred.pointer_y - this.clicked_point.y
		}
	},
	on_mouseup: function() {
		this.dragging_point = false
		this.creating_bezier = false
	},
	on_touchstart: function(e) {
		//e.preventDefault();
		//var x = e.touches[0].pageX
		//var y = e.touches[0].pageY
		this.on_mousedown(e)
	},
	on_touchend: function(e) {
		//e.preventDefault();
		//var x = e.touches[0].pageX
		//var y = e.touches[0].pageY
		this.on_mouseup(e)
	},
	draw: function() {
		if (this.polygon) this.polygon.draw()
	},
	/*
	 * Cancels polygon creation, starts fresh with a new polygon
	 */
	cancel: function() {
		this.polygon = false
	},
	complete_polygon: function() {
		// move the polygon to the active Fred layer 
		Fred.active_layer.objects.push(this.polygon)
		// stop storing the polygon in the pen tool
		this.polygon.refresh()
		this.polygon.selected = false
		this.polygon = false
		Fred.stop_observing('fred:postdraw',this.draw)
	}
})

