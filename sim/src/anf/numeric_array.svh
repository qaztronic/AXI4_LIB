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

typedef int array_shape_t[];  // same shape convention as numpy
typedef int array_index_t[];

class numeric_array #(type T = shortreal);
  array_shape_t shape;
  int dim;
  T a_1d[];
  T a_2d[][];
  T a_3d[][][];

  // --------------------------------------------------------------------
  function void set_entry(array_index_t i, T value);
    case(dim)
      1:        a_1d[i[0]] = value;
      2:        a_2d[i[0]][i[1]] = value;
      3:        a_3d[i[0]][i[1]][i[2]] = value; //[z][y][x]
      default:  $stop;  // not supported
    endcase
  endfunction

  // --------------------------------------------------------------------
  function T get_entry(array_index_t i);
    case(dim)
      1:        get_entry = a_1d[i[0]];
      2:        get_entry = a_2d[i[0]][i[1]];
      3:        get_entry = a_3d[i[0]][i[1]][i[2]]; //[z][y][x]
      default:  $stop;  // not supported
    endcase
  endfunction

  // --------------------------------------------------------------------
  function longint to_bits(array_index_t i);
    case(type(T))
      type(shortreal):  to_bits = $shortrealtobits(get_entry(i));
      type(real):       to_bits = $realtobits(get_entry(i));
      default:          $stop;  // not supported
    endcase
  endfunction

  // --------------------------------------------------------------------
  function int bits;
    case(type(T))
      type(shortreal):  bits = 32;
      type(real):       bits = 64;
      default:          $stop;  // not supported
    endcase
  endfunction

  // --------------------------------------------------------------------
  function void new_2d(array_shape_t shape);
    a_2d = new[shape[0]];
    foreach(a_2d[y])
      a_2d[y] = new[shape[1]];
  endfunction

  // --------------------------------------------------------------------
  function void new_3d(array_shape_t shape);
    a_3d = new[shape[0]];
    foreach(a_3d[z])
    begin
      a_3d[z] = new[shape[1]];
      foreach(a_3d[z,y])
        a_3d[z][y] = new[shape[2]];
    end
  endfunction

  // --------------------------------------------------------------------
  function void make_new;
    case(dim)
      1:        a_1d = new[shape[0]];
      2:        new_2d(shape);
      3:        new_3d(shape);
      default:  $stop;  // not supported
    endcase
  endfunction

  // --------------------------------------------------------------------
  function void make_2d_constant(T value=0.0);
    $display("### value = %x",  $shortrealtobits(value));
    make_new();
    foreach(a_2d[y,x])
      a_2d[y][x] = value;
  endfunction

  // --------------------------------------------------------------------
  function new(array_shape_t shape);
    this.shape = shape;
    this.dim = shape.size();
    make_new();
  endfunction

// --------------------------------------------------------------------
endclass
