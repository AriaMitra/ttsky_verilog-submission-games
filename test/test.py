# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 5)

    dut._log.info("Testing Rock Paper Scissors")
    dut.ui_in.value = 0b00000011
    await ClockCycles(dut.clk, 5)
    rps_result = int(dut.uo_out.value) & 0b11
    dut._log.info(f"RPS Result: {rps_result:02b}")
    assert rps_result in [0b00, 0b01, 0b11]

    dut._log.info("Testing Tic Tac Toe")
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 5)

    dut.ui_in.value = 0b10000000
    await ClockCycles(dut.clk, 1)
    dut.ui_in.value = 0
    await ClockCycles(dut.clk, 1)

    dut.ui_in.value = 0b10001000
    await ClockCycles(dut.clk, 1)
    dut.ui_in.value = 0
    await ClockCycles(dut.clk, 1)

    dut.ui_in.value = 0b10011000
    await ClockCycles(dut.clk, 1)
    dut.ui_in.value = 0
    await ClockCycles(dut.clk, 1)

    dut.ui_in.value = 0b10100000
    await ClockCycles(dut.clk, 1)
    dut.ui_in.value = 0
    await ClockCycles(dut.clk, 1)

    dut.ui_in.value = 0b10110000
    await ClockCycles(dut.clk, 1)
    dut.ui_in.value = 0
    await ClockCycles(dut.clk, 3)

    output = int(dut.uo_out.value)
    ttt_winner = (output >> 4) & 0b11
    dut._log.info(f"Tic Tac Toe winner: {ttt_winner}")
    assert ttt_winner == 0

    dut._log.info("Testing Draw Case in Tic Tac Toe")
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 5)

    moves = [0, 1, 2, 4, 3, 5, 7, 6, 8]
    for idx, pos in enumerate(moves):
        move_valid = 1 << 7
        move_bits = pos << 3
        ui_in_val = move_valid | move_bits
        dut.ui_in.value = ui_in_val
        await ClockCycles(dut.clk, 1)
        dut.ui_in.value = 0
        await ClockCycles(dut.clk, 1)

    await ClockCycles(dut.clk, 3)
    output = int(dut.uo_out.value)
    draw_bit = (output >> 6) & 1
    ttt_winner = (output >> 4) & 0b11
    dut._log.info(f"Tic Tac Toe draw bit: {draw_bit}, winner: {ttt_winner}")
    assert draw_bit == 0
    assert ttt_winner == 0

    dut._log.info("RPS User: Rock")
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 2)
    dut.ui_in.value = 0b00000001
    await ClockCycles(dut.clk, 3)
    rps_result = int(dut.uo_out.value) & 0b11
    dut._log.info(f"RPS Result (Rock): {rps_result:02b}")
    assert rps_result in [0b00, 0b01, 0b11]

    dut._log.info("RPS User: Scissors")
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 2)
    dut.ui_in.value = 0b00000111
    await ClockCycles(dut.clk, 3)
    rps_result = int(dut.uo_out.value) & 0b11
    dut._log.info(f"RPS Result (Scissors): {rps_result:02b}")
    assert rps_result in [0b00, 0b01, 0b11]

    dut._log.info("Tic Tac Toe Quick Win: Diagonal")
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 2)

    move_sequence = [0, 1, 4, 2, 8]
    for idx, pos in enumerate(move_sequence):
        move_valid = 1 << 7
        move_bits = pos << 3
        ui_in_val = move_valid | move_bits
        dut.ui_in.value = ui_in_val
        await ClockCycles(dut.clk, 1)
        dut.ui_in.value = 0
        await ClockCycles(dut.clk, 1)

    await ClockCycles(dut.clk, 3)
    output = int(dut.uo_out.value)
    ttt_winner = (output >> 4) & 0b11
    dut._log.info(f"Winner after diagonal win: {ttt_winner}")
    assert ttt_winner == 0
