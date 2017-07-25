// -----------------------------------------------------------------------------
//    Copyright © 2017 Yauheni Lychkouski.
//
//    This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.
// -----------------------------------------------------------------------------
// File: tb_module_stereo_dac_output.v
// Description: Test bench for interpolating stereo sigma-delta DAC
// -----------------------------------------------------------------------------

module tb_module_i2s();
    localparam CLK_FREQ        = 100_000_000;
    localparam SAMPLE_WIDTH    = 16;
    localparam SAMPLE_RATE     = 48000;
    localparam SAMPLE_FREQ     = SAMPLE_RATE * SAMPLE_WIDTH * 2;
    localparam SAMPLE_NCLKS    = CLK_FREQ / SAMPLE_FREQ;
    localparam SAMPLE_NCLKS_HALF = SAMPLE_NCLKS / 2;

    reg                      clk;
    reg                      reset;
    reg                      bclk;
    reg                      lrclk;
    reg                      adcda;
    reg  [SAMPLE_WIDTH-1:0]  left_in;
    reg  [SAMPLE_WIDTH-1:0]  right_in;

    wire [SAMPLE_WIDTH-1:0]  left_out;
    wire [SAMPLE_WIDTH-1:0]  right_out;
    wire                     dataready;
    wire                     bclk_s;
    wire                     lrclk_s;
    wire                     dacda;

    // dut
    i2s #(SAMPLE_WIDTH) dut (
        .clk        (clk            ),
        .reset      (reset          ),
        .bclk       (bclk           ),
        .lrclk      (lrclk          ),
        .adcda      (adcda          ),
        .left_in    (left_in        ),
        .right_in   (right_in       ),
        .left_out   (left_out       ),
        .right_out  (right_out      ),
        .dataready  (dataready      ),
        .bclk_s     (bclk_s         ),
        .lrclk_s    (lrclk_s        ),
        .dacda      (dacda          )
    );


    initial $timeformat(-9, 0, " ns", 0);

    always begin
        #5;
        clk <= ~clk;
    end


    initial begin
        clk             <= 0;
        reset           <= 1;
        repeat (100) @(posedge clk);
        reset <= 0;
    end


    initial begin
        bclk            <= 0;
        lrclk           <= 0;
        adcda           <= 0;

        @(posedge clk);
        while (reset) @(posedge clk);

        bclk            <= 0;
        lrclk           <= 0;
        adcda           <= 0;

        forever begin
            repeat (2) begin
                repeat (SAMPLE_WIDTH+5) begin
                    repeat (SAMPLE_NCLKS_HALF) @(posedge clk);
                    bclk  <= 1'b1;
                    repeat (SAMPLE_NCLKS_HALF) @(posedge clk);
                    bclk  <= 1'b0;
                    adcda <= $random % 2;
                end
                lrclk     <= ~lrclk;
            end

            repeat (1000) @(posedge clk);
        end
    end


    initial begin
        left_in         <= 0;
        right_in        <= 0;
        @(posedge clk);

        while (reset) @(posedge clk);

        repeat (SAMPLE_NCLKS) @(posedge clk);
        left_in         <= $random();
        right_in        <= $random();
    end

endmodule
