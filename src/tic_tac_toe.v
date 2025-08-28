module tic_tac_toe (
    input clk,
    input reset,
    input move_valid,         
    input [3:0] move_pos,        
    output reg [1:0] board_0,
    output reg [1:0] board_1,
    output reg [1:0] board_2,
    output reg [1:0] board_3,
    output reg [1:0] board_4,
    output reg [1:0] board_5,
    output reg [1:0] board_6,
    output reg [1:0] board_7,
    output reg [1:0] board_8,
    output reg [1:0] current_player, // 1 = X, 2 = O
    output reg [1:0] winner,         // 0 = no winner, 1 = X, 2 = O
    output reg draw
);

    integer i;

    // Helper wires for comparison
    wire [1:0] board_vals [0:8];
    assign board_vals[0] = board_0;
    assign board_vals[1] = board_1;
    assign board_vals[2] = board_2;
    assign board_vals[3] = board_3;
    assign board_vals[4] = board_4;
    assign board_vals[5] = board_5;
    assign board_vals[6] = board_6;
    assign board_vals[7] = board_7;
    assign board_vals[8] = board_8;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            board_0 <= 0;
            board_1 <= 0;
            board_2 <= 0;
            board_3 <= 0;
            board_4 <= 0;
            board_5 <= 0;
            board_6 <= 0;
            board_7 <= 0;
            board_8 <= 0;
            current_player <= 1;
            winner <= 0;
            draw <= 0;
        end else if (move_valid && winner == 0 && draw == 0) begin
            case (move_pos)
                0: if (board_0 == 0) board_0 <= current_player;
                1: if (board_1 == 0) board_1 <= current_player;
                2: if (board_2 == 0) board_2 <= current_player;
                3: if (board_3 == 0) board_3 <= current_player;
                4: if (board_4 == 0) board_4 <= current_player;
                5: if (board_5 == 0) board_5 <= current_player;
                6: if (board_6 == 0) board_6 <= current_player;
                7: if (board_7 == 0) board_7 <= current_player;
                8: if (board_8 == 0) board_8 <= current_player;
                default: ; // do nothing
            endcase

            // Check winning conditions
            if (
                (board_vals[0] == current_player && board_vals[1] == current_player && board_vals[2] == current_player) ||
                (board_vals[3] == current_player && board_vals[4] == current_player && board_vals[5] == current_player) ||
                (board_vals[6] == current_player && board_vals[7] == current_player && board_vals[8] == current_player) ||
                (board_vals[0] == current_player && board_vals[3] == current_player && board_vals[6] == current_player) ||
                (board_vals[1] == current_player && board_vals[4] == current_player && board_vals[7] == current_player) ||
                (board_vals[2] == current_player && board_vals[5] == current_player && board_vals[8] == current_player) ||
                (board_vals[0] == current_player && board_vals[4] == current_player && board_vals[8] == current_player) ||
                (board_vals[2] == current_player && board_vals[4] == current_player && board_vals[6] == current_player)
            ) begin
                winner <= current_player;
            end else begin
                // Check for draw
                if (
                    board_0 != 0 &&
                    board_1 != 0 &&
                    board_2 != 0 &&
                    board_3 != 0 &&
                    board_4 != 0 &&
                    board_5 != 0 &&
                    board_6 != 0 &&
                    board_7 != 0 &&
                    board_8 != 0
                )
                    draw <= 1;
                else
                    current_player <= (current_player == 1) ? 2 : 1;
            end
        end
    end

endmodule

