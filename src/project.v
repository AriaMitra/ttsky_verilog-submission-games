/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_AriaMitraGames (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  wire reset = ~rst_n;

  // 0 is tic_tac_toe, 1 is rock_paper
  wire gametype = ui_in[0];


  wire [1:0] rps_win;
  rock_paper rps_game (
    .u(ui_in[2:1]),   
    .clk(clk),
    .reset(reset),
    .win(rps_win)
  );

    wire [1:0] b0,b1,b2,b3,b4,b5,b6,b7,b8;
  wire [1:0] ttt_player;
  wire [1:0] ttt_winner;
  wire       ttt_draw;

  tic_tac_toe ttt_game (
    .clk(clk),
    .reset(reset),
    .move_valid(ui_in[7]), 
    .move_pos(ui_in[6:3]), 
      .board_0(b0),
      .board_1(b1),
      .board_2(b2),
      .board_3(b3),
      .board_4(b4),
      .board_5(b5),
      .board_6(b6),
      .board_7(b7),
      .board_8(b8),
    .current_player(ttt_player),
    .winner(ttt_winner),
    .draw(ttt_draw)
  );

  assign uo_out =
      (gametype == 1'b0) ?
      {
        1'b0,              // unused
        ttt_draw,          // bit 6
        ttt_winner,        // bits 5-4
        ttt_player,        // bits 3-2
        1'b0,   
        1'b0
      } :
      {
        5'b00000,         // unused
        rps_win           // bits 1-0 → result
      };

  // Set unused outputs
  assign uio_out = 8'b0;
  assign uio_oe  = 8'b0;

  // Avoid unused warnings
  wire _unused = &{ena, uio_in};

endmodule


