// --------------------------------------------------------------------
// Copyright 2020 qaztronic
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Licensed under the Solderpad Hardware License v 2.1 (the “License”);
// you may not use this file except in compliance with the License, or,
// at your option, the Apache License version 2.0. You may obtain a copy
// of the License at
//
// https://solderpad.org/licenses/SHL-2.1/
//
// Unless required by applicable law or agreed to in writing, any work
// distributed under the License is distributed on an “AS IS” BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
// implied. See the License for the specific language governing
// permissions and limitations under the License.
// --------------------------------------------------------------------

// --------------------------------------------------------------------
class video_frame_class;
  rand int  frame_id;
  rand int  pixels_per_line;
  rand int  lines_per_frame;
  rand int  bits_per_pixel;
  int bytes_per_pixel;
  rand int  pixels_per_clk;
  line_s    lines[];
  string    name = "";
  string    pattern = "";

  constraint default_pixels_per_line
  {
    pixels_per_line >= 4;
    pixels_per_line % 2 == 0;
    pixels_per_line <= 16384;
  }

  constraint default_lines_per_frame
  {
    lines_per_frame >= 4;
    lines_per_frame % 2 == 0;
    lines_per_frame <= 16384;
  }

  constraint default_bits_per_pixel
  {
    bits_per_pixel >= 1 && bits_per_pixel <= 32;
  }

  //--------------------------------------------------------------------
  function new;
    this.frame_id = 0;
  endfunction: new

  // --------------------------------------------------------------------
  function void init
  (
    int pixels_per_line,
    int lines_per_frame,
    int bits_per_pixel,
    int pixels_per_clk = 1,
    string name = ""
 );
    this.pixels_per_line  = pixels_per_line;
    this.lines_per_frame  = lines_per_frame;
    this.bits_per_pixel   = bits_per_pixel;
    this.pixels_per_clk   = pixels_per_clk;
    this.name             = name;
    this.bytes_per_pixel  = (bits_per_pixel % 8 == 0)
                          ? (bits_per_pixel / 8)
                          : (bits_per_pixel / 8) + 1;

    this.make_constant(0);
  endfunction: init

  // --------------------------------------------------------------------
  task write_pixel(frame_coordinate_t coordinate, int pixel);
    this.lines[coordinate.y].pixel[coordinate.x] = pixel;
  endtask: write_pixel

  // --------------------------------------------------------------------
  function int read_pixel(frame_coordinate_t coordinate);
    read_pixel = this.lines[coordinate.y].pixel[coordinate.x];
  endfunction: read_pixel

  // --------------------------------------------------------------------
  function flattened_frame_t flatten_frame();
    flatten_frame = new[lines_per_frame*pixels_per_line];
    foreach(this.lines[l])
      foreach(this.lines[l].pixel[p])
        flatten_frame[(l*pixels_per_line)+p] = this.lines[l].pixel[p];
  endfunction: flatten_frame

  // --------------------------------------------------------------------
  function void load_flatten_frame(flattened_frame_t a);
    make_constant(0);
    foreach(lines[l])
      foreach(lines[l].pixel[p])
        lines[l].pixel[p] = a[(l*pixels_per_line)+p];
  endfunction: load_flatten_frame

  // --------------------------------------------------------------------
  function void load_memh(string file_name);
    flattened_frame_t a;
    $readmemh(file_name, a);
    load_flatten_frame(a);
 endfunction: load_memh

  // --------------------------------------------------------------------
  function void do_writememh(string file_name);
    flattened_frame_t a = flatten_frame();
    $writememh(file_name, a);
  endfunction: do_writememh

  // --------------------------------------------------------------------
  function void make_constant(int pixel);
    this.lines = new[lines_per_frame];

    foreach(this.lines[l])
    begin
      this.lines[l].pixel = new[pixels_per_line];

      foreach(this.lines[l].pixel[p])
        this.lines[l].pixel[p] = pixel;
    end

    pattern = "constant";
  endfunction: make_constant

  // --------------------------------------------------------------------
  function void make_counting(int offset = 0);
    this.lines = new[lines_per_frame];

    foreach(this.lines[l])
    begin
      this.lines[l].pixel = new[pixels_per_line];

      foreach(this.lines[l].pixel[p])
        this.lines[l].pixel[p] = (pixels_per_line * l) + p + offset;
    end

    pattern = "counting";
  endfunction: make_counting

  // --------------------------------------------------------------------
  function void make_horizontal();
    this.lines = new[lines_per_frame];

    foreach(this.lines[l])
    begin
      this.lines[l].pixel = new[pixels_per_line];

      foreach(this.lines[l].pixel[p])
        this.lines[l].pixel[p] = p;
    end

    pattern = "horizontal";
  endfunction: make_horizontal

  // --------------------------------------------------------------------
  function void make_vertical();
    this.lines = new[lines_per_frame];

    foreach(this.lines[l])
    begin
      this.lines[l].pixel = new[pixels_per_line];

      foreach(this.lines[l].pixel[p])
        this.lines[l].pixel[p] = l;
    end

    pattern = "vertical";
  endfunction: make_vertical

  // --------------------------------------------------------------------
  function void make_random(int range=bits_per_pixel);
    this.lines = new[lines_per_frame];

    foreach(this.lines[l])
    begin
      this.lines[l].pixel = new[pixels_per_line];

      foreach(this.lines[l].pixel[p])
        this.lines[l].pixel[p] = $urandom_range(((2 ** range) - 1), 0);
    end

    pattern = "random";
  endfunction: make_random

  // --------------------------------------------------------------------
  function void add(video_frame_class f_h);
    foreach(this.lines[l])
      foreach(this.lines[l].pixel[p])
        this.lines[l].pixel[p] = this.lines[l].pixel[p] + f_h.lines[l].pixel[p];
  endfunction: add

  // --------------------------------------------------------------------
  function void subtract(video_frame_class f_h);
    foreach(this.lines[l])
      foreach(this.lines[l].pixel[p])
        this.lines[l].pixel[p] = this.lines[l].pixel[p] - f_h.lines[l].pixel[p];
  endfunction: subtract

  // --------------------------------------------------------------------
  function void multiply(video_frame_class f_h);
    foreach(this.lines[l])
      foreach(this.lines[l].pixel[p])
        this.lines[l].pixel[p] = this.lines[l].pixel[p] * f_h.lines[l].pixel[p];
  endfunction: multiply

  // --------------------------------------------------------------------
  function void divide(video_frame_class f_h);
    foreach(this.lines[l])
      foreach(this.lines[l].pixel[p])
        this.lines[l].pixel[p] = this.lines[l].pixel[p] / f_h.lines[l].pixel[p];
  endfunction: divide

  // --------------------------------------------------------------------
  function void copy(video_frame_class from);
    this.frame_id         = from.frame_id;
    this.pixels_per_line  = from.pixels_per_line;
    this.lines_per_frame  = from.lines_per_frame;
    this.bits_per_pixel   = from.bits_per_pixel;
    this.name             = from.name;
    this.lines            = new[this.lines_per_frame];

    foreach(this.lines[l])
    begin
      this.lines[l].pixel = new[this.pixels_per_line];

      foreach(this.lines[l].pixel[p])
        this.lines[l].pixel[p] = from.lines[l].pixel[p];
    end
  endfunction: copy

  // --------------------------------------------------------------------
  virtual function video_frame_class clone;
    clone = new();
    clone.copy(this);
  endfunction: clone

  // --------------------------------------------------------------------
  function video_frame_class catenate_horizontally(video_frame_class tail);

    if(this.lines_per_frame != tail.lines_per_frame)
      return(null);

    if(this.bits_per_pixel != tail.bits_per_pixel)
      return(null);

    catenate_horizontally = new();
    catenate_horizontally.pixels_per_line  = this.pixels_per_line + tail.pixels_per_line;
    catenate_horizontally.lines_per_frame  = this.lines_per_frame;
    catenate_horizontally.bits_per_pixel   = this.bits_per_pixel;
    catenate_horizontally.name             = this.name;
    catenate_horizontally.lines            = new[catenate_horizontally.lines_per_frame];

    foreach(catenate_horizontally.lines[l])
    begin
      catenate_horizontally.lines[l].pixel = new[catenate_horizontally.pixels_per_line];

      foreach(this.lines[l].pixel[p])
        catenate_horizontally.lines[l].pixel[p] = this.lines[l].pixel[p];

      foreach(tail.lines[l].pixel[p])
        catenate_horizontally.lines[l].pixel[p + this.pixels_per_line] = tail.lines[l].pixel[p];
    end
  endfunction: catenate_horizontally

  // --------------------------------------------------------------------
  function void shift_right(ref line_s column);

    foreach(this.lines[l])
      for(int p = pixels_per_line - 1; p > 0; p--)
        this.lines[l].pixel[p] = this.lines[l].pixel[p - 1];

    foreach(this.lines[l])
      this.lines[l].pixel[0] = column.pixel[l];
  endfunction: shift_right

  // // --------------------------------------------------------------------
  // function int compare_line
  // ( int line
  // , int max_mismatches
  // , video_frame_class to
  // );
    // int mismatch_count = 0;

    // if(to.bits_per_pixel != this.bits_per_pixel)
    // begin
      // log.error($sformatf("to.bits_per_pixel != this.bits_per_pixel | %s", name));
      // return(-3);
    // end

      // foreach(this.lines[line].pixel[p])
        // if(to.lines[line].pixel[p] != this.lines[line].pixel[p])
        // begin

          // if(max_mismatches > 0)
            // mismatch_count++;

            // log.error($sformatf("mismatch @ frame[%4h][%4h] | to == %4h | this == %4h  | %s",
                      // line, p, to.lines[line].pixel[p], this.lines[line].pixel[p], name));

          // if(mismatch_count > max_mismatches)
            // return(mismatch_count);
        // end

      // return(mismatch_count);
  // endfunction: compare_line

  // // --------------------------------------------------------------------
  // function int compare(int max_mismatches, video_frame_class to);
    // int mismatch_count = 0;
    // log.info($sformatf("%m"));

    // if(to.pixels_per_line != this.pixels_per_line)
    // begin
      // log.error($sformatf("to.pixels_per_line != this.pixels_per_line | %s", name));
      // return(-1);
    // end

    // if(to.lines_per_frame != this.lines_per_frame)
    // begin
      // log.error($sformatf("to.lines_per_frame != this.lines_per_frame | %s", name));
      // return(-2);
    // end

    // if(to.bits_per_pixel != this.bits_per_pixel)
    // begin
      // log.error($sformatf("to.bits_per_pixel != this.bits_per_pixel | %s", name));
      // return(-3);
    // end

      // foreach(this.lines[l])
      // begin
        // foreach(this.lines[l].pixel[p])
          // if(to.lines[l].pixel[p] != this.lines[l].pixel[p])
          // begin
            // if(max_mismatches > 0)
              // mismatch_count++;

              // log.error($sformatf("mismatch @ frame[%4h][%4h] | to == %4h | this == %4h  | %s", l, p, to.lines[l].pixel[p], this.lines[l].pixel[p], name));

            // if(mismatch_count > max_mismatches)
              // return(mismatch_count);
          // end
      // end

      // return(mismatch_count);
  // endfunction: compare

  // // --------------------------------------------------------------------
  // function void print_line(int line, int pixel, int count);
    // log.info($sformatf("%m"));

    // for(int i = 0; i < count; i++)
      // log.display($sformatf("%4h @ frame[%4h][%4h] | %s", this.lines[line].pixel[(pixel + i)], line, (pixel + i), name));
  // endfunction: print_line

  // // --------------------------------------------------------------------
  // function void print_config();
    // log.display($sformatf("%m | frame_id         = %06d  | %s", frame_id, name));
    // log.display($sformatf("%m | pixels_per_line  = %06d  | %s", pixels_per_line, name));
    // log.display($sformatf("%m | lines_per_frame  = %06d  | %s", lines_per_frame, name));
    // log.display($sformatf("%m | bits_per_pixel   = %06d  | %s", bits_per_pixel, name));
    // log.display($sformatf("%m | pixels_per_clk   = %06d  | %s", pixels_per_clk, name));
    // log.display($sformatf("%m | pattern          = %s    | %s", pattern, name));
  // endfunction: print_config

  // --------------------------------------------------------------------
  function void print_config();
    $display($sformatf("%m | frame_id         = %06d  | %s", frame_id, name));
    $display($sformatf("%m | pixels_per_line  = %06d  | %s", pixels_per_line, name));
    $display($sformatf("%m | lines_per_frame  = %06d  | %s", lines_per_frame, name));
    $display($sformatf("%m | bits_per_pixel   = %06d  | %s", bits_per_pixel, name));
    $display($sformatf("%m | pixels_per_clk   = %06d  | %s", pixels_per_clk, name));
    $display($sformatf("%m | pattern          = %s    | %s", pattern, name));
  endfunction: print_config

  // --------------------------------------------------------------------
  function string convert2string(int grid=8);
    string s0, s1;
    string f ="";
    int nibbles = ( bits_per_pixel % 4 == 0)
                  ? bits_per_pixel / 4
                  : (bits_per_pixel / 4) + 1;

    foreach(this.lines[l]) begin
      s0 = $sformatf("[%4.d]", l);
      foreach(this.lines[l].pixel[p]) begin
        s1 = $sformatf("%.h", this.lines[l].pixel[p]);
        s1 = s1.substr(nibbles, s1.len()-1);
        s0 = {s0, (p % grid == 0) ? "!" : "|", s1};
      end

      f = {f, s0, "|\n"};
    end

    return f;
  endfunction: convert2string

// --------------------------------------------------------------------
endclass
