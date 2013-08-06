// Generated by CoffeeScript 1.6.3
(function() {
  import ui.View;
  import src.gameobject.Dot as Dot;
  import src.Setting as Setting;
  import animate;
  var DotsGrid, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  DotsGrid = (function(_super) {
    __extends(DotsGrid, _super);

    function DotsGrid() {
      _ref = DotsGrid.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    DotsGrid.prototype.init = function(opts) {
      var dot, grid_width, i, j, pattern, that, _i, _j, _ref1, _ref2;
      this.columns = 5;
      this.rows = 5;
      this.margin = 30;
      this.dot_width = 25;
      this.dot_height = this.dot_width;
      grid_width = Setting.game_width - this.margin * 2;
      this.dot_col_space = (grid_width - this.columns * this.dot_width) / (this.columns - 1);
      this.dot_row_space = this.dot_col_space;
      this.grid_height = this.rows * (this.dot_row_space + this.dot_height);
      this.offset_y = 50;
      opts = merge(opts, {
        x: 0,
        y: 0,
        width: Setting.game_width,
        height: Setting.game_height
      });
      DotsGrid.__super__.init.call(this, opts);
      this.data = [];
      this.dots_array = [];
      this.current_pattern = void 0;
      this.selected_dots = [];
      that = this;
      for (i = _i = 0, _ref1 = this.columns; 0 <= _ref1 ? _i < _ref1 : _i > _ref1; i = 0 <= _ref1 ? ++_i : --_i) {
        this.data[i] = [];
        this.dots_array[i] = [];
        for (j = _j = 0, _ref2 = this.rows; 0 <= _ref2 ? _j < _ref2 : _j > _ref2; j = 0 <= _ref2 ? ++_j : --_j) {
          pattern = Dot.random_pattern();
          this.data[i].push(pattern);
          dot = this.create_new_dot(i, j, pattern);
          this.dots_array[i].push(dot);
        }
      }
      this.on("InputSelect", this.finish_selection);
      return true;
    };

    DotsGrid.prototype.create_new_dot = function(i, j, pattern) {
      var dot, that;
      that = this;
      dot = new Dot(i, j, pattern, {
        superview: this,
        x: this.margin + i * (this.dot_col_space + this.dot_width),
        y: this.offset_y + this.grid_height - this.dot_height - j * (this.dot_row_space + this.dot_height),
        width: this.dot_width,
        height: this.dot_height
      });
      dot.on("InputOver", function(over, overCount, atTarget) {
        return that.select_dot(this);
      });
      return dot;
    };

    DotsGrid.prototype.finish_selection = function() {
      var dot, _i, _len, _ref1;
      console.log("--------------------------");
      _ref1 = this.selected_dots;
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        dot = _ref1[_i];
        console.log("(" + dot.grid_i + ", " + dot.grid_j + ")");
        this.data[dot.grid_i][dot.grid_j] = -1;
        dot.removeFromSuperview();
      }
      this.selected_dots.length = 0;
      this.fall_dots();
      return this.new_dots();
    };

    DotsGrid.prototype.fall_dots = function() {
      var dot, i, j, _i, _j, _ref1, _ref2, _results;
      for (i = _i = 0, _ref1 = this.columns; 0 <= _ref1 ? _i < _ref1 : _i > _ref1; i = 0 <= _ref1 ? ++_i : --_i) {
        for (j = _j = _ref2 = this.rows - 1; _ref2 <= 0 ? _j <= 0 : _j >= 0; j = _ref2 <= 0 ? ++_j : --_j) {
          if (this.data[i][j] < 0) {
            this.dots_array[i].splice(j, 1);
            this.data[i].splice(j, 1);
          }
        }
      }
      this.update_data_array();
      _results = [];
      for (i in this.dots_array) {
        _results.push((function() {
          var _results1;
          _results1 = [];
          for (j in this.dots_array[i]) {
            dot = this.dots_array[i][j];
            dot.grid_j = j;
            _results1.push(animate(dot).then({
              y: this.offset_y + this.grid_height - this.dot_height - j * (this.dot_row_space + this.dot_height)
            }, 300, animate.easeOut));
          }
          return _results1;
        }).call(this));
      }
      return _results;
    };

    DotsGrid.prototype.new_dots = function() {
      var dot, i, j, pattern, _i, _j, _ref1, _ref2, _ref3;
      for (i = _i = 0, _ref1 = this.columns; 0 <= _ref1 ? _i < _ref1 : _i > _ref1; i = 0 <= _ref1 ? ++_i : --_i) {
        if (this.data[i].length < this.rows) {
          for (j = _j = _ref2 = this.data[i].length, _ref3 = this.rows; _ref2 <= _ref3 ? _j < _ref3 : _j > _ref3; j = _ref2 <= _ref3 ? ++_j : --_j) {
            pattern = Dot.random_pattern();
            dot = this.create_new_dot(i, j, pattern);
            dot.style.y = -Setting.game_height - this.dot_height;
            animate(dot).wait(300).then({
              y: this.offset_y + this.grid_height - this.dot_height - j * (this.dot_row_space + this.dot_height)
            }, 300, animate.easeOut);
            this.dots_array[i].push(dot);
          }
        }
      }
      return this.update_data_array();
    };

    DotsGrid.prototype.update_data_array = function() {
      var i, j, _results;
      _results = [];
      for (i in this.dots_array) {
        this.data[i].length = 0;
        _results.push((function() {
          var _results1;
          _results1 = [];
          for (j in this.dots_array[i]) {
            _results1.push(this.data[i].push(this.dots_array[i][j].pattern_no));
          }
          return _results1;
        }).call(this));
      }
      return _results;
    };

    DotsGrid.prototype.select_dot = function(dot) {
      var is_adjacent;
      is_adjacent = function(dot1, dot2) {
        if (dot1 === dot2) {
          return false;
        }
        if (dot1.grid_i === dot2.grid_i && Math.abs(dot1.grid_j - dot2.grid_j) === 1) {
          return true;
        }
        if (dot1.grid_j === dot2.grid_j && Math.abs(dot1.grid_i - dot2.grid_i) === 1) {
          return true;
        }
        return false;
      };
      if (this.selected_dots.length === 0) {
        this.current_pattern = dot.pattern_no;
        return this.selected_dots.push(dot);
      } else if (this.current_pattern === dot.pattern_no) {
        if (is_adjacent(dot, this.selected_dots[this.selected_dots.length - 1])) {
          return this.selected_dots.push(dot);
        }
      }
    };

    return DotsGrid;

  })(ui.View);

  exports = DotsGrid;

}).call(this);