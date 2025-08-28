module tic_tac_toe (
    input clk,
    input reset,
    input move_valid,         
    input [3:0] move_pos,        
  output reg [1:0] board [0:8],  // 0 is empty, 1 is X, 2 is O
  output reg [1:0] current_player, // 1 is X, 2 is O
  output reg [1:0] winner,       // 0 is no winner, 1 is X, 2 is O
    output reg draw
);

    integer i;

    // all winning combos
    localparam [8:0][2:0] WIN_LINES = '{
        '{0, 1, 2},
        '{3, 4, 5},
        '{6, 7, 8},
        '{0, 3, 6},
        '{1, 4, 7},
        '{2, 5, 8},
        '{0, 4, 8},
        '{2, 4, 6},
        '{0, 0, 0} 
    };

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 9; i = i + 1)
                board[i] <= 0;

            current_player <= 1;
            winner <= 0;
            draw <= 0;
        end
        else if (move_valid && board[move_pos] == 0 && winner == 0 && draw == 0) begin
            board[move_pos] <= current_player;

            for (i = 0; i < 8; i = i + 1) begin
                if (board[WIN_LINES[i][0]] == current_player &&
                    board[WIN_LINES[i][1]] == current_player &&
                    board[WIN_LINES[i][2]] == current_player) begin
                    winner <= current_player;
                end
            end

            if (winner == 0) begin
                integer full = 1;
                for (i = 0; i < 9; i = i + 1)
                    if (board[i] == 0)
                        full = 0;
                if (full)
                    draw <= 1;
            end
            if (winner == 0 && draw == 0)
                current_player <= (current_player == 1) ? 2 : 1;
        end
    end

endmodule

