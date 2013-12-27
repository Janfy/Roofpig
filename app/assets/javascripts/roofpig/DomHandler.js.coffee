class @DomHandler

  constructor: (@display_id, @div, renderer, alg_to_show) ->
    @div.css(position:'relative', 'font-family':'"Lucida Sans Unicode", Lucida Grande, sans-serif')
    this.has_focus(false)
    @div.data('dpid', @display_id)

    renderer.setSize(@div.width(), @div.width())
    @div.append(renderer.domElement);

    @scale = @div.width()/400

  has_focus: (has_it) ->
    color = if has_it then 'gray' else '#eee'
    cursor = if has_it then 'pointer' else 'default'
    @div.css("border": "2px solid #{color}", cursor: cursor)

  alg_changed: (playing, at_start, at_end, place_text) ->
    if playing
      for button in @buttons
        if button == @play
          button.hide()
        else
          this._show(button, button == @pause)
    else
      for button in @buttons
        switch button
          when @reset, @prev
            this._show(button, not at_start)
          when @next, @play
            this._show(button, not at_end)
          when @pause
            button.hide()

    @active_play_or_pause = this._active_play_or_pause(playing, at_end)

    @place.html(place_text)

  _active_play_or_pause: (playing, at_end) ->
    if at_end
      return { click: -> }

    if playing then @pause else @play

  add_alg_area: (showalg) ->
    @alg_area = $("<div/>").height(@div.height() - @div.width()).width(@div.width()).css("border-top": "1px solid #ccc")
    @div.append(@alg_area)

    if showalg
      @alg_text = $("<div/>").width(@div.width()).css('background-color': "#eee", 'margin-bottom': '2px')
      @alg_area.append(@alg_text)

    @reset = this._make_button("↩",  "reset")
    @prev  = this._make_button("-",  "prev")
    @next  = this._make_button("+",  "next")
    @pause = this._make_button("Ⅱ", "pause")
    @play  = this._make_button("▶",  "play")

    @place = this._make_place_area()

    @buttons = [@reset, @prev, @next, @pause, @play]

  init_alg_text: (text) ->
    if @alg_text
      font_size = 24 * @scale * Math.min(1, 35/text.length)
      @alg_text.height(1.2 * font_size).css("font-size": font_size)
      @alg_text.text(text)

  _show: (button, active) ->
    button.show()
    if active
      button.button('enable')
    else
      button.button('disable')

  _make_button: (text, id) ->
    button = $("<button/>", { id: id, 'data-dpid': @display_id }).button(label: text)
    @alg_area.append(button)
    button.height(40 * @scale).width(80 * @scale).css("font-size", 22 * @scale)

  _make_place_area: ->
    place_div = $("<div/>", { id: "place" }).css("text-align": 'right', 'float': 'right')
    @alg_area.append(place_div)
    place_div.height(40 * @scale).width(80 * @scale).css("font-size", 24 * @scale)
